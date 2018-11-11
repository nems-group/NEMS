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
    var resource: Resource
    
    private enum CodingKeys: String, CodingKey {
        case providerType = "provider_type"
        case resource = "resource"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.providerType = try container.decode(String.self, forKey: .providerType)
        let resources = try container.decode([Resource].self, forKey: .resource)
        guard let first = resources.first else {
            throw APIerror.dataError
        }
        self.resource = first
        return
    }
    
}
