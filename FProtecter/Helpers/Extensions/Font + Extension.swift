//
//  Font + Extension.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 20.05.24.
//

import SwiftUI

enum KanitFont: String, CaseIterable {
    case kanit_regular = "Kanit-Regular"
    case kanit_medium = "Kanit-Medium"
    case kanit_mediumItalic = "Kanit-MediumItalic"
    case kanit_bold = "Kanit-Bold"
    case kanit_boldItalic = "Kanit-BoldItalic"
    case kanit_light = "Kanit-Light"
}

extension Font {
    
    static func kanit_font(size: CGFloat, weight: KanitFont = .kanit_regular) -> Font {
        let font = Font.custom(weight.rawValue, size: size)
        return font
    }
    
}
