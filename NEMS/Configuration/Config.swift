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
            return Config(clientID: "", clientCallbackURI: "", codeProccessURI: "", refreshProcessURI: "")
        }
    }
    
    convenience init() throws {
            guard let data = Config.data else {
                throw APIerror.dataError
            }
            let options = try ModelStore.jsonDecoder.decode(Config.self, from: data)
            self.init(clientID: options.clientID, clientCallbackURI: options.clientCallbackURI, codeProccessURI: options.codeProcessURI, refreshProcessURI: options.refreshProccessURI)
    }
    
    init(clientID: String, clientCallbackURI: String, codeProccessURI: String, refreshProcessURI: String) {
        self.clientID = clientID
        self.clientCallbackURI = clientCallbackURI
        self.codeProcessURI = codeProccessURI
        self.refreshProccessURI = refreshProcessURI
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
    
    var clientID: String
    var clientCallbackURI: String
    var codeProcessURI: String
    var refreshProccessURI: String
    
}
