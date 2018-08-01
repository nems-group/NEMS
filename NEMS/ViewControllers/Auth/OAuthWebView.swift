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

public func sfAuth(uri: URL, callback: String?, codeProcessingEndpoint: String) -> SFAuthenticationSession? {
    
    let web = SFAuthenticationSession(url: uri, callbackURLScheme: callback) { (_url, error) in
        if let url = _url {
            print(url)
            let parameters = url.parameters
            for (key,value) in parameters {
                if key == "code" {
                    // with our code now we send that code to our server to process
                    exchangeCodeForToken(code: value, serverAddress: codeProcessingEndpoint)
                }
            }
        }
    }
    return web
}

public func exchangeCodeForToken(code: String, serverAddress: String) {
    
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
