//
//  ReasonForAppointmentVC.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 10/17/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

class ReasonForAppointmentVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var reasonForVisit: [Reasons] = []
    var selectedCell: ReasonForVisitCollectionViewCell?
    
    @IBOutlet weak var reasonForVisitCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (reasonForVisit.startIndex != reasonForVisit.endIndex) && section <= reasonForVisit.endIndex {
            let resouce = reasonForVisit[section].resource
            return resouce.events.count
        }
        return 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print(reasonForVisit.count, "sections")
        return reasonForVisit.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reasonForAppointment", for: indexPath) as? ReasonForVisitCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.dataSource = self.reasonForVisit
        cell.setup(for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ReasonForVisitCollectionViewCell else {
            return
        }
        
        self.selectedCell = cell
        
    }
    
    override func viewDidLoad() {
        self.reasonForVisitCollectionView.delegate = self
        self.reasonForVisitCollectionView.dataSource = self
        self.reasonForVisitCollectionView.collectionViewLayout.invalidateLayout()
        let layout = ReasonForVisitLayout()
        self.reasonForVisitCollectionView.setCollectionViewLayout(layout, animated: true)
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "calendarViewSegue" {
            guard let appointmentVC = segue.destination as? AppointmentViewController, let reason = sender as? ReasonForVisitCollectionViewCell else {
                return
            }
            appointmentVC.event = selectedCell?.event
            appointmentVC.resource = selectedCell?.resource
        }
    }
}
