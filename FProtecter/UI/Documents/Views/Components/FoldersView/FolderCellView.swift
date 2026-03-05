//
//  FolderCellView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 21.05.24.
//

import SwiftUI

struct FolderCellView: View {
    let folder: FolderModel
    
    let isSecure: Bool
    
    let folderSize: CGSize = CGSize(width: 100, height: 120)
    
    var body: some View {
       
        ZStack {
            BlurView(blurStyle: .systemMaterial)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                .frame(width: folderSize.width, height: folderSize.height)
                .shadow(radius: Constants.shadowRadius)
            contentView
        }
    }
    
    var contentView: some View {
        VStack {
            folderNameView
            folderImageView
                .shadow(radius: Constants.shadowRadius)
            folderSizeView
        }
        .padding()
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
        .shadow(radius: Constants.shadowRadius - 4)
        .padding()
    }
    
    var folderNameView: some View {
        Text(folder.folderName)
            .foregroundStyle(Color.black)
            .font(.kanit_font(size: 14, weight: .kanit_medium))
            .frame(height: 20)
            .lineLimit(2)
    }
    
    var folderImageView: some View {
        ZStack {
            Image(uiImage: UIImage.folder)
                .resizable()
                .frame(width: 59, height: 59)
            if isSecure {
                Image(uiImage: UIImage.padlock)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .offset(x: 21, y: 10)
            }
        }
    }
    
    var folderSizeView: some View {
        ZStack {
            if let folderSize = folder.folderSize {
                Text("\(folderSize)")
                    .font(.kanit_font(size: 13, weight: .kanit_light))
            }
        }
    }
}

