//
//  MessageQuery.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/7/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class MessageQuery {
    
    class func getMostRecentDate(messageStacks: [MessageStack]) -> String? {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let newStack = messageStacks.max { (message1, message2) -> Bool in
            guard let date1 = formatter.date(from: message1.timestamp), let date2 = formatter.date(from: message2.timestamp) else {
                return false
            }
            return date1.timeIntervalSince1970 > date2.timeIntervalSince1970
        }
        guard let maxStack = newStack else {
            return nil
        }
        print(maxStack.timestamp)
        return maxStack.timestamp
    }
}
