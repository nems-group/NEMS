//
//  PatientPortalModelDecodingError.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/25/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

enum PatientPortalModelDecodingError: Error {
    case noAuthToken
    case authTokenExpired
    case urlErrorResponse(urlResponse: HTTPURLResponse)
    case dataNil
    case modelNotDecoded
}
