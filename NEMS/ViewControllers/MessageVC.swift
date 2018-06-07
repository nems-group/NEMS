//
//  MessageVC.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MessageVC: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageDelegate {
    var messages: [Message]?
    var messageHandler = MessageHandler()
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let n = self.messages?.count else {
            print("no rows")
            return 1
        }
        return n
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell =  tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell else {
            return UITableViewCell()
        }
        
        guard let m = self.messages?[indexPath.row] else {
            return cell
        }
        cell.subject.text = m.subject
        cell.messageBody.text = m.messageText
        cell.messageID = m.messageID
        cell.index = indexPath
        //print(cell)
        return cell
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messageHandler.downloadMessagesBack(sender: self, -3, .month)
        
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
            return
        }
        messageHandler.readMessage(id: id, sender: self)
        
        print("read message \(id)")
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
}
