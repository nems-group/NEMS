//
//  MainViewController.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    
        //changed to launch safari app instead of using web-kit (in-app), this will allow users to save passwards and such as though they used the regular safari app. possibly use third party apps using settings in the future.
        @IBAction func patientPortalLaunch(_ sender: Any) {
                openPatientPortal()
            }
    
        func openPatientPortal() {
                UIApplication.shared.open(URL(string: "https://www.nextmd.com")!)
            }
}
