//
//  HomePageCollectionViewLayout2.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct SectionHeight {
    static let sectionOne: CGFloat = 180.0
    static let sectionTwo: CGFloat = 70.0
    static let sectionThree: CGFloat = 130.0
    static let sectionFour: CGFloat = 170.0
}

class HomePageCollectionViewLayout2: UICollectionViewLayout {
    var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    
    var contentSize: CGSize = CGSizeZero
    var screenRect: CGRect?
    var numberOfSections: Int?
    var layouts: [String] = []

    let sectionVerticalInset: CGFloat = 5
    
    //MARK: Prepare Layout
    override func prepareLayout() {
        super.prepareLayout()
        self.collectionView?.layoutIfNeeded()
        self.screenRect = self.collectionView!.bounds
        self.layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
        self.numberOfSections  = self.collectionView?.numberOfSections()

        for (index, layout) in enumerate(self.layouts) {
            if layout == "1" {
                self.layoutOne(index)
            } else if layout == "2" {
                self.layoutTwo(index)
            } else if layout == "3" {
                self.layoutThree(index)
            } else if layout == "4" {
                self.layoutFour(index)
            }
        }
    }
    
    //MARK: Layout One
    func layoutOne(section: Int) {
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.frame = CGRectMake(0, self.sectionYOffsetWithSectionNumber(section), screenRect!.width , SectionHeight.sectionOne)
        
        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
    }
    
    //MARK: Layout Two
    func layoutTwo(section: Int) {
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.frame = CGRectMake(0, self.sectionYOffsetWithSectionNumber(section), screenRect!.width , SectionHeight.sectionTwo)
        
        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
    }
    
    //MARK: Layout Three
    func layoutThree(section: Int) {
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.frame = CGRectMake(0, self.sectionYOffsetWithSectionNumber(section), screenRect!.width , SectionHeight.sectionThree)
        
        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
    }
    
    //MARK: Layout Four
    func layoutFour(section: Int) {
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.frame = CGRectMake(0, self.sectionYOffsetWithSectionNumber(section), screenRect!.width , SectionHeight.sectionFour)
        
        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
    }
    
    //MARK: - Section Y Offset With Section Number
    func sectionYOffsetWithSectionNumber(section: Int) -> CGFloat {
        var occupiedSpace: CGFloat = 0.0
        for var x = 0; x < section; x++ {
            if self.layouts[x] == "1" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionOne + sectionVerticalInset
            } else if self.layouts[x] == "2" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionTwo + sectionVerticalInset
            } else if self.layouts[x] == "3" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionThree + sectionVerticalInset
            } else if self.layouts[x] == "4" {
                 occupiedSpace = occupiedSpace + SectionHeight.sectionFour + sectionVerticalInset
            } else {
                occupiedSpace = 0.0
            }
        }
        
       /* var sectionCounter: Int = 0
        
        do {
            if self.layouts[sectionCounter] == "1" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionOne + sectionVerticalInset
            }
            sectionCounter++
        } while (sectionCounter < section)*/
        
        return occupiedSpace
    }
    
    //MARK: - Dynamic Key Generator
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
        return CGSizeMake(self.screenRect!.width, self.sectionYOffsetWithSectionNumber(self.numberOfSections!))
    }
    
    
    //MARK: - CollectionView Layout Delegate
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
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return !CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size)
    }
    
    //MARK: - Decoration View
    func decorationViewWithYPosition(yPosition: CGFloat, sectionHeight: CGFloat, path: NSIndexPath) -> (attribute: UICollectionViewLayoutAttributes, key: String) {
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, yPosition, screenRect!.width, sectionHeight)
        decorationViewAttribute.zIndex = -1
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        return (decorationViewAttribute, decorationKey)
    }

}
