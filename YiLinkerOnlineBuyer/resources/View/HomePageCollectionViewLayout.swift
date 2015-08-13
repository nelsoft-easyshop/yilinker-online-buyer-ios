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
    let sectionVeticalInset: CGFloat = 15.0
    let sectionHeight: CGFloat = 240.0
    var screenRect: CGRect?
    var numberOfSections: Int?
    
    var currentScreenHeigth: CGFloat = 0.0
    
    var layouts: [String] = []
    
    override func prepareLayout() {
        super.prepareLayout()
        self.collectionView?.layoutIfNeeded()
        self.screenRect = self.collectionView!.bounds
        self.layoutAttributes = Dictionary<String, UICollectionViewLayoutAttributes>()
        self.numberOfSections  = self.collectionView?.numberOfSections()
        
        for (index, layout) in enumerate(layouts) {
            if layout == Constants.HomePage.layoutOneKey {
                self.bannerLayout(index)
            } else if layout == Constants.HomePage.layoutTwoKey {
                self.subBannerLayout(index)
            } else if layout == Constants.HomePage.layoutThreeKey {
                self.threeImageLayout2(index)
            } else if layout == Constants.HomePage.layoutFourKey {
                self.fourImageLayout(index)
            } else if layout == Constants.HomePage.layoutFiveKey {
                self.sixImageLayout(index)
            } else if layout == Constants.HomePage.layoutSixKey {
                self.twoColumnGridLayout(index)
            } else if layout == Constants.HomePage.layoutSevenKey {
                self.twoImageLayout(index)
            } else if layout == Constants.HomePage.layoutEightKey {
                self.scrollableImageLayout(index)
            } else if layout == Constants.HomePage.layoutNineKey {
                self.newSellerScrollableImageLayout(index)
            } else if layout == Constants.HomePage.layoutTenKey {
                self.sellerLayout(index)
            }
        }
       
    }
    
    
    
    func bannerLayout(section: Int) {
        let defaultYPosition = self.currentScreenHeigth

        var xPosition: CGFloat = self.horizontalInset
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        var item = 0
        
        let indexPath = NSIndexPath(forItem: item, inSection: section)
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        
        var itemSize: CGSize = CGSizeMake(0, 0)
        
        if item == 0 {
            let mainBannerHeightSize: CGFloat = 140.0
            itemSize = CGSizeMake(screenRect!.width + horizontalInset, mainBannerHeightSize)
            xPosition = 0
            yPosition = defaultYPosition
        }
        
        attributes.frame = CGRectMake(xPosition, yPosition, itemSize.width , itemSize.height)
        
        let key = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attributes
        
        yPosition = yPosition + itemSize.height + self.horizontalInset
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    
    func threeImageLayout2(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Decoration View
        let decorationView: (attribute: UICollectionViewLayoutAttributes, key: String) = decorationViewWithYPosition(defaultYPosition + self.headerViewHeight, path: path)
        
        self.layoutAttributes[decorationView.key] = decorationView.attribute
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
    
        //Add cells
        var xPosition: CGFloat = 0
        defaultYPosition = defaultYPosition + headerViewHeight
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        
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
                } else {
                    yPosition = defaultYPosition + self.verticalInset
                }
            }

            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.verticalInset

        //Add Footer View
        let footerView: (attribute: UICollectionViewLayoutAttributes, key: String) = footerViewWithYPosition(yPosition, path: path)
        self.layoutAttributes[footerView.key] = footerView.attribute
        
        let height: CGFloat = yPosition + self.footerHeight
        self.currentScreenHeigth = height
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    func sixImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Decoration View
        let decorationView: (attribute: UICollectionViewLayoutAttributes, key: String) = decorationViewWithYPosition(defaultYPosition + self.headerViewHeight, path: path)
        
        self.layoutAttributes[decorationView.key] = decorationView.attribute
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute

        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight + self.sectionVeticalInset

        var yPosition: CGFloat = defaultYPosition
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        var itemSize: CGSize = CGSizeZero
        
        let halfScreenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * 3)) /  2)
        
        let box1Height: CGFloat = 95
        let box2Width : CGFloat = 80
        let smallBoxInLeft: CGFloat = 2.0
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            if item == 0 {
                itemSize = CGSizeMake(halfScreenWidth, box1Height)
            } else if item == 1 || item == 2 {
                itemSize = CGSizeMake((halfScreenWidth - self.horizontalInset) / smallBoxInLeft , box2Width)
                if item == 1 {
                    yPosition = yPosition + self.horizontalInset + box1Height
                } else {
                    xPosition = self.horizontalInset + itemSize.width + xPosition
                }
            } else if item == 3 {
                let cellItemHeight: CGFloat = 182
                let cellItemWidth: CGFloat = halfScreenWidth / 2.2
                
                xPosition = halfScreenWidth + (self.horizontalInset * 2)
                yPosition = defaultYPosition
                
                itemSize = CGSizeMake(cellItemWidth, cellItemHeight)
            } else {
                let cellItemWidth: CGFloat = (halfScreenWidth / 2 )
                let cellHeight: CGFloat = (182 - verticalInset) / 2
                let horizontalInsets: CGFloat = self.horizontalInset * 3
                
                xPosition = halfScreenWidth + (halfScreenWidth / 2.2) + horizontalInsets
                
                if item == 5 {
                    yPosition = yPosition + itemSize.height + self.verticalInset
                }
                
                itemSize = CGSizeMake(cellItemWidth, cellHeight)
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)

            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + self.sectionVeticalInset + self.headerViewHeight
        
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    func sixImageLayout2(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Decoration View
        let decorationView: (attribute: UICollectionViewLayoutAttributes, key: String) = decorationViewWithYPosition(defaultYPosition + self.headerViewHeight, path: path)
        
        self.layoutAttributes[decorationView.key] = decorationView.attribute
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute

        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight + self.sectionVeticalInset
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let insets: CGFloat = 3
        let halfScreenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * insets)) /  2)
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)

            let leftBoxHeight: CGFloat = 80
            let box2Height: CGFloat = 95
            
            if item == 0 || item == 1 {
                itemSize = CGSizeMake((halfScreenWidth - self.horizontalInset) / 2 , leftBoxHeight)
                if item == 1 {
                    xPosition = self.horizontalInset + itemSize.width + xPosition
                }
            } else if item == 2 {
                xPosition = self.horizontalInset
                yPosition = yPosition + itemSize.height + self.verticalInset
                itemSize = CGSizeMake(halfScreenWidth, box2Height)
            } else if item == 3 || item == 4 {
                let cellItemWidth: CGFloat = (halfScreenWidth / 2)
                var cellHeight: CGFloat = 0
                if item == 4 {
                    yPosition = yPosition + itemSize.height + self.verticalInset
                    cellHeight = box2Height
                } else {
                    cellHeight = leftBoxHeight
                    xPosition = xPosition + itemSize.width + self.horizontalInset
                    yPosition = defaultYPosition + self.verticalInset
                }
                
                itemSize = CGSizeMake(cellItemWidth, cellHeight)
                
            } else if item == 5 {
                let cellItemWidth: CGFloat = (halfScreenWidth / 2)
                var cellHeight: CGFloat = 0
                let bigBoxHeight: CGFloat = 180
                
                xPosition = xPosition + self.horizontalInset + cellItemWidth
                yPosition = defaultYPosition + self.verticalInset
                itemSize = CGSizeMake(halfScreenWidth / 2.2, bigBoxHeight)
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + self.sectionHeight
        
        //Add Footer View
        let footerView: (attribute: UICollectionViewLayoutAttributes, key: String) = footerViewWithYPosition(yPosition, path: path)
        self.layoutAttributes[footerView.key] = footerView.attribute
        
        let height: CGFloat = yPosition + self.footerHeight
        
        self.currentScreenHeigth = height
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    func twoImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Decoration View
        let decorationView: (attribute: UICollectionViewLayoutAttributes, key: String) = decorationViewWithYPosition(defaultYPosition + self.headerViewHeight, path: path)
        
        self.layoutAttributes[decorationView.key] = decorationView.attribute
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight + 20
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let insets: CGFloat = 3
        let halfScreenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * insets)) /  2)
        
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
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + self.sectionVeticalInset
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    func threeImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Decoration View
        let decorationView: (attribute: UICollectionViewLayoutAttributes, key: String) = decorationViewWithYPosition(defaultYPosition + self.headerViewHeight, path: path)
        
        self.layoutAttributes[decorationView.key] = decorationView.attribute
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
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
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + self.sectionVeticalInset
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
        
    }
    
    func subBannerLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        var xPosition: CGFloat = self.horizontalInset
        var yPosition: CGFloat = defaultYPosition
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        let insets: CGFloat = 4
        let cellCount: CGFloat = 3
        let screenWidth: CGFloat =  ((screenRect!.width - (self.horizontalInset * insets)) /  cellCount)
        
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
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + self.sectionVeticalInset
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
    }
    
    
    func scrollableImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        //Add header view
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
    
        let indexPath = NSIndexPath(forItem: 0, inSection: section)
        let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        let cellHeight: CGFloat = 180
        
        itemSize = CGSizeMake(self.screenRect!.width, cellHeight)
        
        attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
        
        let key: String = self.layoutKeyForIndexPath(indexPath)
        self.layoutAttributes[key] = attribute
        
        yPosition = yPosition + itemSize.height + horizontalInset + self.sectionVeticalInset
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
        
    }
    
    func sellerLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)

        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight
        var yPosition: CGFloat = defaultYPosition + verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        let initialMargin: CGFloat = 8
        
        let fullSectionItemHeight: CGFloat = 230
        var itemSize: CGSize = CGSizeZero
        
        let insets: CFloat = 3
        
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
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + self.sectionVeticalInset
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)

    }
    
    func newSellerScrollableImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        
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
        
        yPosition = yPosition + itemSize.height + horizontalInset + self.sectionVeticalInset
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
        
    }
    
    func twoColumnGridLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + self.headerViewHeight + self.sectionVeticalInset
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
        
        yPosition = yPosition + itemSize.height + self.horizontalInset + self.sectionVeticalInset
        xPosition = 0
        
        self.currentScreenHeigth = yPosition
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
        
        let multiplier: Int = Int(((CGFloat(numberOfItems!) + 1) / 2))
        let insets: CGFloat = (CGFloat(numberOfItems!) + 1) * verticalInset
        let decorationViewHeight: CGFloat = 287 * CGFloat(multiplier) + insets
        
        //Add decoration view
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, defaultYPosition, screenRect!.width, decorationViewHeight)
        decorationViewAttribute.zIndex = -1
        
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        self.layoutAttributes[decorationKey] = decorationViewAttribute
    }
    
    func fourImageLayout(section: Int) {
        var defaultYPosition = self.currentScreenHeigth
        
        let path = NSIndexPath(forItem: 0, inSection: section)
        
        //Add Decoration View
        let decorationView: (attribute: UICollectionViewLayoutAttributes, key: String) = decorationViewWithYPosition(defaultYPosition + self.headerViewHeight, path: path)
        
        self.layoutAttributes[decorationView.key] = decorationView.attribute
        
        //Add Header View
        let headerView: (attribute: UICollectionViewLayoutAttributes, key: String) = headerViewWithYPosition(defaultYPosition, path: path)
        self.layoutAttributes[headerView.key] = headerView.attribute

        
        //Add cells
        var xPosition: CGFloat = self.horizontalInset
        defaultYPosition = defaultYPosition + headerViewHeight
        var yPosition: CGFloat = defaultYPosition + self.verticalInset
        
        let numberOfItems = self.collectionView?.numberOfItemsInSection(section)
        
        let fullSectionItemHeight: CGFloat = 225
        var itemSize: CGSize = CGSizeZero
        
        for var item = 0; item < numberOfItems; item++ {
            let indexPath = NSIndexPath(forItem: item, inSection: section)
            let attribute = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
            
            if item == 0 {
                let screenWidth: CGFloat =  screenRect!.width * 0.35
                itemSize = CGSizeMake(screenWidth, fullSectionItemHeight)
            } else if item == 1 {
                xPosition = xPosition + horizontalInset + itemSize.width
                let screenWidth: CGFloat =  screenRect!.width - (self.horizontalInset) - (self.screenRect!.width * 0.35)
                itemSize = CGSizeMake(screenWidth - 10, 110)
            } else if item == 2 {
                let screenWidth: CGFloat =  (itemSize.width - self.horizontalInset) / 2
                itemSize = CGSizeMake(screenWidth, 110)
                yPosition = yPosition + self.verticalInset + itemSize.height
            } else if item == 3 {
                itemSize = CGSizeMake(itemSize.width, 110)
                xPosition = xPosition + self.horizontalInset + itemSize.width
            }
            
            attribute.frame = CGRectMake(xPosition, yPosition, itemSize.width, itemSize.height)
            
            let key: String = self.layoutKeyForIndexPath(indexPath)
            self.layoutAttributes[key] = attribute
        }
        
        yPosition = yPosition + itemSize.height + self.verticalInset
  
        //Add Footer View
        let footerView: (attribute: UICollectionViewLayoutAttributes, key: String) = footerViewWithYPosition(yPosition, path: path)
        self.layoutAttributes[footerView.key] = footerView.attribute
        
        let height: CGFloat = yPosition + self.footerHeight + sectionVeticalInset
        
        self.currentScreenHeigth = height
        self.contentSize = CGSizeMake(screenRect!.width, self.currentScreenHeigth)
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
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return !CGSizeEqualToSize(newBounds.size, self.collectionView!.frame.size)
    }
    
    func decorationViewWithYPosition(yPosition: CGFloat, path: NSIndexPath) -> (attribute: UICollectionViewLayoutAttributes, key: String) {
        let decorationViewAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: "SectionBackground", withIndexPath: path)
        decorationViewAttribute.frame = CGRectMake(0, yPosition, screenRect!.width, sectionHeight)
        decorationViewAttribute.zIndex = -1
        let decorationKey: String = self.layoutKeyForDecorationViewAtIndexPath(path)
        return (decorationViewAttribute, decorationKey)
    }
    
    func headerViewWithYPosition(yPosition: CGFloat, path: NSIndexPath) -> (attribute: UICollectionViewLayoutAttributes, key: String) {
        let headerAttribute = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withIndexPath: path)
        let headerHeight = self.headerViewHeight
        headerAttribute.frame = CGRectMake(0, yPosition, self.collectionView!.frame.size.width, headerHeight)
        let headerKey = layoutKeyForHeaderAtIndexPath(path)
        return (headerAttribute, headerKey)
    }
    
    func footerViewWithYPosition(yPosition: CGFloat, path: NSIndexPath) -> (attribute: UICollectionViewLayoutAttributes, key: String) {
        let footerAttribute: UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withIndexPath: path)
        footerAttribute.frame = CGRectMake(0, yPosition, self.screenRect!.width, self.footerHeight)
        let footerKey = layoutKeyForFooterAtIndexPath(path)
        return (footerAttribute, footerKey)
    }

}
