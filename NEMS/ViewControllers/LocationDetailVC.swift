//
//  LocationDetailVC.swift
//  NotificationTutorial
//
//  Created by User on 4/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class LocationDetailVC: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("text: \(textView.text)")
        if let location = ModelStore.shared.selectedLocation {
            imageView.image = UIImage(named: location.image!)
            textView.text = location.description
        }
    }


}

