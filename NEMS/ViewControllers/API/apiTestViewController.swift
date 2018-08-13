//
//  apiTestViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class apiTestViewController: UIViewController, UITextFieldDelegate, OAuthDelegate {
    func tokenChanged() {
        guard let token = ModelStore.shared.token else {
            presentAlert()
            return
        }
    }
    
    @IBOutlet weak var apiEndPoint: UITextField!
    
    
    var oauthDelegate: OAuthDelegate?
    
    func presentAlert() {
        let action = UIAlertAction(title: "Ok", style: .default) { (action) in
            OAuth.session?.start()
        }
            let alert = UIAlertController(title: "You are not logged in", message: "Please login first", preferredStyle: .alert)
            alert.addAction(action)
            present(alert, animated: true)
    }
    
    @IBAction func apiSend(_ sender: Any) {
        
        guard let authToken = ModelStore.shared.token, let endPoint = apiEndPoint.text else {
            guard (ModelStore.shared.token?.refresh_token) != nil else {
                do {
                    try Keyring.retrieveRefreshToken()
                } catch KeychainError.noToken {
                    presentAlert()
                } catch {
                    print(error)
                }
                return
            }
            return
        }
        do {
            try patientPortalAPI(call: endPoint, authToken: authToken) { (response, data) in
                if response?.statusCode == 200 {
                    DispatchQueue.main.async {
                        
                        if let data =  data {
                            do {
                               let result = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                               guard let resultText = result as? String else {
                                    print("couldn't make it a string for some dumb reason")
                                    self.apiResults.text = String(describing: result)
                                    return
                                }
                                self.apiResults.text = resultText
                            } catch {
                                print(error)
                            }
                        }
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        self.apiResults.text = response.debugDescription
                    }
                    
                }
            }
        } catch {
            print(error)
        }
    }
    
    @IBOutlet weak var apiResults: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.oauthDelegate = self

        // Do any additional setup after loading the view.
    }
    
    @IBAction func hideKeyboard() {
        becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        apiSend(self)
        self.becomeFirstResponder()
        return true
    }
    @IBAction func refreshToken(_ sender: Any) {
        OAuth.session?.refresh()
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
