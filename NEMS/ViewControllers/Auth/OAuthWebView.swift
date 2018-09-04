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
            print("This is in OAuthWebView.sfRefresh - malformed url")
            return
        }
        print("This is in OAuthWebView.sfRefresh: \(url)")
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
                    print("This is in OAuthWebView.sfRefresh - sf refresh after decode data into authtoken.self")
                    dump(ModelStore.shared.token)
                } catch {
                    print(error)
                    return
                }
            }
        }.resume()
    }
    
    
    func authCodeHandler(apiError: OAuthError?,data: Data?) -> Void {
        if apiError != nil {
            print("This is in OAuthWebView.authCodeHandler: \(apiError)")
            print("so sad :( \nthere was an error in the authentication")
            return
        }
        if let data = data {
            do {
                // we need a function to create the token here and assign to Model Store
                let token = try ModelStore.jsonDecoder.decode(AuthToken.self, from: data)
                ModelStore.shared.token = token
                try Keyring.saveRefresh(token: token)
                print("This is in OAuthWebView.authCodeHandler - token: \(token)")
                
                //20180826 get pt demo
                apiSend(endPoint: "patient")
            } catch {
                dump(data)
                print("This is in OAuthWebView.authCodeHandler Catch: \(error)")
            }
        }
        
    }
    
    //20180826 make pt portal api call
    func apiSend(endPoint: String) {
        guard let authToken = ModelStore.shared.token else {
            guard (ModelStore.shared.token?.refresh_token) != nil else {
                do {
                    try Keyring.retrieveRefreshToken()
                } catch KeychainError.noToken {
                    print("This is in OAuthWebView.apiSend - no saved Token")
                } catch {
                    print(error)
                }
                return
            }
            return
        }
        do {
            try patientPortalAPI(call: endPoint, authToken: authToken) { (response, data) in
                if response?.statusCode == 200 {
                    DispatchQueue.main.async {
                        //print("This is in OAuthWebView.apiSend - data: \(String(describing: data))" )
                        if let data =  data {
                            do {
                                let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                                
                                // Pretty Print the string, for debugging
                                //let JSONObject = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0))
                                let prettyData = try! JSONSerialization.data(withJSONObject: result, options: .prettyPrinted)
                                let prettyString = String(data: prettyData, encoding: String.Encoding.utf8)
                                print(prettyString ?? "No String Available")
                                
                                guard let resultText = result as? String else {
                                    //print("This is in OAuthWebView.apiSend - make it a string for some dumb reason")
                                    //print("This is in OAuthWebView.apiSend - result: \(JSONObject)")
                                    return
                                }
                                
                                //print("This is in OAuthWebView.apiSend - resultText: \(resultText)")
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        ModelStore.shared.memberName = "Hello Guest!"
                    }
                    
                }
            }
        } catch {
            print(error)
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
