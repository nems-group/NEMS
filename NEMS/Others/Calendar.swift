//
//  Calendar.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 8/1/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

extension Date {
    func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    /// This date format in ISO8601 string
    static var now: String {
        get {
            let date = Date()
            let formatter = Formatter.iso8601
            return formatter.string(from: date)
        }
    }
}
