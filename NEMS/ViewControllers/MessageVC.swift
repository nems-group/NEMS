//
//  MessageVC.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MessageVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageDelegate {
    

    var messageHandler = MessageHandler()
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let stacks = ModelStore.shared.messageStack
        print(stacks.count)
        print(section)
        var count = 0
        if stacks.count-1 >= section {
            print(stacks.count)
            print(section)
            let stack = stacks[section]
            
            for _ in stack.messages {
                count+=1
            }
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = buildCell(tableView, cellForRowAt: indexPath)
        return cell
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messageHandler.delegate = self
        messageHandler.sync()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MessageTableViewCell else {
            print("couldn't make it MessageTableViewCell")
            return
        }
        
        guard let id = cell.messageID else {
            print("no cell id")
            return
        }
        let result = messageHandler.readMessage(id: id, messageStacks: &ModelStore.shared.messageStack)
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
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
        }
        print("refresh")
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func buildCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
            
        let stacks = ModelStore.shared.messageStack
        
        let stackIndexLimit = stacks.count-1
        
        if indexPath.section <= stackIndexLimit {
            let stack = stacks[indexPath.section]
            let messageIndexLimit = stack.messages.count-1
            
            if indexPath.row <= messageIndexLimit {
                cell.subject.text = stack.messages[indexPath.row].subject
                cell.messageBody?.text = stack.messages[indexPath.row].messageBody
                cell.messageID = stack.messages[indexPath.row].messageID
                cell.index = indexPath
                
            }
            
        }
        return cell
    }
    
}
