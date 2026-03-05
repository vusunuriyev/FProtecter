//
//  QuickLookViewControllerRepresentable.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 31.05.24.
//

import SwiftUI
import QuickLook

struct QuickLookViewControllerRepresentable: UIViewControllerRepresentable {
    
    var url: URL
    
    func makeUIViewController(context: Context) -> QLPreviewController {
        let quickLookViewController = QLPreviewController()
        quickLookViewController.dataSource = context.coordinator
        return quickLookViewController
    }
    
    func updateUIViewController(_ uiViewController: QLPreviewController, context: Context) {
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(url: url)
        }
    
    class Coordinator: NSObject, QLPreviewControllerDataSource {
        
        var url: URL
        
        
        init(url: URL) {
            self.url = url
        }
        
        func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
        
        func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> any QLPreviewItem {
            return url as QLPreviewItem
        }
    }
    
}
