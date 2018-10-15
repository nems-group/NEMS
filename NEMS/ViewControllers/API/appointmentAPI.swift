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
    
    class func query(appointmentQuery: AppointmentSearchQuery) throws {
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
    var location: String
    
    init?(typeOfAppointment type: String, location: String, starting: Date, ending: Date, available: [Day], timeOfDay: TimeOfDay) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
    
        let start = formatter.string(from: starting)
        let end = formatter.string(from: ending)
        self.dateRange = DateRange(start: start, end: end)
        self.location = location
        
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
        let pID = ""
//        guard let pID = ModelStore.shared.patient?.id else {
//            return nil
//        }
        self.appointmentType = type
        self.personID = pID
    }
    
    func search() -> Bool {
        
        print("search")
        let searchQuery = AppointmentSearchQuery(event_id: self.appointmentType, location_id: self.location, startDate: self.dateRange.start, start_time: self.timeRange.start, end_time: self.timeRange.end, pi_sun: self.daysAvailable.sun, pi_mon: self.daysAvailable.mon, pi_tue: self.daysAvailable.tue, pi_wed: self.daysAvailable.wed, pi_thu: self.daysAvailable.thr, pi_fri: self.daysAvailable.fri, pi_sat: self.daysAvailable.sat)
            guard let codedParameters = try? URLQueryEncoder.encode(searchQuery) else {
                print("error encoding")
                return false
            }
            print(codedParameters)
            try? customAPI(endPoint: Config.options.webConfig.appointmentRequestURI, parameters: codedParameters) { (data, response, error) in
                print(response)
            }
            return false
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


struct AppointmentSearchQuery: Codable {
    
    var event_id: String
    var location_id: String
    var startDate: String = Date.now
    var start_time: String = "0000"
    var end_time: String = "2359"
    var pi_sun: Int = 1
    var pi_mon: Int = 2
    var pi_tue: Int = 3
    var pi_wed: Int = 4
    var pi_thu: Int = 5
    var pi_fri: Int = 6
    var pi_sat: Int = 7
    
    
}
