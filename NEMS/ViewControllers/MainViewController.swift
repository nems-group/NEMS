//
//  MainViewController.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MessageDelegate {
    
    var messageHandler: MessageHandler!
    
    @IBOutlet weak var messageReadCount: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageHandler = MessageHandler()
        self.messageHandler?.delegate = self
        self.messageHandler?.dataSource = ModelStore.shared
        self.messageHandler?.start()
        
        
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
        guard let stacks = messageHandler?.dataSource?.messageStack else {
            print("no stack")
            return
        }
        for stack in stacks {
            let messages = stack.messages
            for message in messages {
                if message.readInd == false {
                    print("unread")
                    count = count + 1
                }
            }
        }
        if count > 0 {
            DispatchQueue.main.async {
                self.messageReadCount.text = "\(count) unread messages"
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(MessageHandler.pathForDocArchivedLog)
        print("viewDidAppear(_:)")
        messageHandler.sync()
        return
    }
}
