//
//  TokenExtractor.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation



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
    var queryString: String? {
        let urlString = self.absoluteString
        guard let queryIndexStart = urlString.firstIndex(of: "?") else {
            return nil
        }
        let startIndex = urlString.index(after: queryIndexStart)
        let queryString = urlString[startIndex..<urlString.endIndex]
        return String(queryString)
    }
    var parameters: [String: String] {
        var queryContainer: [String: String] = [:]
        guard let workingString = self.queryString else {
            return queryContainer
        }
        let components = workingString.components(separatedBy: "&")
        for component in components {
            let split = component.split(separator: "=")
            if split.count == 2 {
                let key = String(split[0])
                let value = String(split[1])
                queryContainer[key] = value
            } else {
                print("malformed url at \(component)")
            }
        }
        return queryContainer
    }
}
