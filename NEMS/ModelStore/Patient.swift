//
//  Patient.swift
//  NEMS
//
//  Created by User on 9/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
struct Patient: Codable {
    let name: [PtName]?
    let id: String?
    let gender: String?
    
    init() {
        self.name = [PtName(given: ["Test"], family: ["Family Name"])]
        self.id = UUID().uuidString
        self.gender = nil
    }
    
    func getResources() throws -> [Resource] {
        
        guard let person_id = self.id else {
            throw AppointmentError.noPersonID
        }
        try customAPI(endPoint: Config.options.webConfig.appointmentResourcesURI, parameters: ["Person_id": person_id]) { (data, response, error) in
            if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode == 200 {
                guard let data = data else {
                    return
                }
                let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
                
            }
            
        }
        throw AppointmentError.noResourcesAvaliable
        
    }
    
}

struct PtName: Codable {
    let given: [String]?
    let family: [String]?
}

struct PtCommunication: Codable {
    let language: PtLanguage?
}

struct PtLanguage: Codable {
    let text: String?
}
/*
 {
 "gender": "male",
 "address": [{
 "line": ["1520 Stockton Street"],
 "state": "CA",
 "city": "San Francisco",
 "postalCode": "94133"
 }],
 "id": "23d8bd42-b748-411b-9bcf-685028f634df",
 "telecom": [{
 "system": "phone",
 "value": "4152222222",
 "use": "home"
 },
 {
 "system": "email",
 "value": "larry.chew@nems.org",
 "use": "home"
 },
 {
 "system": "phone",
 "value": "4157939144",
 "use": "mobile"
 }],
 "birthDate": "1995-12-01",
 "deceasedBoolean": false,
 "identifier": [{
 "system": "Patient",
 "value": "HQM Only1, Test"
 }],
 "communication": [{
 "language": {
 "text": "Cantonese",
 "coding": [{
 "system": "urn:istf:bcp:46",
 "display": "Cantonese",
 "code": "bb0f45b3-168c-4f1b-8962-8b8d5a35a57f"
 }]
 }
 }],
 "extension": [{
 "url": "http:\/\/fhir.org\/guides\/argonaut\/StructureDefinition\/orgo-race",
 "valueCodeableConcept": {
 "text": "American Indian\/Alaskan Native",
 "coding": [{
 "system": "http:\/\/fhir.org\/guides\/argonaut\/v3\/Race",
 "display": "American Indian\/Alaskan Native",
 "code": "2131-1"
 }]
 }
 },
 {
 "url": "http:\/\/fhir.org\/guides\/argonaut\/StructureDefinition\/argo-birthsex",
 "valueCodeableConcept": {
 "text": "Male",
 "coding": [{
 "system": "http:\/\/hl7.org\/fhir\/v3\/AdministrativeGender",
 "display": "Male",
 "code": "M"
 }]
 }
 }],
 "resourceType": "Patient",
 "name": [{
 "given": ["HQM Only1"],
 "family": ["Test"]
 }]
 }
*/
