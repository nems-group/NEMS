//
//  Reasons.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 11/8/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

struct Reasons: Codable {
    var providerType: String
    var resources: [Resource]
    
    private enum CodingKeys: String, CodingKey {
        case providerType = "provider_type"
        case resources = "resources"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.providerType = try container.decode(String.self, forKey: .providerType)
        self.resources = try container.decode([Resource].self, forKey: .resources)
        return
    }
    
}
