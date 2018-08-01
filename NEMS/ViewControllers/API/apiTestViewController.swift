//
//  apiTestViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class apiTestViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var apiEndPoint: UITextField!
    
    @IBAction func apiSend(_ sender: Any) {
        guard let authToken = ModelStore.shared.token, let endPoint = apiEndPoint.text else {
            let alert = UIAlertController(title: "No Token", message: "Please Login", preferredStyle: .alert)
            self.present(alert, animated: true) {
                alert.dismiss(animated: true, completion: nil)
                return
            }
            return
        }
        if self.apiEndPoint.text == "vitals" {
            let _ = VitalSigns()
            return
        }
        do {
            try patientPortalAPI(call: endPoint, authToken: authToken) { (response, data) in
                if response?.statusCode == 200 {
                    DispatchQueue.main.async {
                        
                        if let data =  data {
                            do {
                                let result = try JSONSerialization.jsonObject(with: data, options: [])
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
