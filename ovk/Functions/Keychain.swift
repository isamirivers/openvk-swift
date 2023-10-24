//
//  Keychain.swift
//  ovk
//
//  Created by Isami Riša on 24.10.2023.
//

import Foundation
import Security

func getValueFromKeychain(forKey key: String) -> String? {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key,
        kSecReturnData as String: true
    ]

    var result: AnyObject?
    let status = SecItemCopyMatching(query as CFDictionary, &result)

    if status == errSecSuccess, let data = result as? Data, let value = String(data: data, encoding: .utf8) {
        return value
    } else {
        return nil
    }
}

func saveValueToKeychain(forKey key: String, value: String) -> Bool {
    if let data = value.data(using: .utf8) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]

        let status = SecItemAdd(query as CFDictionary, nil)
        return status == errSecSuccess
    }

    return false
}

func deleteValueFromKeychain(forKey key: String) -> Bool {
    let query: [String: Any] = [
        kSecClass as String: kSecClassGenericPassword,
        kSecAttrAccount as String: key
    ]

    let status = SecItemDelete(query as CFDictionary)
    return status == errSecSuccess
}
