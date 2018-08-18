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

    }
    
    @IBOutlet weak var loginLogoutButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
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


}
