//
//  MessageCell.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/11/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

enum InboxView {
    case inbox
    case favorite
    case archived
}

class MessageViewCell {
    
    weak var delegate: MessageHandler?
    weak var inboxDelegate: InboxViewController?
    
    func buildCells(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        //ensure the unread features style stay.
        cell.unreadInd.isHidden = false
        cell.subject.font = UIFont(name: "HelveticaNeue-Bold", size: 20.0)
        cell.messageBody.font = UIFont(name: "HelveticaNeue-Bold", size: 14.0)
        
        guard let inboxView = inboxDelegate?.inboxView, let messageStacks = self.delegate?.dataSource?.messageStacks else {
            return cell
        }
        guard let filteredStacks = MessageQuery.getMessagesFiltered(by: inboxView, messageStack: messageStacks) else {
            return cell
        }
        
        let stackIndexLimit = MessageQuery.safeIndexOfMessageStack(messageStack: filteredStacks).max
        
        if indexPath.section <= stackIndexLimit {
            let stack = filteredStacks[indexPath.section]
            print(filteredStacks[indexPath.section].timestamp)
            print(filteredStacks[indexPath.section].messages.count)
            print(indexPath.row)
            let messageIndexLimit = stack.messages.count-1
            
            if indexPath.row <= messageIndexLimit {
                cell.subject.text = stack.messages[indexPath.row].subject
                cell.messageBody?.text = stack.messages[indexPath.row].messageBody
                cell.messageID = stack.messages[indexPath.row].messageID
                cell.index = indexPath
                
                
                if stack.messages[indexPath.row].readInd == true {
                    
                    cell.subject.font = UIFont(name: "HelveticaNeue", size: 14.0)
                    cell.messageBody.font = UIFont(name: "HelveticaNeue", size: 11.0)
                    cell.unreadInd.isHidden = true
                }
                
            }
            
        }
        return cell
    }
    
    func buildHeaders(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let inboxView = self.inboxDelegate?.inboxView, let messageStacks = self.delegate?.dataSource?.messageStacks else {
            return nil
        }
        guard let stacks = MessageQuery.getMessagesFiltered(by: inboxView, messageStack: messageStacks) else {
            return nil
        }
        let max = MessageQuery.safeIndexOfMessageStack(messageStack: stacks).max
        
        if max >= section {
            if stacks[section].messages.count == 0 {
                return nil
            }
            let timestamp = stacks[section].timestamp
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            guard let date = formatter.date(from: timestamp) else {
                return nil
            }
            formatter.dateFormat = "MMM d, yyyy"
            let header = formatter.string(from: date)
            return header
        }
        return "No Date"
    }
    
    func getBadgeCounts() {
        guard let messageStacks = inboxDelegate?.messageHandler.dataSource?.messageStacks else {
            return
        }
        guard let viewControllers = inboxDelegate?.tabBarController?.viewControllers else {
            return
        }
        for view in viewControllers {
            if view.title == "Favorites" {
                view.tabBarItem.badgeValue = MessageQuery.getNumberOfMessages(messageStacks: messageStacks).favorited.description
                if view.tabBarItem.badgeValue == "0" {
                    view.tabBarItem.badgeValue = nil
                }
            }
            if view.title == "History" {
                view.tabBarItem.badgeValue = MessageQuery.getNumberOfMessages(messageStacks: messageStacks).archived.description
                if view.tabBarItem.badgeValue == "0" {
                    view.tabBarItem.badgeValue = nil
                }
            }
            if view.title == "Inbox" {
                view.tabBarItem.badgeValue = MessageQuery.getNumberOfMessages(messageStacks: messageStacks).unread.description
                if view.tabBarItem.badgeValue == "0" {
                    view.tabBarItem.badgeValue = nil
                }
            }
        }
    }
}
