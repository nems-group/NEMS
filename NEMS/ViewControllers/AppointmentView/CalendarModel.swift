//
//  CalendarModel.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit



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
    
    var asDate: Date? {
        get {
            guard let date = try? Date(year: self.year, month: self.month, day: self.day) else {
                return nil
            }
            return date
        }
    }

}


class Cal {
    var dates: [CalendarDate]
    
    init() {
        self.dates = []
        setup()
    }
    
    func setup() {
        
        var calendarIndex: [CalendarDate] = []
        
        var priorNumberOfDays = 0
        //var postNumberOfDays = 0
        let totalSquares = 42 // five weeks
        
        // now lets populate our cells with dates starting with the Sunday of the week of todays date
        
        let today = Date()
        guard let todayMonth = today.currentMonth else {
            return
        }
        let todayCalendarDate = CalendarDate(month: todayMonth, day: today.day, year: today.year)
        
        guard let todayWeekday = todayCalendarDate.weekday else {
            print("some weekday is nil")
            return
        }
        
        switch todayWeekday {
        case .sun:
            priorNumberOfDays = 0
        case .mon:
            priorNumberOfDays = 1
        case .tues:
            priorNumberOfDays = 2
        case .wed:
            priorNumberOfDays = 3
        case .thur:
            priorNumberOfDays = 4
        case .fri:
            priorNumberOfDays = 5
        case .sat:
            priorNumberOfDays = 6
        }
        calendarIndex.append(todayCalendarDate)
        
        if priorNumberOfDays > 0 {
            
            for i in 1...priorNumberOfDays {
                guard let dateBefore = today.dateAdd(-i, unit: .day) else {
                    print("couldn't get the date before")
                    return
                }
                guard let dateBeforeMonth = dateBefore.currentMonth else {
                    print("newDate not made into calObject")
                    return
                }
                let newDate = CalendarDate(month: dateBeforeMonth, day: dateBefore.day, year: dateBefore.year)
                calendarIndex.insert(newDate, at: 0)
                
            }
            
        }
        
        // now in the array we should have today + the dates update to sunday so if today was friday we would have 6 days in the array.
        
        let daysLeftToAdd = totalSquares - calendarIndex.count
        
        for i in 1...daysLeftToAdd {
            guard let dateBefore = today.dateAdd(i, unit: .day) else {
                print("couldn't get the date before")
                return
            }
            guard let dateBeforeMonth = dateBefore.currentMonth else {
                print("newDate not made into calObject")
                return
            }
            let newDate = CalendarDate(month: dateBeforeMonth, day: dateBefore.day, year: dateBefore.year)
            calendarIndex.append(newDate)
        }
        
        
        self.dates = calendarIndex
        //print(self.dates.count)
        
    }
    
    func addWeek() {
       
        for i in 1...7 {
            let lastValue = self.dates.endIndex-1
            let calDate = self.dates[lastValue]
            guard let date = calDate.asDate, let newDate = date.dateAdd(1, unit: .day), let newMonth = newDate.currentMonth else {
                continue
            }
            let newCalendar = CalendarDate(month: newMonth, day: newDate.day, year: date.year)
            //print(newCalendar)
            self.dates.append(newCalendar)
        }
    }
    
    func addDay() throws {
            let lastValue = self.dates.endIndex-1
            let calDate = self.dates[lastValue]
            guard let date = calDate.asDate, let newDate = date.dateAdd(1, unit: .day), let newMonth = newDate.currentMonth else {
                throw CalendarError.date
            }
            let newCalendar = CalendarDate(month: newMonth, day: newDate.day, year: date.year)
            //print(newCalendar)
            self.dates.append(newCalendar)
    }
}

enum CalendarError: Error {
    case date
}
