//
//  HomePageCollectionViewLayout.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HomePageCollectionViewLayout: UICollectionViewLayout {
    
    var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    var contentSize: CGSize = CGSizeZero
    
    var horizontalInset = 5.0 as CGFloat
    var verticalInset = 5.0 as CGFloat
    
    let headerViewHeight: CGFloat = 42.0
    let footerHeight: CGFloat = 80.0
    
    let sectionHeight: CGFloat = 230.0
    
    var screenRect: CGRect?
    var numberOfSections: Int?
    
    var currentScreenHeigth: CGFloat = 0.0
    
    override func prepareLayout() {
        super.prepareLayout()
        self.collectionView?.layoutIfNeeded()
        self.screenRect = self.collectionView!.bounds
        self.layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
        self.numberOfSections  = self.collectionView?.numberOfSections()
        
        self.bannerLayout(0)
        self.threeImageLayout2(1)
        self.sixImageLayout(2)
        self.sixImageLayout2(3)
        self.twoImageLayout(4)
        self.threeImageLayout(5)
        self.scrollableImageLayout(6)
        self.sellerLayout(7)
        self.newSellerScrollableImageLayout(8)
        self.twoColumnGridLayout(9)
    }
    
    
    override func collectionViewContentSize() -> CGSize {
        return self.contentSize
    }
    

    
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
    
    func bannerLayout(section: Int) {
        let defaultYPosition = self.currentScreenHeigth

        var xPosition: CGFloat = self.horizontalInset
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        var bannerSectionHeight: CGFloat = 0
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            var itemSize: CGSize = CGSizeMake(0, 0)
            
            if item == 0 {
                let mainBannerHeightSize: CGFloat = 140.0
                itemSize = CGSizeMake(screenRect!.width + horizontalInset, mainBannerHeightSize)
                xPosition = 0
                yPosition = defaultYPosition
            } else {
                let miniScreenWidth = (((screenRect!.width - (initialMargin * 2)) - (horizontalInset * CGFloat(numberOfItems! - 2)))  / (CGFloat(numberOfItems!) - 1))
                itemSize = CGSizeMake(miniScreenWidth, 80)
            }
            
            attributes.frame = CGRectMake(xPosition, yPosition, itemSize.width , itemSize.height)
            
            let key = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attributes
            
            if item == 0 {
                horizontalInset = 6
                yPosition = yPosition + itemSize.height + self.horizontalInset
                xPosition  = initialMargin
            } else {
                xPosition = xPosition + self.horizontalInset + itemSize.width
            }
            
            bannerSectionHeight = yPosition + itemSize.height + self.horizontalInset
        }
        
        self.currentScreenHeigth = bannerSectionHeight
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    func threeImageLayout2(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add decoration view
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, defaultYPosition + self.headerViewHeight, screenRect!.width, sectionHeight + 10)
        decorationViewAttribute.zIndex = -1
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        self.layoutAttributes[decorationKey] = decorationViewAttribute
        
        //Add header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, defaultYPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        self.layoutAttributes[headerKey] = headerAttribute
    
        //Add cells
        var xPosition: CGFloat = 0
        defaultYPosition = defaultYPosition + headerViewHeight
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            if item == 0 {
                let halfScreenWidth: CGFloat =  (screenRect!.width / 2)
                itemSize = CGSizeMake(halfScreenWidth, fullSectionItemHeight)
            } else {
                let rowHeight: CGFloat = 220 / 2
                let halfScreenWidth: CGFloat =  ( (screenRect!.width) / 2)
                itemSize = CGSizeMake(halfScreenWidth, rowHeight)
                xPosition = halfScreenWidth
                if item == 2 {
                    yPosition = yPosition + rowHeight + self.verticalInset
                }
            }

            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.verticalInset
        xPosition = 0
        
        //Add footer view
        let footerAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: path)
        footerAttribute.frame = CGRectMake(xPosition, yPosition, self.screenRect!.width, self.footerHeight)
        let footerKey = layoutKeyForFooterAtIndexPath(path)
        self.layoutAttributes[footerKey] = footerAttribute
        
        let height: CGFloat = yPosition + footerAttribute.frame.size.height
        
        self.currentScreenHeigth = height
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    func sixImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add decoration view
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, defaultYPosition + self.headerViewHeight, screenRect!.width, self.sectionHeight)
        decorationViewAttribute.zIndex = -1
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        self.layoutAttributes[decorationKey] = decorationViewAttribute
        
        //Add header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, defaultYPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        self.layoutAttributes[headerKey] = headerAttribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight + 20
        var yPosition: CGFloat = defaultYPosition + verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let halfScreenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * 3)) /  2)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            if item == 0 {
                itemSize = CGSizeMake(halfScreenWidth, 95)
            } else if item == 1 || item == 2 {
                itemSize = CGSizeMake((halfScreenWidth - self.horizontalInset) / 2 , 80)
                if item == 1 {
                    yPosition = yPosition + self.horizontalInset + 95
                } else {
                    xPosition = self.horizontalInset + itemSize.width + xPosition
                }
            } else if item == 3 {
                let cellItemHeight: CGFloat = 182
                let cellItemWidth: CGFloat = halfScreenWidth / 2.2
                
                xPosition = halfScreenWidth + (self.horizontalInset * 2)
                yPosition = defaultYPosition + verticalInset
                
                itemSize = CGSizeMake(cellItemWidth, cellItemHeight)
            } else {
                let cellItemWidth: CGFloat = (halfScreenWidth / 2 )
                let cellHeight: CGFloat = (182 - verticalInset) / 2

                xPosition = halfScreenWidth + (halfScreenWidth / 2.2) + (self.horizontalInset * 3)
                
                if item == 5 {
                    yPosition = yPosition + itemSize.height + self.verticalInset
                }
                
                itemSize = CGSizeMake(cellItemWidth, cellHeight)
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + 20
        
        let height: CGFloat = yPosition
        
        self.currentScreenHeigth = height
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    func sixImageLayout2(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add decoration view
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, defaultYPosition + self.headerViewHeight, screenRect!.width, self.sectionHeight)
        decorationViewAttribute.zIndex = -1
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        self.layoutAttributes[decorationKey] = decorationViewAttribute
        
        //Add header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, defaultYPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        self.layoutAttributes[headerKey] = headerAttribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight + 20
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let halfScreenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * 3)) /  2)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            if item == 0 || item == 1 {
                itemSize = CGSizeMake((halfScreenWidth - self.horizontalInset) / 2 , 80)
                if item == 1 {
                    xPosition = self.horizontalInset + itemSize.width + xPosition
                }
            } else if item == 2 {
                xPosition = self.horizontalInset
                yPosition = yPosition + itemSize.height + self.verticalInset
                itemSize = CGSizeMake(halfScreenWidth, 95)
            } else if item == 3 || item == 4 {
                let cellItemWidth: CGFloat = (halfScreenWidth / 2 )
                var cellHeight: CGFloat = 0
                
                if item == 4 {
                    yPosition = yPosition + itemSize.height + self.verticalInset
                    cellHeight = 95
                } else {
                    cellHeight = 80
                    xPosition = xPosition + itemSize.width + self.horizontalInset
                    yPosition = defaultYPosition + self.verticalInset
                }
                
                itemSize = CGSizeMake(cellItemWidth, cellHeight)
                
            } else if item == 5 {
                let cellItemWidth: CGFloat = (halfScreenWidth / 2 )
                var cellHeight: CGFloat = 0
                
                xPosition = xPosition + self.horizontalInset + cellItemWidth
                yPosition = defaultYPosition + self.verticalInset
                itemSize = CGSizeMake(halfScreenWidth / 2.2, 180)
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + 20
        xPosition = 0
        //Add footer view
        let footerAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: path)
        footerAttribute.frame = CGRectMake(xPosition, yPosition, self.screenRect!.width, self.footerHeight)
        let footerKey = layoutKeyForFooterAtIndexPath(path)
        self.layoutAttributes[footerKey] = footerAttribute
        
        let height: CGFloat = yPosition + footerAttribute.frame.size.height
        
        self.currentScreenHeigth = height
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    func twoImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add decoration view
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, defaultYPosition + self.headerViewHeight, screenRect!.width, sectionHeight)
        decorationViewAttribute.zIndex = -1
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        self.layoutAttributes[decorationKey] = decorationViewAttribute
        
        //Add header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, defaultYPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        self.layoutAttributes[headerKey] = headerAttribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight + 20
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let halfScreenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * 3)) /  2)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            let cellHeight: CGFloat = 200
            
            if item == 1 {
                xPosition = xPosition + horizontalInset + halfScreenWidth
            }
            
            itemSize = CGSizeMake(halfScreenWidth, cellHeight)
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + 20
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    func threeImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add decoration view
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, defaultYPosition + self.headerViewHeight, screenRect!.width, 110)
        decorationViewAttribute.zIndex = -1
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        self.layoutAttributes[decorationKey] = decorationViewAttribute
    
        //Add header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, defaultYPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        self.layoutAttributes[headerKey] = headerAttribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let screenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * 4)) /  3)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            let cellHeight: CGFloat = 100
            
            if item == 1 || item == 2 {
                xPosition = xPosition + self.horizontalInset + screenWidth
            }
            
            itemSize = CGSizeMake(screenWidth, cellHeight)
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + 20
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
        
    }
    
    
    func scrollableImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        //Add header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, defaultYPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        self.layoutAttributes[headerKey] = headerAttribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let screenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * 4)) /  3)
        
        for var item = 0; item < numberOfItems; item++ {
            if item == 0 {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                let cellHeight: CGFloat = 180
                
                itemSize = CGSizeMake(self.screenRect!.width, cellHeight)
                
                attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
                
                let key: String = self.layoutKeyForIndexPath(indexPath)
                self.layoutAttributes[key] = attribute
            }
        }
        
        yPosition = yPosition + itemSize.height + horizontalInset + 20
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
        
    }
    
    func sellerLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)

        //Add header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, defaultYPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        self.layoutAttributes[headerKey] = headerAttribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight
        var yPosition: CGFloat = defaultYPosition + verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let screenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * 3)) /  2)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            let cellHeight: CGFloat = 287
            
            itemSize = CGSizeMake(screenWidth, cellHeight)
            
            if (item + 1) % 2 != 0 {
                if (item + 1) != 1 {
                    xPosition = self.horizontalInset
                    yPosition = yPosition + cellHeight + self.verticalInset
                }
            } else {
                if item != 0 {
                    xPosition = xPosition + screenWidth + self.horizontalInset
                }
               
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + 20
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)

    }
    
    func newSellerScrollableImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        //Add header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, defaultYPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        self.layoutAttributes[headerKey] = headerAttribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + self.headerViewHeight
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let itemWidth: CGFloat =  122
        
        for var item = 0; item < numberOfItems; item++ {
            if item == 0 {
                let indexPath = NSIndexPath(forItem: item, inSection: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                let cellHeight: CGFloat = 180
                
                itemSize = CGSizeMake(self.screenRect!.width, cellHeight)
                
                attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
                
                let key: String = self.layoutKeyForIndexPath(indexPath)
                self.layoutAttributes[key] = attribute
            }
        }
        
        yPosition = yPosition + itemSize.height + horizontalInset + 20
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
        
    }
    
    func twoColumnGridLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add header view
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, defaultYPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        self.layoutAttributes[headerKey] = headerAttribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + self.headerViewHeight
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let screenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * 3)) /  2)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            let cellHeight: CGFloat = 287
            
            itemSize = CGSizeMake(screenWidth, cellHeight)
            
            if (item + 1) % 2 != 0 {
                if (item + 1) != 1 {
                    xPosition = self.horizontalInset
                    yPosition = yPosition + cellHeight + self.verticalInset
                }
            } else {
                if item != 0 {
                    xPosition = xPosition + screenWidth + self.horizontalInset
                }
                
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + 20
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
        
        let decorationViewHeight: CGFloat = 287 * ((CGFloat(numberOfItems!) + 1) / 2)
        
        //Add decoration view
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, defaultYPosition, screenRect!.width, decorationViewHeight)
        decorationViewAttribute.zIndex = -1
        
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        self.layoutAttributes[decorationKey] = decorationViewAttribute
    }

    
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
}
