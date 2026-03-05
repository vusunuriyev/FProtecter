//
//  ImagePicker.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 22.05.24.
//

import SwiftUI
import UIKit
import UniformTypeIdentifiers
import Photos

struct ImagePicker: UIViewControllerRepresentable {
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            
            
            // - Checks if the user gave access to photos/videos for us
            
            PHPhotoLibrary.requestAuthorization { status in
                guard status == .authorized else {
                    DispatchQueue.main.async {
                        self.parent.presentationMode.wrappedValue.dismiss()
                    }
                    return
                }
                
                
                
                if let asset = info[.phAsset] as? PHAsset {
                    
                    if let imageURL = info[.imageURL] as? URL,
                       let uiImage = info[.originalImage] as? UIImage {
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            let assetResources = PHAssetResource.assetResources(for: asset)
                            if let assetResource = assetResources.first {
                                DispatchQueue.main.async {
                                    let fileName = assetResource.originalFilename
                                    
                                    self.parent.imageCompletion?(uiImage, imageURL, fileName)
                                    self.parent.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                        
                    } else if let videoURL = info[.mediaURL] as? URL{
                        
                        DispatchQueue.global(qos: .userInitiated).async {
                            let assetResources = PHAssetResource.assetResources(for: asset)
                            if let assetResource = assetResources.first {
                                DispatchQueue.main.async {
                                    let fileName = assetResource.originalFilename
                                    
                                    self.parent.videoCompletion?(videoURL, fileName)
                                    self.parent.presentationMode.wrappedValue.dismiss()
                                }
                            }
                        }
                    }
                    
                }
                
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
    
    @Environment(\.presentationMode) var presentationMode
    var imageCompletion: ((UIImage?, URL?, String?) -> Void)?
    var videoCompletion: ((URL?, String?) -> Void)?
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.mediaTypes = [UTType.image.identifier, UTType.movie.identifier]
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
}
