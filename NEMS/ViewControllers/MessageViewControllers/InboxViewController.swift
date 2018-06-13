//
//  InboxViewController.swift
//
//
//  Created by Scott Eremia-Roden on 06/01/18.
//  Copyright © 2018 Scott Eremia-Roden. All rights reserved.
//

import UIKit

class InboxViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageCellBuilderDelegate, UITabBarDelegate {
    

    var messageHandler: MessageHandler!
    var messageViewCell: MessageViewCell!
    var inboxView: InboxView = .inbox
    var selectedUUID: UUID?

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
        return messageViewCell.buildCells(tableView, cellForRowAt: indexPath)
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messageHandler = MessageHandler()
        messageHandler.loadedOnce = 1
        messageHandler?.delegate = self
        messageViewCell = MessageViewCell()
        messageViewCell.delegate = self.messageHandler
        messageViewCell.inboxDelegate = self
        messageHandler?.dataSource = ModelStore.shared
        messageHandler?.start()
        
    }
        
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return messageViewCell.buildHeaders(tableView, titleForHeaderInSection: section)
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
        guard let result = messageHandler?.updateMessage(id: id, action: .read) else {
            print("read message failed because messageHandler is nil")
            return
        }
        if result {
            print("read message \(id)")
            readRow(tableView, indexPath: indexPath)
            
        }
        self.selectedUUID = id
        
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
            self.messageViewCell.getBadgeCounts()
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
        self.messageViewCell.getBadgeCounts()
        self.refresh()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "messageDetail" {
            guard let viewController = segue.destination as? MessageDetailViewController else {
                return
            }
            viewController.delegate = self
            
        }
    }
    
}
