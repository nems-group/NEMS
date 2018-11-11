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
    var dataSource: [Reasons]?
    
    func setup(for indexPath: IndexPath) {
        print(indexPath)
        guard let reasons = dataSource else {
            print("dataSource is nil")
            return
        }
        // index path 0.0
        if (reasons.startIndex != reasons.endIndex) && reasons.endIndex >= indexPath.section {
            let reasonsForSection = reasons[indexPath.section]
            print(reasonsForSection.providerType)
            if (reasonsForSection.resource.events.startIndex != reasonsForSection.resource.events.endIndex) && reasonsForSection.resource.events.endIndex >= indexPath.row {
                let event = reasonsForSection.resource.events[indexPath.row]
                self.event = event
                self.resource = reasonsForSection.resource
                self.reasonLabel.text = event.displayName
            }
        } else {
            print(indexPath, reasons.startIndex, reasons.endIndex)
        }
    }
    
    
    
}
