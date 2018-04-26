//
//  Location.swift
//  NotificationTutorial
//
//  Created by User on 4/22/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

struct LocationData {
    struct Keys {
        static let Name = "name"
        static let Address = "address"
        static let Description = "description"
        static let Image = "image"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
    }
    
    var name: String
    var address: String
    var description: String?
    var image: UIImage
    var latitude: Float
    var longitude: Float
    
    init?(dictionary: [String: Any]) {
        //Mandatory values
        guard
            let name = dictionary[Keys.Name] as? String,
            let address = dictionary[Keys.Address] as? String,
            let image = dictionary[Keys.Image] as? UIImage,
            let latitude = dictionary[Keys.Latitude] as? Float,
            let longitude = dictionary[Keys.Longitude] as? Float
    
        else {
            print("mandatory values failed")
            return nil
        }
        
        //Optional Values
        let description = dictionary[Keys.Description] as? String
        
        //Pass values to the full initializer
        self.init(name: name, address: address, description: description, image: image, latitude: latitude, longitude: longitude)
    }
    
    init(name: String, address: String, description: String?, image: UIImage, latitude: Float, longitude: Float) {
        
        self.name = name
        self.address = address
        self.description = description
        self.image = image
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
