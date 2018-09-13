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
    var available: Available
    var dateRange: DateRange
    
}


struct Available: Codable {
    var sun: String
    var mon: String
    var tues: String
    var wed: String
    var thur: String
    var fri: String
    var sat: String
    var amPM: String
}

struct DateRange: Codable {
    var start: Date
    var end: Date
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
