//
//  HomeView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 20.05.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct DocumentsView: View {
    var foldersVM: FoldersViewModel
    
    var storageVM: StorageViewModel = StorageViewModel()
    
    @State var passwords: [String] = []
    
    // - Marketing Ad Properties
    @State var marketingUrlString: String?
    @State var marketingImageString: String = ""
    
    @State private var showStatistics: Bool = false
    @State private var folderToShowStatistics: FolderModel?
    
    
    var body: some View {
        ZStack {
            
            NavigationView {
                ScrollView {
                    ZStack {
                        VStack {
                            Color.black
                                .frame(height: 200)
                                .ignoresSafeArea()
                            Spacer()
                        }
                        
                        VStack {
                            titleView
                            adView
                            storageView
                            FoldersView(foldersVM: foldersVM, passwords: passwords) { folder in
                                showStatistics = true
                                self.folderToShowStatistics = folder
                            }
                        }
                        
                    }
                }
                
                if showStatistics {
                    if let folderToShowStatistics = folderToShowStatistics {
                        StatisticsView(items: folderToShowStatistics.folderItems, showStatistics: $showStatistics)
                            .padding()
                    }
                }
            }
        }
        .onAppear {
            MarketingNetworking.shared.getMarketingImage { data in
                print(data.fileLink)
                DispatchQueue.main.async {
                    self.marketingUrlString = data.url
                    self.marketingImageString = data.fileLink
                }
            }
        }
        
    }
    
    var backgroundView: some View {
        ZStack {
            Color.black
        }
    }
    
    var titleView: some View {
        HStack {
            Text("My Documents")
                .font(.kanit_font(size: Constants.titleSize, weight: .kanit_bold))
                .foregroundStyle(Color.white)
            Spacer()
        }
        .padding()
    }
    
    var storageView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color.gray)
                .shadow(color: Color.white, radius: Constants.shadowRadius - 5)
                .padding()
            HStack {
                VStack(alignment: .leading) {
                    Text("Available storage on your iPhone")
                        .font(.kanit_font(size: 14, weight: .kanit_light))
                        .foregroundStyle(Color.white)
                    
                    HStack {
                        Text("\(storageVM.formatBytes(storageVM.storage?.available ?? 0))")
                            .font(.kanit_font(size: 22, weight: .kanit_bold))
                            .foregroundColor(.white)
                        
                        Text("of")
                            .font(.kanit_font(size: 22, weight: .kanit_light))
                            .foregroundColor(.white)
                        
                        Text("\(storageVM.formatBytes(storageVM.storage?.total ?? 0))")
                            .font(.kanit_font(size: 22, weight: .kanit_bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.trailing)
                
                ZStack {
                    Circle()
                        .stroke(lineWidth: 10)
                        .opacity(0.3)
                        .foregroundColor(Color.white)
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(min(storageVM.availableStoragePercentage(), 1.0)))
                        .stroke(style: StrokeStyle(lineWidth: 10, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color.green)
                        .shadow(color: .green, radius: Constants.shadowRadius)
                        .rotationEffect(Angle(degrees: 270.0))
                        .animation(.linear, value: storageVM.availableStoragePercentage())
                    
                    Text(String(format: "%.1f%%", storageVM.availableStoragePercentage() * 100))
                        .font(.kanit_font(size: 15, weight: .kanit_bold))
                        .foregroundColor(Color.white)
                }
                .frame(width: 70, height: 70)
            }
            .padding()
            
        }
        .frame(height: 150)
    }
    
    
}

extension DocumentsView {
    
    var adView: some View {
        ZStack {
            if marketingImageString != "" {
                WebImage(url: URL(string: marketingImageString))
                    .resizable()
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
                    .onTapGesture {
                        if let urlString = marketingUrlString, let url = URL(string: urlString) {
                            UIApplication.shared.open(url)
                        }
                    }
            }
        }
        
    }
}
