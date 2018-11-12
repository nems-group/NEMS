//
//  ReasonForVisitLayoutEngine.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 10/21/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit


class ReasonForVisitLayoutEngine {
    
    var collectionView: UICollectionView?
    
    private var itemHeight: CGFloat {
        get {
            guard let collectionViewFrame = collectionView?.frame else {
                return 0.00
            }
            let height: CGFloat
            if (collectionViewFrame.height / 11.0 ) <= 50.0 {
                height = 50.0
            } else {
                height = collectionViewFrame.height / 11
            }
            return height
        }
    }
    private var topSpacing: CGFloat {
        get {
            return 15.0
        }
    }
    private var itemWidth: CGFloat {
        get {
            guard let collectionViewFrame = collectionView?.frame else {
                return 0.00
            }
            let paddedWidth = collectionViewFrame.width * 0.90
            return paddedWidth
        }
    }
    
    private var itemSpacing: CGFloat {
        get {
            return 5.00
        }
    }
    private var sectionHeight: CGFloat {
        get {
            return 25.0
        }
    }
    var itemSize: CGSize {
        let size = CGSize(width: itemWidth, height: itemHeight)
        //print("size of cell height: \(size.height), width: \(size.width)")
        return size
    }
    
    var sectionSize: CGSize {
        let size = CGSize(width: itemWidth, height: sectionHeight)
        return size
    }
    
    private func yPositionOfSectionHeader(for index: IndexPath) -> CGFloat {
        var numberOfItemsPrevious = 0
        guard let collectionView = collectionView else {
            return 0.00
        }
        for section in 0..<index.section {
            numberOfItemsPrevious += collectionView.numberOfItems(inSection: section)
        }
        let heightFromPreviousSections = (self.sectionHeight * CGFloat(index.section))
        let heightFromPreviousItems = self.itemHeight * CGFloat(numberOfItemsPrevious)
        let totalHeight = heightFromPreviousItems + heightFromPreviousSections
        print("numberOfPreviousItems: \(numberOfItemsPrevious), so total y: \(totalHeight)")
        
        return totalHeight
    }
    
    private func yPosition(for indexPath: IndexPath) -> CGFloat {
        
        let numberOfSections = CGFloat(indexPath.section+1)
        let heightFromSections = (numberOfSections * self.sectionHeight)
        var totalItems: CGFloat = 0.00
        for section in 0..<indexPath.section {
            //print("section: \(section), indexPathSection: \(indexPath.section)")
            let numberOfItems = collectionView!.numberOfItems(inSection: section)
            totalItems = totalItems + CGFloat(numberOfItems)
        }
        totalItems = totalItems + CGFloat(indexPath.row)
        let totalHeight = heightFromSections + (totalItems * itemHeight) + (CGFloat(indexPath.row) * itemSpacing)
        print("y for cell \(indexPath): \(totalHeight)")
        return totalHeight
        
    }
    
    func placementOfCell(for collectionView: UICollectionView?, indexPath index: IndexPath) -> CGRect {
        var total: (sections: CGFloat, items: CGFloat) = (CGFloat(index.section),0.00)
        var totalItems: CGFloat = 0.00
        for section in 0...index.section {
            let numberOfItems = collectionView!.numberOfItems(inSection: section)
            totalItems = totalItems + CGFloat(numberOfItems)
        }
        total.items = totalItems
        total.sections = total.sections+1
        //print("for  \(index), total.Items: \(total.items), total.Sections: \(total.sections)")
        let x =  (collectionView!.frame.width / 2.0) - (self.itemSize.width / 2)
        let y = yPosition(for: index)
        
        let rect = CGRect(x: x, y: y, width: self.itemSize.width, height: self.itemSize.height)
        //print("cell position: \(rect.debugDescription)")
        return rect
    }
    
    func placementOfHeader(for collectionView: UICollectionView?, indexPath index: IndexPath) -> CGRect {
        let x =  (collectionView!.frame.width / 2.0) - (self.itemSize.width / 2)
        let y = yPositionOfSectionHeader(for: index)
        //print("indexSection: \(index.section) indexRow: \(index.row), x: \(x), y: \(y), collectionViewFrameHeight: \(collectionView!.frame.height)")
        let rect = CGRect(x: x, y: y, width: self.itemSize.width, height: self.sectionHeight)
        //print("header position: \(rect.debugDescription)")
        return rect
    }
    
    
    
}
