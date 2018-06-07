//
//  Message.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 4/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct Message: Codable {

    var subject: String
    var messageText: String
    var locations: [String]?
    var readInd: Bool
    var messageID: UUID
    var timestamp: String?
    
    init(subject: String, messageText: String, location: [String]?, uuid: UUID?, timestamp: String?) {
        self.subject = subject
        self.messageText = messageText
        self.locations = location
        self.timestamp = timestamp
        self.readInd = false
        if let uuid = uuid {
            self.messageID = uuid
            return
        } else {
            self.messageID = UUID()
        }
    }
    
    init(subject: String, messageText: String, location: [String]?, timestamp: String?) {
        self.subject = subject
        self.messageText = messageText
        self.locations = location
        self.readInd = false
        self.messageID = UUID()
        self.timestamp = timestamp
    }
    
    
    
}

