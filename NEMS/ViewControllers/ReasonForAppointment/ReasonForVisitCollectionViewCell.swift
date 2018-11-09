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
    var resource: Resource?
    
    func setup(_ event: Event, for resource: Resource) {
        self.event = event
        self.resource = resource
        reasonLabel.text = event.displayName
        
    }
    
    
    
}
