//
//  FProtecterApp.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 17.05.24.
//

import SwiftUI

@main
struct FProtecterApp: App {
    @State var splashImageString: String?
    @State var splashUrlString: String?
    @State var showView: Bool = false
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            Group {
                if let splashImageString = splashImageString {
                    ContentView(splashImageString: splashImageString, splashUrlString: splashUrlString)
                } else {
                    ContentView(splashImageString: nil)
                }
                
                
            }
            .onAppear {
                MarketingNetworking.shared.getSplashImage { data in
                    DispatchQueue.main.async {
                        if let fileLink = data?.fileLink,
                           let urlString = data?.url {
                            self.splashUrlString = urlString
                            self.splashImageString = fileLink
                        } else {
                            showView = true
                        }
                    }
                }
            }
        }
    }
}
