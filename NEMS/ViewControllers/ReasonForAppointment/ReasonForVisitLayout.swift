//
//  ReasonForVisitLayout.swift
//  NEMS
//
//  Created by Scott Eremia-Roden on 10/18/18.
//  Copyright © 2018 User. All rights reserved.
//

import Foundation
import UIKit

class ReasonForVisitLayout: UICollectionViewFlowLayout {
    
    var engine: ReasonForVisitLayoutEngine? = ReasonForVisitLayoutEngine()
    private var cache = [UICollectionViewLayoutAttributes]()
    
    override func invalidateLayout() {
        if let bounds = collectionView?.bounds {
            super.invalidateLayout()
        }
        super.invalidateLayout()
    }
    
    override func prepare() {
        print("prepare")
        print("engine: \(engine)")
        
        engine?.collectionView = self.collectionView
        
        if cache.isEmpty {
            guard let indexPaths = self.collectionView?.indexPathForAllItems else {
                return
            }
            for index in indexPaths {
                guard let cellRect = engine?.placementOfCell(for: self.collectionView, indexPath: index) else {
                    return
                }
                let attribute = UICollectionViewLayoutAttributes(forCellWith: index)
                if index.row == 0 {
                    let sectionA = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: index)
                    print("sectionA \(sectionA)")
                    cache.append(sectionA)
                }
                attribute.frame = cellRect
                cache.append(attribute)
            }
        }
        
        
    
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("indexPath: \(indexPath)")
        
        let sectionA = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: indexPath)
        sectionA.bounds.size = engine?.sectionSize ?? .zero
        print("sectionA attributes: \(sectionA)")
        let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        attributes.representedElementCategory
        attributes.bounds.size = engine?.itemSize ?? .zero
        
        return attributes
        
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print(elementKind, "layoutAttributesForSupplementaryView")
        let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKind, with: indexPath)
        attributes.bounds.size = engine?.sectionSize ?? .zero
        return attributes
    }
    
    
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var elementsInRect = [UICollectionViewLayoutAttributes]()
        guard let indexPaths = self.collectionView?.indexPathForAllItems else {
            return elementsInRect
        }
        for index in indexPaths {
            guard let cellRect = engine?.placementOfCell(for: self.collectionView, indexPath: index) else {
                continue
            }
            if rect.intersects(cellRect) {
                if index.row == 0 {
                    let sectionA = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, with: index)
                    guard let sectionRect = engine?.placementOfHeader(for: self.collectionView, indexPath: index)  else {
                        continue
                    }
                    sectionA.frame = sectionRect
                    elementsInRect.append(sectionA)
                }
                let attributes = UICollectionViewLayoutAttributes(forCellWith: index)
                attributes.frame = cellRect
                elementsInRect.append(attributes)
            }
            
        }
        return elementsInRect
    }
    
    override var collectionViewContentSize: CGSize {
        get {
            guard let collectionView = collectionView else { return .zero }
            guard collectionView.frame != .zero else { return .zero }
            
            let width = collectionView.frame.width
            
            let height: CGFloat
            
            if let lastAttribute = cache.last {
                height = lastAttribute.frame.maxY + CGFloat(collectionView.frame.height * 0.05)
            } else {
                height = 0
            }
            print(height)
            
            return CGSize(width: width, height: height)
            
        }
    }
    
    


    
    
}


extension UICollectionView {

    
    var indexPathForAllItems: [IndexPath] {
        var indexPaths = [IndexPath]()
        print(self.numberOfSections)
        for section in 0..<self.numberOfSections {
            print("indexPathForAllItems: \(section)")
            var sectionTotal = self.numberOfItems(inSection: section)
            print("sectionTotal \(sectionTotal)")
            if sectionTotal < 0 {
                sectionTotal = 0
            }
            if sectionTotal > 0 {
                for item in 0..<sectionTotal {
                    print("item: \(item)")
                    let indexPath = IndexPath(item: item, section: section)
                    indexPaths.append(indexPath)
                }
            }
        }
        return indexPaths
    }
}
