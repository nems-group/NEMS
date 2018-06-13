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
        var favorited: Bool = false
        var base64Image: String?
        
            private enum CodingKeys: String, CodingKey {
                case subject
                case messageBody
                case locations
                case readInd
                case messageID
                case favorited
                case base64Image
            }
        
            init(from decoder: Decoder) throws {
                let container = try decoder.container(keyedBy: CodingKeys.self)
                self.subject = try container.decode(String.self, forKey: .subject)
                self.messageBody = try container.decode(String.self, forKey: .messageBody)
                self.locations = try container.decode([String].self, forKey: .locations)
                self.messageID = try container.decode(UUID.self, forKey: .messageID)
                self.readInd = try container.decodeIfPresent(Bool.self, forKey: .readInd) ?? false
                self.favorited = try container.decodeIfPresent(Bool.self, forKey: .favorited) ?? false
                self.base64Image = try container.decodeIfPresent(String.self, forKey: .base64Image)

            }
        
        init(subject: String, messageBody: String, locations: [String], readInd: Bool, messageID: UUID, favorited: Bool) {
            self.subject  = subject
            self.messageBody = messageBody
            self.locations = locations
            self.readInd = readInd
            self.messageID = messageID
            self.favorited = favorited
        }
        
    }
    
    init(timestamp: String, messages: [Message]) {
        self.timestamp = timestamp
        self.messages = messages
    }

}

