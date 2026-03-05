//
//  StorageViewModel.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 25.05.24.
//

import SwiftUI

class StorageViewModel: ObservableObject{
    @Published var storage: StorageModel?
    
    init() {
        self.storage = calculateStorage()
    }
    
    func calculateStorage() -> StorageModel? {
        let fileManager = FileManager.default
        
        let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last!
        
        guard let systemAttributes = try? fileManager.attributesOfFileSystem(forPath: documentDirectory) else {return nil}
        
        if let totalSize = systemAttributes[.systemSize] as? Int64,
           let freeSize = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage
             {
            print(totalSize)
            print(freeSize)
            let storage = StorageModel(available: freeSize, total: totalSize)
            return storage
        }
        
        return nil
        
    }
    
    func formatBytes(_ bytes: Int64) -> String {
        let formatter = ByteCountFormatter()
        formatter.allowedUnits = [.useGB, .useMB]
        formatter.countStyle = .file
        return formatter.string(fromByteCount: bytes)
    }
    
    func availableStoragePercentage() -> Double {
        if storage?.total == 0 {
            return 0.0
        }
        return (Double(storage?.total ?? 0) - Double(storage?.available ?? 0)) / Double(storage?.total ?? 0)
    }
    
}
