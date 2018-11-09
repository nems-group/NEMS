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
    case invalidJSONEncoding
    case dataEncodingToUTF8failed
    case parameterEncodingError
}

func customAPI(endPoint: String, body: Data, completionHandler completion: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
    
    guard let url = URL(string: endPoint) else {
        throw CustomAPIError.invalidURL
    }
    
    
    let session = URLSession(configuration: .default)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpBody = body
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    urlRequest.httpMethod = "POST"
    
    dump(urlRequest.httpBody)
    
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
        // MARK: To-Do
        //dump(data)
        //dump(response)
        //
        completion(data, response, error)
    }
    task.resume()
}

func customAPI<T: Encodable>(endPoint: String, encodableParameter parameters: T, completionHandler completion: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
    print("custom api call \(endPoint)")
    let queryString = try URLQueryEncoder.encode(parameters)
    
    guard let url = URL(string: endPoint+queryString) else {
        throw CustomAPIError.invalidURL
    }
    
    
    let session = URLSession(configuration: .default)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
        completion(data, response, error)
    }
    task.resume()
    
    
}


func customAPI(endPoint: String, parameters: String, completionHandler completion: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
    guard let url = URL(string: "\(endPoint)/\(parameters)") else {
        throw CustomAPIError.invalidURL
    }
    print(url)
    let session = URLSession(configuration: .default)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
        completion(data, response, error)
    }
    task.resume()
}

func customAPI(endPoint: String, parameters: [String: String], completionHandler completion: @escaping (Data?, URLResponse?, Error?) -> Void) throws {
    guard var uri = URLComponents(string: endPoint) else {
        throw CustomAPIError.invalidURL
    }
    var param = [URLQueryItem]()
    for (k, v) in parameters {
        let item = URLQueryItem(name: k.lowercased(), value: v)
        param.append(item)
    }
    uri.queryItems = param
    guard let url = uri.url else {
        throw CustomAPIError.invalidURL
    }
    
    let session = URLSession(configuration: .default)
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = "GET"
    urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
    
    let task = session.dataTask(with: urlRequest) { (data, response, error) in
        completion(data, response, error)
    }
    task.resume()
}

enum HTTPParameter: Decodable {
    case string(String)
    case bool(Bool)
    case int(Int)
    case double(Double)
    case date(Date)
    case stringArray([String])
    case boolArray([Bool])
    case intArray([Int])
    case doubleArray([Double])
    case dateArray([Date])
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let string = try? container.decode(String.self) {
            self = .string(string)
        } else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let double = try? container.decode(Double.self) {
            self = .double(double)
        } else if let date = try? container.decode(Date.self) {
            self = .date(date)
        } else if let stringArray = try? container.decode([String].self) {
            self = .stringArray(stringArray)
        } else if let boolArray = try? container.decode([Bool].self) {
            self = .boolArray(boolArray)
        } else if let intArray = try? container.decode([Int].self) {
            self = .intArray(intArray)
        } else if let doubleArray = try? container.decode([Double].self) {
            self = .doubleArray(doubleArray)
        } else if let dateArray = try? container.decode([Date].self) {
            self = .dateArray(dateArray)
        } else {
            throw CustomAPIError.parameterEncodingError
        }
    }
}


enum URLQueryEncoder {
    static func encode<T: Encodable>(_ encodable: T) throws -> String {
        //let i = HTTPParameter.bool(true)
        
        let parametersData = try JSONEncoder().encode(encodable)
        let parameters = try JSONDecoder().decode([String: HTTPParameter].self, from: parametersData)
        var queryString = parameters.map( { key, value in
            var string = String()
            switch value {
            case .bool(let value): string = value.description
            case .string(let value):
                string = value
            case .int(let value):
                string = String(value)
            case .double(let value):
                string = String(value)
            case .date(let value):
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYYMMdd"
                print(formatter.string(from: value))
                string = formatter.string(from: value)
            case .stringArray(let value):
                string = value.description
            case .boolArray(let value):
                string = value.description
            case .intArray(let value):
                string = value.description
            case .doubleArray(let value):
                string = value.description
            case .dateArray(let value):
                var array = [String]()
                let formatter = DateFormatter()
                formatter.dateFormat = "YYYYMMdd"
                for v in value {
                    let stringDate = formatter.string(from: v)
                    array.append(stringDate)
                }
                string = array.description
            }
            return "\(key.lowercased())=\(string.lowercased())"
        })
        .joined(separator: "&")
        .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        
        print(queryString)
        return "?\(queryString ?? "")"
    }
}
