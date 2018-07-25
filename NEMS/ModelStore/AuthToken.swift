//
//  AuthToken.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct AuthToken: Codable {
    var accessToken: String?
    var expiration: String?
    var tokenType: String?
    var scopes: [String] = []
    
    init(_ token: Token) {
        for compenent in token.components {
            if compenent.contains("access_token") {
                let sub = compenent.split(separator: "=")
                if sub.count == 2 {
                    accessToken = String(sub[1])
                }
            } else if compenent.contains("expires_in") {
                let sub = compenent.split(separator: "=")
                if sub.count == 2 {
                    expiration = String(sub[1])
                }
            } else if compenent.contains("token_type") {
                let sub = compenent.split(separator: "=")
                if sub.count == 2 {
                    tokenType = String(sub[1])
                }
            } else if compenent.contains("scope") {
                let sub = compenent.split(separator: "=")
                if sub.count == 2 {
                    let splits = String(sub[1]).split(separator: " ")
                    for split in splits {
                        scopes.append(String(split))
                    }
                }
            }
       }
        return
    }
    
}


