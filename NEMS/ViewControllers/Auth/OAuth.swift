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
    case status(code: Int)
    case noResponseRecievedFromAuthCodeServerProcess
    case cannotGetHTTPurlReponseObject
    case malformedURL
    case tooManyAttempts
    case noRefreshTokenInKeychain
    case refreshTokenIsNil
}

enum OAuthType {
    case implicit
    case authorizationCode
}

class OAuth {
    
    typealias authHandler = (OAuthError?,Data?)->Void
    
    static let session = OAuth(clientID: Config.options.webConfig.clientID, callback: Config.options.webConfig.clientCallbackURI)
    
    
    let baseURL: URL
    let authorize: URL
    let type: OAuthType
    let clientID: String
    let callback: String
    var sfSession: SFAuthenticationSession?
    var code: String?
    var delegate: OAuthDelegate?
    var attemptsForRefresh: Int = 0
    
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
                    print("This is in OAuth.getAuthCode: \(value)")
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
                completionHandler(.malformedURL, nil)
                return
            }
        
            let request = URLRequest(url: url)
            let task = URLSession(configuration: .default)
            let dataTask = task.dataTask(with: request) { (data, response, error) in
                
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completionHandler(.cannotGetHTTPurlReponseObject, nil)
                        return
                    }
                
                    if httpResponse.statusCode == 200 {
                        if let data = data {
                            completionHandler(nil, data)
                            return
                        }
                    } else {
                        completionHandler(.status(code: httpResponse.statusCode), nil)
                    }
            }
            dataTask.resume()
        } catch {
            print("This is in OAuth.getToken Catch: \(error)")
            completionHandler(.noResponseRecievedFromAuthCodeServerProcess, nil)
        }
            
    }
    
    /// Start the OAuth Flow
    func start() {
        guard let endPoint = URL(string: Config.options.webConfig.codeProcessURI) else {
            return
        }
        self.sfSession = sfAuth(uri: self.authorize, callback: self.callback, codeProcessingServerURL: endPoint)
        self.sfSession?.start()
    }
    
    
    
    /// Send a Refresh Token to the Config Refresh Process URI
    ///
    /// - Parameter token: The Refresh Token to Process
    func refresh(token: String) throws {
        guard let endPoint = URL(string: Config.options.webConfig.refreshProccessURI) else {
            throw OAuthError.malformedURL
        }
        sfRefresh(token: token, codeProcessingServerURL: endPoint) { error, token in
            guard let token = token else {
                print(error)
                return
            }
            Keyring.saveRefresh(token: token) { (error, success) in
                    if error != nil {
                        print(error)
                        return
                    }
                    if success {
                        OAuth.session?.delegate?.tokenChanged()
                        self.attemptsForRefresh = 0
                    }
            }
        }
    }
    
    /// Start the refresh token flow
    ///
    /// - Parameter completion: run any additional code after completion
    /** - Throws:
     * OAuthError.tooManyAttempts: If the calls to refresh exceed 3 calls
     * OAuthError.refreshTokenIsNil: If the retrieveRefreshToken call fails to retrieve the refreshToken from the Keychain and does not map to the model store object
     * Error: If retrieveRefreshToken call raises any error
     */
    func refresh(completionHandler completion: () -> Void) throws {
        
        self.attemptsForRefresh = self.attemptsForRefresh + 1
        
        if (self.attemptsForRefresh) >= 3 {
                ModelStore.shared.token = nil
                throw OAuthError.tooManyAttempts
        }
        print("This is in OAuth.refresh - refreshing oauth")
        do {
            Keyring.retrieveRefreshToken { (error, success) in
                if !success || error != nil {
                    return
                }
            }
            guard let token = ModelStore.shared.token?.refresh_token else {
                throw OAuthError.refreshTokenIsNil
            }
            try refresh(token: token)
            completion()
            
        } catch let error {
            completion()
            throw error
        }
    }
    
    /// Checks to see if there is a refresh token saved in the keychain
    func checkLogin() throws {
        try Keyring.retrieveRefreshToken { (error, success) in
            if !success || error != nil {
                return
            } else {
                OAuth.session?.delegate?.tokenChanged()
            }
        }
    }
    
    func sfAuth(uri: URL, callback: String?, codeProcessingServerURL: URL) -> SFAuthenticationSession? {
        
        print(uri)
        let web = SFAuthenticationSession(url: uri, callbackURLScheme: callback) { (_url, error) in
            if let url = _url {
                self.getToken(authCodeURL: url, uriEndpoint: codeProcessingServerURL) { (_apiError, _data) in
                    self.authCodeHandler(apiError: _apiError, data: _data)
                }
            }
        }
        return web
    }
    
    func sfRefresh(token: String, codeProcessingServerURL: URL, completionHandler completion: @escaping (Error?, AuthToken?) -> Void) {
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
        let task = session.dataTask(with: url) { (_data, _urlResponse, _error) in
            guard let response = _urlResponse as? HTTPURLResponse, response.statusCode == 200 else {
                return
            }
            
            if let data = _data {
                do {
                    let authToken = try ModelStore.jsonDecoder.decode(AuthToken.self, from: data)
                    ModelStore.shared.token = authToken
                    print("This is in OAuthWebView.sfRefresh - sf refresh after decode data into authtoken.self")
                    completion(nil, authToken)
                } catch {
                    completion(error, nil)
                    return
                }
            }
        }
        task.resume()
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
                Keyring.saveRefresh(token: token) { (error, success) in
                    if !success || error != nil {
                        print(error)
                        return
                    } else {
                        OAuth.session?.delegate?.tokenChanged()
                    }
                }
                print("This is in OAuthWebView.authCodeHandler - token: \(token)")
                
                //20180826 get pt demo
                //apiSend(endPoint: "patient")
            } catch {
                dump(data)
                print("This is in OAuthWebView.authCodeHandler Catch: \(error)")
            }
        }
        
    }
    
    
    
    
}

