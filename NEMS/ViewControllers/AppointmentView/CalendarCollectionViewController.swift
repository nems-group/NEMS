//
//  CalendarCollectionViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

private let cellIdentifier: String = "CalendarViewCell"

class CalendarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout
{
    @IBOutlet var calendarCollectionView: UICollectionView!
    
    var calendar: Cal?
    var dates: [CalendarDate]? {
        get {
            return self.calendar?.dates
        }
    }
    var selectParameters: AppointmentSearchQuery?
    
    override func viewDidLoad() {
        //super.viewDidLoad()
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        
        let CalendarViewCell = UINib(nibName: "CalendarViewCell", bundle: nil)
        self.collectionView?.register(CalendarViewCell, forCellWithReuseIdentifier: cellIdentifier)
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        print(collectionView.description)
        return 0.00
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.00
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = self.view.frame
        let width = frame.width/7.0
        let height = frame.height/5.0
        
        let itemSize = CGSize(width: width, height: height)
        
        return itemSize
    }
    
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dates?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // this is the method call to the api
        print(self.dates?[indexPath.row])
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //self.dates?[indexPath.row]
        if let dateCount = self.dates?.count {
            //print(indexPath.row)
            if indexPath.row == dateCount-1 {
                print("add a week")
                self.calendar?.addWeek()
                self.collectionView?.reloadSections(IndexSet.init(integersIn: indexPath.section...indexPath.section))
            }
        }
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

struct AppointmentSearchQuery: Codable {
    
    var event_id: String
    var location_id: String
    var startDate: String = Date.now
    var start_time: String = "0000"
    var end_time: String = "2359"
    var pi_sun: Int = 1
    var pi_mon: Int = 2
    var pi_tue: Int = 3
    var pi_wed: Int = 4
    var pi_thu: Int = 5
    var pi_fri: Int = 6
    var pi_sat: Int = 7
    
}
