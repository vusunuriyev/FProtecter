//
//  FolderModel.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 21.05.24.
//

import SwiftUI

struct FolderModel: Codable, Identifiable {
    var id: UUID = UUID()
    var folderName: String
    var folderSize: Double?
    var folderDate: Date
    var folderItems: [ItemModel]
    var folderPassword: String?
}
