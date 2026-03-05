//
//  KeychainHelper.swift
//  FProtecter
//
//  Created by Vusal Nuriyev 2 on 22.05.24.
//

import SwiftUI
import Security

class KeychainHelper {
    static let shared = KeychainHelper()
    
    func savePassword(service: String, account: String, password: String) -> Bool {
        if let data = password.data(using: .utf8) {
            let query = [
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrService as String: service,
                kSecAttrAccount as String: account,
                kSecValueData as String: data
            ] as [String: Any]
            
            SecItemDelete(query as CFDictionary) // Delete any existing items
            let status = SecItemAdd(query as CFDictionary, nil)
            return status == errSecSuccess
        }
        return false
    }
    
    func retrievePassword(service: String, account: String) -> String? {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]
        
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data,
               let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        return nil
    }
}
