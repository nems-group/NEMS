//
//  AppointmentViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/16/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController, UICollectionViewDelegate {
    
    var calendar: CalendarCollectionViewController?
    var layout: CalendarLayout?
    @IBOutlet weak var calendarLabel: UILabel!
    var currentCalendar: CalendarModel? = try! CalendarModel(month: Date.thisMonth!, year: Date.currentYear)
    
    
    
    //var selectedDate: CalendarDate?
    
    @IBAction func changeMonth(_ sender: UIButton) {
        var calendarDirection: MovementDirection = .forward
        guard let title = sender.currentTitle else {
            return
        }
        if title == "<" {
            calendarDirection = .backward
        }
        
        changeDate(calendarDirection)
        
    }
    
    func changeDate(_ movement: MovementDirection) {
        let newMonth: CalendarModel?
        switch movement {
        case .backward: do {
            guard let lastMonth = self.currentCalendar?.previousMonth?.calObject else {
                return
            }
            newMonth = lastMonth
            }
        case .forward: do {
            guard let nextMonth = self.currentCalendar?.nextMonth?.calObject else {
                return
            }
            newMonth = nextMonth
            }
        }
        
        guard let newCal = newMonth else {
            return
        }
        //dump(newCal)
        print("refresh")
        self.currentCalendar = newCal
        self.layout = CalendarLayout(self.currentCalendar!)
        self.calendarLabel.text = currentCalendar?.month.description
        self.calendar?.collectionView?.delegate = self
        self.calendar?.collectionView?.dataSource = self.layout
        self.calendar?.collectionView?.reloadData()
        
       
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("viewDIdload")
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.calendarLabel.text = self.currentCalendar?.month.description
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarContainerSegue" {
            
            print("id")
            guard let cal = self.currentCalendar else {
                return
            }
            self.layout = CalendarLayout(cal)
            guard let layout = self.layout else {
                print("layout issue")
                return
            }
            guard let delegate = segue.destination as? CalendarCollectionViewController else {
                print("container issue")
                return
            }
            
            delegate.collectionView!.delegate = self
            delegate.collectionView!.dataSource = layout
            let CalendarViewCell = UINib(nibName: "CalendarViewCell", bundle: nil)
            delegate.collectionView!.register(CalendarViewCell, forCellWithReuseIdentifier: "CalendarViewCell")
            self.calendar = delegate
            
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
