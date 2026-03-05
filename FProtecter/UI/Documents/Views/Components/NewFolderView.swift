//
//  SwiftUIView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 22.05.24.
//

import SwiftUI

struct NewFolderView: View {
    @ObservedObject var foldersVM: FoldersViewModel
    @Binding var isCreatingNewFolder: Bool
    /// - Default values
    @State var newFolder: FolderModel = FolderModel(folderName: "New Folder", folderSize: nil, folderDate: Date(), folderItems: [], folderPassword: nil)
    @State var selectedImage: UIImage?
    @State var showImagePicker: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.3)
                .ignoresSafeArea()
            contentView
        }
    }
    
    var contentView: some View {
        VStack(alignment: .center) {
            nameTextFieldView
            titleView
                .padding(.horizontal)
            HStack {
                cancelButtonView
                submitButtonView
            }
                .padding()
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color.white)
                .shadow(radius: Constants.shadowRadius)
        }
        .padding()
    }
    
    var titleView: some View {
        ZStack {
            Image(uiImage: .folder)
                .resizable()
                .frame(width: 100, height: 100)
                .shadow(radius: Constants.shadowRadius)
        }
    }
    
    var nameTextFieldView: some View {
        TextField(newFolder.folderName, text: $newFolder.folderName)
            .font(.kanit_font(size: 20, weight: .kanit_medium))
            .multilineTextAlignment(.center)
            .foregroundStyle(Color.blue)
    }
    
    var cancelButtonView: some View {
        Button {
            isCreatingNewFolder = false
        } label: {
            Text("Cancel")
                .font(.kanit_font(size: 15, weight: .kanit_regular))
                .foregroundStyle(Color.white)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .fill(Color.red)
                        .frame(width: 70, height: 40)
                }
        }
    }
    
    var submitButtonView: some View {
        Button {
            foldersVM.createFolder(newFolder)
            isCreatingNewFolder = false
        } label: {
            Text("Submit")
                .font(.kanit_font(size: 15, weight: .kanit_regular))
                .foregroundStyle(Color.white)
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .fill(Color.green)
                        .frame(width: 70, height: 40)
                }
        }
    }
    
    
    
}
