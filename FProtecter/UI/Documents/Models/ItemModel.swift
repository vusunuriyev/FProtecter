//
//  DocumentModel.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 20.05.24.
//

import SwiftUI

enum ItemType: String, Codable, CaseIterable {
    case mp3 = "MP3"
    case mp4 = "MP4"
    case mov = "MOV"
    case png = "PNG"
    case jpg = "JPG"
    case zip = "ZIP"
    case txt = "TXT"
    case pdf = "PDF"
    case docx = "DOCX"
    case unknown
}

struct ItemModel: Codable, Identifiable, Hashable {
    var id: UUID = UUID()
    let itemName: String
    let itemType: ItemType
    let itemSize: Double
    let itemDate: Date
    let itemURL: URL?
}
