//
//  MessageHandler.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 4/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class MessageHandler {

    static let baseDocPath = FileManager().urls(for: .documentDirectory , in: .userDomainMask).first!
    static let pathForArchivedLog = baseDocPath.appendingPathComponent("messageLog.plist")
    
    var delegate: MessageDelegate?
    
    func saveMessages(_ sender: MessageDelegate) -> Bool {
        
        // MARK: To-Do
        
        return false
    }
    
    func retrieveMessages(fromURL path: URL, sender: MessageDelegate) {
        let session = URLSession(configuration: .default)
        
        let dataTask = session.dataTask(with: path) { (data, response, error) in
            print(error)
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: [String: Any]] else {
                        return
                    }
                    guard let messages = self.loadMessage(fromDictionary: json) else {
                        return
                    }
                    sender.saveMessages(message: messages)
                    return
                } catch {
                    dump(error)
                }
            }
        }
        dataTask.resume()
        
    }
    

    
    func loadMessages(fromPath path: URL) -> [Message]? {
        let dict =  NSDictionary(contentsOf: path) // make a dictionary of the url path that is passeds
        guard let dictionary = dict, let d = dictionary as? [String: [String: Any]] else {
            return nil
        }
        
        let result = loadMessage(fromDictionary: d)
        return result
        
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
}
