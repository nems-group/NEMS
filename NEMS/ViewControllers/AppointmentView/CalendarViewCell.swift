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
    @IBOutlet weak var weekday: UILabel!
    
    var typeOfDisplay: CalendarDisplay = .date
    
    func setUp(cellDisplay: CalendarCellDisplay) {
        
        if let _ = cellDisplay.day  {
            self.dayNumber.text = cellDisplay.display
        }
        if let _ =  cellDisplay.weekday {
            self.typeOfDisplay = .weekday
            self.weekday.text = cellDisplay.display
        }
        
        switch typeOfDisplay {
        case .date:
            self.weekday.isHidden = true
            self.dayNumber.isHidden = false
        case .weekday:
            self.weekday.isHidden = false
            self.dayNumber.isHidden = true
        }
        
        return
    }
    
    
}

enum CalendarDisplay {
    case date
    case weekday
}
