//
//  ItemsView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 22.05.24.
//

import SwiftUI

struct ItemsView: View {
    @ObservedObject var foldersVM: FoldersViewModel
    
    @State var selectedFolderId: Int
    
    @State private var showImagePicker = false
    @State private var showDocumentPicker = false
    @State private var selectedImage: UIImage? = nil
    @State private var selectedDocumentURL: URL? = nil
    
    @State private var isAuth: Bool = false
    @State private var showPasswordSettings: Bool = false
    @State private var enteredPassword: String = ""
    @State private var showError: Bool = false
    
    @State private var showOverwriteConfirmation: Bool = false
    @State private var tempNewItem: ItemModel? = nil
    
    @State private var selectedItems = Set<ItemModel>()
    @State private var isEditing = false
    
    @State private var selectedItemForPreview: ItemModel? = nil
    @State private var showPreview = false

    
    let didAddItems: () -> Void
    let didSelectEncrypt: () -> Void
    
    var body: some View {
        ZStack {
            if foldersVM.folders[selectedFolderId].folderPassword != nil {
                if isAuth {
                    contentView
                } else {
                    passwordView
                }
            } else {
                contentView
            }
        }
        
    }
    
    var contentView: some View {
        ZStack {
            
            List(selection: $selectedItems) {
                ForEach(foldersVM.folders[selectedFolderId].folderItems) { item in
                    HStack {
                        
                        ItemCellView(item: item, isSelected: selectedItems.contains(item), isEditing: isEditing)
                            .contextMenu(ContextMenu(menuItems: {
                                Button(role: .destructive) {
                                    foldersVM.deleteItem(item, selectedFolderId: selectedFolderId)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }))
                            .swipeActions {
                                Button(role: .destructive) {
                                    foldersVM.deleteItem(item, selectedFolderId: selectedFolderId)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .onTapGesture {
                                if isEditing {
                                    if selectedItems.contains(item) {
                                        selectedItems.remove(item)
                                    } else {
                                        selectedItems.insert(item)
                                    }
                                } else {
                                    selectedItemForPreview = item
                                    showPreview = true
                                }
                            }

                    }
                }
            }

            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack {
                        addImageButtonView
                            .padding(.bottom, 30)
                        addDocumentsButtonView
                    }
                }
                .padding()
            }
            .padding()
            
            // - MARK: Show Overwrite View
            
            if showOverwriteConfirmation {
                CustomAlertView(text: "File Already Exists", message: "A file with the same name already exists. Do you want to overwrite it?", buttonName: "Submit") {
                    showOverwriteConfirmation = false
                } didTapSubmitButton: {
                    if let newItem = tempNewItem {
                        overwriteItem(newItem)
                    }
                }

            }
            
            if showPreview {
                if let selectedItem = selectedItemForPreview {
                    PreviewView(item: selectedItem, showPreview: $showPreview)
                        .padding()
                }
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    didSelectEncrypt()
                    showPasswordSettings = true
                } label: {
                    Text("\(foldersVM.folders[selectedFolderId].folderPassword != nil ? "Reset" : "Encrypt")")
                        .font(.kanit_font(size: 18, weight: .kanit_regular))
                }
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    isEditing.toggle()
                }) {
                    Text(isEditing ? "Done" : "Edit")
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if isEditing {
                    Button(action: deleteSelectedItems) {
                        Text("Delete Selected")
                    }
                    .disabled(selectedItems.isEmpty)
                }
            }
        }
        .environment(\.editMode, isEditing ? .constant(.active) : .constant(.inactive))
        .sheet(isPresented: $showImagePicker) {
            ImagePicker { image, imageURL, imageFileName in
                
                if let image,
                   let imageData = image.jpegData(compressionQuality: 1.0),
                   let imageURL{
                    
                    print(imageURL.absoluteString)
                    
                    let documentSize = Double(imageData.count) / (1024 * 1024) // Convert to MB
                    let newItem = ItemModel(itemName: imageFileName ?? "", itemType: foldersVM.getItemType(from: imageURL), itemSize: documentSize, itemDate: Date(), itemURL: imageURL)
                    
                    
                    if let data = image.sd_imageData() {
                        let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(imageFileName ?? "")")
                        try? data.write(to: filename!)
                    }
                    

                    
                    if foldersVM.folders[selectedFolderId].folderItems.contains(where: { $0.itemName == newItem.itemName }) {
                        tempNewItem = newItem
                        showOverwriteConfirmation = true
                    } else {
                        DispatchQueue.main.async {
                            foldersVM.folders[selectedFolderId].folderItems.append(newItem)
                            foldersVM.updateFolders()
                            showImagePicker = false
                        }
                    }
                }
            } videoCompletion: { videoURL, videoFileName in
                if let videoURL, let videoFileName {
                    print("----- DEBUG: videoCompletion -----")
                    print(videoURL)
                    addItem(from: videoURL, itemName: videoFileName)
                }
            }
        }
        
