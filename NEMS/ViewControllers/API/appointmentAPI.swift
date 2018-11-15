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



struct AppointmentQuery: Codable, Paramatizable {
    
    
    var patient: Patient
    var resource: Resource
    var event: Event
    var providerId: String
    var duration: Int
    var providerName: String
    var daysAvailable: [Day] = [.sun, .mon, .tues, .wed, .thur, .fri, .sat]
    var startFrom: Date = Date()
    var timeOfDay: TimeOfDay = .any
    
    
//    ?providerId=6AF22F68-7AE8-456E-95BB-404C2839836C
//    &providerName=Jackie%20Wai-Hang%20Lam%20MD
//    &resourceId=09F80653-28A0-409B-8FB5-B249293257F9,E611AE76-7BF8-41AF-BC59-E4E708549BAA
//    &locationId=ED9100BD-AE45-4154-AAEC-D076B14D179B,8756D516-2C66-478B-9B61-27C62B8ADF4D
//    &eventId=79C7E354-8743-47ED-B8CA-66C4308C55FF
//    &eventDisplayName=Follow-Up
//    &duration=15
//    &startDate=20181110
//    &dayOfWeek=1234567
//    &time=Any
    var paramatized: ParamatizedAppointmentQuery? {
        guard let patient_id = self.patient.id else  {
            return nil
        }
        let locationIds = self.resource.locationIds
        let resourceIds = self.resource.resourceIds
        let providerId = self.providerId
        let providerName = self.providerName
        let duration = self.duration
        let eventId = self.event.eventId
        var days: String = ""
        for d in self.daysAvailable {
            days.append(String(d.rawValue))
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYYMMdd"
        let startDate = formatter.string(from: self.startFrom)
        let para = ParamatizedAppointmentQuery(patient: patient_id, resourceIds: resourceIds, eventId: eventId, daysAvailable: days, startFrom: startDate, locationIds: locationIds, timeOfDay: timeOfDay.rawValue, providerId: providerId, providerName: providerName, duration: duration)
        return para
    }
    
    
    func search(completionHandler completion: @escaping (Error?, [Appointment]?) -> Void) throws {
        try customAPI(endPoint: Config.options.webConfig.appointmentQueryURI, encodableParameter: self.paramatized) { (data, response, error) in
            if let data = data, let response = (response as? HTTPURLResponse)?.statusCode {
                if response == 200 {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                        let appointment = try ModelStore.jsonDecoder.decode([Appointment].self, from: data)
                        completion(nil, appointment)
                    } catch {
                        print(error)
                        completion(error, nil)
                    }
                    return
                }
            }
            completion(error, nil)
            print(error)
            return
        }
        
        return
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
    
    init(resource: Resource, event: Event, providerName: String, providerId: String, duration: Int) throws {
        guard let patient = ModelStore.shared.patient else {
            throw APIerror.patientIsNil
        }
        self.patient = patient
        self.resource = resource
        self.event = event
        self.providerId = providerId
        self.providerName = providerName
        self.duration = duration
    }
    
    
}


struct ParamatizedAppointmentQuery: Codable {
    var patient: String
    var resourceIds: String
    var eventId: String
    var daysAvailable: String
    var startFrom: String
    var locationIds: String
    var timeOfDay: String
    var providerId: String
    var providerName: String
    var duration: Int
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

