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
        print("closed side menu")
        performSegue(withIdentifier: "unwindToLeftMenuViewController", sender: self)
    }
    
    
    @IBOutlet weak var lblMemberName: UILabel?
    @IBOutlet weak var loginLogoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblMemberName?.text = "Hello \(ModelStore.shared.patient?.fullName ?? "Guest")"
    }
    
    func tokenChanged() {
        DispatchQueue.init(label: "patient").async {
            print("patient thread")
            print("modelStorepatient: \(ModelStore.shared.patient)")
            if ModelStore.shared.patient == nil && ModelStore.shared.token != nil {
                ModelStore.shared.patient = Patient()
            }
        }
        
        DispatchQueue.main.async {
            print("token changed")
            guard ModelStore.shared.token?.refresh_token != nil else {
                self.loginStatus = .loggedOut
                self.loginLogoutButton.setTitle("Login", for: .normal)
                ModelStore.shared.memberName = "Guest!"
                return
            }
            self.loginStatus = .loggedIn
            self.loginLogoutButton.setTitle("Logout", for: .normal)
            self.lblMemberName?.text = "Hello \(ModelStore.shared.patient?.fullName ?? "Guest")"
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
                ModelStore.shared.patient = nil
                self.loginStatus = .loggedOut
                self.loginLogoutButton.setTitle("Login", for: .normal)
            } catch {
                print(error)
            }
        }
        self.tokenChanged()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("This is in MenuController viewWillAppear - ModelStore.shared.token: \(ModelStore.shared.token)")
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
