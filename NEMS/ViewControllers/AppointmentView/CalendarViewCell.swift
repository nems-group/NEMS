//
//  CalendarViewCell.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class CalendarViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dayNumber: UILabel!
    @IBOutlet weak var view: UIView!
    
    var typeOfDisplay: CalendarDisplay = .date
    
    func setDate(date: CalendarDate) {
        self.dayNumber.text = String(date.day)
        //self.contentView.layer.shadowRadius = 3
       // self.contentView.layer.shadowOpacity = 0.5
    }
    
    
}

enum CalendarDisplay {
    case date
    case weekday
}
