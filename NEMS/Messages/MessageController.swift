//
//  MessageRegister.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 8/12/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

class MessageController {
    
    private static var deviceUUID: String {
        return UIDevice.current.identifierForVendor?.uuidString ?? ""
    }
    
    
    /// This will send a POST to our Message Server Endpoint along with the Device ID and all the "tags" that user wishes to be informed about
    class func register(token: String, tags: Tag) {
        
        guard let url = URL(string: Config.options.webConfig.messageServerURI) else {
            print("invalid url")
            return
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        //example of what the stucture looks like
        /*
         {
            "deviceID": "02399234029349023",
            "tags": ["homecare", "healthcare", "free stuff", "Lundy"],
            "timestamp": "20120902 03:29:20T0"
         }
        */
        
        let data: [String: Any] = ["deviceID": token, "tag": tags, "timestamp": Date.now]
        do {
            let body = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            request.httpBody = body
            request.timeoutInterval = 2000
            
            debugPrint(request.debugDescription)
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: request) { (_data, _response, _error) in
                print(_data)
                if _error == nil {
                    print("successly sent")
                } else {
                    print(_error)
                }
                return
            }
            task.resume()
        } catch {
            print(error)
            return
        }
        
    }
    
    
    class func pushHandler() {
        
    }
    
    
    ///  This will fetch the messages from our message end point
    ///
    /// - Parameter completionHandler: this method is called once we retrieve the data from the server or have an error
    class func fetch(completionHandler completion: @escaping (JSON?, URLError.Code?) -> Void) {
        
        guard let url = URL(string: Config.options.webConfig.messageServerURI) else {
            completion(nil, URLError.unsupportedURL)
            return
        }
        let deviceID = URLQueryItem(name: "deviceID", value: deviceUUID)
        let date = URLQueryItem(name: "after", value: Date.now)
        var compenents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        compenents?.queryItems = []
        compenents?.queryItems?.append(deviceID)
        compenents?.queryItems?.append(date)
        guard let uri = compenents?.url else {
            completion(nil, URLError.badURL)
            return
        }
        var request = URLRequest(url: uri)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { (_data, _response, _error) in
            guard let response = _response as? HTTPURLResponse else {
                completion(nil, URLError.cannotParseResponse)
                return
            }
            guard response.statusCode == 200 else {
                completion(nil, URLError.badServerResponse)
                return
            }
            
            guard let data = _data else {
                completion(nil, URLError.cannotDecodeContentData)
                return
            }
            
            guard let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
                completion(nil, URLError.cannotDecodeContentData)
                return
            }
            
            completion(json, nil)
            
        }
        task.resume()
        
    }
}
