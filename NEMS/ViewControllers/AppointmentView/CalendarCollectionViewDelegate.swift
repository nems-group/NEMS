//
//  CalendarCollectionViewDelegate.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

protocol CalendarCollectionViewDelegate {
    func currentCalendarChanged(newModel: CalendarModel)
    func newLayout(from dataSource: CalendarModel)
    var layout: CalendarLayout? { get set }
}
