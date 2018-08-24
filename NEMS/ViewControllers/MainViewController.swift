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
    
    //var oauthHandler: OAuth?
    
    @IBOutlet weak var messageReadCount: UITextField!
    @IBOutlet var leftMenuTrailingConstraints: NSLayoutConstraint!
    @IBOutlet var leftMenuLeadingConstraints: NSLayoutConstraint!
    
    //****** searchOption view variables
    //control how far the left menu can go
    var isleftMenuOpened: Bool = false
    var leftMenuOpenConstraint: CGFloat = 0
    
    //View that will display the left menu view controller
    @IBOutlet var leftMenuViewRef: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.messageHandler = MessageHandler()
        self.messageHandler?.delegate = self
        self.messageHandler?.dataSource = ModelStore.shared
        //self.oauthHandler = OAuth.session
        OAuth.session?.delegate = self
        self.messageHandler?.start()
        
        do {
            try OAuth.session?.checkLogin()
        } catch {
            print("not logged in")
        }

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
        OAuth.session?.start()
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
        menuBar?.tokenChanged()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //20180812 add left menu View Controller
        //set initial left menu open area to leading constratints
        leftMenuOpenConstraint = self.view.bounds.width //-leftMenuViewRef.bounds.size.width
        leftMenuTrailingConstraints.constant = -self.leftMenuOpenConstraint
        
        
        
        //self.navigationController?.setNavigationBarHidden(true, animated: animated)
        //messageHandler.sync()
        //MessageController.register(tags: ["Hello World", "New Test"])
        return
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func slideOutLeftMenuBar() {
        //slide in/out menu
        if !isleftMenuOpened {
            //this make a shadow line between leftMenu view and main view, range from 0 - 1
            leftMenuViewRef.layer.shadowOpacity = 1
            //shadowRadius needs "shadowOpacity" to show on the screen.
            leftMenuViewRef.layer.shadowRadius = 6
            
            leftMenuLeadingConstraints.constant = 0
            leftMenuTrailingConstraints.constant = 0

            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
            
        } else {
            //this make a shadow line between leftMenu view and main view, range from 0 - 1
            leftMenuViewRef.layer.shadowOpacity = 0
            
            leftMenuLeadingConstraints.constant = -self.leftMenuOpenConstraint
            leftMenuTrailingConstraints.constant = -self.leftMenuOpenConstraint
        }
        
        isleftMenuOpened = !isleftMenuOpened
    }
    
    
    //unwind function to call slideOutLeftMenuBar() from Child view contorller///////
    @IBAction func unwindToLeftMenuViewController(sender: UIStoryboardSegue) -> Void {
        //if let controller = sender.source as? UIViewController, let data = controller
        slideOutLeftMenuBar()
    }
    
    
}
