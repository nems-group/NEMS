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
        
        var comparingDateString: String?
        var fetchDateString: String?
        for stack in messageStacks {
            let timestamp = stack.timestamp
            if comparingDateString == nil {
                comparingDateString = timestamp
            } else {
                fetchDateString = timestamp
            }
            if fetchDateString == nil {
                fetchDateString = timestamp
            }
            
            guard let fD = fetchDateString, let cD = comparingDateString else {
                return nil
            }
            
            let formatter = DateFormatter()
            guard let comparingDate = formatter.date(from: cD), let fetchDate = formatter.date(from: fD) else {
                print("couldn't make a query date")
                return nil
            }
            
            let result = comparingDate.compare(fetchDate)
            print("result \(result)")
            
        }
        return nil
    }
}
