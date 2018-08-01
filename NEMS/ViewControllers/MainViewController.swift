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
    var oauthHandler: OAuth?
    
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
        let client_id = "l7f2ac2380f849472f8092393ef83cb14f"
        let redirectURI = "nems-app://oauthCallback"
        self.oauthHandler = OAuth(clientID: client_id, callback: redirectURI)
        // SFAuth
        oauthHandler?.start()
        //ASAuth
    }
    
    func refresh() {
        var count = 0
        guard let stacks = self.messageHandler.dataSource?.messageStacks else {
            DispatchQueue.main.async {
                self.messageReadCount.text = "Failed to get number of messages"
            }
            return
        }
        count = MessageQuery.getNumberOfMessages(messageStacks: stacks).unread
        if count > 0 {
            DispatchQueue.main.async {
                self.messageReadCount.text = "\(count) unread messages"
            }
        } else {
            DispatchQueue.main.async {
                self.messageReadCount.text = "No unread messages"
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        messageHandler.sync()
        return
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}
