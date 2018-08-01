//
//  PatientPortalModel.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/25/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class PatientPortalModel {
    static let shared = PatientPortalModel()
    static let jsonDecoder = JSONDecoder()
    static let jsonEncoder = JSONEncoder()
    
    var vitalSigns: VitalSigns?
    
}
