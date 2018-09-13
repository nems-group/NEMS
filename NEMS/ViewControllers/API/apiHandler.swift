//
//  apiHandler.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 7/24/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

enum APIerror: Error {
    case statusCode(_ : HTTPURLResponse)
    case dataError
    case noResponse
    case invalidToken
    case expiredToken
    case noRefreshToken
}

var url: URL?

func patientPortalAPI(call: String, authToken token: AuthToken, completionHander: @escaping (HTTPURLResponse?, Data?) throws -> Void ) throws {
    print("This is in apiHandler - call: \(call)")
    guard let exp = token.acccesTokenExpirationTime else {
        print("This is in apiHandler - no expiration date")
        guard (ModelStore.shared.token?.refresh_token != nil) else {
            print("This is in apiHandler - no refresh token?")
            throw APIerror.noRefreshToken
        }
        guard let attempts = OAuth.session?.attemptsForRefresh else {
            return
        }
        print(attempts)
        if attempts > 3 {
            print("This is in apiHandler - not above 3 tries")
            return
        }
        try OAuth.session?.refresh {
            print(ModelStore.shared.token)
        }
        try patientPortalAPI(call: call, authToken: token, completionHander: completionHander)
        return
    }
    guard exp.minutes(from: Date()) >= 2 else {
        print(Date().minutes(from: exp))
        throw APIerror.expiredToken
    }
    
    //20180825 added this URL to get patient demo
    if call == "patient" {
        url = URL(string: "https://fhir.nextgen.com/mu3api/dstu2/v1.0/patient/me")
    } else {
        url = URL(string: "https://fhir.nextgen.com/mu3api/dstu2/v1.0/\(call)?patient=me")
    }
    
    
    guard let fullURI = url, let accessToken = token.access_token else {
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
                    print("This is in apiHandler - couldn't convert to httpURLresponse")
                    do {
                       try completionHander(nil, nil)
                    } catch {
                        
                    }
                    return
                }
                if httpResponse.statusCode == 200 {
                    // good going we got a successful message this should be json
                    if let data = data {
                        print("This is in apiHandler - we got the data: \(data)")
                        do {
                            try completionHander(httpResponse, data)
                        } catch {
                            
                        }
                    } else {
                        print("This is in apiHandler - no data")
                        do {
                            try completionHander(httpResponse, nil)
                        } catch {
                            
                        }
                    }
                } else {
                    print(httpResponse.statusCode)
                    do {
                        try completionHander(httpResponse, nil)
                    } catch {
                        
                    }
                }
            }
        task.resume()
   

}

//20180826 make pt portal api call
func apiSend(endPoint: String) {
    guard let authToken = ModelStore.shared.token else {
        guard (ModelStore.shared.token?.refresh_token) != nil else {
            Keyring.retrieveRefreshToken { (error, success) in
                if !success || error != nil {
                    return
                }
            }
            return
        }
        return
    }
    do {
        try patientPortalAPI(call: endPoint, authToken: authToken) { (response, data) in
            if response?.statusCode == 200 {
                DispatchQueue.main.async {
                    //print("This is in OAuthWebView.apiSend - data: \(String(describing: data))" )
                    
                    if let data =  data {
                        do {
                            let patient = try JSONDecoder().decode(Patient.self, from: data)
                            ModelStore.shared.patient = patient
                            ModelStore.shared.memberName = patient.name![0].given![0]
                            print("This is in OAuthWebView.apiSend - JSONDictionary: \(ModelStore.shared.patient)")
                            
                            let dateRange = DateRange.init(start: Date(), end: Date().addingTimeInterval(TimeInterval.init(110000)))
                            guard let person = ModelStore.shared.patient?.id else {
                                print("personID IS POOP")
                                return
                            }
                            let available = Available.init(sun: "Y", mon: "N", tues: "Y", wed: "N", thur: "N", fri: "N", sat: "Y", amPM: "AM")
                            var appointment = AppointmentQuery.init(personID: person, appointmentType: "PEDI", available: available, dateRange: dateRange)
                            
                            
                            try Appointment.query(appointmentQuery: appointment)
                            
                        } catch {
                            print(error)
                        }
                    }
                }
                
            } else {
                DispatchQueue.main.async {
                    ModelStore.shared.memberName = "Guest!"
                }
                
            }
        }
    } catch {
        print(error)
    }
}

