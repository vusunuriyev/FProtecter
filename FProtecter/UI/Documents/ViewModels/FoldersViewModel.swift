//
//  FoldersViewModel.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 21.05.24.
//

import SwiftUI
import CommonCrypto

class FoldersViewModel: ObservableObject {
    
    @Published var folders: [FolderModel] = []
    
    private static var encryptionKey: Data?
    
    private let folderDataFileName = "encryptedFolderData.json"
    private var folderDataFileURL: URL {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(folderDataFileName)
    }
    
    // - Create Folder Function
    
    public func createFolder(_ newFolder: FolderModel) {
        folders.append(newFolder)
        try! appendDataToFile(data: newFolder)
    }
    
    init() {
        encryptFolder()
        self.folders = try! retrieveDataFromFile()
    }
    
    // - Encrypt Folder Function
    
    private func encryptFolder() {
        FoldersViewModel.encryptionKey = generateEncryptionKey()
    }
    
    // MARK: - Items Functions
    
    // - Delete Item
    
    public func deleteItem(_ item: ItemModel, selectedFolderId: Int) {
        if let index = folders[selectedFolderId].folderItems.firstIndex(where: { $0.id == item.id }) {
            folders[selectedFolderId].folderItems.remove(at: index)
            updateFolderItemsInViewModel(selectedFolderId: selectedFolderId)
        }
    }
    
    // - Update Items
    
    public func updateFolderItemsInViewModel(selectedFolderId: Int) {
        if let folderIndex = folders.firstIndex(where: { $0.id == folders[selectedFolderId].id }) {
            folders[folderIndex].folderItems = folders[selectedFolderId].folderItems
            try? appendDataToFile(data: folders[folderIndex])
        }
    }
    
    // - Get Item Type
    
    func getItemType(from url: URL) -> ItemType {
        let ext = url.pathExtension.lowercased()
        switch ext {
        case "jpg", "jpeg":
            return .jpg
        case "png":
            return .png
        case "pdf":
            return .pdf
        case "docx":
            return .docx
        case "txt":
            return .txt
        case "mov":
            return .mov
        case "mp3":
            return .mp3
        case "mp4":
            return .mp4
        case "zip":
            return .zip
        default:
            return .unknown
        }
    }
    
    // MARK: - Folders Functions
    
    // - Update Folders Function
    
    func updateFolders() {
        try! updateDataFile()
    }
    
    // - Update Folders' Password Function
    
    func updateFoldersPassword() {
        for id in 0..<folders.count {
            if let savedPassword = KeychainHelper.shared.retrievePassword(service: Constants.bundleId, account: folders[id].folderName) {
                folders[id].folderPassword = savedPassword
            }
        }
        try! updateDataFile()
    }
    
    // - Delete Folders Function
    
    func deleteFolder(_ folder: FolderModel) {
        if let index = folders.firstIndex(where: { $0.folderDate == folder.folderDate }) {
            folders.remove(at: index)
            try! updateDataFile()
        }
    }
    
    // - Update Data File Function
    
    private func updateDataFile() throws {
        let jsonData = try JSONEncoder().encode(folders)
        print(folders)
        let encryptedData = try encryptData(data: jsonData, key: FoldersViewModel.encryptionKey!)
        try encryptedData.write(to: folderDataFileURL, options: .atomic)
        print("Data updated successfully in file: \(folderDataFileURL)")
    }
    
    // - Retrieve Data From File Function
    
    func retrieveDataFromFile() throws -> [FolderModel] {
        do {
            if FileManager.default.fileExists(atPath: folderDataFileURL.path) {
                let encryptedData = try Data(contentsOf: folderDataFileURL)
                let decryptedData = try decryptData(data: encryptedData, key: FoldersViewModel.encryptionKey!)
                let jsonData = try JSONDecoder().decode([FolderModel].self, from: decryptedData)
                return jsonData
            } else {
                return []
            }
        } catch {
            print("Error retrieving data from file: \(error)")
            throw error
        }
    }
    
    // - Function to append data to the encrypted file
    
    func appendDataToFile(data: FolderModel) throws {
        var allFolderData = try retrieveDataFromFile()
        
        if let existingIndex = allFolderData.firstIndex(where: { $0.id == data.id }) {
            allFolderData[existingIndex] = data
        } else {
            allFolderData.append(data)
        }
        
        let jsonData = try JSONEncoder().encode(allFolderData)
        let encryptedData = try encryptData(data: jsonData, key: FoldersViewModel.encryptionKey!)
        try encryptedData.write(to: folderDataFileURL, options: .atomic)
        print("Data saved successfully to file: \(folderDataFileURL)")
    }
    
    // - Generate Encryption Key
    
    func generateEncryptionKey() -> Data {
        if let storedKey = UserDefaults.standard.data(forKey: "encryptionKey") {
            return storedKey
        } else {
            var key = [UInt8](repeating: 0, count: kCCKeySizeAES128)
            _ = SecRandomCopyBytes(kSecRandomDefault, kCCKeySizeAES128, &key)
            let generatedKey = Data(key)
            
            UserDefaults.standard.set(generatedKey, forKey: "encryptionKey")
            return generatedKey
        }
    }
    
    enum JSONError: Error {
        case encodingFailed
    }
    
}

extension FoldersViewModel {
    
    // - Function to encrypt data using CommonCrypto
    
    private func encryptData(data: Data, key: Data) throws -> Data {
        var encryptedBytes = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128)
        var numBytesEncrypted = 0
        
        try key.withUnsafeBytes { keyBytes in
            try data.withUnsafeBytes { dataBytes in
                guard CCCrypt(
                    UInt32(kCCEncrypt),
                    UInt32(kCCAlgorithmAES),
                    UInt32(kCCOptionPKCS7Padding),
                    keyBytes.baseAddress,
                    kCCKeySizeAES128,
                    nil,
                    dataBytes.baseAddress,
                    data.count,
                    &encryptedBytes,
                    encryptedBytes.count,
                    &numBytesEncrypted
                ) == kCCSuccess else {
                    throw JSONError.encodingFailed
                }
            }
        }
        
        return Data(encryptedBytes.prefix(numBytesEncrypted))
    }
    
    // - Function to decrypt data using CommonCrypto
    
    private func decryptData(data: Data, key: Data) throws -> Data {
        var decryptedBytes = [UInt8](repeating: 0, count: data.count + kCCBlockSizeAES128)
        var numBytesDecrypted = 0
        
        try key.withUnsafeBytes { keyBytes in
            try data.withUnsafeBytes { dataBytes in
                guard CCCrypt(
                    UInt32(kCCDecrypt),
                    UInt32(kCCAlgorithmAES),
                    UInt32(kCCOptionPKCS7Padding),
                    keyBytes.baseAddress,
                    kCCKeySizeAES128,
                    nil,
                    dataBytes.baseAddress,
                    data.count,
                    &decryptedBytes,
                    decryptedBytes.count,
                    &numBytesDecrypted
                ) == kCCSuccess else {
                    throw JSONError.encodingFailed
                }
            }
        }
        
        return Data(decryptedBytes.prefix(numBytesDecrypted))
    }
    
}
