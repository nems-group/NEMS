//
//  appointmentAPI.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/12/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

enum AppointmentError {
    case invalidChoice
}

class Appointment {
    
    class func query(appointmentQuery: AppointmentQuery) throws {
        let data = try ModelStore.jsonEncoder.encode(appointmentQuery)
        
        try customAPI(endPoint: Config.options.webConfig.appointmentRequestURI, body: data) { (error, data) in
            // MARK: To-Do
            print(error)
            print(data)
        }
        
    }
}

struct AppointmentQuery: Codable {
    
    var personID: String
    var appointmentType: String
    var daysAvailable: DaysAvailable
    var dateRange: DateRange
    var timeRange: TimeRange
    
    init?(typeOfAppointment type: String, starting: Date, ending: Date, available: [Day], timeOfDay: TimeOfDay) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
    
        let start = formatter.string(from: starting)
        let end = formatter.string(from: ending)
        self.dateRange = DateRange(start: start, end: end)
        
        var sun: Int = 0
        var mon: Int = 0
        var tue: Int = 0
        var wed: Int = 0
        var thr: Int = 0
        var fri: Int = 0
        var sat: Int = 0
        
        for day in available {
            switch day {
                case .sun: sun = 1
                case .mon: mon = 2
                case .tues: tue = 3
                case .wed: wed = 4
                case .thur: thr = 5
                case .fri: fri = 6
                case .sat: sat = 7
            }
        }
        
        var startTime: String = "0000"
        var endTime: String = "2359"
        
        switch timeOfDay {
            case .am: do {
                startTime = "0700"
                endTime = "1200"
            }
            case .pm: do {
                startTime = "1200"
                endTime = "2100"
            }
            case .any: do {
                break
            }
        }
        
        let timeRange = TimeRange(start: startTime, end: endTime)
        self.timeRange = timeRange
        
        self.daysAvailable = DaysAvailable(sun: sun, mon: mon, tue: tue, wed: wed, thr: thr, fri: fri, sat: sat)
        guard let personID = ModelStore.shared.patient?.id else {
            return nil
        }
        self.appointmentType = type
        self.personID = personID
    }
}


struct DaysAvailable: Codable {
    var sun: Int
    var mon: Int
    var tue: Int
    var wed: Int
    var thr: Int
    var fri: Int
    var sat: Int

}

struct DateRange: Codable {
    var start: String
    var end: String
}

struct TimeRange: Codable {
    var start: String
    var end: String
}

enum YesNo  {
    case yes
    case no
}

enum Day {
    case sun
    case mon
    case tues
    case wed
    case thur
    case fri
    case sat
}

enum TimeOfDay {
    case am
    case pm
    case any
}
