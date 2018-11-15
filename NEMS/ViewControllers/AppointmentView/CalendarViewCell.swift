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
    var calendarDate: CalendarDate?
    
    override var isHighlighted: Bool {
        didSet {
            if self.isHighlighted == true {
                self.view.backgroundColor = UIColor.lightGray
            } else {
                self.view.backgroundColor = nil
            }
        }
    }
    
    
    var typeOfDisplay: CalendarDisplay = .date
    
    func setDate(date: CalendarDate) {
        self.dayNumber.text = String(date.day)
        self.calendarDate = date
        self.view.layer.borderColor = UIColor.gray.cgColor
        //self.view.backgroundColor = UIColor.lightGray
        self.view.layer.borderWidth = 0.5
    }
    
    
}

enum CalendarDisplay {
    case date
    case weekday
}
