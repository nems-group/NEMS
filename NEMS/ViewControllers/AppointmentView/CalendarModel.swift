//
//  CalendarModel.swift
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

class CalendarModel {
    
    var month: Month
    var year: Int
    var days: [CalendarDate]
    var numberOfWeeks: Int
    var numberOfDays: Int
    var startsOn: Day
    var endsOn: Day
    var previousMonth: Date? {
        get {
            guard let lastMonth = try? Date(year: self.year, month: month, day: 1).dateAdd(-1, unit: .month) else {
                return nil
            }
            //print(lastMonth)
            return lastMonth
        }
    }
    var nextMonth: Date? {
        get {
            guard let nextMonth = try? Date(year: self.year, month: month, day: 1).dateAdd(1, unit: .month) else {
                return nil
            }
            //print(nextMonth)
            return nextMonth
        }
    }
    
    
    //var today: Int
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
        
        let lastDate = try Date(year: year, month: month, day: days)
        let lastDay = current.component(.weekday, from: lastDate)
        guard let monthEndsOn = Day(rawValue: lastDay) else {
            throw CalendarLayoutError.weekdayError
        }
        var daysArray = [CalendarDate]()
        for day in 1...days {
            let calDate = CalendarDate(month: month, day: day, year: year)
            daysArray.append(calDate)
        }
        self.month = month
        self.numberOfWeeks = weeks
        self.numberOfDays = days
        self.startsOn = monthStartsOn
        self.endsOn = monthEndsOn
        self.year = year
        self.days = daysArray
        //self.index = [:]
        
    }

    
}

struct CalendarDate {
    var month: Month
    var day: Int
    var year: Int
    
    var weekday: Day? {
        get {
            guard let date = try? Date(year: self.year, month: self.month, day: self.day) else {
                return nil
            }
            let weekdayValue = Calendar.current.component(.weekday, from: date)
            let day = Day(rawValue: weekdayValue)
            return day
            
        }
    }
    
    
}

struct CalendarCellDisplay {
    var month: Month?
    var day: Int?
    var year: Int?
    var weekday: Day?
    var display: String {
        get {
            if let day = self.day {
                return String(day)
            }
            if let weekday = self.weekday?.description {
                return weekday
            }
            return ""
        }
    }
}

extension Date {
    var calObject: CalendarModel? {
        get {
            guard let month = self.currentMonth else {
                return nil
            }
            guard let object = try? CalendarModel(month: month, year: self.year) else {
                
                return nil
            }
            return object
        }
    }
}

