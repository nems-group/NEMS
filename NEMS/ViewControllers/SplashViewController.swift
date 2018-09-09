//
//  SplashViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/8/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

enum menuToggle {
    case opened
    case closed
}

class SplashViewController: UIViewController {

    @IBOutlet weak var sideMenuLeading: NSLayoutConstraint!
    var menuStatus: menuToggle = .closed
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func toggleMenu() {
        debugPrint("before", self.sideMenuLeading)
        switch self.menuStatus {
            
        case .opened: {
            print("opened menu bar needs to close")
            self.sideMenuLeading.constant = -341.00
            self.menuStatus = .closed
        }()
        case .closed: {
            print("closed menu bar needs to open")
            self.sideMenuLeading.constant = 0.00
            self.menuStatus = .opened
        }()
        }
        //dump(self.view)
        self.updateViewConstraints()
        debugPrint("after", self.sideMenuLeading)
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
