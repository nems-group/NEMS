//
//  Appointment.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 11/12/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct Appointment: Codable {
    
    var apptDateTime: Date //2018-12-26T16:45:00Z
    var duration: Int //15
    var resourceId: String //09F80653-28A0-409B-8FB5-B249293257F9
    var locationId: String //ED9100BD-AE45-4154-AAEC-D076B14D179B
    var locationName: String //2308 Taraval Street
    var providerId: String //6AF22F68-7AE8-456E-95BB-404C2839836C
    var providerName: String //Jackie Wai-Hang Lam MD
    var eventId: String //79C7E354-8743-47ED-B8CA-66C4308C55FF
    var eventDisplayName: String //Follow-Up
    var address: [Address]
    
    private enum CodingKeys: String, CodingKey {
        case apptDateTime = "appt_datetime"
        case duration = "duration"
        case resourceId = "resource_id"
        case locationId = "location_id"
        case locationName = "location_name"
        case providerId = "provider_id"
        case providerName = "provider_name"
        case eventId = "event_id"
        case eventDisplayName = "event_display_name"
        case address = "address"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let apptDateTime = try container.decode(String.self, forKey: .apptDateTime)
        guard let date = apptDateTime.toDate(format: "yyyy-MM-dd'T'HH:mm:ss'Z") else {
            throw APIerror.dataError
        }
        self.apptDateTime = date
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.resourceId = try container.decode(String.self, forKey: .resourceId)
        self.locationId = try container.decode(String.self, forKey: .locationId)
        self.locationName = try container.decode(String.self, forKey: .locationName)
        self.providerId = try container.decode(String.self, forKey: .providerId)
        self.providerName = try container.decode(String.self, forKey: .providerId)
        self.eventId = try container.decode(String.self, forKey: .eventId)
        self.eventDisplayName = try container.decode(String.self, forKey: .eventDisplayName)
        self.address = try container.decode([Address].self, forKey: .address)
    }
}

struct Address: Codable {
    
    var line1: String //2308 Taraval Street
    var line2: String? //null
    var city: String //San Francisco
    var state: String //CA
    var zip: Int //941162252
    
    private enum CodingKeys: String, CodingKey {
        case line1 = "address_line_1"
        case line2 = "address_line_2"
        case city = "city"
        case state = "state"
        case zip = "zip"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.line1 = try container.decode(String.self, forKey: .line1)
        self.line2 = try container.decodeIfPresent(String.self, forKey: .line2)
        self.city = try container.decode(String.self, forKey: .city)
        self.state = try container.decode(String.self, forKey: .state)
        self.zip = try container.decode(Int.self, forKey: .zip)
    }
}
