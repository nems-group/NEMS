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
    
    weak var delegate: MessageDelegate?
    
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
    
    static var newMessagesFromDateBaseURL = MessageHandler.onlineURLforMessage?.appendingPathComponent("newMessages")
    static var allMessagesFromBaseURL = MessageHandler.onlineURLforMessage?.appendingPathComponent("allMessages")
    
    
    func downloadMessages(forDateAfter: String) {
        guard var url = MessageHandler.newMessagesFromDateBaseURL else {
            return
        }
        url = url.appendingPathComponent(forDateAfter)
        print(url)
        retrieveMessages(fromURL: url) {
            guard let delegate = self.delegate else {
                return
            }
            delegate.refresh()
        }
    }
    
    
    
    func downloadMessages() {
        guard let url = MessageHandler.allMessagesFromBaseURL else {
            return
        }
        retrieveMessages(fromURL: url) {
            guard let delegate = self.delegate else {
                return
            }
            delegate.refresh()
        }
    }
    
    func retrieveMessages(fromURL path: URL, completionHandler completetion: @escaping () -> Void) {
        let session = URLSession(configuration: .default)
        let dataTask = session.dataTask(with: path) { (data, response, error) in
            guard let response = response else {
                return
            }
            guard let res = response as? HTTPURLResponse else {
                print("no http url response so sad")
                return
            }
            if res.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try ModelStore.jsonDecoder.decode([MessageStack].self, from: data)
                        ModelStore.shared.messageStack = json
                        let saved = self.saveToDrive()
                        if (saved) {
                            print("saved to drive")
                        }
                        completetion()
                        return
                    } catch {
                        print(error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func loadMessages(fromPath path: URL, completionHandler completion: () -> Void) -> Bool {
        let option = NSData.ReadingOptions.uncached
        
        do {
            let data = try Data(contentsOf: path, options: option)
            let json = try ModelStore.jsonDecoder.decode([MessageStack].self, from: data)
            ModelStore.shared.messageStack = json
            completion()
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func readMessage(id: UUID, messageStacks: inout [MessageStack]) -> Bool {
        var stackIndex = 0
        for stack in messageStacks {
            var messageStackIndex = 0
            for message in stack.messages {
                
                if message.messageID == id {
                    print( messageStacks[stackIndex].messages[messageStackIndex].readInd )
                    print(id, "needs to be read")
                    messageStacks[stackIndex].messages[messageStackIndex].readInd = true
                    print( messageStacks[stackIndex].messages[messageStackIndex].readInd )
                    //ModelStore.shared.messageStack[stackIndex].messages[messageStackIndex].readInd = true
                    return true
                }
                messageStackIndex+=1
            }
            stackIndex+=1
        }
        return false
    }
    
    func downloadTodaysMessages() {
        guard let todayDate = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: todayDate)
        let stacks = ModelStore.shared.messageStack
        guard let mostRecentDateString = MessageQuery.getMostRecentDate(messageStacks: stacks) else {
            downloadMessages(forDateAfter: todayString)
            return
        }
        guard let mostRecentDate = formatter.date(from: mostRecentDateString) else {
            downloadMessages(forDateAfter: todayString)
            return
        }
        
        if mostRecentDate < todayDate {
            print("getting older missed messages too")
            downloadMessages(forDateAfter: mostRecentDateString)
            return
        }
        return
    }
    
    func downloadMessagesBack(_ numberOf: Int, _ dateCompenent: Calendar.Component) {
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
        downloadMessages(forDateAfter: dateString)
    }
    
    func saveToDrive() -> Bool {
        let path = MessageHandler.pathForDocArchivedLog
        let encodable = ModelStore.shared.messageStack
        if encodable.count > 0 {
            do {
                let json = try ModelStore.jsonEncoder.encode(encodable)
                try json.write(to: path)
                print(path)
                return true
            } catch {
                print(error)
                return false
            }
        }
        return false
    }
    
    func loadFromDrive(completionHandler completition: () -> Void) -> Bool {
        let path = MessageHandler.pathForDocArchivedLog
        let loaded = loadMessages(fromPath: path) { completition() }
        return loaded
    }

    func sync() {
        
        loadFromDrive() {
            print("loaded from drive, now lets get most recent messages")
            downloadTodaysMessages()
        }
    }
}
