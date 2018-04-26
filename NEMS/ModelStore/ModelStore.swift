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
    
    //**** Location values
    var allLocations: [LocationData] = [LocationData]()
    
    var selectedLocation:LocationData!
    
}
