//
//  Message.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 4/28/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct Message {

    var subject: String
    var messageText: String
    var locations: String?
    
    init(subject: String, messageText: String, location: String?) {
        self.subject = subject
        self.messageText = messageText
        self.locations = location
    }
    
}

