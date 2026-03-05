//
//  SettingsView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 20.05.24.
//

import SwiftUI
import AVFoundation
import _AVKit_SwiftUI
import SDWebImageSwiftUI

struct SettingsView: View {
    
    var body: some View {
        ZStack {
            ScrollView {
                VStack {
                    HStack {
                        Text("Settings")
                            .font(.kanit_font(size: Constants.titleSize, weight: .kanit_bold))
                        Spacer()
                    }
                    .padding()
                    
                    videoAdView
                    
                    SettingsParametersView()
                    
                    imageAdView
                    
                    Spacer()
                    
                }
            }
        }
        
    }
    
    
    // - Marketing Ad View
    
    @State private var splashVideoString = ""
    @State private var splashUrlString: String?
    @State private var player: AVPlayer?
    
    var videoAdView: some View {
        ZStack {
            if splashVideoString != "" {
                VideoPlayer(player: player)
                    .frame(height: 200)
                    .cornerRadius(10)
                    .padding()
                    .onAppear {
                        self.player = AVPlayer(url: URL(string: splashVideoString)!)
                        self.player?.play()
                        UIViewController.attemptRotationToDeviceOrientation()
                    }
                    .onDisappear {
                        self.player?.pause()
                        self.player = nil
                    }
                    .onTapGesture {
                        if let urlString = splashUrlString, let url = URL(string: urlString) {
                            UIApplication.shared.open(url)
                        }
                    }
            }
        }
        .onAppear {
            MarketingNetworking.shared.getMarketingVideo { data in
                print(data.fileLink)
                DispatchQueue.main.async {
                    self.splashUrlString = data.url
                    print(data.url)
                    self.splashVideoString = data.fileLink
                    guard let url = URL(string: self.splashVideoString) else {return}
                    self.player = AVPlayer(url: url)
                }
            }
        }
    }
    
    @State var marketingImageString: String = ""
    @State var marketingUrlString: String?
    
    var imageAdView: some View {
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
}

struct SettingsParametersView: View {
    @ObservedObject var settingsVM: SettingsViewModel = SettingsViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                ForEach(SettingsParameters.allCases, id: \.self) { settingsParameter in
                    let settingsParameter = SettingsParameterModel(parameterName: settingsParameter.rawValue, parameterIcon: Image(settingsParameter.rawValue)) {
                        switch settingsParameter {
                        case .helpCenter: openHelpCenterParameters()
                        case .termsOfUse: openTermsOfUseParameters()
                        case .privacyPolicy: openPrivacyPolicyParameters()
                        }
                        
                    }
                    settingsParameterCell(settingsParameter: settingsParameter)
                }
            }
        }
    }
    
    @ViewBuilder
    func settingsParameterCell(settingsParameter: SettingsParameterModel) -> some View {
        Button {
            settingsParameter.handler()
        } label: {
            VStack {
                HStack {
                    settingsParameter.parameterIcon
                        .resizable()
                        .frame(width: 20, height: 20)
                    Text(settingsParameter.parameterName)
                        .font(.kanit_font(size: 20, weight: .kanit_regular))
                        .foregroundStyle(Color.black)
                }
                Divider()
                    .padding(.horizontal)
            }
            .padding(5)
            .padding(.vertical, 20)
            .background {
                RoundedRectangle(cornerRadius: Constants.cornerRadius).fill(Color.white)
                    .shadow(radius: Constants.shadowRadius)
                    .padding()
            }
        }
    }
    
    
    func openHelpCenterParameters() {
        if let url = URL(string: "https://fprotecter.wordpress.com/contact/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Invalid URL")
        }
    }
    
    func openPrivacyPolicyParameters() {
        if let url = URL(string: "https://fprotecter.wordpress.com/privacy-policy/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Invalid URL")
        }
    }
    
    func openTermsOfUseParameters() {
        if let url = URL(string: "https://fprotecter.wordpress.com/terms-of-use/") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("Invalid URL")
        }
    }
    
}

#Preview {
    SettingsView()
}
