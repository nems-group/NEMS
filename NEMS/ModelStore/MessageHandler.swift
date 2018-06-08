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
    
    static let query = MessageQuery.self
    
    
    //private var messages: [Message]?

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
    
    
    
    func downloadMessages(forDateAfter: String) {
        guard var url = MessageHandler.newMessageFromDateBaseURL else {
            return
        }
        url = url.appendingPathComponent(forDateAfter)
        print(url)
        retrieveMessages(fromURL: url)
    }
    
    
    
    func downloadMessages() {
        guard let url = MessageHandler.onlineURLforMessage else {
            return
        }
        retrieveMessages(fromURL: url)
    }
    
    func retrieveMessages(fromURL path: URL) {
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
                    
                    let json = try ModelStore.jsonDecoder.decode([MessageStack].self, from: data)
                    ModelStore.shared.messageStack = json
                    print(ModelStore.shared.messageStack)
                    return
                } catch {
                    print(error)
                }
            }
        }
        dataTask.resume()
        
    }
    
    func loadMessages(fromPath path: URL) -> Bool {
        let data = path.dataRepresentation
        do {
            let json = try ModelStore.jsonDecoder.decode([MessageStack].self, from: data)
            ModelStore.shared.messageStack = json
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func readMessage(id: UUID) {
        guard let messageStacks = ModelStore.shared.messageStack else {
            return
        }
        for stack in messageStacks {
            var index = 0
            for message in stack.messages {
                if message.messageID == id {
                    print(id, "needs to be read")
                    index += 1
                }
            }
        }
    }
    
    func downloadTodaysMessages() {
        guard let today = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateString = formatter.string(from: today)
        guard let messages = ModelStore.shared.messageStack?.first?.messages else {
            return
        }
        if (messages) != nil {
            print("not nil")
        } else {
            downloadMessages(forDateAfter: dateString)
        }
    }
    
//    func downloadMessagesBack(_ numberOf: Int, _ dateCompenent: Calendar.Component) {
//        guard let today = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {
//            return
//        }
//        print(today)
//        let negativeNumber = -abs(numberOf)
//        guard let refDate = Calendar.current.date(byAdding: dateCompenent, value: negativeNumber, to: today) else {
//            return
//        }
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let dateString = formatter.string(from: refDate)
//        if (messages) != nil {
//            print("not nil")
//        } else {
//            downloadMessages(forDateAfter: dateString)
//        }
//    }
}
