//
//  BlurView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 26.05.24.
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    var blurStyle: UIBlurEffect.Style
    
    func makeUIView(context: Context) -> UIVisualEffectView {
        let view = UIVisualEffectView(effect: UIBlurEffect(style: blurStyle))
        return view
    }
    
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: blurStyle)
    }
}
