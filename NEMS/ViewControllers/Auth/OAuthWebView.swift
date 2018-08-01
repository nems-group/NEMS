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
