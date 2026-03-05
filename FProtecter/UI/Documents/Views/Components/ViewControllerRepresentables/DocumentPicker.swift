//
//  SwiftUIView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 22.05.24.
//

import SwiftUI
import UIKit

struct DocumentPicker: UIViewControllerRepresentable {
    var onPick: (URL?) -> Void
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let documentTypes = ["public.data", "public.image", "public.movie"]
        let controller = UIDocumentPickerViewController(documentTypes: documentTypes, in: .import)
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) { }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.onPick(urls.first)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            parent.onPick(nil)
        }
    }
}
