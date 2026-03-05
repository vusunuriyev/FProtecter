//
//  PasswordView.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 22.05.24.
//

import SwiftUI

struct PasswordSettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    let folderID: String
    
    @State private var enteredPassword: String = ""
    @State private var confirmPassword: String = ""
    @State private var alertMessage: String?
    
    let didSetPass: (String) -> Void
    
    var body: some View {
        VStack {
            Text("Set Password")
                .font(.title)
                .padding()
            
            VStack(spacing: 20) {
                SecureField("Enter Password", text: $enteredPassword)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .strokeBorder(Color.gray, lineWidth: 0.5)
                    )
                
                SecureField("Confirm Password", text: $confirmPassword)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .strokeBorder(Color.gray, lineWidth: 0.5)
                    )
                
                if let alertMessage = alertMessage {
                    Text(alertMessage)
                        .font(.kanit_font(size: 13, weight: .kanit_medium))
                        .foregroundStyle(Color.red)
                }
            }
            .padding(.horizontal)
            
            Button(action: {
                validateAndSetPassword()
            }) {
                Text("Set Password")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .foregroundColor(.blue)
                    )
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Cancel")
                    .font(.title3)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .foregroundColor(.gray)
                    )
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            
        }
        .padding()
    }
    
    func validateAndSetPassword() {
        if enteredPassword == confirmPassword {
            if KeychainHelper.shared.savePassword(service: Constants.bundleId, account: folderID, password: confirmPassword) {
                didSetPass(confirmPassword)
                presentationMode.wrappedValue.dismiss()
            } else {
                alertMessage = "Failed to save password"
            }
        } else {
            alertMessage = "Passwords do not match"
        }
    }
}

extension Optional: Identifiable where Wrapped: Identifiable {
    public var id: Wrapped.ID? {
        return self?.id
    }
}
