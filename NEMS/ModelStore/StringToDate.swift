//
//  StringToDate.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/9/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

extension String {
    func toDate(format: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
