//
//  Paramatizable.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 10/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation



/// Any Object that conforms to this protocol 
protocol Paramatizable: Codable {
    
    associatedtype Paramatizable = Self
    var paramatized: Paramatizable { get }
    
}
