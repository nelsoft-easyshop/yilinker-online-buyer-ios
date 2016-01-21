//
//  FABCollectionViewLayout.swift
//  FloatingActionButton
//
//  Created by Alvin John Tandoc on 1/20/16.
//  Copyright (c) 2016 YiAyOS. All rights reserved.
//

import UIKit

class FABCollectionViewLayout: UICollectionViewLayout {
    
    var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    
    let cellHeight: Int = 65
    let cellProfileHeight: Int = 90
    var cellFirstYPosition : CGFloat = 0
    
    var textAndIcons: [TextAndIconModel] = []
    
    //MARK: -
    //MARK: - Prepare Layout
    override func prepareLayout() {
        super.prepareLayout()
        self.collectionView?.layoutIfNeeded()
        
        self.layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
        
        self.cellFirstYPosition = self.collectionView!.frame.size.height - CGFloat(cellHeight)
        
        let numberOfItems: Int = self.collectionView!.numberOfItemsInSection(0)
        
        for index in 0..<numberOfItems {
            let yOffSet: CGFloat = CGFloat(index) * CGFloat(cellHeight)
            let indexPath: NSIndexPath = NSIndexPath(forItem: index, inSection: 0)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
           
            if self.textAndIcons[index].isProfile {
                let frame: CGRect = CGRectMake(0, self.cellFirstYPosition - (yOffSet + 20), self.collectionView!.frame.size.width, CGFloat(self.cellProfileHeight))
                attribute.frame = frame
            } else {
                let frame: CGRect = CGRectMake(0, self.cellFirstYPosition - yOffSet , self.collectionView!.frame.size.width, CGFloat(self.cellHeight))
                attribute.frame = frame
            }
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
    }
    
    //MARK: -
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
        return self.collectionView!.frame.size
    }
    
    //MARK: -
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
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true
    }
    
    func test() {
        //This is just a test. A func that will destroy everything.
    }
    
    //MARK: - 
    //MARK: - Collection View Animation Layout
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes: UICollectionViewLayoutAttributes = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)!
        
        attributes.frame = CGRectMake(attributes.frame.origin.x, self.collectionView!.frame.size.height, attributes.frame.size.width, attributes.frame.size.height)
        
        return attributes
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        var attributes: UICollectionViewLayoutAttributes = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)!
        
       attributes.frame = CGRectMake(attributes.frame.origin.x, self.collectionView!.frame.size.height, attributes.frame.size.width, attributes.frame.size.height)
        
        return attributes
    }
}
