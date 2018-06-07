//
//  MessageHandler.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 4/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

class MessageHandler {
    
    var delegate: MessageDelegate?
    private var messages: [Message]?

    static let baseDocPath = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let pathForDocArchivedLog = baseDocPath.appendingPathComponent("messageLog.json")
    static var onlineURLforMessage: URL? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dictionary = NSDictionary(contentsOfFile: path) {
            if let urlPath = dictionary.object(forKey: "MessagesURL") as? String {
                let url = URL(string: urlPath)
                //print(url)
                return url
            }
        }
        print("couldn't get plist")
        return nil
    }
    
    static var newMessageFromDateBaseURL = MessageHandler.onlineURLforMessage?.appendingPathComponent("newMessages")
    let coder = NSCoder()
    
    
    func downloadMessages(sender: MessageDelegate, forDateAfter: String) {
        guard var url = MessageHandler.newMessageFromDateBaseURL else {
            return
        }
        url = url.appendingPathComponent(forDateAfter)
        print(url)
        retrieveMessages(fromURL: url) {
            sender.messages = self.messages
        }
    }
    
    
    
    func downloadMessages(sender: MessageDelegate) {
        guard let url = MessageHandler.onlineURLforMessage else {
            return
        }
        retrieveMessages(fromURL: url) {
            sender.messages = self.messages
        }
    }
    
    func retrieveMessages(fromURL path: URL, completionHander completetion: @escaping () -> Void) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: path) { (data, response, error) in
            guard let response = response else {
                return
            }
            guard let r = response as? HTTPURLResponse else {
                print("no http url response so sad")
                return
            }
            print(r.statusCode)
            if let data = data {
                do {
                    guard let json = JSON.downloadArray(data) else {
                        return
                    }
                    guard let messages = self.loadMessage(fromDictionaryArray: json) else {
                        return
                    }
                    self.messages = messages
                    completetion()
                    return
                } catch {
                    dump(error)
                }
            }
        }
        dataTask.resume()
        
    }
    
    func loadMessages(fromPath path: URL) {
        let dict =  NSDictionary(contentsOf: path) // make a dictionary of the url path that is passeds
        guard let dictionary = dict, let d = dictionary as? [String: [String: Any]] else {
            return
        }
        let loadedMessage = loadMessage(fromDictionary: d)
        self.messages = loadedMessage
        return
        
    }
    
    
    func loadMessage(fromDictionary: [String: [String: Any]]) -> [Message]? {
        var messages = [Message]() //init to append values to later
        var sub: String?
        var messText: String?
        var loc: [String]?
        var time: String?
        
        for item in fromDictionary {
            
            for i in item.value {
                if i.key == "subject" {
                    sub = i.value as? String
                }
                if i.key == "messageBody" {
                    messText = i.value as? String
                }
                if i.key == "locations" {
                    loc = i.value as? [String]
                }
            }
            guard let s = sub, let m = messText, let l = loc else { //init the string to later init a message
                print("something is nil")
                return nil
            }
            let newMessage = Message(subject: s, messageText: m, location: l, timestamp: time) //init a message and then append
            messages.append(newMessage)
                
            
        }
        //print(messages)
        return messages
        
    }
    
    func loadMessage(fromDictionaryArray: [[String: Any]]) -> [Message]? {
        var messages = [Message]() //init to append values to later
        var sub: String?
        var messText: String?
        var loc: [String]?
        var time: String?
        var uuid: UUID?
        
        
        
        for child in fromDictionaryArray {
            for item in child {
                if item.key == "timestamp" {
                    time = item.value as? String
                }
                if item.key == "messages" {
                    guard let messagesArray = item.value as? [[String: Any]] else {
                        print("could not parse message json")
                        return nil
                    }
                    for message in messagesArray {
                        
                        for key in message.keys {
                            
                        if key == "subject" {
                            
                            sub = message[key] as? String
                        }
                        if key == "messageBody" {
                            
                            messText = message[key] as? String
                        }
                        if key == "location" {
                            
                            loc = message[key] as? [String]
                        }
                        if key == "messageID" {
                            
                            guard let uuidString = message[key] as? String else {
                                print("could make it a uuid")
                                continue
                            }
                            uuid = UUID(uuidString: uuidString)
                        }
                        }
                    
                            guard let s = sub, let m = messText else { //init the string to later init a message
                                print("something is nil")
                                break
                            }
                            let newMessage = Message(subject: s, messageText: m, location: loc, uuid: uuid, timestamp: time)//init a message and then append
                            //print(newMessage.messageID)
                            messages.append(newMessage)
                            
                    
                    }
                }
            }
            
        }
        //print(messages)
        return messages
        
    }
    
    func cacheMessage() {
        guard let messages = self.messages else {
            return
        }
        self.coder.encode(messages)
    }
    
    func retrieveCachedMessages() {
        self.messages = coder.decodeObject() as? [Message]
    }
    
    
    func readMessage(id: UUID, sender: MessageDelegate) {
        guard let messages = sender.messages else {
            return
        }
        var index = 0
        for message in messages {
            if message.messageID == id {
                sender.messages![index].readInd = true
            }
        index+=1
        }
    }
    
    func downloadTodaysMessages(sender: MessageDelegate) {
        guard let today = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: today)
        if (messages) != nil {
            print("not nil")
        } else {
            downloadMessages(sender: sender, forDateAfter: dateString)
        }
    }
    
    func downloadMessagesBack(sender: MessageDelegate, _ numberOf: Int, _ dateCompenent: Calendar.Component) {
        guard let today = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {
            return
        }
        print(today)
        let negativeNumber = -abs(numberOf)
        guard let refDate = Calendar.current.date(byAdding: dateCompenent, value: negativeNumber, to: today) else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: refDate)
        if (messages) != nil {
            print("not nil")
        } else {
            downloadMessages(sender: sender, forDateAfter: dateString)
        }
    }
}
