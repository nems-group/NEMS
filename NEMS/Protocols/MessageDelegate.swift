//
//  MessageProtocol.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 4/29/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol MessageDelegate {
    var messages: [Message]? { get set }
    
    
}
