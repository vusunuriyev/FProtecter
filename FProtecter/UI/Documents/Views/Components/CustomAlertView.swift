//
//  CustomAlertView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 30.05.24.
//

import SwiftUI

struct CustomAlertView: View {
    let text: String
    let message: String
    let buttonName: String
    
    let didTapCancelButton: () -> Void
    let didTapSubmitButton: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Constants.cornerRadius)
                .fill(Color.white)
                .frame(height: 250)
                .shadow(radius: Constants.shadowRadius)
            
            VStack {
                VStack {
                    Text(text)
                        .font(.kanit_font(size: 25, weight: .kanit_boldItalic))
                    Text(message)
                        .font(.kanit_font(size: 15, weight: .kanit_regular))
                }
                .multilineTextAlignment(.center)
                
                HStack {
                    cancelButtonView
                    submitButtonView
                }
                .padding()
            }
        }
        .padding()
    }
    
    var cancelButtonView: some View {
        Button {
            didTapCancelButton()
        } label: {
            Text("Cancel")
                .font(.kanit_font(size: 15, weight: .kanit_bold))
                .foregroundStyle(Color.white)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .fill(Color.red)
                }
        }
    }
    
    var submitButtonView: some View {
        Button {
            didTapSubmitButton()
        } label: {
            Text(buttonName)
                .font(.kanit_font(size: 15, weight: .kanit_bold))
                .foregroundStyle(Color.green)
                .padding()
                .background {
                    RoundedRectangle(cornerRadius: Constants.cornerRadius)
                        .fill(Color.gray.opacity(0.5))
                }
        }
    }
    
}
