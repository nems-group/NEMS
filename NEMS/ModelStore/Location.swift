//
//  Location.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

struct Location {
    struct Keys {
        static let Name = "name"
        static let Address = "address"
        
        static let City = "city"
        static let State = "state"
        static let Zip = "zip"
        static let Phone = "phone"
        static let ClinicHours = "clinicHours"
        static let PharmacyHours = "pharmacyHours"
        
        static let Description = "description"
        
        static let Transportation = "transportation"
        
        static let Image = "image"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    var name: String?
    var address: String?
    
    var city: String?
    var state: String?
    var zip: String?
    var phone: String?
    var clinicHours: String? //[String:Any]?
    var pharmacyHours: String? //[String:Any]?
    var description: String?
    var transportation: String?
    
    var image: String?
    var latitude: String?
    var longitude: String?
    
    init?(dictionary: [String: Any]) {
        //Mandatory values
//        guard
//            let name = dictionary[Keys.Name] as? String,
//            let address = dictionary[Keys.Address] as? String,
//            let image = dictionary[Keys.Image] as? String,
//            let latitude = dictionary[Keys.Latitude] as? Double,
//            let longitude = dictionary[Keys.Longitude] as? Double
//
//        else {
//            print("mandatory values failed")
//            return nil
//        }
        
        //Optional Values
        let name = dictionary[Keys.Name] as? String
        let address = dictionary[Keys.Address] as? String
        let image = dictionary[Keys.Image] as? String
        let latitude = dictionary[Keys.Latitude] as? String
        let longitude = dictionary[Keys.Longitude] as? String
        
        let description = dictionary[Keys.Description] as? String
        let city = dictionary[Keys.City] as? String
        let state = dictionary[Keys.State] as? String
        let zip = dictionary[Keys.Zip] as? String
        let phone = dictionary[Keys.Phone] as? String
        let clinicHours = dictionary[Keys.ClinicHours] as? String //[String:Any]
        let pharmacyHours = dictionary[Keys.PharmacyHours] as? String //[String:Any]
        let transportation = dictionary[Keys.Transportation] as? String
        

        //Pass values to the full initializer
        self.init(name: name, address: address, city: city, state: state, zip: zip, phone: phone, clinicHours: clinicHours, pharmacyHours: pharmacyHours, description: description, transportation: transportation, image: image, latitude: latitude, longitude: longitude)
    }
    
    init(name: String?, address: String?, city: String?, state: String?, zip: String?, phone: String?, clinicHours:String?, pharmacyHours:String?, description: String?, transportation: String?, image: String?, latitude: String?, longitude: String?) {
        
        
        
        self.name = name
        self.address = address
        
        self.city = city
        self.state = state
        self.zip = zip
        self.phone = phone
        self.clinicHours = clinicHours
        self.pharmacyHours = pharmacyHours
        self.description = description
        self.transportation = transportation
        
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
