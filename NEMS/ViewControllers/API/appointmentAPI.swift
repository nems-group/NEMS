//
//  appointmentAPI.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/12/18.
//  Copyright © 2018 User. All rights reserved.
//
import Foundation

enum AppointmentError: Error {
    case invalidChoice
    case noResourcesAvaliable
    case noPersonID
    case noJSONdatas
}
/*


struct AppointmentQuery: Codable, Paramatizable {
    
    
    var patient: Patient
    var resources: [Resource]
    var events: [Event]
    var daysAvailable: [Day] = [.sun, .mon, .tues, .wed, .thur, .fri, .sat]
    var startFrom: Date = Date()
    var timeOfDay: TimeOfDay = .any
    
    var paramatized: ParamatizedAppointmentQuery? {
        guard let patient_id = self.patient.id else  {
            return nil
        }
        var resource = [String]()
        var locations = [String]()
        for r in self.resources {
            resource.append(r.resourceId)
            guard let locationId = r.clinicLocation?.locationId else {
                continue
            }
            locations.append(locationId)
        }
        var events = [String]()
        for e in self.events {
            events.append(e.eventId)
        }
        var days = [String]()
        for d in self.daysAvailable {
            days.append(d.description)
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        let startDate = formatter.string(from: self.startFrom)
        let para = ParamatizedAppointmentQuery(patient: patient_id, resources: resource, events: events, daysAvailable: days, startFrom: startDate, locations: locations, timeOfDay: timeOfDay.rawValue)
        return para
    }
    
    
    func search() throws -> Bool {
        var success = false
        try customAPI(endPoint: Config.options.webConfig.appointmentQueryURI, encodableParameter: self.paramatized) { (data, response, error) in
            print(response)
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                print(json)
                success = true
                return
            }
            success = false
            print(error)
            return
        }
        
        return success
    }
    
    func schedule() throws {
        let data = try ModelStore.jsonEncoder.encode(self)
        
        try customAPI(endPoint: Config.options.webConfig.appointmentScheduleURI, body: data) { (data, response, error) in
            // MARK: To-Do
            print(error)
            print(data)
            return
        }
        
    }
    
    init(resource: Resource, event: Event) throws {
        guard let patient = ModelStore.shared.patient else {
            throw APIerror.patientIsNil
        }
        self.patient = patient
        self.resources = [resource]
        self.events = [event]
    }
    
    
}


struct ParamatizedAppointmentQuery: Codable {
    var patient: String
    var resources: [String]
    var events: [String]
    var daysAvailable: [String]
    var startFrom: String
    var locations: [String]
    var timeOfDay: String
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

*/
