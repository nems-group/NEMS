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
    private var itemWidth: CGFloat {
        get {
            guard let collectionViewFrame = collectionView?.frame else {
                return 0.00
            }
            let paddedWidth = collectionViewFrame.width * 0.90
            return paddedWidth
        }
    }
    private var sectionHeight: CGFloat {
        get {
            return 5.0
        }
    }
    var itemSize: CGSize {
        let size = CGSize(width: itemWidth, height: itemHeight)
        print("size of cell height: \(size.height), width: \(size.width)")
        return size
    }
    
    
    private func yPosition(for indexPath: IndexPath) -> CGFloat {
        
        let numberOfSections = CGFloat(indexPath.section)
        let heightFromSections = numberOfSections * self.sectionHeight
        var totalItems: CGFloat = 0.00
        for section in 0..<indexPath.section {
            let numberOfItems = collectionView!.numberOfItems(inSection: section)
            totalItems = totalItems + CGFloat(numberOfItems)
        }
        totalItems = totalItems + CGFloat(indexPath.row+1)
        let totalHeight = heightFromSections + (totalItems * itemHeight) + (CGFloat(collectionView!.frame.height) * 0.125)
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
        print(total)
        print("for  \(index), total.Items: \(total.items), total.Sections: \(total.sections)")
        let x =  (collectionView!.frame.width / 2.0) - (self.itemSize.width / 2)
        let y = yPosition(for: index)
        print("indexSection: \(index.section) indexRow: \(index.row), x: \(x), y: \(y), collectionViewFrameHeight: \(collectionView!.frame.height)")
        let rect = CGRect(x: x, y: y, width: self.itemSize.width, height: self.itemSize.height)
        return rect
    }
    
    
    
}
