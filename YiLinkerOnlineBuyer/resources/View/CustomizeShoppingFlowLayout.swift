//
//  CustomizeShoppingFlowLayout.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol CustomizeShoppingFlowLayoutDelegate {
    func customizeShoppingFlowLayout(deselectCategoryWithAttributes attributes: UICollectionViewLayoutAttributes)
}

class CustomizeShoppingFlowLayout: UICollectionViewFlowLayout {
    
    var currentDeletedAttribute: UICollectionViewLayoutAttributes?
    var rowOfItemAdded: Int = 0
    var deletedIndexPath: NSIndexPath?
    var delegate: CustomizeShoppingFlowLayoutDelegate?
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes: UICollectionViewLayoutAttributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)!
        
        if itemIndexPath.row == self.rowOfItemAdded {
            attributes.transform = CGAffineTransformMakeScale(2.0, 2.0)
            attributes.center = currentDeletedAttribute!.center
            
            if attributes.center.x > self.collectionView!.frame.size.width {
                attributes.center = self.collectionView!.center
            }
        }
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes: UICollectionViewLayoutAttributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)!
        if itemIndexPath.isEqual(self.deletedIndexPath) {
            self.deletedIndexPath = nil
            self.delegate!.customizeShoppingFlowLayout(deselectCategoryWithAttributes: attributes)
        }
        
        return attributes
    }
    
}
