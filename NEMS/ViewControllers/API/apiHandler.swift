//
//  apiHandler.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

func patientPortalAPI(call: String, authToken token: AuthToken, completionHander: @escaping (HTTPURLResponse?, Data?) -> Void ) {
    guard let fullURI = URL(string: "https://fhir.nextgen.com/mu3api/dstu2/v1.0/\(call)?patient=me"), let accessToken = token.accessToken else {
        return
    }
    let authHeader: String = "Bearer \(accessToken)"
    let session = URLSession(configuration: .default)
    var urlRequest = URLRequest(url: fullURI)
    urlRequest.addValue(authHeader, forHTTPHeaderField: "Authorization")
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.httpMethod = "GET"
    
    
    dump(urlRequest)
    
        let task = session.dataTask(with: urlRequest) { (data, response, error) in
            
                guard let httpResponse = response as? HTTPURLResponse else {
                    print("couldn't convert to httpURLresponse")
                    completionHander(nil, nil)
                    return
                }
                if httpResponse.statusCode == 200 {
                    // good going we got a successful message this should be json
                    if let data = data {
                        print("we got the data: \(data)")
                        completionHander(httpResponse, data)
                    } else {
                        print("no data")
                        completionHander(httpResponse, nil)
                    }
                } else {
                    print(httpResponse.statusCode)
                    completionHander(httpResponse, nil)
                }
            }
        task.resume()
   

}
