//
//  StatisticsView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 25.05.24.
//

import SwiftUI

struct StatisticsView: View {
    let items: [ItemModel]
    
    @Binding var showStatistics: Bool
    
    // Calculate the statistics
    var itemCounts: [ItemType: Int] {
        var counts = [ItemType: Int]()
        for item in items {
            counts[item.itemType, default: 0] += 1
        }
        return counts
    }
    
    var itemSizes: [ItemType: Double] {
        var sizes = [ItemType: Double]()
        for item in items {
            sizes[item.itemType, default: 0.0] += item.itemSize
        }
        return sizes
    }
    
    var sortedItemTypesBySize: [ItemType] {
        itemSizes.keys.sorted { itemSizes[$0]! > itemSizes[$1]! }
    }
    
    var body: some View {
        ScrollView(.vertical) {
            
            VStack(spacing: 20) {
                
                titleView
                
                VStack {
                    itemsTypesCountsView
                    
                    itemsBySizeView
                }
                .padding()
                
            }
            
        }
        .padding()
        .background {
            BlurView(blurStyle: .systemMaterial)
                .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
            
        }
        .shadow(radius: 10)
    }
    
    var titleView: some View {
        HStack {
            Text("Folder Statistics")
                .font(.kanit_font(size: 32, weight: .kanit_bold))
                .foregroundStyle(.white)
            Spacer()
            Button {
                showStatistics = false
            } label: {
                Image(systemName: "xmark")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .padding(10)
                    .foregroundStyle(Color.white)
                    .background {
                        Circle().fill(Color.black)
                    }
                
            }
        }
        .padding()
        
    }
    
    var itemsTypesCountsView: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Item Types and Counts")
                .font(.headline)
                .foregroundColor(Color.white)
            ForEach(ItemType.allCases, id: \.self) { type in
                if let count = itemCounts[type], count > 0 {
                    HStack {
                        Text(type.rawValue)
                            .font(.subheadline)
                            .foregroundColor(Color.white)
                        Spacer()
                        Text("\(count)")
                            .font(.kanit_font(size: 20, weight: .kanit_bold))
                            .foregroundColor(Color.white)
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
    
    var itemsBySizeView: some View {
        
        VStack(alignment: .leading, spacing: 10) {
            Text("Item Types by Size")
                .font(.headline)
                .foregroundColor(Color.white)
            ForEach(sortedItemTypesBySize, id: \.self) { type in
                if let size = itemSizes[type], size > 0 {
                    HStack {
                        Text(type.rawValue)
                            .frame(width: 60, alignment: .leading)
                            .foregroundColor(Color.white)
                        
                        VStack(alignment: .leading) {
                            Text(String(format: "%.2f MB", size))
                                .font(.kanit_font(size: 20, weight: .kanit_bold))
                                .foregroundColor(Color.white)
                                .frame(height: 20)
                            
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                                    .frame(width: geo.size.width * CGFloat(size / (itemSizes[sortedItemTypesBySize.first!] ?? 1)), height: 20)
                                    .shadow(radius: 3)
                            }
                            .frame(height: 20)
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.black.opacity(0.7))
        .cornerRadius(10)
        .shadow(radius: 5)
        
    }
    
}
