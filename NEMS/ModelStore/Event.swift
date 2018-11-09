//
//  Event.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 10/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct Event: Codable {
    var eventName: String
    var eventId: String
    var displayName: String
    var duration: Int
    
    private enum CodingKeys: String, CodingKey {
        case eventName = "event_name"
        case eventId = "event_id"
        case displayName = "event_display_name"
        case duration = "duration"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.eventId = try container.decode(String.self, forKey: .eventId)
        self.displayName = try container.decode(String.self, forKey: .displayName)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.eventName = try container.decode(String.self, forKey: .eventName)
    }
}

