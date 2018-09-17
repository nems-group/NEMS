//
//  CalendarCollectionViewController.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 9/13/18.
//  Copyright © 2018 User. All rights reserved.
//

import UIKit



class CalendarCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var layout: CalendarLayout?
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    var addPreviousMonthDaysToFirstWeek: Int = 0
    var addNextMonthDaysToLastWeek: Int = 0
    //var delegate: CalendarCollectionViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewHeight = self.view.frame.height
        let viewWidth = self.view.frame.width
        
        guard let model = self.layout?.dataSource else {
            return
        }
        
//        let layoutGuide: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layoutGuide.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        layoutGuide.itemSize = CGSize(width: viewWidth/7, height: viewHeight/CGFloat(model.numberOfWeeks))
//        layoutGuide.minimumInteritemSpacing = 0
//        layoutGuide.minimumLineSpacing = 0
//        collectionView?.collectionViewLayout = layoutGuide
        
        
        
    }
    
    
    

    

}
