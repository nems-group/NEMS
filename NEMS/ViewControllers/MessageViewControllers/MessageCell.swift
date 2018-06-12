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
    weak var inboxView: MessageCellBuilderDelegate?
    
    class func buildCells(_ tableView: UITableView, cellForRowAt indexPath: IndexPath, messageHandler: MessageHandler, inboxView: InboxView) -> UITableViewCell {
        
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        let filteredStack: [MessageStack]? = {
            switch inboxView {
                case .inbox: return MessageQuery.getMessagesFiltered(by: .inbox, messageStack: ModelStore.shared.messageStacks)
                case .archived: return MessageQuery.getMessagesFiltered(by: .archived, messageStack: ModelStore.shared.messageStacks)
            case .favorite: return MessageQuery.getMessagesFiltered(by: .favorite, messageStack: ModelStore.shared.messageStacks)
            }
        }()
        guard let filteredStacks = filteredStack else {
            
            return cell
        }
        print(filteredStacks.count)
        
        let max = MessageQuery.safeIndexOfMessageStack(messageStack: filteredStacks).max
        let stackIndexLimit = max
        
        if indexPath.section <= stackIndexLimit {
            let stack = filteredStacks[indexPath.section]
            let messageIndexLimit = stack.messages.count-1
            
            if indexPath.row <= messageIndexLimit {
                cell.subject.text = stack.messages[indexPath.row].subject
                cell.messageBody?.text = stack.messages[indexPath.row].messageBody
                cell.messageID = stack.messages[indexPath.row].messageID
                cell.index = indexPath
                
                
                if stack.messages[indexPath.row].readInd == true {
                    
                    cell.subject.font = UIFont(name: "Helvetica Neue-Regular", size: 20.0)
                    cell.messageBody.font = UIFont(name: "Helvetica Neue-Regular", size: 11.0)
                    cell.unreadInd.isHidden = true
                }
                
            }
            
        }
        return cell
    }
    
    class func buildHeaders(_ tableView: UITableView, titleForHeaderInSection section: Int, messageHandler: MessageHandler, inboxView: InboxView) -> String? {
        guard let stacks = MessageQuery.getMessagesFiltered(by: inboxView, messageStack: messageHandler.dataSource?.messageStacks) else {
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
}
