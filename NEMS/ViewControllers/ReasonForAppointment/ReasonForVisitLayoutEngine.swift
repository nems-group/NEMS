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

    func sizeForCell(for collectionView: UICollectionView?) -> CGSize {
        guard let collectionViewFrame = collectionView?.frame else {
            return .zero
        }
        let height: CGFloat
        let paddedWidth = collectionViewFrame.width * 0.90
        if (collectionViewFrame.height / 11.0 ) <= 50.0 {
            height = 50.0
        } else {
            height = collectionViewFrame.height / 11
        }
        let size = CGSize(width: paddedWidth, height: height)
        print("size of cell height: \(size.height), width: \(size.width)")
        return size
    }
    
    func placementOfCell(for collectionView: UICollectionView?, indexPath index: IndexPath) -> CGRect {
        let size = sizeForCell(for: collectionView)
        let row = CGFloat(index.row)
        let x =  (collectionView!.frame.width / 2.0) - (size.width / 2)
        let y = (row * size.height) + ((collectionView!.frame.height * 0.025) * row) + (collectionView!.frame.height * 0.025)
        print("indexRow: \(index.row), x: \(x), y: \(y), collectionViewFrameHeight: \(collectionView!.frame.height)")
        let rect = CGRect(x: x, y: y, width: size.width, height: size.height)
        return rect
    }
    
    
    
}
