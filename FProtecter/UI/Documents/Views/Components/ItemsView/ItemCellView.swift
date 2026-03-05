//
//  ItemCellView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 22.05.24.
//

import SwiftUI

struct ItemCellView: View {
    let item: ItemModel
    let isSelected: Bool
    let isEditing: Bool
    
    var body: some View {
        HStack {
            selectedView
            itemIcon
            itemInfo
            Spacer()
        }
        .padding(.horizontal)
    }
    
    var selectedView: some View {
        ZStack {
            if isEditing {
                if isSelected {
                    Image(systemName: "checkmark.circle")
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "circle")
                        .foregroundColor(.gray)
                }
            }
        }
    }
    
    var itemIcon: some View {
        Image(item.itemType.rawValue.uppercased())
            .resizable()
            .frame(width: Constants.itemIconSize.width, height: Constants.itemIconSize.height)
        
    }
    
    var itemInfo: some View {
        VStack(alignment: .leading) {
            Text(item.itemName)
                .font(.kanit_font(size: Constants.itemNameSize, weight: .kanit_regular))
                .lineLimit(2)
            Text("\(item.itemType.rawValue) • \(String(format: "%.1f%", item.itemSize))MB • \(item.itemDate)")
                .font(.kanit_font(size: 12, weight: .kanit_light))
                .foregroundStyle(Color.gray.opacity(0.75))
        }
    }
}
