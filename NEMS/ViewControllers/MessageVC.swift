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
    
    static var urlForMessage: URL? {
        if let path = Bundle.main.path(forResource: "Info", ofType: "plist"), let dictionary = NSDictionary(contentsOfFile: path) {
            //print(path)
            //print(dictionary)
               if let urlPath = dictionary.object(forKey: "MessagesURL") as? String {
                    let url = URL(string: urlPath)
                    //print(url)
                    return url
            }
        }
        print("couldn't get plist")
        return nil
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let n = messages?.count else {
            print("no rows")
            return 1
        }
        return n
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        print(messages)
        
        guard let m = messages?[indexPath.row] else {
            return cell
        }
        cell.textLabel?.text = m.subject
        //print(cell)
        return cell
    }
    
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    var messageHandler = MessageHandler()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        messagesTableView.delegate = self
        messagesTableView.dataSource = self
        messageHandler.delegate = self
        guard let url = MessageVC.urlForMessage else {
            return
        }
        messageHandler.retrieveMessages(fromURL: url, sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func saveMessages(message: [Message]?) {
        guard let messages = message else {
            return
        }
        self.messages = messages
        DispatchQueue.main.async {
            self.messagesTableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.messages = messageHandler.loadMessages(fromPath: MessageHandler.pathForArchivedLog)
        
       // messagesTableView.reloadData()
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
