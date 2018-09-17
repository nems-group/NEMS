//
//  CalendarCollectionViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit

private let reuseIdentifier = "CalendarViewCell"

class CalendarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CalendarCollectionViewDelegate {
    
    func newLayout(from dataSource: CalendarModel) {
        self.layout = CalendarLayout(dataSource)
        print("layout: \(self.layout), dataSource: \(dataSource), localLayout: \(CalendarLayout(dataSource))")
        self.collectionView?.reloadData()
    }
    
    
    func currentCalendarChanged(newModel: CalendarModel) {
        self.layout = CalendarLayout(newModel)
        self.collectionView?.reloadData()
    }
    

    var layout: CalendarLayout?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var addPreviousMonthDaysToFirstWeek: Int = 0
    var addNextMonthDaysToLastWeek: Int = 0
    //var delegate: CalendarCollectionViewDelegate?
    
    override func viewWillAppear(_ animated: Bool) {
        

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        guard let model = self.layout?.dataSource else {
            return CGSize(width: 0, height: 0)
        }
        
        let calWidth = view.frame.width/7
        
        let viewHeightHalf = view.frame.height
        var calHeight = viewHeightHalf/CGFloat(model.numberOfWeeks)
        
        if indexPath.section == 0 {
            calHeight = 25
        }
        
        return CGSize(width: calWidth, height: calHeight)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        
        
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        guard let model = self.layout?.dataSource else {
            return
        }
        
        let layoutGuide: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layoutGuide.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layoutGuide.itemSize = CGSize(width: viewWidth/7, height: viewHeight/CGFloat(model.numberOfWeeks))
        layoutGuide.minimumInteritemSpacing = 0
        layoutGuide.minimumLineSpacing = 0
        collectionView?.collectionViewLayout = layoutGuide
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Register cell classes
        let CalendarViewCell = UINib(nibName: "CalendarViewCell", bundle: nil)
        self.collectionView?.register(CalendarViewCell, forCellWithReuseIdentifier: reuseIdentifier)

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
            guard let count = layout?.index?.count else {
                print("no layout")
                return 0
            }
            print(count)
            return count
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let calCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? CalendarViewCell else {
            return CalendarViewCell()
        }
        if indexPath.section == 0 {
            print(indexPath.row)
            calCell.setUp(weekdayInt: indexPath.row+1)
        } else {
            guard let layout = self.layout else {
                print("no layout")
                return calCell
            }
            guard let indexCount = layout.index?.count, let index = layout.index else {
                print("no index count")
                return calCell
            }
            let indexRange = indexCount+1
            if indexPath.row > indexRange {
                return calCell
            }
            let model = index[indexPath.row]
            calCell.setUp(date: model)
            return calCell
        }
        
        
        
        
        // Configure the cell
        
        return calCell
    }

    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        //collectionView.collectionViewLayout
        //collectionView.frame = CGRect(x: 20, y: 20, width: 20, height: 20)
        //print(model.month.description)
        //print((indexPath.row+1)-addBlankDaysToFirstWeek)
        print(layout?.index?[indexPath.row]?.month)
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
