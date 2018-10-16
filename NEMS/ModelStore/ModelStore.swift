//
//  Model.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class ModelStore {
    static let shared = ModelStore()
    static let jsonDecoder = JSONDecoder()
    static let jsonEncoder = JSONEncoder()
    static var deviceID: String? {
        return AppDelegate.deviceToken
    }
    //**** Location values
    var allLocations: [Location] = [Location]()
    
    //**** Messsage stack
    var messageStacks: [MessageStack] = [MessageStack]()
    
    var selectedLocation: Location!
    var token: AuthToken?
    var memberName: String = "Guest!"
    var patient: Patient?
    var apptSelection: Selection?
}

struct Selection {
    var resources: [Resource]?
    var clinicLocation: [ClinicLocation]?
    var events: [Event]?
}
