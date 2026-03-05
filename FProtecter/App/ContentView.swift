//
//  ContentView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 20.05.24.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContentView: View {
    var foldersVM: FoldersViewModel = FoldersViewModel()
    @State var selectedTab: TabBar = .documents
    @State var isCreatingNewFolder: Bool = false
    
    @State var splashImageString: String?
    @State var splashUrlString: String?
    @State var showSplash: Bool = true
    
    var body: some View {
        ZStack {
            if showSplash && splashImageString != nil {
                VStack(alignment: .trailing) {
                    Button {
                        showSplash = false
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 15, height: 15)
                            .padding()
                    }
                    
                    WebImage(url: URL(string: splashImageString ?? ""))
                        .resizable()
                        .cornerRadius(10)
                        .padding()
                        .onTapGesture {
                            if let urlString = splashUrlString, let url = URL(string: urlString) {
                                UIApplication.shared.open(url)
                            }
                        }
                }
            } else if !showSplash || splashImageString == nil {
                
                selectedTabView
                
                tabBarView
                
                if isCreatingNewFolder {
                    NewFolderView(foldersVM: foldersVM, isCreatingNewFolder: $isCreatingNewFolder)
                }
            }
        }
    }
    
    var selectedTabView: some View {
        Group {
            switch selectedTab {
            case .documents:
                DocumentsView(foldersVM: foldersVM)
            case .settings:
                SettingsView()
            }
        }
        .padding(.bottom, 100)
    }
    
    var tabBarView: some View {
        VStack {
            Spacer()
            TabBarView(selectedTab: $selectedTab) {
                isCreatingNewFolder = true
            }
        }
        .padding(.top, 40)
    }
}

#Preview {
    ContentView()
}
