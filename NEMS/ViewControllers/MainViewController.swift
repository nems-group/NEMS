//
//  MainViewController.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MessageDelegate {
    
    @IBOutlet weak var messageReadCount: UITextField!
    
    
    var messages: [Message]? {
        didSet {
            DispatchQueue.main.async {
                guard let messages = self.messages else {
                    return
                }
                var count: Int = 0
                for message in messages {
                    if message.readInd == false {
                        count += 1
                    }
                }
                self.messageReadCount.text = "\( { (count) -> String in  if count == 0 { return "No" } else { return String(count) } }(count)) unread messages" as String
                let returnValue = JSON.writeToDrive(self.messages)
                print(MessageHandler.pathForDocArchivedLog)
                print(returnValue)
            }
        }
    }
    var messageHandler: MessageHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageHandler = MessageHandler()
        self.messageHandler?.downloadMessagesBack(sender: self, 3, .month)
        
        
        
    }

    
        //changed to launch safari app instead of using web-kit (in-app), this will allow users to save passwards and such as though they used the regular safari app. possibly use third party apps using settings in the future.
        @IBAction func patientPortalLaunch(_ sender: Any) {
                openPatientPortal()
            }
    
        func openPatientPortal() {
            UIApplication.shared.open(URL(string: "https://www.nextmd.com")!,options: [:])
            }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MessageViewController" {
            guard let messageVC = segue.destination as? MessageVC else {
                return
            }
            messageVC.messages = self.messages
            
        }
    }
}
