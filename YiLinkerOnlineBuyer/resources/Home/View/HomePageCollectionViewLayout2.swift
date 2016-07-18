//
//  HomePageCollectionViewLayout2.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct SectionHeight {
    static func sectionOneHeight() -> CGFloat {
        //height = screenWidth * height ratio / width ratio
        //ratio 8:3
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return (screenSize.width * 250) / 616
        //return 500
    }
    
    static func sectionTwoHeight() -> CGFloat {
        //116 x 110
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return (screenSize.width * 110) / 616
        //return 500
    }
    
    static func sectionThreeHeight() -> CGFloat {
        //116 x 110
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return (screenSize.width * 150) / 616
    }
    
    static func sectionThreeCellWidth() -> CGFloat {
        //116 x 110
        return (SectionHeight.sectionThreeHeight() * 300) / (150)
        //return 500
    }
    
    static func sectionSixHeight() -> CGFloat {
        //201 x 616
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return (screenSize.width * 201) / (430)
        //return 253
    }
    
    static func sectionSixFirstCellWidth() -> CGFloat {
        //201 x 616
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return (SectionHeight.sectionSixHeight() * 319) / (490)
        //return 500
    }
    
    static func sectionSixSecondCellWidth() -> CGFloat {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        return (screenSize.width  - 6) - (SectionHeight.sectionSixFirstCellWidth())
        //return 500
    }
    
    static let sectionOne: CGFloat = SectionHeight.sectionOneHeight()
    static let sectionTwo: CGFloat = SectionHeight.sectionTwoHeight()
    static let sectionThree: CGFloat = SectionHeight.sectionThreeHeight()
    static let sectionFive: CGFloat = 230.0
    static let sectionSix: CGFloat = SectionHeight.sectionSixHeight()
    static let sectionEight: CGFloat = 338
    static let sectionNine: CGFloat = 250
    static let sectionTen: CGFloat = 287
    static let sectionEleven: CGFloat = 150
    static let layoutHeader: CGFloat = 40.0
    static let sectionTwelve: CGFloat = 199
    static let sectionThirteen: CGFloat = 275
    static let sectionFourteen: CGFloat = 280
    
}

class HomePageCollectionViewLayout2: UICollectionViewLayout {
    var layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
    
    var contentSize: CGSize = CGSizeZero
    var screenRect: CGRect?
    var numberOfSections: Int?
    var layouts: [String] = []

    var homePageModel: HomePageModel = HomePageModel()
    
