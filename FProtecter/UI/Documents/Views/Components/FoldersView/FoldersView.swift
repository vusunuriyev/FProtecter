//
//  DocumentsView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 20.05.24.
//

import SwiftUI

struct FoldersView: View {
    @ObservedObject var foldersVM: FoldersViewModel
    
    @State private var folderPassword: String?
    @State private var currentFolder: FolderModel?
    @State var passwords: [String] = []
    
    @State private var showDeleteAlert = false
    @State private var folderToDelete: FolderModel?
    
    @State var didSelectShowStatistics: (FolderModel) -> Void

    private let adaptiveColumn = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        ScrollView {
            contentView
        }
    }
    
    var contentView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("My Folders")
                    .foregroundStyle(Color.black)
                    .font(.kanit_font(size: Constants.titleSize - 10, weight: .kanit_medium))
            }
            .padding(.horizontal)
            
            
            LazyVGrid(columns: adaptiveColumn) {
                ForEach(foldersVM.folders.indices, id: \.self) { index in
                    cellView(index)
                }
            }
                
            .offset(y: -20)
        }
    
        
    }
    
    func cellView(_ id: Int) -> some View {
        NavigationLink(destination: {
            ItemsView(foldersVM: foldersVM, selectedFolderId: id) {
                updateFolder(id: id)
            } didSelectEncrypt: {
                updateFolder(id: id)
            }

        }, label: {
            FolderCellView(folder: foldersVM.folders[id], isSecure: foldersVM.folders[id].folderPassword != nil)
                .contextMenu {
                    Button(role: .cancel) {
                        didSelectShowStatistics(foldersVM.folders[id])
                    } label: {
                        Label("Statistics", systemImage: "info.circle.fill")
                    }
                    
                    Button(role: .destructive) {
                        folderToDelete = foldersVM.folders[id]
                        showDeleteAlert = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
        })
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Folder"),
                message: Text("Are you sure you want to delete this folder?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let folderToDelete = folderToDelete {
                        deleteFolder(folder: folderToDelete)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func updateFolder(id: Int) {
        
        do {
            try foldersVM.appendDataToFile(data: foldersVM.folders[id])
            let loadedData = try foldersVM.retrieveDataFromFile()
            print("Loaded Data: \(loadedData)")
        } catch {
            print("Error: \(error)")
        }
        foldersVM.updateFolders()
    }
    
    private func deleteFolder(folder: FolderModel) {
        foldersVM.deleteFolder(folder)
    }
}
