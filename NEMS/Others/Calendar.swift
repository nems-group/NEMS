//
//  Calendar.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 8/1/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

enum DateError: Error {
    case invalidString
    case invalidMonthNumber
}

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
    
    static var currentYear: Int {
        get {
            let date = Date()
            let yearComponent = Calendar.Component.year
            let year = Calendar.current.component(yearComponent, from: date)
            return year
        }
    }
    
    static var currentMonth: Int {
        get {
            let date = Date()
            let monthComponent = Calendar.Component.month
            let month = Calendar.current.component(monthComponent, from: date)
            return month
        }
    }
    
    static var thisMonth: Month? {
        get {
            return Month(rawValue: currentMonth)
        }
    }
    
    init(year: Int, month: Int) throws {
        var monthS: String
        if month < 10 {
            monthS = "0"+String(month)
        } else if month > 12 || month <= 0 {
            throw DateError.invalidMonthNumber
        } else {
            monthS = String(month)
        }
        let yearS: String = String(year)
        let yyyyMM = yearS+monthS
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMM"
        
        guard let newDate = formatter.date(from: yyyyMM) else {
            throw DateError.invalidString
        }
        self = newDate
    }
    
    
}

enum Month: Int, CustomStringConvertible {
    case january = 1
    case febuary
    case march
    case april
    case may
    case june
    case july
    case august
    case september
    case october
    case november
    case december
    
    var description: String {
        switch self {
            case .january: return "January"
            case .febuary: return "Febuary"
            case .march: return "March"
            case .april: return "April"
            case .may: return "May"
            case .june: return "June"
            case .july: return "July"
            case .august: return "August"
            case .september: return "September"
            case .october: return "October"
            case .november: return "November"
            case .december: return "December"
        }
    }
}

enum Day: Int {
    case sun = 1
    case mon = 2
    case tues = 3
    case wed = 4
    case thur = 5
    case fri = 6
    case sat = 7
    
    var description: String {
        switch self {
            case .sun: return "Sunday"
            case .mon: return "Monday"
            case .tues: return "Tuesday"
            case .wed: return "Wednesday"
            case .thur: return "Thursday"
            case .fri: return "Friday"
            case .sat: return "Saturday"
        }
    }
    
    var shortDescription: String {
        switch self {
        case .sun: return "Sun"
        case .mon: return "Mon"
        case .tues: return "Tues"
        case .wed: return "Wed"
        case .thur: return "Thur"
        case .fri: return "Fri"
        case .sat: return "Sat"
        }
    }
    
    var weekend: Bool {
        switch self {
            case .sun, .sat: return true
            default: return false
        }
    }
}

enum TimeOfDay {
    case am
    case pm
    case any
}
