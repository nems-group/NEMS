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
    var uiWebView: UIWebView!
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self

        //view = webView
        
        uiWebView = UIWebView(frame: .zero)
        view = uiWebView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let myURL = URL(string: "https://www.nextmd.com/m")
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
        
        uiWebView.loadRequest(myRequest)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        //webViewDidFinishLoad(webView: uiWebView)
    }
    

    func webViewDidFinishLoad(webView: UIWebView) {
        //doesn't work, still need a way to find the username and password field in PP websit.
        // fill data
        let savedUsername = "USERNAME"
        let savedPassword = "PASSWORD"
        print("savedUsername: \(savedUsername)")
        
        let fillForm = String(format: "document.getElementById('#loginTxtUsrName').value = '\(savedUsername)';document.getElementById('divUserPwd').value = '\(savedPassword)';")
        webView.stringByEvaluatingJavaScript(from: fillForm)
        
    }

}
