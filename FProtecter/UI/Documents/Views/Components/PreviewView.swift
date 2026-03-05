//
//  PreviewView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 30.05.24.
//

import SwiftUI

struct PreviewView: View {
    var item: ItemModel
    @Binding var showPreview: Bool
    
    var body: some View {
        ZStack {
            contentView
                .padding()
                .background {
                    BlurView(blurStyle: .systemMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                        .shadow(radius: Constants.shadowRadius)
                }
        }
    }
    
    var contentView: some View {
        VStack {
            HStack {
                Text(item.itemName)
                    .font(.kanit_font(size: Constants.titleSize - 10, weight: .kanit_bold))
                Spacer()
                Button {
                    showPreview = false
                } label: {
                    Image(systemName: "xmark")
                        .resizable()
                        .tint(.white)
                        .frame(width: 10, height: 10)
                        .padding(15)
                        .background {
                            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                                .fill(.black)
                                .shadow(radius: Constants.shadowRadius)
                        }
                }
            }
            .padding(.horizontal)
            itemView
        }
    }
    
    var itemView: some View {
        VStack {
            
            switch item.itemType {
            case .mov:
                ZStack {
                    if let url = loadDocument(named: item.itemURL?.lastPathComponent ?? "") {
                        QuickLookViewControllerRepresentable(url: url)
                    }
                }
            case .mp3, .mp4, .docx, .txt, .pdf :
                ZStack {
                    if let url = loadDocument(named: item.itemName) {
                        QuickLookViewControllerRepresentable(url: url)
                    }
                }
            case .png, .jpg:
                if let image = loadImage(named: item.itemName) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("Failed to load image")
                }
            case .zip:
                ZStack {
                    Image(uiImage: .ZIP)
                        .resizable()
                        .frame(width: 100, height: 100)
                }
            case .unknown:
                ZStack {
                    Text("Unsupported item type")
                }
            }
        }
    }
    
    func loadImage(named name: String) -> UIImage? {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(name)")
        if let data = try? Data(contentsOf: fileURL) {
            return UIImage(data: data)
        }
        return nil
    }
    
    func loadDocument(named name: String) -> URL? {
        let fileURL = getDocumentsDirectory().appendingPathComponent("\(name)")
        return fileURL
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
