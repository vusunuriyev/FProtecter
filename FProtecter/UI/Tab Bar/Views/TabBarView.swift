//
//  TabBarView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 21.05.24.
//

import SwiftUI

struct TabBarView: View {
    @Binding var selectedTab: TabBar
    let plusButtonHandler: () -> Void
    
    let tabSize: CGFloat = 30
    
    var body: some View {
        ZStack {
            HStack {
                tabButtonView(tab: .documents)
                Spacer()
                tabButtonView(tab: .settings)
            }
            .padding(.horizontal)
            .padding()
            .background(
                Color.black
            )
            .ignoresSafeArea(.keyboard)
            
            
            plusButtonView
        }
    }
    
    var plusButtonView: some View {
        Button {
            plusButtonHandler()
        } label: {
            Image("addFolder")
                .resizable()
                .frame(width: tabSize + 5, height: tabSize + 5)
                .foregroundColor(.white)
                .padding(15)
                .background(
                    Circle()
                        .fill(Color.white)
                        .shadow(radius: 5)
                )
                
//                .padding(.bottom, -40)
//                .zIndex(1)
        }
        .shadow(radius: 10)
    }
    
    @ViewBuilder
    func tabButtonView(tab: TabBar) -> some View {
        Button {
            withAnimation {
                selectedTab = tab
            }
        } label: {
            VStack {
                Image(selectedTab == tab ? "Selected\(tab.rawValue.capitalized)" : tab.rawValue.capitalized)
                    .resizable()
                    .frame(width: tabSize, height: tabSize)
                    .foregroundColor(selectedTab == tab ? .purple : .black)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .foregroundColor(selectedTab == tab ? .white : .clear)
                    )
            }
            .padding(.vertical, 5)
            .padding(.horizontal, 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}
