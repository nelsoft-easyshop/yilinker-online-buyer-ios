//
//  CustomizeShoppingCollectionViewLayout.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol CustomizeShoppingCollectionViewLayoutDelegate {
   func customizeShoppingCollectionViewLayout(didAddItemWithAttribute attribute: UICollectionViewLayoutAttributes)
}

class CustomizeShoppingCollectionViewLayout: UICollectionViewLayout {
    
    var delegate: CustomizeShoppingCollectionViewLayoutDelegate?
    
    var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    var contentSize: CGSize = CGSizeZero
    var screenRect: CGRect?
    var numberOfSections: Int?
    
    var cellHeight: CGFloat = 90
    var cellWidth: CGFloat = 90
    
    let smallCellHeight: CGFloat = 45
    let smallCellWidth: CGFloat = 45
    
    let horizontalSpace: CGFloat = 10
    let verticalSpace: CGFloat = 20
    let sectionSpace: CGFloat = 10
    let xIndent: CGFloat = 20
    
    var selectedIndexPath: NSIndexPath?
    var addedIndexPath: NSIndexPath?
    var previousCellAttribute: UICollectionViewLayoutAttributes?
    
    let deleteIndexPaths: NSMutableArray = NSMutableArray()
    let insertIndexPaths: NSMutableArray = NSMutableArray()
    
    var rowOffset: CGFloat = 0.09
    
    var showAddAnimation: Bool = false
    var addedAttribute: UICollectionViewLayoutAttributes?
    
    override func prepareLayout() {
        super.prepareLayout()
        self.collectionView?.layoutIfNeeded()
        
        self.layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
        
        let sectionCount: Int = self.collectionView!.numberOfSections()
        
            let numberOfItems: Int = self.collectionView!.numberOfItemsInSection(0)
            
            var xPosition: CGFloat = 0
            var yPosition: CGFloat = 0
        
            var firstVerticalRowYPosition: CGFloat = 100
        
        if IphoneType.isIphone6Plus() {
            firstVerticalRowYPosition = 100.00
        } else if IphoneType.isIphone6() {
            firstVerticalRowYPosition = 30.00
        } else if IphoneType.isIphone5() {
            firstVerticalRowYPosition = 30.00
            cellHeight = 55
            cellWidth = 55
        } else if IphoneType.isIphone4() {
            firstVerticalRowYPosition = 60.00
            cellHeight = 50
            cellWidth = 50
        }
            
            for var item = 0 ; item < numberOfItems; item++ {
                let indexPath: NSIndexPath = NSIndexPath(forItem: item, inSection: 0)
                let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
               
                let cellPatternNumber: Int = (item + 1) % 8
                
                if cellPatternNumber <= 3 {
                    if cellPatternNumber == 1 {
                        if item == 0 {
                            xPosition = 10
                        } else {
                            xPosition = xPosition + (cellWidth / 2) + sectionSpace
                        }
                        yPosition = firstVerticalRowYPosition
                    } else {
                        yPosition = yPosition + verticalSpace + cellHeight
                        xPosition = xPosition + self.xIndent
                    }
                    
                    attribute.frame = CGRectMake(xPosition, yPosition, cellWidth, cellHeight)
                    
                } else if cellPatternNumber <= 5  {
                    if cellPatternNumber == 4 {
                        yPosition = firstVerticalRowYPosition + (cellHeight / 2)
                        xPosition = xPosition + (cellWidth / 2) + sectionSpace
                    } else {
                        yPosition = yPosition + verticalSpace + cellHeight
                        xPosition = xPosition + self.xIndent
                    }
                    attribute.frame = CGRectMake(xPosition, yPosition, cellWidth, cellHeight)
                } else {
                    
                    if cellPatternNumber == 6 {
                        xPosition = xPosition + (cellWidth / 2) + sectionSpace
                        yPosition = firstVerticalRowYPosition - 30
                    } else {
                        yPosition = yPosition + verticalSpace + cellHeight
                        xPosition = xPosition + self.xIndent
                    }
                    
                    attribute.frame = CGRectMake(xPosition, yPosition, cellWidth, cellHeight)
                    
                }
                
                let key: String = self.layoutKeyForIndexPath(indexPath)
                self.layoutAttributes[key] = attribute
            }
            
            self.contentSize = CGSizeMake(xPosition + self.cellWidth, self.collectionView!.frame.size.height)
        
    }
    
    //Dynamic Key Generator
    
    func layoutKeyForIndexPath(indexPath : NSIndexPath) -> String {
        return "\(indexPath.section)_\(indexPath.row)"
    }
    
    func layoutKeyForHeaderAtIndexPath(indexPath : NSIndexPath) -> String {
        return "s_\(indexPath.section)_\(indexPath.row)"
    }
    
    func layoutKeyForFooterAtIndexPath(indexPath : NSIndexPath) -> String {
        return "f_\(indexPath.section)_\(indexPath.row)"
    }
    
    func layoutKeyForDecorationViewAtIndexPath(indexPath : NSIndexPath) -> String {
        return "d_\(indexPath.section)_\(indexPath.row)"
    }
    
    override func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    
    
    //CollectionView Layout Delegate
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let key = layoutKeyForIndexPath(indexPath)
        return self.layoutAttributes[key]
    }
    
    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        let headerKey = layoutKeyForIndexPath(indexPath)
        return self.layoutAttributes[headerKey]
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
        let predicate = NSPredicate {  [unowned self] (evaluatedObject, bindings) -> Bool in
            let layoutAttribute = self.layoutAttributes[evaluatedObject as! String]
            
            return CGRectIntersectsRect(rect, layoutAttribute!.frame)
        }
        
        let dict = self.layoutAttributes as NSDictionary
        let keys = dict.allKeys as NSArray
        let matchingKeys = keys.filteredArrayUsingPredicate(predicate)
        
        return dict.objectsForKeys(matchingKeys, notFoundMarker: NSNull())
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes: UICollectionViewLayoutAttributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)!

        if itemIndexPath.isEqual(self.selectedIndexPath) {
            self.delegate!.customizeShoppingCollectionViewLayout(didAddItemWithAttribute: attributes)
            self.selectedIndexPath = nil
        }
        
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes: UICollectionViewLayoutAttributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)!
        
        if self.showAddAnimation {
            self.showAddAnimation = false
            if itemIndexPath.row == 0 {
                attributes.center = self.addedAttribute!.center
                attributes.transform = CGAffineTransformMakeScale(0.5, 0.5)
            }
        }
        
        return attributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    

}
