//
//  TokenExtractor.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

func tokenizer(url: URL) -> AuthToken? {
    guard let tokenString = url.tokenQuery else {
        return nil
    }
    guard let token = Token(string: tokenString) else {
        return nil
    }
    return AuthToken(token)
}

final class Token {
    var components: [String]
    
    init?(string: String) {
        print(string)
        //first check if this string is a token
        if (string.first != "#") {
            return nil
        } else {
            let workingString = String(string[(string.index(after: string.startIndex))..<string.endIndex])
            self.components = workingString.components(separatedBy: "&")
            return
        }
    }
}

extension URL {
    var tokenQuery: String? {
        let urlString = self.absoluteString
        guard let indexStartTokenString = urlString.firstIndex(of: "#") else {
            return nil
        }
        print(urlString.endIndex)
        let tokenString = urlString[indexStartTokenString..<urlString.endIndex]
        print(tokenString)
        return String(tokenString)
    }
}
