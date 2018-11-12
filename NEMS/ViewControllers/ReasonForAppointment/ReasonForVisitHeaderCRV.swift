//
//  ReasonForVisitHeaderCRV.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 11/11/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class ReasonForVisitHeaderCRV: UICollectionReusableView {
    
    @IBOutlet weak var ProviderTypeLabel: UILabel!
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
            DispatchQueue.main.async {
                self.ProviderTypeLabel.text = reasonsForSection.providerType
            }
        } else {
            print(indexPath, reasons.startIndex, reasons.endIndex)
        }
    }
    
    
    
}
