//
//  CustomAPI.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/12/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

enum CustomAPIError: Error {
    case invalidURL
}

func customAPI(endPoint: String, body: Data, completionHandler completion: @escaping (Error?, Data?) -> Void) throws {
    
    guard let url = URL(string: endPoint) else {
        throw CustomAPIError.invalidURL
    }
    
    let session = URLSession(configuration: .default)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpBody = body
    urlRequest.httpMethod = "POST"
    
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
        // MARK: To-Do
        //dump(data)
        //dump(response)
        dump(response)
        completion(error, data)
    }
    task.resume()
}
