//
//  CalendarCollectionViewDelegate.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

protocol CalendarCollectionViewDelegate {
    func currentCalendarChanged(newModel: CalendarModel, completionHandler: () -> Void)
    func newLayout(from dataSource: CalendarModel, sender: UICollectionViewDelegate)
    var layout: CalendarLayout? { get set }
    func reloadView()
}

