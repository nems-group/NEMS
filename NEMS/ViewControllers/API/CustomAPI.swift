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

func customAPI(endPoint: String, body: Data, completionHandler completion: @escaping (Error?, Data?) -> Void) throws {
    
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
        dump(response)
        completion(error, data)
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
        let item = URLQueryItem(name: k, value: v)
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
        } else {
            throw CustomAPIError.parameterEncodingError
        }
    }
}


enum URLQueryEncoder {
    static func encode<T: Encodable>(_ encodable: T) throws -> String {
        //let i = HTTPParameter.bool(true)
        //print(i)
        let parametersData = try JSONEncoder().encode(encodable)
        print(try? JSONSerialization.jsonObject(with: parametersData, options: .allowFragments))
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
            }
            return "\(key)='\(string)'"
        })
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        return queryString ?? ""
    }
}
