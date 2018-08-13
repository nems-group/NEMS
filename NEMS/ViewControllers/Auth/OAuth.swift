//
//  OAuth.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/30/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import SafariServices
//import AuthenticationServices

enum OAuthError: Error {
    case noAuthCode
}


class OAuth {
    static let session = OAuth(clientID: Config.options.clientID, callback: Config.options.clientCallbackURI)
    
    let baseURL: URL
    let authorize: URL
    let type: OAuthType
    let clientID: String
    let callback: String
    var sfSession: SFAuthenticationSession?
    var code: String?
    var delegate: OAuthDelegate?
    var attemptsForRefresh: Int = 0
    //var asSession: ASWebAuthenticationSession?
    
    init?(base: URL, authorizeEndpoint: String, type: OAuthType, clientID: String, callback: String) {
        self.type = type
        self.clientID = clientID
        self.callback = callback
        self.baseURL = base
        var responseType: String {
            switch type {
                case .authorizationCode: return "code"
                case .implicit: return "token"
            }
        }
        guard let url = URL(string: "\(base.absoluteString)\(authorizeEndpoint)?response_type=\(responseType)&prompt=none&client_id=\(self.clientID)&redirect_uri=\(callback)") else {
                return nil
        }
        self.authorize = url
        
        }
    
        /// FHIR Code Grant Flow
        ///
        /// - Parameters:
        ///   - clientID: obtained by NextGen application portal
        ///   - callback: redirect uri
        convenience init?(clientID: String, callback: String) {
            guard let url = URL(string: "https://fhir.nextgen.com/auth/oauth/v2") else {
                return nil
            }
            let authorizeEndpoint = "/authorize"
            self.init(base: url, authorizeEndpoint: authorizeEndpoint, type: .authorizationCode, clientID: clientID, callback: callback)
        }
    
        func getAuthCode(url: URL) throws -> String {
            for (key,value) in url.parameters {
                    if key == "code" {
                        print(value)
                        return value
                    }
                }
            throw OAuthError.noAuthCode
        }
    
    /// Send the auth code to the trusted server to process and give up a token
    ///
    /// - Parameters:
    ///   - authCodeURL: the auth code with the whole url, which we will scrape with the get auth code function
    ///   - uriEndpoint: the end point we pass to Ex: /token
    ///   - completionHandler: handle the API error and pass the data object up
    func getToken(authCodeURL: URL, uriEndpoint: URL, completionHandler: @escaping authHandler) {
            do {
                let code = try getAuthCode(url: authCodeURL)
                // add parameter
                let param = URLQueryItem(name: "code", value: code)
                let uri = uriEndpoint.absoluteString
                var components = URLComponents(string: uri)
                components?.queryItems = []
                components?.queryItems?.append(param)
                guard let url = components?.url else {
                    print("malformed url")
                    return
                }
            
                let request = URLRequest(url: url)
                let task = URLSession(configuration: .default)
                let dataTask = task.dataTask(with: request) { (data, response, error) in
                    
                        guard let httpResponse = response as? HTTPURLResponse else {
                            completionHandler(APIerror.dataError, nil)
                            return
                        }
                        if httpResponse.statusCode == 200 {
                            if let data = data {
                                completionHandler(nil, data)
                                return
                            }
                        } else {
                            completionHandler(APIerror.statusCode(httpResponse), nil)
                        }
                }
                dataTask.resume()
            } catch {
                print(error)
                completionHandler(APIerror.noResponse, nil)
            }
            
        }
    
    typealias authHandler = (APIerror?,Data?)->Void
    
    
    
    func start() {
        guard let endPoint = URL(string: Config.options.codeProcessURI) else {
            return
        }
        self.sfSession = sfAuth(uri: self.authorize, callback: self.callback, codeProcessingServerURL: endPoint)
        self.sfSession?.start()
        
    }
    
    func refresh(token: String) {
        
        guard let endPoint = URL(string: Config.options.refreshProccessURI) else {
            return
        }
        sfRefresh(token: token, codeProcessingServerURL: endPoint)
    }
    
    func refresh() {
        self.attemptsForRefresh = self.attemptsForRefresh + 1
        if (self.attemptsForRefresh) > 3 {
                print("failed")
                ModelStore.shared.token = nil
                return
            }
            print("refreshing oauth")
            do {
                try Keyring.retrieveRefreshToken()
                guard let token = ModelStore.shared.token?.refresh_token else {
                    return
                }
                refresh(token: token)
            } catch {
                print(error)
            }
    }
}

enum OAuthType {
    case implicit
    case authorizationCode
}
