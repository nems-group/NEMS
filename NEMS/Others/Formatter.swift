//
//  Formatter.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 8/12/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

extension Formatter {
    static let iso8601: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()
}
