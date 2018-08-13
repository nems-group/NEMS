//
//  JSON.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/6/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

class JSONf {
    class func downloadArray(_ data: Data) -> [[String: Any]]? {
        do {
            print()
            let jsonAny = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
            //print(jsonAny)
            guard let json = (jsonAny as AnyObject) as? [[String: Any]] else {
                print("couldn't do string to any")
                return nil
            }
            //dump(json)
            return json
            } catch {
                print(error)
                return nil
            }
        }
    
    class func downloadObject(_ data: Data) -> [String: [String: Any]]? {
        do {
            guard let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: [String: Any]] else {
                return nil
            }
            
            return json
        } catch {
            print(error)
            return nil
        }
    }
    
    class func writeToDrive<T : Encodable>(_ data: T) -> Bool {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let json = try encoder.encode(data)
            try json.write(to: MessageHandler.pathForDocArchivedLog)
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    class func writeArrayToDrive<T: Encodable>(_ dataArray: [T]) -> Bool {
        var value: Bool = false
        for data in dataArray {
            value = writeToDrive(data)
        }
        return value
    }
    
    class func loadJSONfromDrive(url path: URL) -> (json: [[String: Any]]?,success: Bool) {
        let data = path.dataRepresentation
        let json = JSONf.downloadArray(data)
        if json != nil {
            return (json,true)
        } else {
            return (json,false)
        }
    }
}
