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
    
    var reasonForVisit: [Reasons]?
    var selectedCell: ReasonForVisitCollectionViewCell?
    
    @IBOutlet weak var reasonForVisitCollectionView: UICollectionView!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numberOfItemsInSection \(reasonForVisit?.count)")
        return reasonForVisit?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        let count = 0
        guard let reasons = self.reasonForVisit else {
            return count
        }
        var providerType = [String]()
        for reason in reasons {
            
        }
        print("number of sections: \(providerType.count)")
        return providerType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reasonForAppointment", for: indexPath) as? ReasonForVisitCollectionViewCell else {
            return UICollectionViewCell()
        }
        guard let reasons = self.reasonForVisit else {
            return cell
        }
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
