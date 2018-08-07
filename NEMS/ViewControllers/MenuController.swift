//
//  MenuController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 8/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

enum LoginStatus {
    case `in`
    case out
}

class MenuController: UIViewController, OAuthDelegate {
    var loginStatus: LoginStatus?

    @IBOutlet weak var loginLogoutButton: UIButton!
    override func viewDidLoad() {
        OAuth.session?.delegate = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func tokenChanged() {
        print("token changed")
        guard ModelStore.shared.token != nil else {
            self.loginStatus = .out
            self.loginLogoutButton.titleLabel?.text = "Login"
            return
        }
        self.loginStatus = .in
        self.loginLogoutButton.titleLabel?.text = "Logout"
    }
    
    @IBAction func loginLogout(){
        guard let status = self.loginStatus else {
            return
        }
        switch status {
        case .in: OAuth.session?.start()
            case .out : do {
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
            self.loginStatus = .out
            self.loginLogoutButton.titleLabel?.text = "Login"
            return
        }
        self.loginStatus = .in
        self.loginLogoutButton.titleLabel?.text = "Logout"
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
