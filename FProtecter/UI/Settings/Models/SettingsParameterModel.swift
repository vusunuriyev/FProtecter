//
//  ParameterModel.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 20.05.24.
//

import SwiftUI

enum SettingsParameters: String, CaseIterable {
    case helpCenter = "Help Center"
    case termsOfUse = "Terms Of Use"
    case privacyPolicy = "Privacy Policy"
    
}

struct SettingsParameterModel {
    let parameterName: String
    let parameterIcon: Image
    let handler: () -> Void
}
