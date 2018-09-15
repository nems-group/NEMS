//
//  HistoriesViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/10/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class HistoriesViewController: InboxViewController {
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.inboxView = .archived
    }
    
    
}
