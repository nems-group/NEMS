//
//  OAuthWebView.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 8/1/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SafariServices
//import AuthenticationServices

extension OAuth {

    func sfAuth(uri: URL, callback: String?, codeProcessingServerURL: URL) -> SFAuthenticationSession? {
    

    let web = SFAuthenticationSession(url: uri, callbackURLScheme: callback) { (_url, error) in
        if let url = _url {
                self.getToken(authCodeURL: url, uriEndpoint: codeProcessingServerURL) { (_apiError, _data) in
                    self.authCodeHandler(apiError: _apiError, data: _data)
                }
            }
        }
    return web
    }
    
    func sfRefresh(token: String, codeProcessingServerURL: URL) {
        let params = URLQueryItem(name: "refresh_token", value: token)
        var urlComponents = URLComponents(url: codeProcessingServerURL, resolvingAgainstBaseURL: false)
        urlComponents?.queryItems = []
        urlComponents?.queryItems?.append(params)
        guard let url = urlComponents?.url else {
            print("malformed url")
            return
        }
        print(url)
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (_data, _urlResponse, _error) in
            guard let response = _urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            if let data = _data {
                do {
                    let authToken = try ModelStore.jsonDecoder.decode(AuthToken.self, from: data)
                    ModelStore.shared.token = authToken
                    try Keyring.saveRefresh(token: authToken)
                    print("sf refresh after decode data into authtoken.self")
                    dump(ModelStore.shared.token)
                } catch {
                    print(error)
                    return
                }
            }
        }.resume()
    }
    
    
    func authCodeHandler(apiError: APIerror?,data: Data?) -> Void {
        if apiError != nil {
            print(apiError)
            print("so sad :( \n there was an error in the authentication")
            return
        }
        if let data = data {
            do {
                // we need a function to create the token here and assign to Model Store
                let token = try ModelStore.jsonDecoder.decode(AuthToken.self, from: data)
                ModelStore.shared.token = token
                try Keyring.saveRefresh(token: token)
                delegate?.tokenChanged()
            } catch {
                dump(data)
                print(error)
            }
        }
        
    }
}
//@available(iOS 12.0, *)
//public func asAuth(uri: URL, callback: String?) -> ASWebAuthenticationSession? {
//
//    let web = ASWebAuthenticationSession(url: uri, callbackURLScheme: callback) { (_url, error) in
//        if let url = _url {
//            print(url)
//            let parameters = url.parameters
//            for (key,value) in parameters {
//                if key == "code" {
//                    ModelStore.shared.refresh = value
//                }
//            }
//        }
//    }
//    return web
//
//}