        .sheet(isPresented: $showDocumentPicker) {
            DocumentPicker { url in
                if let documentURL = url {
                    addItem(from: documentURL, itemName: nil)
                }
            }
        }
        .sheet(isPresented: $showPasswordSettings) {
            PasswordSettingsView(folderID: foldersVM.folders[selectedFolderId].id.uuidString) { pass in
                if let folderIndex = foldersVM.folders.firstIndex(where: { $0.id == foldersVM.folders[selectedFolderId].id }) {
                    foldersVM.folders[folderIndex].folderPassword = pass
                    foldersVM.updateFoldersPassword()
                }
            }
        }
        
    }
    
    // MARK: - Add Image Button View & Add Documents Button View
    
    var addImageButtonView: some View {
        ButtonView(title: nil, image: Image(uiImage: .image)) {
            showImagePicker = true
        }
        .shadow(radius: Constants.shadowRadius)
    }
    
    var addDocumentsButtonView: some View {
        ButtonView(title: nil, image: Image(uiImage: .documentsIcon)) {
            showDocumentPicker = true
        }
        .shadow(radius: Constants.shadowRadius)
    }
    
    
    
    // MARK: - Password View
    
    var passwordView: some View {
        VStack(spacing: 20) {
            if showError {
                Text("Incorrect Password")
                    .foregroundColor(.red)
                    .font(.system(size: 14, weight: .semibold))
            }
            
            SecureField("Enter the password", text: $enteredPassword)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding(.horizontal)
            
            Button(action: {
                isAuth = enteredPassword == foldersVM.folders[selectedFolderId].folderPassword
                showError = !isAuth
            }) {
                Text("Submit")
                    .font(.system(size: 15, weight: .regular))
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(8)
                    .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
            }
            .padding(.horizontal)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding()
    }
    
    private func addItem(from url: URL, itemName: String?) {
        do {
            var newItem: ItemModel!
            
            let documentData = try Data(contentsOf: url)
            let documentSize = Double(documentData.count) / (1024 * 1024) // Convert to MB
            
            if let itemName {
                newItem = ItemModel(itemName: itemName, itemType: foldersVM.getItemType(from: url), itemSize: documentSize, itemDate: Date(), itemURL: url)
            } else {
                newItem = ItemModel(itemName: url.lastPathComponent, itemType: foldersVM.getItemType(from: url), itemSize: documentSize, itemDate: Date(), itemURL: url)
            }
            
            let filename = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("\(url.lastPathComponent)")
            try? documentData.write(to: filename!)
            
            if foldersVM.folders[selectedFolderId].folderItems.contains(where: { $0.itemName == newItem.itemName }) {
                tempNewItem = newItem
                showOverwriteConfirmation = true
            } else {
                DispatchQueue.main.async {
                    foldersVM.folders[selectedFolderId].folderItems.append(newItem)
                    foldersVM.updateFolders()
                    showDocumentPicker = false
                }
            }
            
            
        } catch {
            print("Failed to load document data: \(error.localizedDescription)")
        }
        
        url.stopAccessingSecurityScopedResource()
    }
    
    private func overwriteItem(_ item: ItemModel) {
        if let index = foldersVM.folders[selectedFolderId].folderItems.firstIndex(where: { $0.itemName == item.itemName }) {
            foldersVM.folders[selectedFolderId].folderItems.remove(at: index)
            foldersVM.folders[selectedFolderId].folderItems.append(item)
            foldersVM.updateFolders()
        }
        showOverwriteConfirmation = false
    }
    
    
    private func deleteSelectedItems() {
        for item in selectedItems {
            if let index = foldersVM.folders[selectedFolderId].folderItems.firstIndex(of: item) {
                foldersVM.folders[selectedFolderId].folderItems.remove(at: index)
            }
        }
        foldersVM.updateFolders()
        selectedItems.removeAll()
    }
    
    
}
