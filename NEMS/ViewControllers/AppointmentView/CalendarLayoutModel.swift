//
//  CalendarLayoutModel.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

enum CalendarLayoutError: Error {
    case numberOfWeeksNil
    case numberOfDaysNil
    case weekdayError
    case monthInvalid
}

class CalendarLayoutModel {
    
    var month: Month
    var year: Int = Date.currentYear
    var numberOfWeeks: Int
    var numberOfDays: Int
    var startsOn: Day
    
    convenience init() throws {
        guard let month = Date.thisMonth else {
            throw CalendarLayoutError.monthInvalid
        }
        try self.init(month: month, year: Date.currentYear)
    }
    
    
    
    /// Setup the Layout Model with the all the values need to configure the Calendar view.
    ///
    /// - Parameters:
    ///   - month: The month for the current selected view
    ///   - year: The year for the current selected view
    /// - Throws: Throws errors if the calendar month is invalid
    init(month: Month, year: Int) throws {
        
        let date = try Date(year: year, month: month.rawValue)
        let current = Calendar.current
        guard let weeks = current.range(of: .weekOfMonth, in: .month, for: date)?.count else {
            throw CalendarLayoutError.numberOfWeeksNil
        }
        guard let days = current.range(of: .day, in: .month, for: date)?.count else {
            throw CalendarLayoutError.numberOfDaysNil
        }
        let weekday = current.component(.weekday, from: date)
        
        guard let monthStartsOn = Day(rawValue: weekday) else {
            throw CalendarLayoutError.weekdayError
        }
        
        self.month = month
        self.numberOfWeeks = weeks
        self.numberOfDays = days
        self.startsOn = monthStartsOn
        
        
        return
        
    }
    
}
