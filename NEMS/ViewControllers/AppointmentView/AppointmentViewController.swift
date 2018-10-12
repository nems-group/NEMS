//
//  AppointmentViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController {
    
    //var calendar: CalendarCollectionViewController?
    var calendar: Cal?
    @IBOutlet weak var calendarLabel: UILabel!
    //var currentCalendar: CalendarModel? = try! CalendarModel(month: Date.thisMonth!, year: Date.currentYear)
    @IBOutlet weak var calendarHeight: NSLayoutConstraint!
    
    
    
    //var selectedDate: CalendarDate?
    
    @IBAction func changeMonth(_ sender: UIButton) {
        var calendarDirection: MovementDirection = .forward
        guard let title = sender.currentTitle else {
            return
        }
        if title == "<" {
            calendarDirection = .backward
        }
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarContainerSegue" {
        
            guard let destination = segue.destination as? CalendarCollectionViewController else {
                print("container issue")
                return
            }
//            //destination.calendarCollectionView.frame = calendarContainer.frame
//            print("segueFrom: \(segue.source.description)")
////            let collectionLayout = UICollectionViewFlowLayout()
////            collectionLayout.scrollDirection = .vertical
           destination.container = self
           self.calendar = Cal()
//            print(calendarContainer.frame)
////
////
////            destination.collectionView?.setCollectionViewLayout(collectionLayout, animated: true)
////            print("calendarDate on appointmentView \(self.calendar?.dates)")
           destination.calendar = self.calendar
//            destination.calendarDelegate = CalendarLayout()
//
//            let CalendarViewCell = UINib(nibName: "CalendarViewCell", bundle: nil)
//            destination.collectionView?.register(CalendarViewCell, forCellWithReuseIdentifier: "CalendarViewCell")
            
            //self.calendar = delegate
            
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

enum MovementDirection {
    case forward
    case backward
}
