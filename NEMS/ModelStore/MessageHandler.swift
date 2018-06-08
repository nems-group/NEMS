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
    
    static var newMessagesFromDateBaseURL = MessageHandler.onlineURLforMessage?.appendingPathComponent("newMessages")
    static var allMessagesFromBaseURL = MessageHandler.onlineURLforMessage?.appendingPathComponent("allMessages")
    
    
    func downloadMessages(forDateAfter: String, delegate: MessageDelegate) {
        guard var url = MessageHandler.newMessagesFromDateBaseURL else {
            return
        }
        url = url.appendingPathComponent(forDateAfter)
        print(url)
        retrieveMessages(fromURL: url) {
            delegate.refresh()
        }
    }
    
    
    
    func downloadMessages(delegate: MessageDelegate) {
        guard let url = MessageHandler.allMessagesFromBaseURL else {
            return
        }
        retrieveMessages(fromURL: url) {
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
    
    func readMessage(id: UUID) -> Bool {
        guard let messageStacks = ModelStore.shared.messageStack else {
            return false
        }
        for stack in messageStacks {
            var index = 0
            for message in stack.messages {
                if message.messageID == id {
                    
                    // MARK: TODO - Need to find update the model store when read
                    print(id, "needs to be read")
                    index += 1
                }
            }
            if index > 0 {
                return true
            }
        }
        return false
    }
    
    func downloadTodaysMessages(delegate: MessageDelegate) {
        guard let todayDate = Calendar.current.date(byAdding: .day, value: 0, to: Date()) else {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: todayDate)
        guard let stacks = ModelStore.shared.messageStack else {
            print("no messages found in model so lets download anyways")
            downloadMessages(forDateAfter: todayString, delegate: delegate)
            return
        }
        guard let mostRecentDateString = MessageQuery.getMostRecentDate(messageStacks: stacks) else {
            downloadMessages(forDateAfter: todayString, delegate: delegate)
            return
        }
        guard let mostRecentDate = formatter.date(from: mostRecentDateString) else {
            downloadMessages(forDateAfter: todayString, delegate: delegate)
            return
        }
        
        if mostRecentDate < todayDate {
            print("getting older missed messages too")
            downloadMessages(forDateAfter: mostRecentDateString, delegate: delegate)
            return
        }
        return
    }
    
    func downloadMessagesBack(_ numberOf: Int, _ dateCompenent: Calendar.Component, delegate: MessageDelegate) {
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
        downloadMessages(forDateAfter: dateString, delegate: delegate)
    }
    
    func saveToDrive() -> Bool {
        let path = MessageHandler.pathForDocArchivedLog
        guard let encodable = ModelStore.shared.messageStack else {
            print("no encodable to save")
            return false
        }
        do {
            let json = try ModelStore.jsonEncoder.encode(encodable)
            try json.write(to: path)
            return true
        } catch {
            print(error)
            return false
        }
    }
}
