//
//  AuthToken.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import Security

struct AuthToken: Codable {
    var access_token: String?
    var expires_in: Int?
    var acccesTokenExpirationTime: Date?
    var token_type: String?
    var scope: [String]? = []
    var refresh_token: String?
    static var now: Date = Calendar.current.date(byAdding: Calendar.Component.minute, value: 0, to: Date())!
    
    
    private enum CodingKeys: String, CodingKey {
        case access_token
        case expires_in
        case token_type
        case scope
        case refresh_token
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.access_token = try container.decode(String.self, forKey: .access_token)
        self.expires_in = try container.decode(Int.self, forKey: .expires_in)
        self.token_type = try container.decode(String.self, forKey: .token_type)
        let scopes = try container.decode(String.self, forKey: .scope)
        if let expiresSeconds = self.expires_in {
            print(AuthToken.now)
            print(Date())
            self.acccesTokenExpirationTime = Calendar.current.date(byAdding: .second, value: expiresSeconds, to: AuthToken.now)
            print(self.acccesTokenExpirationTime)
        }
        let scopeArray = scopes.split(separator: " ") //scopes can be " " seperated so we will want that data in array since that is easier to work with
        self.scope = []
        for scope in scopeArray {
            self.scope?.append(String(scope))
        }
        self.refresh_token = try container.decodeIfPresent(String.self, forKey: .refresh_token)
    }
    
    init() {
        
    }
    
//    struct key {
//
//    }
//
//    private func storeRefreshToken() {
//        let tag = "com.nems.app".data(using: .utf8)!
//        let keyAttributes: [String: Any] = [kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
//                                            kSecAttrKeySizeInBits as String: 2048,
//                                            kSecPrivateKeyAttrs as String: [kSecAttrIsPermanent as String: true,
//                                                                            kSecAttrApplicationTag as String: tag]]
//
//        let addQuery: [String: Any] = [kSecClass as String: kSecClass,
//                                       kSecAttrApplicationTag as String: tag,
//                                       kSecValueRef as String: key.self]
//        let status = SecItemAdd(addQuery as CFDictionary, nil)
//
//    }
//
//    private func retrieveRefreshToken() {
//        let getQuery: [String: Any] = [kSecClass as String: kSecClassKey,
//                                       kSecAttrApplicationTag as String: tag,
//                                       kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
//                                       kSecReturnRef as String: true]
//    }
    

    
}



