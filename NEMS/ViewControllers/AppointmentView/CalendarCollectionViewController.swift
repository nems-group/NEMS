//
//  CalendarCollectionViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

private let cellIdentifier: String = "CalendarViewCell"

class CalendarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    @IBOutlet var calendarCollectionView: UICollectionView!
    
    var newDataFinished: Bool = true
    var calendarDisplay: DisplayStatus = .large
    var container: AppointmentViewController?
    var calendar: Cal?
    var dates: [CalendarDate]? {
        get {
            return self.calendar?.dates
        }
    }
    
    var reasonForAppointment: String?
    var selectedDate: CalendarDate?
    var selectedLocation: String?
    var selectedEvent: Event?
    var selectedResource: Resource?
    
    //var appointmentQuery: AppointmentQuery?
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        
        let CalendarViewCell = UINib(nibName: "CalendarViewCell", bundle: nil)
        self.calendarCollectionView.register(CalendarViewCell, forCellWithReuseIdentifier: cellIdentifier)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //print(collectionView.description)
        return 0.00
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.00
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = self.view.frame
        let width = frame.width/7.0
        var height = frame.height/2.0
        if self.calendarDisplay == .large {
            height = frame.height/5.0
        } else {
            height = frame.height/2.0
        }
        let itemSize = CGSize(width: width, height: height)
        
        return itemSize
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // this is the method call to the api
        if self.calendarDisplay == .large {
            self.toggleCalendar()
        }
        if self.calendarDisplay == .small {
            // don't do anything
        }
        var timeout = 1000
        while ModelStore.shared.patient == nil && timeout != 0 {
            timeout = timeout - 1
            continue
        }
        guard ModelStore.shared.patient != nil else {
            print("modelstore patient is nil")
            return
        }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? CalendarViewCell else {
            print("cell is not a CalendarViewCell")
            return
        }
        cell.isHighlighted = true
        self.selectedDate = cell.calendarDate
        guard let event = self.selectedEvent, let resource = self.selectedResource else {
            print("selected items are nil - event: \(selectedEvent) -resource: \(selectedResource)")
            return
        }
        let providerName = resource.providerName
        let providerId = resource.providerId
        let duration = event.duration
        do {
            let query = try AppointmentQuery(resource: resource, event: event, providerName: providerName, providerId: providerId, duration: duration)
            try query.search { error, appointments in
                if error == nil && appointments != nil {
                    self.container?.appointments = appointments
                }
            }
        } catch {
            print(error)
        }
        
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.calendarDisplay == .small {
            self.toggleCalendar()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let dateCount = self.dates?.count {
            if indexPath.row <= dateCount-8 && self.newDataFinished {
                self.newDataFinished = false
                self.calendarCollectionView.performBatchUpdates({
                    var newWeek = [IndexPath]()
                    while self.dates!.count < dateCount+7 {
                        let index = IndexPath(row: dateCount - 1 , section: 0)
                        newWeek.append(index)
                        do {
                            try self.calendar?.addDay()
                        } catch {
                            print(error)
                            break
                        }
                    }
                    self.calendarCollectionView.insertItems(at: newWeek)
                }) { (finished) in
                    if finished {
                        self.newDataFinished = true
                    } else {
                        self.newDataFinished = false
                    }
                }
                
            }
        }
    }
    
    func toggleCalendar() {
        switch self.calendarDisplay {
        case .small:
                UIView.animate(withDuration: 0.75) {
                    self.container?.calendarHeight.constant = 330
                    self.container?.view.layoutSubviews()
                }
                self.calendarDisplay = .large
                return
        case .large:
                UIView.animate(withDuration: 0.75) {
                    self.container?.calendarHeight.constant = 120
                    self.calendarCollectionView.reloadSections(IndexSet(integer: 0))
                    self.container?.view.layoutSubviews()
                }
                self.calendarDisplay = .small
                return
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //self.dates?[indexPath.row]
        
        guard let calendarCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? CalendarViewCell else {
            return UICollectionViewCell()
        }
        guard let endIndex = self.dates?.endIndex else {
            return calendarCell
        }
        let lastItemIndex = endIndex-1
        if indexPath.row <= lastItemIndex {
            guard let date = self.dates?[indexPath.row] else {
                return calendarCell
            }
            calendarCell.setDate(date: date)
            //print(calendarCell)
            return calendarCell
        }
        return calendarCell
    }

}

enum DisplayStatus {
    case small
    case large
}


