//
//  Message.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 4/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct MessageStack: Codable {
    var timestamp: String
    var messages: [Message]
    
    struct Message: Codable {
        
        var subject: String
        var messageBody: String
        var locations: [String]
        var readInd: Bool = false
        var messageID: UUID
        
            private enum CodingKeys: String, CodingKey {
                case subject
                case messageBody
                case locations
                case readInd
                case messageID
            }
        
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.subject = try container.decode(String.self, forKey: .subject)
                self.messageBody = try container.decode(String.self, forKey: .messageBody)
                self.locations = try container.decode([String].self, forKey: .locations)
                self.messageID = try container.decode(UUID.self, forKey: .messageID)
                self.readInd = false
            }
        
    }

}

