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
    var allLocations: [Location] = [Location]()
    
    var selectedLocation:Location!
    
//    let json = """
//        {
//            "name": "Durian",
//            "points": 600,
//            "description": "A fruit with a distinctive scent."
//        }
//        """.data(using: .utf8)!
//
//        let decoder = JSONDecoder()
//        //let product = try decoder.decode(GroceryProduct.self, from: json)

}
