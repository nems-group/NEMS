//
//  Patient.swift
//  NEMS
//
//  Created by User on 9/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
struct Patient: Decodable {
    let name: [Name]?
}

struct Name: Decodable {
    let given: [String]?
    let family: [String]?
}
