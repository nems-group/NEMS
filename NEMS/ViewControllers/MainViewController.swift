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
    
    var messageHandler: MessageHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageHandler = MessageHandler()
        messageHandler?.downloadMessages(delegate: self)
        
        
    }

    
        //changed to launch safari app instead of using web-kit (in-app), this will allow users to save passwards and such as though they used the regular safari app. possibly use third party apps using settings in the future.
        @IBAction func patientPortalLaunch(_ sender: Any) {
                openPatientPortal()
        }
    
        func openPatientPortal() {
            guard let url = URL(string: "https://www.nextmd.com") else {
                return
            }
            UIApplication.shared.open(url,options: [:])
        }
   
    func refresh() {
        var count = 0
        guard let stacks = ModelStore.shared.messageStack else {
            print("message stack is nil")
            return
        }
        for stack in stacks {
            let messages = stack.messages
            for message in messages {
                if message.readInd == false {
                    count+=1
                }
            }
        }
        if count > 0 {
            DispatchQueue.main.async {
                self.messageReadCount.text = "\(count) unread messages"
            }
        }
    }
}
