//
//  CalendarLayout.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

private let reuseIdentifier = "CalendarViewCell"

enum CalendarDisplayStyle {
    case withNeighborDates
    case noNeighborDates
}

@objc class CalendarLayout: NSObject, UICollectionViewDataSource {

    var style: CalendarDisplayStyle = .withNeighborDates
    var dataSource: CalendarModel
    var cellDisplays: [CalendarCellDisplay]
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("number of sections")
        return self.cellDisplays.count
    }

    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let calCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CalendarViewCell else {
            return CalendarViewCell()
        }
        
        let display = self.cellDisplays
        calCell.setUp(cellDisplay: display[indexPath.row])
        return calCell
    
    }
    
    
    
    init(style: CalendarDisplayStyle, dataSource: CalendarModel) {
        print("init")
        self.dataSource = dataSource
        self.style = style
        self.cellDisplays = []
    }
    
    convenience init(_ dataSource: CalendarModel) {
        self.init(style: .withNeighborDates, dataSource: dataSource)
        self.buildIndex()
    }
    
    deinit {
        print("deinit")
    }
    
    
    func setup() {
        var calendarMatrix = [CalendarCellDisplay]()
        for day in 1...7 {
            let display = CalendarCellDisplay(month: nil, day: nil, year: nil, weekday: Day(rawValue: day))
            calendarMatrix.append(display)
        }
        for day in self.dataSource.days {
            let display = CalendarCellDisplay(month: day.month, day: day.day, year: day.year, weekday: day.weekday)
            calendarMatrix.append(display)
        }
    }

    
    func buildIndex() {
        
        var index = 0
        let initialSquare = 0
        var priorNumberOfDays = 0
        //var postNumberOfDays = 0
        let totalSquares = dataSource.numberOfWeeks*7
        var calendarIndex: [CalendarCellDisplay] = []
        switch dataSource.startsOn {
        case .sun:
            priorNumberOfDays = 0
        case .mon:
            priorNumberOfDays = 1
        case .tues:
            priorNumberOfDays = 2
        case .wed:
            priorNumberOfDays = 3
        case .thur:
            priorNumberOfDays = 4
        case .fri:
            priorNumberOfDays = 5
        case .sat:
            priorNumberOfDays = 6
        }
        
        
        for square in initialSquare...(totalSquares) {
            if square < priorNumberOfDays {
                if self.style == .withNeighborDates {
                    guard let prior = try? Date(year: dataSource.year, month: dataSource.month.rawValue).dateAdd((-priorNumberOfDays)+square, unit: .day), let prev = prior,
                        let monthV = Month(rawValue: prev.month) else {
                            print("error in prior")
                            continue
                    }
                    let display = CalendarCellDisplay.init(month: monthV, day: prev.day, year: prev.year, weekday: nil)
                    calendarIndex.append(display)
                    continue
                } else {
                    let display = CalendarCellDisplay(month: nil, day: nil, year: nil, weekday: nil)
                    calendarIndex.append(display)
                    index = index + 1
                    continue
                }
            } else if square >= priorNumberOfDays && square < dataSource.numberOfDays+priorNumberOfDays {
                let day = square-priorNumberOfDays+1
                let display = CalendarCellDisplay(month: dataSource.month, day: day, year: dataSource.year, weekday: nil)
                calendarIndex.append(display)
                continue
            } else {
                if self.style == .withNeighborDates {
                // this is after cal date
                    guard let next = try? Date(year: dataSource.year, month: dataSource.month.rawValue) else {
                        continue
                    }
                    //print(next)
                    //print(square-priorNumberOfDays+1)
                    guard let add = next.dateAdd(square-priorNumberOfDays, unit: .day) else {
                        continue
                    }
                    //print(add)
                    guard let monthV = Month(rawValue: add.month) else {
                        continue
                    }
                    let display = CalendarCellDisplay(month: monthV, day: add.day, year: add.year, weekday: nil)
                    calendarIndex.append(display)
                    
                    continue
                } else {
                    let display = CalendarCellDisplay(month: nil, day: nil, year: nil, weekday: nil)
                    calendarIndex.append(display)
                    
                    continue
                }
            }
        
        
        //dump(self.index)
        //return
        }
        self.cellDisplays = calendarIndex
        //dump(cellDisplays)
    }
    
    
    
}

/*
 
 guard let months = current.range(of: .month, in: .year, for: date) else {
 return
 }
 for month in months {
 guard let mDate = try? Date(year: Date.currentYear, month: month), let days = current.range(of: .day, in: .month, for: mDate), let monthValue = Month(rawValue: month) else {
 return
 }
 for day in days {
 let calDate = CalendarDate(month: monthValue, day: day, year: Date.currentYear)
 self.dates.append(calDate)
 }
 
 }
 
 
 return
 
 }
 */


