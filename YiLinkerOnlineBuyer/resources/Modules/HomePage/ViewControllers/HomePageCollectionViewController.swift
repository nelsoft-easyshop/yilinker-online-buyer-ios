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
    var collectionView: UICollectionView?
    
    var dictionary: NSDictionary = NSDictionary()
    var layouts: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        if self.collectionView == nil {
            let layout: HomePageCollectionViewLayout = HomePageCollectionViewLayout()
            layout.layouts = layouts
            self.collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
            self.collectionView!.delegate = self
            self.collectionView!.dataSource = self
            self.collectionView?.backgroundColor = UIColor.clearColor()
            self.view.addSubview(self.collectionView!)
            self.registerCells()
            if dictionary.count != 0 || self.layouts.count != 0 {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func registerCells() {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return self.layouts.count
    }


    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.layouts[section] == "layout1" {
            return 1
        } else if self.layouts[section] == "layout2" {
            return 3
        } else if self.layouts[section] == "layout3" {
            return 3
        } else if self.layouts[section] == "layout4" {
            return 4
        } else if self.layouts[section] == "layout5" {
            return 6
        } else if self.layouts[section] == "layout6" {
            if let val: AnyObject = self.dictionary["itemsYouMayLike"] {
                let array: NSArray = self.dictionary["itemsYouMayLike"] as! NSArray
                return array.count
            } else {
                let array: NSArray = self.dictionary["shopByNewRelease"] as! NSArray
                return array.count
            }
        } else if layouts[section] == "layout7" {
            return 2
        } else if layouts[section] == "layout8" {
            return 1
        } else if layouts[section] == "layout9" {
            return 1
        } else if layouts[section] == "layout10" {
            let sellerArray: NSArray = self.dictionary["topSellers"] as! NSArray
            return sellerArray.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if self.layouts[indexPath.section] == "layout1" {
            let productDictionary: NSDictionary = dictionary["mainbanner"] as! NSDictionary
            let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
            let homeProductModel: HomePageProductModel = HomePageProductModel.parseDataWithDictionary(productDictionary)
            
            fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.productImageURL, placeholderImage: UIImage(named: "dummy-placeholder"))

            return fullImageColectionViewCell
        } else if self.layouts[indexPath.section] == "layout2" {
            
            var productDictionary: NSArray = NSArray()
            if let val: AnyObject = self.dictionary["subbanners"] {
                productDictionary = self.dictionary["subbanners"] as! NSArray
            } else if let val: AnyObject = self.dictionary["topbanners"] {
                productDictionary = self.dictionary["topbanners"] as! NSArray
            } else if let val: AnyObject = self.dictionary["bottomBanners"] {
                productDictionary = self.dictionary["bottomBanners"] as! NSArray
            }
            
            let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
            let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
            
            let homeProductModel: HomePageProductModel = homeProductModels[indexPath.row]
            fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.productImageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            
            return fullImageColectionViewCell
        } else if self.layouts[indexPath.section] == "layout3" {
            
            var homeProductModel: HomePageProductModel?
            var productArray: NSArray = NSArray()
            if let val: AnyObject = self.dictionary["promo"] {
                productArray = dictionary["promo"] as! NSArray
                var homeProductModels: [HomePageProductModel] = [HomePageProductModel]()
                homeProductModels = HomePageProductModel.parseDataWithArray(productArray)
                homeProductModel  = homeProductModels[indexPath.row]

            } else {
                let arrayDictionary: NSArray = self.dictionary["categories"] as! NSArray
                //hard coded for now
                let categoryDictionary: NSDictionary = arrayDictionary[0] as! NSDictionary
                
                productArray = categoryDictionary["images"] as! NSArray
                var homeProductModels: [HomePageProductModel] = [HomePageProductModel]()
                homeProductModels = HomePageProductModel.parseDataWithArray(productArray)
                homeProductModel  = homeProductModels[indexPath.row]
            }
            
            if indexPath.row == 0 {
                let fourImageCollectionViewCell: VerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("VerticalImageCollectionViewCell", forIndexPath: indexPath) as! VerticalImageCollectionViewCell
                fourImageCollectionViewCell.productItemImageView.sd_setImageWithURL(homeProductModel!.productImageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                fourImageCollectionViewCell.productNameLabel.text = homeProductModel!.productName
                
                if homeProductModel!.productDiscountedPrice != "" {
                    fourImageCollectionViewCell.discountedPriceLabel.text = "P \(homeProductModel!.productDiscountedPrice)"
                    fourImageCollectionViewCell.discountPercentageLabel.text = "\(homeProductModel!.productDiscountPercentage) %"
                } else {
                    fourImageCollectionViewCell.discountedPriceLabel.hidden = true
                    fourImageCollectionViewCell.discountPercentageLabel.hidden = true
                }
                
                return fourImageCollectionViewCell
            } else {
                let fourImageCollectionViewCell: HalfVerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("HalfVerticalImageCollectionViewCell", forIndexPath: indexPath) as! HalfVerticalImageCollectionViewCell
                
                fourImageCollectionViewCell.productItemImageView.sd_setImageWithURL(homeProductModel!.productImageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                fourImageCollectionViewCell.productNameLabel.text = homeProductModel!.productName
                
                if homeProductModel!.productDiscountedPrice != "" {
                    fourImageCollectionViewCell.discountedPriceLabel.text = "P \(homeProductModel!.productDiscountedPrice)"
                    fourImageCollectionViewCell.discountPercentageLabel.text = "\(homeProductModel!.productDiscountPercentage) %"
                } else {
                    fourImageCollectionViewCell.discountedPriceLabel.hidden = true
                    fourImageCollectionViewCell.discountPercentageLabel.hidden = true
                }
             
                return fourImageCollectionViewCell
            }
            
        } else if self.layouts[indexPath.section] == "layout4" {
            var homeProductModel: HomePageProductModel?
            var productArray: NSArray = NSArray()
            
            if let val: AnyObject = self.dictionary["popularCategories"] {
                let productDictionary: NSArray = dictionary["popularCategories"] as! NSArray
                 let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
                homeProductModel = homeProductModels[indexPath.row]
            } else {
                let arrayDictionary: NSArray = self.dictionary["categories"] as! NSArray
                //hard coded for now
                let categoryDictionary: NSDictionary = arrayDictionary[1] as! NSDictionary
                
                productArray = categoryDictionary["images"] as! NSArray
                var homeProductModels: [HomePageProductModel] = [HomePageProductModel]()
                homeProductModels = HomePageProductModel.parseDataWithArray(productArray)
                homeProductModel  = homeProductModels[indexPath.row]
            }
            
            let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
           
            fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel!.productImageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            return fullImageColectionViewCell

        }  else if self.layouts[indexPath.section] == "layout5" {
            let productDictionary: NSArray = dictionary["trendingItems"] as! NSArray
            let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
            let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
            
            let homeProductModel: HomePageProductModel = homeProductModels[indexPath.row]
            fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.productImageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            
            return fullImageColectionViewCell
            
        } else if self.layouts[indexPath.section] == "layout6" {
            let twoColumnGridCollectionViewCell: TwoColumnGridCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("TwoColumnGridCollectionViewCell", forIndexPath: indexPath) as! TwoColumnGridCollectionViewCell
            
            var productArray: NSArray = NSArray()
            var homeProductModel: HomePageProductModel?
            
            if let val: AnyObject = self.dictionary["shopByNewRelease"] {
                productArray = dictionary["shopByNewRelease"] as! NSArray
                
                let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productArray)
                 homeProductModel = homeProductModels[indexPath.row]
            } else {
                productArray = dictionary["itemsYouMayLike"] as! NSArray
                let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productArray)
                homeProductModel = homeProductModels[indexPath.row]
            }
           
            twoColumnGridCollectionViewCell.productItemImageView.sd_setImageWithURL(homeProductModel!.productImageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            return twoColumnGridCollectionViewCell
        } else if self.layouts[indexPath.section] == "layout7"  {
            let productItemWithVerticalDisplay: ProductItemWithVerticalDisplayCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("ProductItemWithVerticalDisplayCollectionViewCell", forIndexPath: indexPath) as! ProductItemWithVerticalDisplayCollectionViewCell
            
            let productDictionary: NSArray = dictionary["toppicks"] as! NSArray
            let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
            
            let homeProductModel: HomePageProductModel = homeProductModels[indexPath.row]
            productItemWithVerticalDisplay.productItemImageView.sd_setImageWithURL(homeProductModel.productImageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            productItemWithVerticalDisplay.originalPriceLabel.text = homeProductModel.productOriginalPrice
            productItemWithVerticalDisplay.productNameLabel.text = homeProductModel.productName
          
            if homeProductModel.productDiscountedPrice != "" {
                productItemWithVerticalDisplay.discountedPriceLabel.text = "P \(homeProductModel.productDiscountedPrice)"
                productItemWithVerticalDisplay.discountPercentageLabel.text = "\(homeProductModel.productDiscountPercentage) %"
            } else {
                productItemWithVerticalDisplay.discountedPriceLabel.hidden = true
                productItemWithVerticalDisplay.discountPercentageLabel.hidden = true
            }
            
            return productItemWithVerticalDisplay
        } else if layouts[indexPath.section] == "layout8" {
            let scrollableCell: ScrollableCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("ScrollableCollectionViewCell", forIndexPath: indexPath) as! ScrollableCollectionViewCell
            var productHomeModels: [HomePageProductModel] = [HomePageProductModel]()
            let products: NSArray = self.dictionary["shopByCategories"] as! NSArray
            
            for (index, product) in enumerate(products) {
                let productDictionary: NSDictionary = product as! NSDictionary
                let productModel = HomePageProductModel.parseDataWithDictionary(productDictionary)
                productHomeModels.append(productModel)
            }
            
            scrollableCell.productModels = productHomeModels
            
            return scrollableCell
        } else if layouts[indexPath.section] == "layout9" {
            let scrollableCell: NewSellerScrollableCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("NewSellerScrollableCollectionViewCell", forIndexPath: indexPath) as! NewSellerScrollableCollectionViewCell
            
            var productHomeModels: [HomePageProductModel] = [HomePageProductModel]()
            let products: NSArray = self.dictionary["newSellers"] as! NSArray
            
            for (index, product) in enumerate(products) {
                let productDictionary: NSDictionary = product as! NSDictionary
                let productModel = HomePageProductModel.parseDataWithDictionary(productDictionary)
                productHomeModels.append(productModel)
            }
            
            
            scrollableCell.productModels = productHomeModels
            
            return scrollableCell
        } else if layouts[indexPath.section] == "layout10" {
            let sellerCollectionView: SellerCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("SellerCollectionViewCell", forIndexPath: indexPath) as! SellerCollectionViewCell
            let sellerArray: NSArray = self.dictionary["topSellers"] as! NSArray
            
            let sellerDictionary: NSDictionary = sellerArray[indexPath.row] as! NSDictionary
            
            let sellerModel: SellerModel = SellerModel.parseDataFromDictionary(sellerDictionary)
            
            sellerCollectionView.sellerTitleLabel.text = sellerModel.name
            sellerCollectionView.sellerSubTitleLabel.text = sellerModel.specialty
            sellerCollectionView.sellerProfileImageView.sd_setImageWithURL(sellerModel.avatar, placeholderImage: UIImage(named: "dummy-placeholder"))
            
            sellerCollectionView.productOneImageView.sd_setImageWithURL(NSURL(string: sellerModel.images[0] as! String)!, placeholderImage: UIImage(named: "dummy-placeholder"))
            sellerCollectionView.productTwoImageView.sd_setImageWithURL(NSURL(string: sellerModel.images[1] as! String)!, placeholderImage: UIImage(named: "dummy-placeholder"))
            sellerCollectionView.productThreeImageView.sd_setImageWithURL(NSURL(string: sellerModel.images[2] as! String)!, placeholderImage: UIImage(named: "dummy-placeholder"))
            
            return sellerCollectionView
        } else {
            let productDictionary: NSArray = dictionary["mainbanner"] as! NSArray
            let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
            let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
            
            let homeProductModel: HomePageProductModel = homeProductModels[indexPath.row]
            println(homeProductModel.productImageURL)
            fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.productImageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            
            return fullImageColectionViewCell
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

            let headerView: LayoutHeaderCollectionViewCell = self.collectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "LayoutHeaderCollectionViewCell", forIndexPath: indexPath) as! LayoutHeaderCollectionViewCell
            
            if self.layouts[indexPath.section] == "layout1" {
                
            } else if self.layouts[indexPath.section] == "layout2" {
                
            } else if self.layouts[indexPath.section] == "layout3" {
                if let val: AnyObject = dictionary["promo"] {
                    headerView.titleLabel.text = "Today's Promo"
                } else {
                    let arrayCategory: NSArray = self.dictionary["categories"] as! NSArray
                    let dictionaryCategory: NSDictionary = arrayCategory[0] as! NSDictionary
                    headerView.titleLabel.text = dictionaryCategory["categoryName"] as? String
                }

            } else if self.layouts[indexPath.section] == "layout4" {
                if let val: AnyObject = dictionary["popularCategories"] {
                    headerView.titleLabel.text = "Popular Categories"
                } else {
                    let arrayCategory: NSArray = self.dictionary["categories"] as! NSArray
                    let dictionaryCategory: NSDictionary = arrayCategory[1] as! NSDictionary
                    headerView.titleLabel.text = dictionaryCategory["categoryName"] as? String
                }
            } else if self.layouts[indexPath.section] == "layout5" {
                headerView.titleLabel.text = "Trending Items"
            } else if self.layouts[indexPath.section] == "layout9" {
                 headerView.titleLabel.text = "New Sellers"
            }

                
                return headerView
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = 0
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
//    func tapProductWithTarget(target: String, targetType: String) {
//        println("target: \(target) \n target type: \(targetType)")
//    }
}
