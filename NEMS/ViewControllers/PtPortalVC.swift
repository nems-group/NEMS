//
//  PtPortalVC.swift
//  NotificationTutorial
//
//  Created by User on 4/23/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit
import WebKit

class PtPortalVC: UIViewController, WKUIDelegate {
    
    var webView: WKWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: "https://www.nextmd.com/")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
