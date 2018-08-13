//
//  KeychainWrapper.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 8/1/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Security

enum KeychainError: Error {
    case noPassword
    case unexpectedRefreshData
    case unhandledError(status: OSStatus)
    case noToken
}

class Keyring {
    
    static let tag = "com.nems.app".data(using: .utf8)!
    
    
    class func saveRefresh(token initToken: AuthToken?) throws {
        //debugPrint("attempting to save to keychain")
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        guard let token = initToken else {
            throw KeychainError.noToken
        }
        
        do {
            let updateQuery: [String: Any] = [kSecValueData as String: token.refresh_token?.data(using: .utf8)]
            try Keyring.retrieveRefreshToken()
            let status = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
            guard status == errSecSuccess else {
                throw KeychainError.unhandledError(status: status)
            }
            OAuth.session?.delegate?.tokenChanged()
            //debugPrint("updated keychain")
        } catch {
            query.updateValue(token.refresh_token?.data(using: .utf8), forKey: kSecValueData as String)
            let status = SecItemAdd(query as CFDictionary, nil)
            guard status == errSecSuccess else {
                throw KeychainError.unhandledError(status: status)
            }
        }
        
    }
    
    class func retrieveRefreshToken() throws {
        debugPrint("attemping to retrieve token from keychain")
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainError.noToken
        }
        guard status == errSecSuccess else {
            throw KeychainError.unhandledError(status: status)
        }
        guard let existingItem = item as? [String : Any],
            let refreshToken = existingItem[kSecValueData as String] as? Data,
            let refresh_token = String(data: refreshToken, encoding: String.Encoding.utf8) else {
                throw KeychainError.unexpectedRefreshData
        }
        if ModelStore.shared.token == nil {
            print("value was nil so lets init a blank authToken object")
            ModelStore.shared.token = AuthToken()
        }
        debugPrint("token retrived")
        ModelStore.shared.token?.refresh_token = refresh_token
        OAuth.session?.delegate?.tokenChanged()
        
    }
    
    class func removeRefreshToken() throws {
        debugPrint("attempting to remove from keychain")
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        let status = SecItemDelete(query as CFDictionary)
        guard status != errSecItemNotFound  else {
            print("not found")
            throw KeychainError.unhandledError(status: status)
        }
        guard status == errSecSuccess else {
            dump(query)
            throw KeychainError.unhandledError(status: status)
        }
        debugPrint("key removed from keychain")
        ModelStore.shared.token = nil
        OAuth.session?.delegate?.tokenChanged()
        return
    }
    
}
