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
                self.messageReadCount.text = "\(self.messages?.count ?? 0) unread messages"
            }
        }
    }
    var messageHandler: MessageHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageHandler = MessageHandler()
        self.messageHandler?.downloadMessages(sender: self)
        
        
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
