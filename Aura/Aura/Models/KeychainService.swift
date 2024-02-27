//
//  KeychainService.swift
//  Aura
//
//  Created by Greg on 26/02/2024.
//

import Foundation
import Security

class KeychainService {
    
    func save(token: String, account: String) {
        let data = Data(token.utf8)
        let query = [
            kSecValueData: data,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccessible: kSecAttrAccessibleAfterFirstUnlockThisDeviceOnly
        ] as CFDictionary

        // Add to keychain
        let status = SecItemAdd(query, nil)
        if status != errSecSuccess {
            // Try to update if it already exists
            let updateQuery = [
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword
            ] as CFDictionary
            
            let updateAttributes = [
                kSecValueData: data
            ] as CFDictionary

            SecItemUpdate(updateQuery, updateAttributes)
        }
    }

    func getToken(account: String) -> String? {
        let query = [
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: kCFBooleanTrue!,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)

        if status == errSecSuccess {
            if let data = dataTypeRef as? Data {
                return String(data: data, encoding: .utf8)
            }
        }
        return nil
    }
}
