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
    let coder = NSCoder()
    
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
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: [String: Any]] else {
                        return
                    }
                    guard let messages = self.loadMessage(fromDictionary: json) else {
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
        var loc: String?
        
        for item in fromDictionary {
            for i in item.value {
                if i.key == "subject" {
                    sub = i.value as? String
                }
                if i.key == "messageText" {
                    messText = i.value as? String
                }
                if i.key == "locations" {
                    loc = i.value as? String
                }
            }
            guard let s = sub, let m = messText, let l = loc else { //init the string to later init a message
                print("something is nil")
                return nil
            }
            let newMessage = Message(subject: s, messageText: m, location: l) //init a message and then append
            messages.append(newMessage)
                
            
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
}
