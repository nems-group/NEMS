//
//  MessageSwipes.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
/*
class MessageSwipe {
    
    weak var delegate: InboxViewController?
    
    func swipe(_ inboxView: InboxView, indexPath: IndexPath) -> UIContextualAction? {
        let action = UIContextualAction(style: .destructive, title:  "Read", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            guard let delegate = self.delegate else {
                return
            }
            guard let cell = self.delegate.tableView.cellForRow(tableView: self.delegate.messagesTableView, at: indexPath) as? MessageTableViewCell else {
        print("couldn't make it MessageTableViewCell")
        return
        }
        guard let id = cell.messageID else {
        return
        }
        let _ = self.messageHandler.updateMessage(id: id, action: .read)
        print("OK, marked as Read")
        success(true)
        })
        return action
    }


}
*/
