//
//  AppointmentCollectionViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CalendarViewCell"

class AppointmentCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    let model = try! CalendarLayoutModel()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var addBlankDaysToFirstWeek: Int = 0
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        
        switch model.startsOn {
            
        case .sun:
            addBlankDaysToFirstWeek = 0
        case .mon:
            addBlankDaysToFirstWeek = 1
        case .tues:
            addBlankDaysToFirstWeek = 2
        case .wed:
            addBlankDaysToFirstWeek = 3
        case .thur:
            addBlankDaysToFirstWeek = 4
        case .fri:
            addBlankDaysToFirstWeek = 5
        case .sat:
            addBlankDaysToFirstWeek = 6
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let calWidth = view.frame.width/7
        
        let viewHeightHalf = view.frame.height/2
        var calHeight = viewHeightHalf/CGFloat(model.numberOfWeeks)
        
        if indexPath.section == 0 {
            calHeight = 25
        }
        
        return CGSize(width: calWidth, height: calHeight)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/7, height: screenWidth/CGFloat(model.numberOfWeeks))
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        let CalendarViewCell = UINib(nibName: "CalendarViewCell", bundle: nil)
        self.collectionView!.register(CalendarViewCell, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if section == 0 {
            return 7
        } else {
            
            
            print(model.numberOfDays)
            return model.numberOfDays+addBlankDaysToFirstWeek
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let calCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CalendarViewCell else {
            return CalendarViewCell()
        }
        calCell.month = model.month.rawValue
        if indexPath.section == 0 {
            for i in indexPath {
                calCell.dayNumber.text = Day(rawValue: i+1)?.shortDescription
                calCell.dayNumber.font = calCell.dayNumber.font.withSize(12.0)
            }
        } else {
        
            for i in indexPath {
                if i < addBlankDaysToFirstWeek {
                    calCell.dayNumber.text = ""
                    calCell.day = 0
                } else {
                    calCell.dayNumber.text = String((i+1)-addBlankDaysToFirstWeek)
                    calCell.day = (i+1)-addBlankDaysToFirstWeek
                }
            }
        }
        // Configure the cell
        
        return calCell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print(model.month.description)
        print((indexPath.row+1)-addBlankDaysToFirstWeek)
        return true
    }
 

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
