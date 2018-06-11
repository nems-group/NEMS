//
//  HistoriesViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/10/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class HistoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MessageDelegate {
    
    var messageHander: MessageHandler!
    
    override func viewDidAppear(_ animated: Bool) {
        //
    }
    
    override func viewDidLoad() {
        //
    }
    
    
    func refresh() {
        // MARK: To-Do refresh
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // MARK: To-Do tableView number of rows
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: To-Do cellForRowAtPath
        return UITableViewCell()
    }
    
    
    
}