    let sectionVerticalInset: CGFloat = 2
    var sectionFour: CGFloat = 170.0
    
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
            } else if layout == "5" {
                self.layoutFive(index)
            } else if layout == "6" {
                self.layoutSix(index)
            } else if layout == "7" {
                self.layoutSeven(index)
            } else if layout == "8" {
                self.layoutEight(index)
            } else if layout == "9" {
                self.layoutNine(index)
            } else if layout == "10" {
                self.layoutTen(index)
            } else if layout == "11" {
                self.layoutEleven(index)
            } else if layout == "12" {
                self.layoutTwelve(index)
            } else if layout == "13" {
                self.layoutThirteen(index)
            } else if layout == "14" {
                self.layoutFourteen(index)
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
        
        attributes.frame = CGRectMake(0, self.sectionYOffsetWithSectionNumber(section), screenRect!.width , self.sectionFour)
        
        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
    }
    
    //MARK: Layout Five
    func layoutFive(section: Int) {
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Decoration View
        let decorationView: (attribute: UICollectionViewLayoutAttributes, key: String) = self.decorationViewWithYPosition(self.sectionYOffsetWithSectionNumber(section), sectionHeight: SectionHeight.sectionFive + SectionHeight.layoutHeader, path: path)
        
        self.layoutAttributes[decorationView.key] = decorationView.attribute
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(self.sectionYOffsetWithSectionNumber(section), path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
        //Add cells
        var xPosition: CGFloat = 0
        let verticalInset: CGFloat = 5.0
        
        let defaultYPosition: CGFloat = self.sectionYOffsetWithSectionNumber(section) + SectionHeight.layoutHeader
        
        var yPosition: CGFloat = defaultYPosition + verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
    
        var itemSize: CGSize = CGSizeZero
        let firstItemHeight: CGFloat = 220
        for var item = 0; item < 3; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            if item == 0 {
                let halfScreenWidth: CGFloat =  (screenRect!.width / 2)
                itemSize = CGSizeMake(halfScreenWidth, firstItemHeight)
                
                attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
                
                let key: String = self.layoutKeyForIndexPath(indexPath)
                self.layoutAttributes[key] = attribute
            } else {
                let rowHeight: CGFloat = (SectionHeight.sectionFive / 2) - (verticalInset * 2)
                let halfScreenWidth: CGFloat =  ( (screenRect!.width) / 2)
                itemSize = CGSizeMake(halfScreenWidth, rowHeight)
                xPosition = halfScreenWidth
                if item == 2 {
                    yPosition = yPosition + rowHeight + verticalInset
                } else {
                    yPosition = defaultYPosition + verticalInset
                }
                
                attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
                
                let key: String = self.layoutKeyForIndexPath(indexPath)
                self.layoutAttributes[key] = attribute
            }
        }
    }
    
    
    //MARK: - Layout Six
    func layoutSix(section: Int) {
        let horizontalInset: CGFloat = 2
        
        for var x = 0; x < 3; x++ {
            let indexPath = NSIndexPath(forItem: x, inSection: section)
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            if x == 0 {
                attributes.frame = CGRectMake(horizontalInset, self.sectionYOffsetWithSectionNumber(section), SectionHeight.sectionSixFirstCellWidth(), SectionHeight.sectionSix)
            } else if x == 1 {
                attributes.frame = CGRectMake(SectionHeight.sectionSixFirstCellWidth() + (horizontalInset * 2), self.sectionYOffsetWithSectionNumber(section), SectionHeight.sectionSixSecondCellWidth(), (SectionHeight.sectionSix -  horizontalInset) / 2)
            } else {
                let extraSpace: CGFloat = 2.0
                 attributes.frame = CGRectMake(SectionHeight.sectionSixFirstCellWidth() + (horizontalInset * 2), self.sectionYOffsetWithSectionNumber(section) + (SectionHeight.sectionSix / 2) + extraSpace, SectionHeight.sectionSixSecondCellWidth(), (SectionHeight.sectionSix -  horizontalInset) / 2)
            }
            
            let key = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attributes
        }
    }
    
    //MARK: Layout Seven
    func layoutSeven(section: Int) {
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Decoration View
        let decorationView: (attribute: UICollectionViewLayoutAttributes, key: String) = self.decorationViewWithYPosition(self.sectionYOffsetWithSectionNumber(section), sectionHeight: SectionHeight.sectionFive + SectionHeight.layoutHeader, path: path)
        
        self.layoutAttributes[decorationView.key] = decorationView.attribute
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(self.sectionYOffsetWithSectionNumber(section), path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
        //Add cells
        var xPosition: CGFloat = 0
        let verticalInset: CGFloat = 5.0
        
        let defaultYPosition: CGFloat = self.sectionYOffsetWithSectionNumber(section) + SectionHeight.layoutHeader
        
        var yPosition: CGFloat = defaultYPosition + verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        
        var itemSize: CGSize = CGSizeZero
        let firstItemHeight: CGFloat = 220
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            if item == 2 {
                let halfScreenWidth: CGFloat =  (screenRect!.width / 2)
                itemSize = CGSizeMake(halfScreenWidth, firstItemHeight)
                xPosition = halfScreenWidth
            } else {
                let rowHeight: CGFloat = (SectionHeight.sectionFive / 2) - (verticalInset * 2)
                let halfScreenWidth: CGFloat =  ( (screenRect!.width) / 2)
                itemSize = CGSizeMake(halfScreenWidth, rowHeight)
                xPosition = verticalInset
                if item == 0 {
                    yPosition = yPosition + rowHeight + verticalInset
                } else {
                    yPosition = defaultYPosition + verticalInset
                }
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
    }
    
    //MARK: - Layout Eight
    func layoutEight(section: Int) {
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(self.sectionYOffsetWithSectionNumber(section), path: indexPath)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.frame = CGRectMake(0, self.sectionYOffsetWithSectionNumber(section) + SectionHeight.layoutHeader, screenRect!.width , SectionHeight.sectionEight)
        
        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
    }
    
    //MARK: Layout Nine
    func layoutNine(section: Int) {
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(self.sectionYOffsetWithSectionNumber(section), path: indexPath)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
        attributes.frame = CGRectMake(0, self.sectionYOffsetWithSectionNumber(section) + SectionHeight.layoutHeader, screenRect!.width , SectionHeight.sectionNine)
        
        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
    }
    
    func layoutTen(section: Int) {
        let horizontalInset: CGFloat = 5.0
        var defaultYPosition = self.sectionYOffsetWithSectionNumber(section) + SectionHeight.layoutHeader + horizontalInset
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(self.sectionYOffsetWithSectionNumber(section), path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        //Add cells
        var xPosition: CGFloat = horizontalInset
        var yPosition: CGFloat = defaultYPosition
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        var itemSize: CGSize = CGSizeZero
        
        let screenWidth: CGFloat =  ((screenRect!.width - (horizontalInset * 3)) /  2)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            let cellHeight: CGFloat = 287
            
            itemSize = CGSizeMake(screenWidth, cellHeight)
            
            if (item + 1) % 2 != 0 {
                if (item + 1) != 1 {
                    xPosition = horizontalInset
                    yPosition = yPosition + cellHeight + horizontalInset
                }
            } else {
                if item != 0 {
                    xPosition = xPosition + screenWidth + horizontalInset
                }
                
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
    }
    
    //MARK: Layout Eleven
    func layoutEleven(section: Int) {
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        attributes.frame = CGRectMake(0, self.sectionYOffsetWithSectionNumber(section), screenRect!.width , SectionHeight.sectionEleven)
        
        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
    }
    
    //MARK: Layout Twelve
    func layoutTwelve(section: Int) {
        let horizontalInset: CGFloat = 5.0
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(self.sectionYOffsetWithSectionNumber(section) + horizontalInset, path: indexPath)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
        // size of the view/layout
        attributes.frame = CGRectMake(0, self.sectionYOffsetWithSectionNumber(section) + SectionHeight.layoutHeader + horizontalInset, screenRect!.width , SectionHeight.sectionTwelve)

        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
    }
    
    // MARK: Layout Thirteen
    func layoutThirteen(section: Int) {
        let horizontalInset: CGFloat = 0//5.0
        var defaultYPosition = self.sectionYOffsetWithSectionNumber(section) + 35.0//horizontalInset
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add cells
        var xPosition: CGFloat = horizontalInset
        var yPosition: CGFloat = defaultYPosition
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 0//8
        
        var itemSize: CGSize = CGSizeZero
        
        let screenWidth: CGFloat =  ((screenRect!.width - (horizontalInset * 3)) /  2)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            let cellHeight: CGFloat = 120
            
            itemSize = CGSizeMake(screenWidth, cellHeight)
            
            if (item + 1) % 2 != 0 {
                if (item + 1) != 1 {
                    xPosition = horizontalInset
                    yPosition = yPosition + cellHeight - 6.0// + horizontalInset
                }
            } else {
                if item != 0 {
                    itemSize.width += 4
                    xPosition = xPosition + screenWidth - 5.0// + horizontalInset
                }
                
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
    }
    
    // MARK: Layout Fourteen
    func layoutFourteen(section: Int) {
        let horizontalInset: CGFloat = 0//5.0
        var defaultYPosition = self.sectionYOffsetWithSectionNumber(section) + SectionHeight.layoutHeader + horizontalInset
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(self.sectionYOffsetWithSectionNumber(section), path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        //Add cells
        var xPosition: CGFloat = horizontalInset
        var yPosition: CGFloat = defaultYPosition
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 0//8
        
        var itemSize: CGSize = CGSizeZero
        
        let screenWidth: CGFloat =  ((screenRect!.width - (horizontalInset * 3)) /  2)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            let cellHeight: CGFloat = 120
            
            itemSize = CGSizeMake(screenWidth, cellHeight)
            
            if (item + 1) % 2 != 0 {
                if (item + 1) != 1 {
                    xPosition = horizontalInset
                    yPosition = yPosition + cellHeight - 6.0// + horizontalInset
                }
            } else {
                if item != 0 {
                    itemSize.width += 4
                    xPosition = xPosition + screenWidth - 5.0// + horizontalInset
                }
                
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
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
                 occupiedSpace = occupiedSpace + self.sectionFour + sectionVerticalInset
            } else if self.layouts[x] == "5" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionFive + sectionVerticalInset + SectionHeight.layoutHeader
            } else if self.layouts[x] == "6" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionSix + sectionVerticalInset
            } else if self.layouts[x] == "7" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionFive + sectionVerticalInset + SectionHeight.layoutHeader
            } else if self.layouts[x] == "8" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionEight + sectionVerticalInset + SectionHeight.layoutHeader
            } else if self.layouts[x] == "9" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionNine + sectionVerticalInset + SectionHeight.layoutHeader
            } else if self.layouts[x] == "10" {
                var numberOfItems: CGFloat = 0
                if self.homePageModel.data[section - 1].isKindOfClass(LayoutTenModel) {
                    let layoutTenModel: LayoutTenModel = self.homePageModel.data[section - 1] as! LayoutTenModel
                    numberOfItems = CGFloat(layoutTenModel.data.count) / 2.0
                } else {
                    let layoutTenModel: LayoutTenModel = self.homePageModel.data[x] as! LayoutTenModel
                    numberOfItems = CGFloat(layoutTenModel.data.count) / 2.0
                }
                
                
                var tempInset: CGFloat = 10
                
                
                if (numberOfItems - floor(numberOfItems) > 0.000001) { // 0.000001 can be changed depending on the level of precision you need
                    var items: Int = Int(numberOfItems)

                    let height: CGFloat = SectionHeight.sectionTen * CGFloat(items + 1)
                    occupiedSpace = occupiedSpace + height + SectionHeight.layoutHeader + (tempInset * CGFloat(items / 2)) + tempInset + tempInset
                } else {
                    let items: Int = Int(numberOfItems)
                    occupiedSpace = occupiedSpace + (SectionHeight.sectionTen * CGFloat(items)) + SectionHeight.layoutHeader + (tempInset * CGFloat(items / 2)) + tempInset
                }
            } else if self.layouts[x] == "11" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionEleven + sectionVerticalInset
            } else if self.layouts[x] == "12" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionTwelve + sectionVerticalInset + 5.0//SectionHeight.sectionThirteen + 5.0
            } else if self.layouts[x] == "13" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionThirteen + sectionVerticalInset
            } else if self.layouts[x] == "14" {
                occupiedSpace = occupiedSpace + SectionHeight.sectionFourteen + sectionVerticalInset
            }
            
        }
        
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
        let navigationBarHeight: CGFloat = 50.0
        return CGSizeMake(self.screenRect!.width, self.sectionYOffsetWithSectionNumber(self.layouts.count) + navigationBarHeight)
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
        return true
    }
    
    //MARK: - Decoration View
    func decorationViewWithYPosition(yPosition: CGFloat, sectionHeight: CGFloat, path: NSIndexPath) -> (attribute: UICollectionViewLayoutAttributes, key: String) {
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, yPosition, screenRect!.width, sectionHeight)
        decorationViewAttribute.zIndex = -1
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        return (decorationViewAttribute, decorationKey)
    }

    //MARK: - Header View With Y Position
    func headerViewWithYPosition(yPosition: CGFloat, path: NSIndexPath) -> (attribute: UICollectionViewLayoutAttributes, key: String) {
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = SectionHeight.layoutHeader
        headerAttribute.frame = CGRectMake(0, yPosition, self.collectionView!.frame.size.width, SectionHeight.layoutHeader)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        return (headerAttribute, headerKey)
    }
}
