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
    
    var day: Int = 1
    var month: Int = 1
    
    func setUp(date cal: CalendarDate?) {
        guard let date = cal else {
            return
        }
        self.day = date.day
        self.month = date.month.rawValue
        dayNumber.text = String(self.day)
        self.weekday.isHidden = true
        return
    }
    
    func setUp(weekdayInt: Int) {
        self.weekday.text = Day(rawValue: weekdayInt)?.description
        self.dayNumber.isHidden = true
    }
    
    
}
