//
//  CalendarLayout.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/15/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation

enum CalendarDisplayStyle {
    case withNeighborDates
    case noNeighborDates
}

class CalendarLayout {
    
    var style: CalendarDisplayStyle = .withNeighborDates
    var dataSource: CalendarModel
    var index: [CalendarDate?]?
    
    
    init(style: CalendarDisplayStyle, dataSource: CalendarModel) {
        self.dataSource = dataSource
        self.style = style
    }
    
    convenience init(_ dataSource: CalendarModel) {
        self.init(style: .withNeighborDates, dataSource: dataSource)
        self.buildIndex()
    }
    
    func buildIndex() {
        
        var index = 0
        let initialSquare = 0
        var priorNumberOfDays = 0
        //var postNumberOfDays = 0
        let totalSquares = dataSource.numberOfWeeks*7
        var calendarIndex: [CalendarDate?] = []
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
            //print("square: \(square)")
            //print("init: \(initialSquare)")
            //print("totalSquares: \(totalSquares)")
            if square < priorNumberOfDays {
                
                //print(square)
                if self.style == .withNeighborDates {
                    guard let prior = try? Date(year: dataSource.year, month: dataSource.month.rawValue).dateAdd((-priorNumberOfDays)+square, unit: .day), let prev = prior,
                        let monthV = Month(rawValue: prev.month) else {
                            print("error in prior")
                            continue
                    }
                    let cal = CalendarDate(month: monthV, day: prev.day, year: prev.year)
                    calendarIndex.append(cal)
                    continue
                } else {
                    calendarIndex.append(nil)
                    index = index + 1
                    continue
                }
            } else if square >= priorNumberOfDays && square < dataSource.numberOfDays+priorNumberOfDays {
                let day = square-priorNumberOfDays+1
                let date = CalendarDate(month: dataSource.month, day: day, year: dataSource.year)
                calendarIndex.append(date)
                continue
            } else {
                if self.style == .withNeighborDates {
                // this is after cal date
                    guard let next = try? Date(year: dataSource.year, month: dataSource.month.rawValue) else {
                        continue
                    }
                    print(next)
                    print(square-priorNumberOfDays+1)
                    guard let add = next.dateAdd(square-priorNumberOfDays, unit: .day) else {
                        continue
                    }
                    print(add)
                    guard let monthV = Month(rawValue: add.month) else {
                        continue
                    }
                    let cal = CalendarDate(month: monthV, day: add.day, year: add.year)
                    calendarIndex.append(cal)
                    
                    continue
                } else {
                    calendarIndex.append(nil)
                    
                    continue
                }
            }
        
        
        //dump(self.index)
        //return
        }
        self.index = calendarIndex
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


