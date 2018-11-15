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
    var event: Event?
    var resource: Resource?
    var selectedDays: [Day]?
    var selectedDate: Date?
    var selectedTime: TimeOfDay = .any
    var providerName: String?
    var providerId: String?
    var duration: Int?
    var appointmentTable: AppointmentListTableViewController?
    var appointments: [Appointment]? {
        didSet {
            var checkAppt: Appointment?
            let appointmentByDate = appointments?.map { (appointment) -> Appointment in
                if checkAppt != nil {
                    if checkAppt!.apptDateTime >= appointment.apptDateTime {
                        return checkAppt!
                    }
                    
                }
                checkAppt = appointment
                return appointment
            }

        }
    }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "calendarContainerSegue" {
        
            guard let destination = segue.destination as? CalendarCollectionViewController else {
                print("container issue")
                return
            }
           destination.container = self
           self.calendar = Cal()
           destination.calendar = self.calendar
           destination.selectedEvent = self.event
           destination.selectedResource = self.resource
           print("cal: \(destination.calendar), event: \(destination.selectedEvent), resource: \(destination.selectedResource) \(self.event), \(self.resource)")
            
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
