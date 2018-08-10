//
//  MainViewController.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, MessageDelegate, OAuthDelegate {
    
    var messageHandler: MessageHandler!
    weak var menuBar: MenuController?
    
    var oauthHandler: OAuth?
    
    @IBOutlet weak var messageReadCount: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.messageHandler = MessageHandler()
        self.messageHandler?.delegate = self
        self.messageHandler?.dataSource = ModelStore.shared
        self.oauthHandler = OAuth.session
        OAuth.session?.delegate = self
        self.messageHandler?.start()
        
        
        
    }
    
    
    //changed to launch safari app instead of using web-kit (in-app), this will allow users to save passwards and such as though they used the regular safari app. possibly use third party apps using settings in the future.
    @IBAction func patientPortalLaunch(_ sender: Any) {
        openPatientPortal()
    }
    
    func openPatientPortal() {
        do {
            try Keyring.retrieveRefreshToken()
            if ModelStore.shared.token?.refresh_token != nil {
                print("we have token data")
                return
            }
        } catch {
            print(error)
        }
        
        
        
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
    
    
    /// This function is called when the token is updated
    func tokenChanged() {
        if ModelStore.shared.token != nil {
            print("you have a token")
            do {
                try Keyring().saveRefresh(token: ModelStore.shared.token!)
                menuBar?.tokenChanged()
            } catch {
                print(error)
            }
        } else {
            menuBar?.tokenChanged()
            print("token is missing")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        messageHandler.sync()
        return
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "menuBarSegue" {
            self.menuBar = segue.destination as? MenuController
        }
    }
    
}
