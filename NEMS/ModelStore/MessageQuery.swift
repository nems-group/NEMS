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
        return maxStack.timestamp
    }
    
    class func getMessagesFiltered(by filter: InboxView, messageStack: [MessageStack]?) -> [MessageStack]? {
        var filteredStack = [MessageStack]()
        var filteredMessages = [MessageStack.Message]()
        guard let messageStack = messageStack else {
            return nil
        }
        var counter = 1
        for stack in messageStack {
            
            
            for message in stack.messages {
                
                switch filter {
                    case .inbox:
                        if message.readInd == false {
                            
                            
                            let message = MessageStack.Message(subject: message.subject, messageBody: message.messageBody, locations: message.locations, readInd: message.readInd, messageID: message.messageID, favorited: message.favorited)
                            filteredMessages.append(message)
                            
                        }
                    case .archived:
                        if message.readInd == true && message.favorited == false {
        
                            
                            let message = MessageStack.Message(subject: message.subject, messageBody: message.messageBody, locations: message.locations, readInd: message.readInd, messageID: message.messageID, favorited: message.favorited)
                            filteredMessages.append(message)
                            
                    }
                case .favorite:
                    if message.favorited == true && message.readInd == true {
                
                        let message = MessageStack.Message(subject: message.subject, messageBody: message.messageBody, locations: message.locations, readInd: message.readInd, messageID: message.messageID, favorited: message.favorited)
                        filteredMessages.append(message)
                        
                    }
                }
                
            }
            
            let newStack = MessageStack(timestamp: stack.timestamp, messages: filteredMessages)
            filteredStack.append(newStack)
            
        }
        return filteredStack
    }
    
    
    class func numberOfMessagesInStack(stackNumber: Int, messageStack: [MessageStack]) -> Int {
        if stackNumber <= safeIndexOfMessageStack(messageStack: messageStack).max {
            var i = 0
            for _ in messageStack[stackNumber].messages {
                i = i + 1
            }
            return i
        }

        return 0
    }
    
    class func numberOfMessages(messageStack: [MessageStack]) -> Int {
        var count = 0
        for stack in messageStack {
            for _ in stack.messages {
                count = count + 1
            }
        }
        
        return count
    }
    
    class func safeIndexOfMessageStack(messageStack: [MessageStack]) -> (min: Int, max: Int) {
        let min = 0
        var max = 0
        for _ in messageStack {
            max = max + 1
        }
        return (min: min, max: max)
    }
    
    
    class func getNumberOfMessages(messageStacks: [MessageStack]) -> (unread: Int, favorited: Int, archived: Int) {
        
        var unreadNum = 0
        var favoritedNum = 0
        var archivedNum = 0
        for stack in messageStacks {
            for message in stack.messages {
                if message.readInd == false {
                    unreadNum = unreadNum+1
                }
                if message.favorited == true {
                    favoritedNum = favoritedNum+1
                }
                if message.readInd == true && message.favorited == false {
                    archivedNum = archivedNum+1
                }
            }
        }
        
        return (unreadNum, favoritedNum, archivedNum)
    }
    
}

