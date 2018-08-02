//
//  apiHandler.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

enum APIerror: Error {
    case statusCode(_ : HTTPURLResponse)
    case dataError
    case noResponse
    case invalidToken
    case expiredToken
    case noRefreshToken
}


func patientPortalAPI(call: String, authToken token: AuthToken, completionHander: @escaping (HTTPURLResponse?, Data?) throws -> Void ) throws {
    
    guard let exp = token.acccesTokenExpirationTime else {
        print("no expiration date")
        guard let refreshToken = ModelStore.shared.token?.refresh_token else {
            print("no refresh token?")
            throw APIerror.noRefreshToken
        }
        OAuth.session?.refresh(token: refreshToken)
        return
    }
    guard exp.minutes(from: Date()) >= 2 else {
        print(Date().minutes(from: exp))
        throw APIerror.expiredToken
    }
    
    guard let fullURI = URL(string: "https://fhir.nextgen.com/mu3api/dstu2/v1.0/\(call)?patient=me"), let accessToken = token.access_token else {
        return
    }
    let authHeader: String = "Bearer \(accessToken)"
    let session = URLSession(configuration: .default)
    var urlRequest = URLRequest(url: fullURI)
    urlRequest.addValue(authHeader, forHTTPHeaderField: "Authorization")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.httpMethod = "GET"
    
    
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("couldn't convert to httpURLresponse")
                    do {
                       try completionHander(nil, nil)
                    } catch {
                        
                    }
                    return
                }
                if httpResponse.statusCode == 200 {
                    // good going we got a successful message this should be json
                    if let data = data {
                        print("we got the data: \(data)")
                        do {
                            try completionHander(httpResponse, data)
                        } catch {
                            
                        }
                    } else {
                        print("no data")
                        do {
                            try completionHander(httpResponse, nil)
                        } catch {
                            
                        }
                    }
                } else {
                    print(httpResponse.statusCode)
                    do {
                        try completionHander(httpResponse, nil)
                    } catch {
                        
                    }
                }
            }
        task.resume()
   

}

