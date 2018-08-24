//
//  MenuController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 8/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

enum LoginStatus {
    case loggedIn
    case loggedOut
}

class MenuController: UIViewController {
    var loginStatus: LoginStatus?

    @IBAction func closeLeftMenuBar(_ sender: Any) {
        performSegue(withIdentifier: "unwindToLeftMenuViewController", sender: self)
    }
    
    
    @IBOutlet weak var lblMemberName: UILabel?
    @IBOutlet weak var loginLogoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.bounds = CGRect(x: 0, y: 0, width: 0, height: 0)
//        self.view.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    func tokenChanged() {
        DispatchQueue.main.async {
            print("token changed")
            guard ModelStore.shared.token?.refresh_token != nil else {
                self.loginStatus = .loggedOut
                self.loginLogoutButton.setTitle("Login", for: .normal)
                return
            }
            self.loginStatus = .loggedIn
            self.loginLogoutButton.setTitle("Logout", for: .normal)
        }
    }
    
    
    @IBAction func loginLogout(){
        guard let status = self.loginStatus else {
            return
        }
        switch status {
        case .loggedOut: OAuth.session?.start()
            case .loggedIn : do {
                try Keyring.removeRefreshToken()
            } catch {
                print(error)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        if lblMemberName?.text == "Hello Guest" {
//            lblMemberName?.text = "Hello Guest!"
//        }
        
        guard ModelStore.shared.token != nil else {
            // we aren't logged in.
            self.loginStatus = .loggedOut
            self.loginLogoutButton.setTitle("Login", for: .normal)
            print("status of login \(self.loginStatus)")
            return
        }
        self.loginStatus = .loggedIn
        self.loginLogoutButton.setTitle("Logout", for: .normal)
        print("status of login \(self.loginStatus)")
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    

}
