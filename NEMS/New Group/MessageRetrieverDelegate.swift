//
//  MessageRetrieverDelegate.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 6/5/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol MessageRetrieverDelegate: class {
    var messages: [Message]? { get set }
    
    func retrieveCachedMessages() -> Void
}
