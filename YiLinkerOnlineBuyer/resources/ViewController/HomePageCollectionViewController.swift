//
//  HomePageCollectionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

let reuseIdentifier = "Cell"

class HomePageCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, ScrollableCollectionViewCellDelegate, NewSellerScrollableCollectionViewCellDelegate, ViewMoreFooterCollectionViewCellDelegate, SellerCollectionViewCellDelegate {
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
        
        self.navigationController?.navigationBar.alpha = 1.0
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
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
        if self.layouts[section] == Constants.HomePage.layoutOneKey {
            return 1
        } else if self.layouts[section] == Constants.HomePage.layoutTwoKey {
            return 3
        } else if self.layouts[section] == Constants.HomePage.layoutThreeKey {
            return 3
        } else if self.layouts[section] == Constants.HomePage.layoutFourKey {
            return 4
        } else if self.layouts[section] == Constants.HomePage.layoutFiveKey {
            return 6
        } else if self.layouts[section] == Constants.HomePage.layoutSixKey {
            if let val: AnyObject = self.dictionary["itemsYouMayLike"] {
                let array: NSArray = self.dictionary["itemsYouMayLike"] as! NSArray
                return array.count
            } else {
                let array: NSArray = self.dictionary["shopByNewRelease"] as! NSArray
                return array.count
            }
        } else if layouts[section] == Constants.HomePage.layoutSevenKey {
            return 2
        } else if layouts[section] == Constants.HomePage.layoutEightKey {
            return 1
        } else if layouts[section] == Constants.HomePage.layoutNineKey {
            return 1
        } else if layouts[section] == Constants.HomePage.layoutTenKey {
            let sellerArray: NSArray = self.dictionary["topSellers"] as! NSArray
            return sellerArray.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if self.layouts[indexPath.section] == Constants.HomePage.layoutOneKey {
            let productDictionary: NSDictionary = dictionary["mainBanner"] as! NSDictionary
            let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
            let homeProductModel: HomePageProductModel = HomePageProductModel.parseDataWithDictionary(productDictionary)

            fullImageColectionViewCell.targetType = homeProductModel.targetType
            fullImageColectionViewCell.target = homeProductModel.target
            
            fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            return fullImageColectionViewCell
        } else if self.layouts[indexPath.section] == Constants.HomePage.layoutTwoKey {
            
            var productDictionary: NSArray = NSArray()
            if let val: AnyObject = self.dictionary["subBanners"] {
                productDictionary = self.dictionary["subBanners"] as! NSArray
            } else if let val: AnyObject = self.dictionary["topBanners"] {
                productDictionary = self.dictionary["topBanners"] as! NSArray
            } else if let val: AnyObject = self.dictionary["bottomBanners"] {
                productDictionary = self.dictionary["bottomBanners"] as! NSArray
            }
            
            let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
            let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
            
            let homeProductModel: HomePageProductModel = homeProductModels[indexPath.row]
            fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            fullImageColectionViewCell.targetType = homeProductModel.targetType
            fullImageColectionViewCell.target = homeProductModel.target
            
            return fullImageColectionViewCell
            
        } else if self.layouts[indexPath.section] == Constants.HomePage.layoutThreeKey {
            var homeProductModel: HomePageProductModel?
            var productArray: NSArray = NSArray()
            if let val: AnyObject = self.dictionary["promos"] {
                productArray = dictionary["promos"] as! NSArray
                var homeProductModels: [HomePageProductModel] = [HomePageProductModel]()
                homeProductModels = HomePageProductModel.parseDataWithArray(productArray)
                homeProductModel  = homeProductModels[indexPath.row]
            } else {
                if let val: AnyObject = self.dictionary["categories"] {
                    let arrayDictionary: NSArray = self.dictionary["categories"] as! NSArray
                    //hard coded for now
                    let categoryDictionary: NSDictionary = arrayDictionary[0] as! NSDictionary
                    
                    productArray = categoryDictionary["images"] as! NSArray
                    var homeProductModels: [HomePageProductModel] = [HomePageProductModel]()
                    homeProductModels = HomePageProductModel.parseDataWithArray(productArray)
                    homeProductModel  = homeProductModels[indexPath.row]
                }
            }
            
            if indexPath.row == 0 {
                let fourImageCollectionViewCell: VerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("VerticalImageCollectionViewCell", forIndexPath: indexPath) as! VerticalImageCollectionViewCell
                fourImageCollectionViewCell.productItemImageView.sd_setImageWithURL(homeProductModel!.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                fourImageCollectionViewCell.productNameLabel.text = homeProductModel!.name
                
                if homeProductModel!.discountedPrice != "" {
                    fourImageCollectionViewCell.discountedPriceLabel.text = "P \(homeProductModel!.discountedPrice)"
                    fourImageCollectionViewCell.discountPercentageLabel.text = "\(homeProductModel!.discountPercentage) %"
                } else {
                    fourImageCollectionViewCell.discountedPriceLabel.hidden = true
                    fourImageCollectionViewCell.discountPercentageLabel.hidden = true
                }
                
                fourImageCollectionViewCell.targetType = homeProductModel!.targetType
                fourImageCollectionViewCell.target = homeProductModel!.target
                fourImageCollectionViewCell.discountedPriceLabel.drawDiscountLine()
                
                return fourImageCollectionViewCell
            } else {
                let fourImageCollectionViewCell: HalfVerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("HalfVerticalImageCollectionViewCell", forIndexPath: indexPath) as! HalfVerticalImageCollectionViewCell
                
                fourImageCollectionViewCell.productItemImageView.sd_setImageWithURL(homeProductModel!.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                fourImageCollectionViewCell.productNameLabel.text = homeProductModel!.name
                
                fourImageCollectionViewCell.targetType = homeProductModel!.targetType
                fourImageCollectionViewCell.target = homeProductModel!.target
                
                if homeProductModel!.discountedPrice != "" {
                    fourImageCollectionViewCell.discountedPriceLabel.text = "P \(homeProductModel!.discountedPrice)"
                    fourImageCollectionViewCell.discountPercentageLabel.text = "\(homeProductModel!.discountPercentage) %"
                } else {
                    fourImageCollectionViewCell.discountedPriceLabel.hidden = true
                    fourImageCollectionViewCell.discountPercentageLabel.hidden = true
                }
                fourImageCollectionViewCell.targetType = homeProductModel!.targetType
                fourImageCollectionViewCell.target = homeProductModel!.target
                fourImageCollectionViewCell.discountedPriceLabel.drawDiscountLine()
                
                return fourImageCollectionViewCell
            }
            
        } else if self.layouts[indexPath.section] == Constants.HomePage.layoutFourKey {
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
           
            fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel!.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            fullImageColectionViewCell.targetType = homeProductModel!.targetType
            fullImageColectionViewCell.target = homeProductModel!.target
            
            return fullImageColectionViewCell

        }  else if self.layouts[indexPath.section] == Constants.HomePage.layoutFiveKey {
            if let val: AnyObject = self.dictionary["trendingItems"] {
                
                let productDictionary: NSArray = dictionary["trendingItems"] as! NSArray
                let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
                let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
                
                let homeProductModel: HomePageProductModel = homeProductModels[indexPath.row]
                fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                fullImageColectionViewCell.targetType = homeProductModel.targetType
                fullImageColectionViewCell.target = homeProductModel.target
                return fullImageColectionViewCell
                
            } else {
                if let val: AnyObject = self.dictionary["categories"] {
                    let arrayDictionary: NSArray = self.dictionary["categories"] as! NSArray
                    //hard coded for now
                    var categoryDictionary: NSDictionary
                    if indexPath.section == 2 {
                        categoryDictionary = arrayDictionary[0] as! NSDictionary
                    } else {
                        categoryDictionary = arrayDictionary[1] as! NSDictionary
                    }
                    
                    let productArray: NSArray = categoryDictionary["images"] as! NSArray
                    var homeProductModels: [HomePageProductModel] = [HomePageProductModel]()
                    homeProductModels = HomePageProductModel.parseDataWithArray(productArray)
                    let homeProductModel: HomePageProductModel  = homeProductModels[indexPath.row]
                    
                    let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
                    fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                    fullImageColectionViewCell.targetType = homeProductModel.target
                    fullImageColectionViewCell.target = homeProductModel.targetType
                    return fullImageColectionViewCell
                } else {
                    let productDictionary: NSArray = dictionary["trendingItems"] as! NSArray
                    let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
                    let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
                    
                    let homeProductModel: HomePageProductModel = homeProductModels[indexPath.row]
                    fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                    fullImageColectionViewCell.targetType = homeProductModel.targetType
                    fullImageColectionViewCell.target = homeProductModel.target
                    return fullImageColectionViewCell
                }
                
            }
            
        } else if self.layouts[indexPath.section] == Constants.HomePage.layoutSixKey {
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
            twoColumnGridCollectionViewCell.productNameLabel.text = homeProductModel?.name
            twoColumnGridCollectionViewCell.targetType = homeProductModel!.targetType
            twoColumnGridCollectionViewCell.target = homeProductModel!.target
            twoColumnGridCollectionViewCell.productItemImageView.sd_setImageWithURL(homeProductModel!.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            
            twoColumnGridCollectionViewCell.discountedPriceLabel.text = homeProductModel?.discountedPrice
            twoColumnGridCollectionViewCell.discountPercentageLabel.text = homeProductModel?.discountPercentage
            twoColumnGridCollectionViewCell.productNameLabel.text = homeProductModel?.name
            twoColumnGridCollectionViewCell.originalPriceLabel.text = homeProductModel?.originalPrice
            twoColumnGridCollectionViewCell.discountedPriceLabel.drawDiscountLine()
            
            return twoColumnGridCollectionViewCell
        } else if self.layouts[indexPath.section] == Constants.HomePage.layoutSevenKey {
            let productItemWithVerticalDisplay: ProductItemWithVerticalDisplayCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("ProductItemWithVerticalDisplayCollectionViewCell", forIndexPath: indexPath) as! ProductItemWithVerticalDisplayCollectionViewCell
            
            let productDictionary: NSArray = dictionary["topPicks"] as! NSArray
            let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
            
            let homeProductModel: HomePageProductModel = homeProductModels[indexPath.row]
            productItemWithVerticalDisplay.productItemImageView.sd_setImageWithURL(homeProductModel.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            productItemWithVerticalDisplay.originalPriceLabel.text = homeProductModel.originalPrice
            productItemWithVerticalDisplay.productNameLabel.text = homeProductModel.name
          
            if homeProductModel.discountedPrice != "" {
                productItemWithVerticalDisplay.discountedPriceLabel.text = "P \(homeProductModel.discountedPrice)"
                productItemWithVerticalDisplay.discountPercentageLabel.text = "\(homeProductModel.discountPercentage) %"
            } else {
                productItemWithVerticalDisplay.discountedPriceLabel.hidden = true
                productItemWithVerticalDisplay.discountPercentageLabel.hidden = true
            }
            productItemWithVerticalDisplay.targetType = homeProductModel.targetType
            productItemWithVerticalDisplay.target = homeProductModel.target
            productItemWithVerticalDisplay.discountedPriceLabel.drawDiscountLine()
            
            return productItemWithVerticalDisplay
        } else if layouts[indexPath.section] == Constants.HomePage.layoutEightKey {
            let scrollableCell: ScrollableCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("ScrollableCollectionViewCell", forIndexPath: indexPath) as! ScrollableCollectionViewCell
            scrollableCell.delegate = self
            var productHomeModels: [HomePageProductModel] = [HomePageProductModel]()
            let products: NSArray = self.dictionary["shopByCategories"] as! NSArray
            
            for (index, product) in enumerate(products) {
                let productDictionary: NSDictionary = product as! NSDictionary
                let productModel = HomePageProductModel.parseDataWithDictionary(productDictionary)
                productHomeModels.append(productModel)
            }
            
            scrollableCell.productModels = productHomeModels
            
            return scrollableCell
        } else if layouts[indexPath.section] == Constants.HomePage.layoutNineKey {
            let scrollableCell: NewSellerScrollableCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("NewSellerScrollableCollectionViewCell", forIndexPath: indexPath) as! NewSellerScrollableCollectionViewCell
            
            var productHomeModels: [HomePageProductModel] = [HomePageProductModel]()
            let products: NSArray = self.dictionary["newSellers"] as! NSArray
            
            for (index, product) in enumerate(products) {
                let productDictionary: NSDictionary = product as! NSDictionary
                let productModel = HomePageProductModel.parseDataWithDictionary(productDictionary)
                productHomeModels.append(productModel)
            }
            
            scrollableCell.delegate = self
            scrollableCell.productModels = productHomeModels
            
            return scrollableCell
        } else if layouts[indexPath.section] == Constants.HomePage.layoutTenKey {
            let sellerCollectionView: SellerCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("SellerCollectionViewCell", forIndexPath: indexPath) as! SellerCollectionViewCell
            let sellerArray: NSArray = self.dictionary["topSellers"] as! NSArray
            
            let sellerDictionary: NSDictionary = sellerArray[indexPath.row] as! NSDictionary
            
            let sellerModel: SellerModel = SellerModel.parseDataFromDictionary(sellerDictionary)
            
            sellerCollectionView.sellerTitleLabel.text = sellerModel.name
            sellerCollectionView.sellerSubTitleLabel.text = sellerModel.specialty
            sellerCollectionView.sellerProfileImageView.sd_setImageWithURL(sellerModel.avatar, placeholderImage: UIImage(named: "dummy-placeholder"))
            
            if sellerModel.products.count == 3 {
                sellerCollectionView.productOneImageView.sd_setImageWithURL(sellerModel.products[0].imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                sellerCollectionView.productTwoImageView.sd_setImageWithURL(sellerModel.products[1].imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                sellerCollectionView.productThreeImageView.sd_setImageWithURL(sellerModel.products[2].imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
                
                sellerCollectionView.productOneImageView.target = sellerModel.products[0].target
                sellerCollectionView.productOneImageView.targetType = sellerModel.products[0].targetType
                
                sellerCollectionView.productTwoImageView.target = sellerModel.products[1].target
                sellerCollectionView.productTwoImageView.targetType = sellerModel.products[1].targetType
                
                sellerCollectionView.productThreeImageView.target = sellerModel.products[2].target
                sellerCollectionView.productThreeImageView.targetType = sellerModel.products[2].targetType
            }

            
            sellerCollectionView.delegate = self
            
            sellerCollectionView.targetType = "Go to Seller!"
            
            sellerCollectionView.target = sellerModel.target
     
            return sellerCollectionView
        } else {
            let productDictionary: NSArray = dictionary["mainbanner"] as! NSArray
            let fullImageColectionViewCell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
            let homeProductModels: [HomePageProductModel] = HomePageProductModel.parseDataWithArray(productDictionary)
            
            let homeProductModel: HomePageProductModel = homeProductModels[indexPath.row]
            println(homeProductModel.imageURL)
            fullImageColectionViewCell.itemProductImageView.sd_setImageWithURL(homeProductModel.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
            
            return fullImageColectionViewCell
        }
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == "UICollectionElementKindSectionFooter" {
            let footerView = self.collectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "ViewMoreFooterCollectionViewCell", forIndexPath: indexPath) as! ViewMoreFooterCollectionViewCell
            
            if self.layouts[indexPath.section] == Constants.HomePage.layoutThreeKey {
                if let val: AnyObject = self.dictionary["promos"] {
                    footerView.target = "View More Promos!"
                    footerView.targetType = "Go to list!"
                }
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutFourKey {
                if let val: AnyObject = self.dictionary["popularCategories"] {
                    footerView.target = "View More Popular Categories!"
                    footerView.targetType = "Go to list!"
                    footerView.cellButton.setTitle("VIEW MORE CATEGORIES", forState: UIControlState.Normal)
                }
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutFourKey {
                
            }
            
            
            
            else {
                if let val: AnyObject = self.dictionary["categories"] {
                    let categoryArray: NSArray = self.dictionary["categories"] as! NSArray
                    
                    for (index, category) in enumerate(categoryArray) {
                        let categoryDictionary: NSDictionary = category as! NSDictionary
                        footerView.target = "footer target"
                    }
                }
            }
            
            footerView.delegate = self
            return footerView
        } else {

            let headerView: LayoutHeaderCollectionViewCell = self.collectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "LayoutHeaderCollectionViewCell", forIndexPath: indexPath) as! LayoutHeaderCollectionViewCell
            
            if self.layouts[indexPath.section] == Constants.HomePage.layoutOneKey {
                
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutTwoKey {
                
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutThreeKey {
                if let val: AnyObject = dictionary["promos"] {
                    headerView.titleLabel.text = "Today's Promo"
                } else {
                    let arrayCategory: NSArray = self.dictionary["categories"] as! NSArray
                    let dictionaryCategory: NSDictionary = arrayCategory[0] as! NSDictionary
                    headerView.titleLabel.text = dictionaryCategory["categoryName"] as? String
                }

            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutFourKey {
                headerView.titleLabel.text = "Popular Categories"
                headerView.backgroundColor = UIColor.whiteColor()
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutFiveKey {
                if let val: AnyObject = self.dictionary["categories"] {
                    let arrayCategory: NSArray = self.dictionary["categories"] as! NSArray
                    let dictionaryCategory: NSDictionary = arrayCategory[indexPath.section - 2] as! NSDictionary
                    headerView.titleLabel.text = dictionaryCategory["categoryName"] as? String
                } else {
                    headerView.titleLabel.text = "Trending Items"
                }
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutSixKey {
                headerView.titleLabel.text = "Items you my like"
                headerView.backgroundColor = UIColor.clearColor()
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutSevenKey {
                headerView.titleLabel.text = "Top Picks"
                headerView.backgroundColor = UIColor.whiteColor()
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutEightKey {
                headerView.titleLabel.text = "Shop by category"
                headerView.backgroundColor = UIColor.clearColor()
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutTenKey {
                headerView.titleLabel.text = "Top Sellers"
                headerView.backgroundColor = UIColor.clearColor()
            } else if self.layouts[indexPath.section] == Constants.HomePage.layoutNineKey {
                headerView.titleLabel.text = "New Sellers"
                headerView.backgroundColor = UIColor.clearColor()
            }
            
            headerView.updateTitleLine()
            
            return headerView
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        let leftRightInset = 0
        
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: UICollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath)!

        if cell.isKindOfClass(FullImageCollectionViewCell) {
            let fullImageCollectionViewCell: FullImageCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! FullImageCollectionViewCell
            println("Target: \(fullImageCollectionViewCell.target)")
            println("Target type: \(fullImageCollectionViewCell.targetType)")
            self.redirectToProductpageWithProductID(fullImageCollectionViewCell.target)
        } else if cell.isKindOfClass(HalfVerticalImageCollectionViewCell) {
            let halfVerticalImageCollectionViewCell: HalfVerticalImageCollectionViewCell = self.collectionView!.cellForItemAtIndexPath(indexPath) as! HalfVerticalImageCollectionViewCell
            println("Target: \(halfVerticalImageCollectionViewCell.target)")
            println("Target type: \(halfVerticalImageCollectionViewCell.targetType)")
            self.redirectToProductpageWithProductID(halfVerticalImageCollectionViewCell.target)
        } else if cell.isKindOfClass(ProductItemWithVerticalDisplayCollectionViewCell) {
            let productItemWithVerticalDisplayCollectionViewCell: ProductItemWithVerticalDisplayCollectionViewCell = cell as! ProductItemWithVerticalDisplayCollectionViewCell
            println("Target: \(productItemWithVerticalDisplayCollectionViewCell.target)")
            println("Target type: \(productItemWithVerticalDisplayCollectionViewCell.targetType)")
            self.redirectToProductpageWithProductID(productItemWithVerticalDisplayCollectionViewCell.target)
        } else if cell.isKindOfClass(ProductWithCenterNameCollectionViewCell) {
            let productWithCenterNameCollectionViewCell: ProductWithCenterNameCollectionViewCell = cell as! ProductWithCenterNameCollectionViewCell
            println("Target: \(productWithCenterNameCollectionViewCell.target)")
            println("Target type: \(productWithCenterNameCollectionViewCell.targetType)")
            self.redirectToProductpageWithProductID(productWithCenterNameCollectionViewCell.target)
        } else if cell.isKindOfClass(TwoColumnGridCollectionViewCell) {
            let twoColumnGridCollectionViewCell: TwoColumnGridCollectionViewCell = cell as! TwoColumnGridCollectionViewCell
            println("Target: \(twoColumnGridCollectionViewCell.target)")
            println("Target type: \(twoColumnGridCollectionViewCell.targetType)")
            self.redirectToProductpageWithProductID(twoColumnGridCollectionViewCell.target)
        } else if cell.isKindOfClass(VerticalImageCollectionViewCell) {
            let verticalImageCollectionViewCell: VerticalImageCollectionViewCell = cell as! VerticalImageCollectionViewCell
            println("Target: \(verticalImageCollectionViewCell.target)")
            println("Target type: \(verticalImageCollectionViewCell.targetType)")
            self.redirectToProductpageWithProductID(verticalImageCollectionViewCell.target)
        } else if cell.isKindOfClass(SellerCollectionViewCell) {
            let sellerCollectionViewCell: SellerCollectionViewCell = cell as! SellerCollectionViewCell
            println("Target: \(sellerCollectionViewCell.target)")
            println("Target type: \(sellerCollectionViewCell.targetType)")
            self.redirectToSellerWithID(sellerCollectionViewCell.target)
        }
    
    }
    
    func didSelectectCellWithTarget(target: String, targetType: String) {
        println("target: \(target) \ntarget type:\(targetType)")
        self.redirectToResultView("target")
    }
    
    func didSelectSellerCellWithTarget(target: String, targetType: String) {
        println("target: \(target) \ntarget type:\(targetType)")
        self.redirectToSellerWithID("asdasdas3w")
    }
    
    func didSelectViewMoreWithtarget(target: String, targetType: String) {
        println("target: \(target) \ntarget type:\(targetType)")
        self.redirectToResultView("target")
    }
    
    func redirectToResultView(target: String) {
        let resultViewController: ResultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
        self.navigationController!.pushViewController(resultViewController, animated: true)
    }
    
    func didSelectProductWithTarget(target: String, targetType: String) {
        println("target: \(target) \ntarget type:\(targetType)")
        self.redirectToProductpageWithProductID("1")
    }
    
    func redirectToProductpageWithProductID(productID: String) {
        println("product id: \(productID)")
        let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        productViewController.tabController = self.tabBarController as! CustomTabBarController
        productViewController.productId = productID
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
    
    func redirectToSellerWithID(sellerID: String) {
        let sellerViewController: SellerViewController = SellerViewController(nibName: "SellerViewController", bundle: nil)
        self.navigationController!.pushViewController(sellerViewController, animated: true)
    }
}
