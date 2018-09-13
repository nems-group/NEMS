//
//  Config.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 8/11/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

final class Config: Codable {
    
    static let path = Bundle.main.path(forResource: "config", ofType: "json")
    static var data: Data? = Config.getData()
    
    static var options: Config {
        do {
            return try Config()
        } catch {
            print(error)
            return Config(clientID: "", clientCallbackURI: "", codeProccessURI: "", refreshProcessURI: "", messageServerURI: "")
        }
    }
    
    convenience init() throws {
            guard let data = Config.data else {
                throw APIerror.dataError
            }
            let options = try ModelStore.jsonDecoder.decode(Config.self, from: data)
        self.init(clientID: options.webConfig.clientID, clientCallbackURI: options.webConfig.clientCallbackURI, codeProccessURI: options.webConfig.codeProcessURI, refreshProcessURI: options.webConfig.refreshProccessURI, messageServerURI: options.webConfig.messageServerURI)
    }
    
    init(clientID: String, clientCallbackURI: String, codeProccessURI: String, refreshProcessURI: String, messageServerURI: String) {
        let webConfig = WebConfig(clientID: clientID, clientCallbackURI: clientCallbackURI, codeProcessURI: codeProccessURI, refreshProccessURI: refreshProcessURI, messageServerURI: messageServerURI)
        self.webConfig = webConfig
    }
    
    class func getData() -> Data? {
        guard let path = Config.path else {
            return nil
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    var webConfig: WebConfig
    
}


struct WebConfig: Codable {
    var clientID: String
    var clientCallbackURI: String
    var codeProcessURI: String
    var refreshProccessURI: String
    var messageServerURI: String
}


