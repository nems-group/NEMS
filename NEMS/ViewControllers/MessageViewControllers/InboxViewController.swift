//
//  InboxViewController.swift
//
//
//  Created by Scott Eremia-Roden on 06/01/18.
//  Copyright © 2018 Scott Eremia-Roden. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageCellBuilderDelegate {
    

    var messageHandler: MessageHandler!
    var inboxView: InboxView = .inbox

    @IBOutlet weak var tabBar: UITabBarItem!
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let stack = MessageQuery.getMessagesFiltered(by: inboxView, messageStack: messageHandler.dataSource?.messageStacks) else {
            return 0
        }
        
        return stack.count
        
    }
    
    
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let filteredStacks = MessageQuery.getMessagesFiltered(by: inboxView, messageStack: messageHandler.dataSource?.messageStacks) else {
            return 0
        }
        let numberOfRows = MessageQuery.numberOfMessagesInStack(stackNumber: section, messageStack: filteredStacks)
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return MessageViewCell.buildCells(tableView, cellForRowAt: indexPath, messageHandler: messageHandler, inboxView: inboxView)
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messageHandler = MessageHandler()
        messageHandler.loadedOnce = 1
        messageHandler?.delegate = self
        messageHandler?.dataSource = ModelStore.shared
        messageHandler?.start()
        
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return MessageViewCell.buildHeaders(tableView, titleForHeaderInSection: section, messageHandler: messageHandler, inboxView: inboxView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: To-do probably going to change this later, and do the "read" on a seperate view
        guard let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell else {
            print("couldn't make it MessageTableViewCell")
            return
        }
        
        guard let id = cell.messageID else {
            print("no cell id")
            return
        }
        guard let result = messageHandler?.readMessage(id: id) else {
            print("read message failed because messageHandler is nil")
            return
        }
        if result {
            print("read message \(id)")
            readRow(tableView, indexPath: indexPath)
            
        }
        
    }
    
    func readRow(_ tableView: UITableView, indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell else {
            print("couldn't make it MessageTableViewCell")
            return
        }
        
        cell.subject.font = UIFont(name: "Helvetica Neue-Regular", size: 20.0)
        cell.messageBody.font = UIFont(name: "Helvetica Neue-Regular", size: 11.0)
        cell.unreadInd.isHidden = true
        self.refresh()
    }
    
    func refresh() {
        
        DispatchQueue.main.async {
            print("refresh")
            guard let messageStacks = self.messageHandler.dataSource?.messageStacks else {
                return
            }
            switch self.inboxView {
                case .inbox: self.tabBar.badgeValue = MessageQuery.getNumberOfMessages(messageStacks: messageStacks).unread.description
                case .favorite: self.tabBar.badgeValue = MessageQuery.getNumberOfMessages(messageStacks: messageStacks).favorited.description
                case .archived: self.tabBar.badgeValue = MessageQuery.getNumberOfMessages(messageStacks: messageStacks).archived.description
            }
            
            print(self.tabBar)
            
            if self.tabBar.badgeValue == "0" {
                self.tabBar.badgeValue = nil
            }
            self.messagesTableView.reloadData()
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.refresh()
    }
    
    
}
