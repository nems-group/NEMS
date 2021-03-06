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
    case patientIsNil
}

var patientCallTimes: Int = 0

func patientPortalAPI(endpoint: PatientPortalEndpoint, authToken token: AuthToken, completionHander: @escaping (HTTPURLResponse?, Data?) throws -> Void ) throws {
    var url: URL?
    patientCallTimes = patientCallTimes + 1
    let call = endpoint.rawValue
    print("This is in apiHandler - call: \(call) #\(patientCallTimes)")
    guard let exp = token.acccesTokenExpirationTime else {
        print("This is in apiHandler - no expiration date")
        guard (ModelStore.shared.token?.refresh_token != nil) else {
            print("This is in apiHandler - no refresh token?")
            throw APIerror.noRefreshToken
        }
        guard let attempts = OAuth.session?.attemptsForRefresh else {
            return
        }
        if attempts > 3 {
            print("This is in apiHandler - not above 3 tries")
            return
        }
        print("refresh??")
        OAuth.session?.refresh { error, authToken in
            guard let token = authToken else {
                print(error)
                print("some the auth token is nil")
                return
            }
            ModelStore.shared.token = token
            try! patientPortalAPI(endpoint: endpoint, authToken: token, completionHander: completionHander)
        }
        return
    }
    guard exp.minutes(from: Date()) >= 2 else {
        print("expired: \(Date().minutes(from: exp))")
        throw APIerror.expiredToken
    }
    
    //20180825 added this URL to get patient demo
    if call == "patient" {
        url = URL(string: "https://fhir.nextgen.com/mu3api/dstu2/v1.0/patient/me")
    } else {
        url = URL(string: "https://fhir.nextgen.com/mu3api/dstu2/v1.0/\(call)?patient=me")
    }
    
    print(url)
    
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
//func apiSend(endPoint: String) {
//    guard let authToken = ModelStore.shared.token else {
//        guard (ModelStore.shared.token?.refresh_token) != nil else {
//            Keyring.retrieveRefreshToken { (error, success) in
//                if !success || error != nil {
//                    return
//                }
//            }
//            return
//        }
//        return
//    }
//    do {
//        try patientPortalAPI(call: endPoint, authToken: authToken) { (response, data) in
//            if response?.statusCode == 200 {
//                DispatchQueue.main.async {
//                    //print("This is in OAuthWebView.apiSend - data: \(String(describing: data))" )
//
//                    if let data =  data {
//                        do {
//                            let patient = try JSONDecoder().decode(Patient.self, from: data)
//                            ModelStore.shared.patient = patient
//                            ModelStore.shared.memberName = patient.name![0].given![0]
//                            print("This is in OAuthWebView.apiSend - JSONDictionary: \(ModelStore.shared.patient)")
//
//                            let daysAvailable: [Day] = [.sun, .tues, .fri]
//                            let timeAvailable: TimeOfDay = .am
//
//
//                            let starting = Date()
//                            let numberOfDays: Int = 2
//                            let daySeconds = (60*60*24)*numberOfDays
//                            let interval = TimeInterval(daySeconds)
//                            let ending = starting.addingTimeInterval(interval)
//
//                            guard let appointmentSearch = AppointmentQuery(type ) else {
//                                print("appointmentQuery object failed to init")
//                                return
//                            }
//
//
//
//                            try Appointment.query(appointmentQuery: appointmentSearch)
//
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
//
//            } else {
//                DispatchQueue.main.async {
//                    ModelStore.shared.memberName = "Guest!"
//                }
//
//            }
//        }
//    } catch {
//        print(error)
//    }
//}

