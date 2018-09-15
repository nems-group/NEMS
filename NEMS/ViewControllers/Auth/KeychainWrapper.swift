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
    
    
    class func saveRefresh(token initToken: AuthToken?, completionHandler completion: (Error?, Bool) -> Void) {
        debugPrint("attempting to save to keychain")
        var query: [String: Any] = [kSecClass as String: kSecClassGenericPassword]
        guard let token = initToken else {
            completion(KeychainError.noToken, false)
            return
        }
        
        Keyring.retrieveRefreshToken { (error, success) in
            if !success || error != nil {
                query.updateValue(token.refresh_token?.data(using: .utf8), forKey: kSecValueData as String)
                let status = SecItemAdd(query as CFDictionary, nil)
                guard status == errSecSuccess else {
                    completion(KeychainError.unhandledError(status: status), false)
                    return
                }
            }
        }
        
        // MARK: To-Do change this from just saving the refresh token to storing the whole token object, might just make a stringified version with computed property
        let updateQuery: [String: Any] = [kSecValueData as String: token.refresh_token?.data(using: .utf8)]
        let status = SecItemUpdate(query as CFDictionary, updateQuery as CFDictionary)
        guard status == errSecSuccess else {
            completion(KeychainError.unhandledError(status: status), false)
            return
        }
        print("saved to keychain")
        completion(nil, true)

    }
    
    class func retrieveRefreshToken(completionHandler completion: (Error?, Bool) -> Void) {
        debugPrint("attemping to retrieve token from keychain")
        let query: [String: Any] = [kSecClass as String: kSecClassGenericPassword,
                                    kSecMatchLimit as String: kSecMatchLimitOne,
                                    kSecReturnAttributes as String: true,
                                    kSecReturnData as String: true]
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            completion(KeychainError.noToken, false)
            return
        }
        guard status == errSecSuccess else {
            print("error")
            completion(KeychainError.unhandledError(status: status),false)
            return
        }
        guard let existingItem = item as? [String : Any],
            let refreshToken = existingItem[kSecValueData as String] as? Data,
            let refresh_token = String(data: refreshToken, encoding: String.Encoding.utf8) else {
                completion(KeychainError.unexpectedRefreshData,false)
                return
        }
        if ModelStore.shared.token == nil {
            print("value was nil so lets init a blank authToken object")
            ModelStore.shared.token = AuthToken()
        }
        debugPrint("token retrived")
        ModelStore.shared.token?.refresh_token = refresh_token
        completion(nil, true)
        
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
        //20180903 set refresh_token to nil
        ModelStore.shared.token?.refresh_token = nil
        OAuth.session?.delegate?.tokenChanged()
        return
    }
    
}
