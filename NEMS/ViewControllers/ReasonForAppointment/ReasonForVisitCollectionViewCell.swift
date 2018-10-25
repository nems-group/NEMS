//
//  ReasonForVisitCollectionViewCell.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 10/17/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class ReasonForVisitCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var reasonLabel: UILabel!
    
    var event: Event?
    
    func setupFor(_ event: Event) {
        self.event = event
        reasonLabel.text = event.description
    }
    
    
    
}
