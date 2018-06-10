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
    weak var dataSource: ModelStore?
    
    static let query = MessageQuery.self
    
    
    //private var messages: [Message]?

    static let baseDocPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
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
        print("downloadMessages(forDateAfter:)")
        guard var url = MessageHandler.newMessagesFromDateBaseURL else {
            return
        }
        url = url.appendingPathComponent(forDateAfter)
        print(url)
        retrieveMessages(fromURL: url)
    }
    
    func start() {
        print("start()")
        //check local
        let local = loadFromDrive()
        
        if local {
            
            let saved = self.saveToDrive()
            if saved {
                // MARK: To-Do what to do if saved?
            }
            //no lets compare the dates
        }
        
        if !local {
            print("no local")
            downloadMessages()
        }
    }
    
    
    func downloadMessages() {
        print("downloadMessages()")
        guard let url = MessageHandler.allMessagesFromBaseURL else {
            return
        }
        retrieveMessages(fromURL: url)
    }
    
    func retrieveMessages(fromURL path: URL) {
        print("retrieveMessages(fromURL:)")
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
                        guard let model = self.dataSource else {
                            return
                        }
                        model.messageStack = json
                        let saved = self.saveToDrive()
                        if (saved) {
                            print("saved to drive")
                        }
                        print("sync retrieve message call")
                        self.sync()
                        return
                    } catch {
                        print(error)
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func loadMessages(fromPath path: URL) -> Bool {
        print("loadMessages(fromPath:)")
        let option = NSData.ReadingOptions.uncached
        
        do {
            let data = try Data(contentsOf: path, options: option)
            let json = try ModelStore.jsonDecoder.decode([MessageStack].self, from: data)
            self.dataSource?.messageStack = json
            print("sync loadMessage(fromPath) call")
            sync()
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    func readMessage(id: UUID) -> Bool {
        print("readMessage(id:)")
        var stackIndex = 0
        guard let stacks = self.dataSource?.messageStack else {
            print("could not read because model is nil")
            return false
        }
        for stack in stacks {
            var messageStackIndex = 0
            for message in stack.messages {
                
                if message.messageID == id {
                    //print( messageStacks[stackIndex].messages[messageStackIndex].readInd )
                   print(id, "needs to be read")
                   self.dataSource?.messageStack[stackIndex].messages[messageStackIndex].readInd = true
                   let saved = saveToDrive()
                    //debugPrint(self.dataSource?.messageStack)
                   
                    if saved {
                       
                        return true
                    }
                    return false
                }
                messageStackIndex+=1
            }
            stackIndex+=1
        }
        return false
    }
    
    func downloadTodaysMessages() {
        print("downloadTodaysMessage()")
        guard let todayDate = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let todayString = formatter.string(from: todayDate)
        guard let stacks = self.dataSource?.messageStack else {
            return
        }
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
        print("downloadMessagesBack(_:_:)")
        guard let today = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {
            return
        }
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
        print("saveToDrive()")
        let path = MessageHandler.pathForDocArchivedLog.path
        let finder = FileManager.default
        guard let model = self.dataSource else {
            return false
        }
        let encodable = model.messageStack
            if encodable.count > 0 {
            do {
                let json = try ModelStore.jsonEncoder.encode(encodable)
                finder.createFile(atPath: path, contents: json, attributes: nil)
                return true
            } catch {
                print(error)
                return false
            }
        }
        return false
    }
    
    func loadFromDrive() -> Bool {
        print("loadFromDrive()")
        let path = MessageHandler.pathForDocArchivedLog
        let option = NSData.ReadingOptions.uncached
        
        do {
            let data = try Data(contentsOf: path, options: option)
            let json = try ModelStore.jsonDecoder.decode([MessageStack].self, from: data)
            self.dataSource?.messageStack = json
            sync()
            return true
        } catch {
            print(error)
            return false
        }
    }

    func sync() {
        print("sync()")
        self.delegate?.refresh()
    }
}
