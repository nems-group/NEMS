//
//  TestSelection.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 10/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

final class TestSelection: Codable {
    
    static let path = Bundle.main.path(forResource: "testSelections", ofType: "json")
    static var data: Data? = TestSelection.getData()
    
    static var options: TestSelection {
        do {
            return try TestSelection()
        } catch {
            print("error: \(error)")
            return TestSelection(resources: nil, clinicLocations: nil, events: nil)
        }
    }
    
    convenience init() throws {
        guard let data = TestSelection.data else {
            throw APIerror.dataError
        }
        let options = try ModelStore.jsonDecoder.decode(TestSelection.self, from: data)
        self.init(resources: options.selectionTest.resources, clinicLocations: options.selectionTest.clinicLocations, events: options.selectionTest.events)
    }
    
    init(resources: [Resource]?, clinicLocations: [ClinicLocation]?, events: [Event]?) {
        let selection = Selection(resources: resources, clinicLocations: clinicLocations, events: events)
        self.selectionTest = selection
    }
    
    class func getData() -> Data? {
        guard let path = TestSelection.path else {
            print("path is nil")
            return nil
        }
        let url = URL(fileURLWithPath: path)
        do {
            let data = try Data(contentsOf: url)
            print(data)
            return data
        } catch {
            print(error)
            return nil
        }
    }
    
    var selectionTest: Selection
    
}


struct Selection: Codable {
    var resources: [Resource]?
    var clinicLocations: [ClinicLocation]?
    var events: [Event]?
}

