//
//  HomePageCollectionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class HomePageCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var section1: [String] = ["dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder"]
    var section2: [String] = ["dummy-placeholder", "dummy-placeholder", "dummy-placeholder"]
    var section3: [String] = ["dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder"]
    var section4: [String] = ["dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder"]
    var section5: [String] = ["dummy-placeholder", "dummy-placeholder"]
    var section6: [String] = ["dummy-placeholder", "dummy-placeholder", "dummy-placeholder"]
    var section7: [String] = ["dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder"]

    //seller
    var section8: [String] = ["dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder"]
    //new seller
    var section9: [String] = ["dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder"]
    
    var section10: [String] = ["dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder", "dummy-placeholder"]
    
    var sections: NSMutableArray?
    var collectionView: UICollectionView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        self.sections = NSMutableArray()
        self.sections?.addObject(section1)
        self.sections?.addObject(section2)
        self.sections?.addObject(section3)
        self.sections?.addObject(section4)
        self.sections?.addObject(section5)
        self.sections?.addObject(section6)
        self.sections?.addObject(section7)
        self.sections?.addObject(section8)
        self.sections?.addObject(section9)
        self.sections?.addObject(section10)
    }
    
    override func viewDidLayoutSubviews() {
        if self.collectionView == nil {
            let layout: HomePageCollectionViewLayout = HomePageCollectionViewLayout()
            self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
            self.collectionView!.delegate = self
            self.collectionView!.dataSource = self
            self.collectionView?.backgroundColor = UIColor.clearColor()
            self.view.addSubview(self.collectionView!)
            
            var fullImageCollectionViewNib: UINib = UINib(nibName: "FullImageCollectionViewCell", bundle:nil)
            collectionView?.registerNib(fullImageCollectionViewNib, forCellWithReuseIdentifier: "FullImageCollectionViewCell")
            
            var layoutHeaderCollectionViewNib: UINib = UINib(nibName: "LayoutHeaderCollectionViewCell", bundle: nil)
            collectionView?.registerNib(layoutHeaderCollectionViewNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "LayoutHeaderCollectionViewCell")
            
            var verticalImageCollectionViewCell: UINib = UINib(nibName: "VerticalImageCollectionViewCell", bundle: nil)
            collectionView?.registerNib(verticalImageCollectionViewCell, forCellWithReuseIdentifier: "VerticalImageCollectionViewCell")
            
            var halfVerticalCollectionViewCellNib = UINib(nibName: "HalfVerticalImageCollectionViewCell", bundle: nil)
            collectionView?.registerNib(halfVerticalCollectionViewCellNib, forCellWithReuseIdentifier: "HalfVerticalImageCollectionViewCell")
            
            var decorationViewNib: UINib = UINib(nibName: "SectionBackground", bundle: nil)
            // CollectionView.CollectionViewLayout.RegisterClassForDecorationView 
            self.collectionView?.collectionViewLayout.registerNib(decorationViewNib, forDecorationViewOfKind: "SectionBackground")
            //ProductItemWithVerticalDisplayCollectionViewCell
            
            var productItemWithVerticalDisplayNib: UINib = UINib(nibName: "ProductItemWithVerticalDisplayCollectionViewCell", bundle: nil)
            self.collectionView?.registerNib(productItemWithVerticalDisplayNib, forCellWithReuseIdentifier: "ProductItemWithVerticalDisplayCollectionViewCell")
            
            var footerNib = UINib(nibName: "ViewMoreFooterCollectionViewCell", bundle: nil)
              collectionView?.registerNib(footerNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "ViewMoreFooterCollectionViewCell")
            
            var scrollableCellNib: UINib = UINib(nibName: "ScrollableCollectionViewCell", bundle: nil)
            self.collectionView?.registerNib(scrollableCellNib, forCellWithReuseIdentifier: "ScrollableCollectionViewCell")
            
            var sellerCollectionViewCellNib: UINib = UINib(nibName: "SellerCollectionViewCell", bundle: nil)
            self.collectionView?.registerNib(sellerCollectionViewCellNib, forCellWithReuseIdentifier: "SellerCollectionViewCell")
            
            var newSellerNib: UINib = UINib(nibName: "NewSellerScrollableCollectionViewCell", bundle: nil)
            self.collectionView?.registerNib(newSellerNib, forCellWithReuseIdentifier: "NewSellerScrollableCollectionViewCell")
            
            var twoColumnCellNib: UINib = UINib(nibName: "TwoColumnGridCollectionViewCell", bundle: nil)
            self.collectionView?.registerNib(twoColumnCellNib, forCellWithReuseIdentifier: "TwoColumnGridCollectionViewCell")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return self.sections!.count
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        
        //let sectionCount: [String] = sections?.objectAtIndex(section) as! Array
        let items: NSArray = self.sections?.objectAtIndex(section) as! NSArray
        if section == 6 || section == 8 {
            return 1
        } else {
            return items.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
            
            let sectionItems: NSArray = self.sections?.objectAtIndex(indexPath.section) as! NSArray
            
            fullImageColectionViewCell.itemProductImageView.image = UIImage(named: sectionItems[indexPath.row] as! String)
            return fullImageColectionViewCell
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                let fourImageCollectionViewCell: VerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("VerticalImageCollectionViewCell", forIndexPath: indexPath) as! VerticalImageCollectionViewCell
                
                let sectionItems: NSArray = self.sections?.objectAtIndex(indexPath.section) as! NSArray
                
                fourImageCollectionViewCell.productItemImageView.image = UIImage(named: sectionItems[indexPath.row] as! String)
                
                return fourImageCollectionViewCell
            } else {
                let fourImageCollectionViewCell: HalfVerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("HalfVerticalImageCollectionViewCell", forIndexPath: indexPath) as! HalfVerticalImageCollectionViewCell
                
                let sectionItems: NSArray = self.sections?.objectAtIndex(indexPath.section) as! NSArray
                
                fourImageCollectionViewCell.productItemImageView.image = UIImage(named: sectionItems[indexPath.row] as! String)
                
                return fourImageCollectionViewCell
            }
          
        } else if indexPath.section == 4 {
            let productItemWithVerticalDisplay: ProductItemWithVerticalDisplayCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("ProductItemWithVerticalDisplayCollectionViewCell", forIndexPath: indexPath) as! ProductItemWithVerticalDisplayCollectionViewCell
            let sectionItems: NSArray = self.sections?.objectAtIndex(indexPath.section) as! NSArray
            
            productItemWithVerticalDisplay.productItemImageView.image = UIImage(named: sectionItems[indexPath.row] as! String)
            return productItemWithVerticalDisplay
        } else if indexPath.section == 6 {
            let scrollableCell: ScrollableCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("ScrollableCollectionViewCell", forIndexPath: indexPath) as! ScrollableCollectionViewCell
            let sectionItems: NSArray = self.sections?.objectAtIndex(indexPath.section) as! NSArray
            
            var models: [HomePageProductModel] = [HomePageProductModel]()
            
            for var x = 0; x < 10; x++ {
                let productModel: HomePageProductModel = HomePageProductModel(productName: "", productImageURL: NSURL(string: "")!, productOriginalPrice: 0, productDiscountedPrice: 0, productDiscountPercentage: 0, productSlug: "", productAction: "", productTargetUrl: "")
                
                models.append(productModel)
            }
            
            scrollableCell.productModels = models
            
            return scrollableCell
        } else if indexPath.section == 7 {
            let sellerCollectionView: SellerCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("SellerCollectionViewCell", forIndexPath: indexPath) as! SellerCollectionViewCell
            
            return sellerCollectionView
            
        } else if indexPath.section == 8 {
            let scrollableCell: NewSellerScrollableCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("NewSellerScrollableCollectionViewCell", forIndexPath: indexPath) as! NewSellerScrollableCollectionViewCell
            let sectionItems: NSArray = self.sections?.objectAtIndex(indexPath.section) as! NSArray
            
            var models: [HomePageProductModel] = [HomePageProductModel]()
            
            for var x = 0; x < 10; x++ {
                let productModel: HomePageProductModel = HomePageProductModel(productName: "", productImageURL: NSURL(string: "")!, productOriginalPrice: 0, productDiscountedPrice: 0, productDiscountPercentage: 0, productSlug: "", productAction: "", productTargetUrl: "")
                
                models.append(productModel)
            }
            
            scrollableCell.productModels = models
            
            return scrollableCell
        } else if indexPath.section == 9 {
            let twoColumnGridCollectionViewCell: TwoColumnGridCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("TwoColumnGridCollectionViewCell", forIndexPath: indexPath) as! TwoColumnGridCollectionViewCell
            
            let sectionItems: NSArray = self.sections?.objectAtIndex(indexPath.section) as! NSArray
            
            return twoColumnGridCollectionViewCell
        } else {
            
            let fullImageCollectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
            
            let sectionItems: NSArray = self.sections?.objectAtIndex(indexPath.section) as! NSArray
            
            fullImageCollectionViewCell.itemProductImageView.image = UIImage(named: sectionItems[indexPath.row] as! String)
            return fullImageCollectionViewCell
        }
       
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == "UICollectionElementKindSectionFooter" {
            if indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 {
                let footerView = self.collectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ViewMoreFooterCollectionViewCell", forIndexPath: indexPath) as! ViewMoreFooterCollectionViewCell
                
                return footerView
            } else {
                return UICollectionReusableView(frame: CGRectMake(0, 0, 0, 0))
            }
            
        } else {
            if indexPath.section == 1 || indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4 || indexPath.section == 5 || indexPath.section == 6 || indexPath.section == 7 || indexPath.section == 8 || indexPath.section == 9 {
                let headerView = self.collectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "LayoutHeaderCollectionViewCell", forIndexPath: indexPath) as! LayoutHeaderCollectionViewCell
                
                return headerView
            } else {
                return UICollectionReusableView(frame: CGRectMake(0, 0, 0, 0))
            }
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = 0
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
}
