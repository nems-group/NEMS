//
//  Resource.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 10/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct Resource: Codable {
    
    
    var providerName: String
    var providerId: String
    var locationIds: String
    var resourceIds: String
    var events: [Event]
    
    private enum CodingKeys: String, CodingKey {
        case providerName = "provider_name"
        case providerId = "provider_id"
        case resourceIds = "resource_ids"
        case locationIds = "location_ids"
        case events = "events"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.providerName = try container.decode(String.self, forKey: .providerName)
        self.providerId = try container.decode(String.self, forKey: .providerId)
        self.locationIds = try container.decode(String.self, forKey: .locationIds)
        self.resourceIds = try container.decode(String.self, forKey: .resourceIds)
        self.events = try container.decode([Event].self, forKey: .events)
    }
    
   
}
