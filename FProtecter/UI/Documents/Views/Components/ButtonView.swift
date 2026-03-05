//
//  ButtonView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 28.05.24.
//

import SwiftUI

struct ButtonView: View {
    let title: String?
    let image: Image
    let completion: () -> Void
    
    let tabSize: CGFloat = 40
    
    var body: some View {
        Button {
            completion()
        } label: {
            VStack {
                image
                    .resizable()
                    .frame(width: tabSize - 12, height: tabSize - 12)
                    .foregroundStyle(Color.white)
                    .background {
                        BlurView(blurStyle: .systemMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
                            .frame(width: tabSize + 10, height: tabSize + 10)
                    }
                if let title {
                    Text(title)
                        .font(.kanit_font(size: 15, weight: .kanit_regular))
                        .foregroundStyle(Color.black)
                }
            }
        }
    }
}
