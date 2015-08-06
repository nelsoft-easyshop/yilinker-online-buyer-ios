//
//  HomePageProductModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HomePageProductModel: ProductModel {
    var productTargetType: String = ""
    var productTargetUrl: String = ""
    
     init(productName: String, productImageURL: NSURL, productOriginalPrice: String, productDiscountedPrice: String, productDiscountPercentage: String, productTarget: String, productTargetType: String, productTargetUrl: String) {
        
        super.init(productName: "", productImageURL: NSURL(string: "")!, productOriginalPrice: "", productDiscountedPrice: "", productDiscountPercentage: "", productTarget: "")
        
        self.productName = productName
        self.productImageURL = productImageURL
        self.productOriginalPrice = productOriginalPrice
        self.productDiscountedPrice = productDiscountedPrice
        self.productDiscountPercentage = productDiscountPercentage
        self.productTarget = productTarget
        self.productTargetType = productTargetType
        self.productTargetUrl = productTargetUrl
    }
    
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> HomePageProductModel {
        /*
            if let tempDealTitle = dictionary["deal_title"] as? String {
            dealTitle = tempDealTitle
            } else {
            dealTitle = ""
            }
        
        */
        var productName: String = ""
        var productImageURL: NSURL = NSURL(string: "")!
        var productOriginalPrice: String = ""
        var productDiscountedPrice: String = ""
        var productTarget: String = ""
        var productDiscountPercentage: String = ""
        var productTargetType: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
           
            if let val: AnyObject = dictionary["productName"] {
                if let tempProductname = dictionary["productName"] as? String {
                    productName = tempProductname
                } else {
                    productName = ""
                }
            }

            if let val: AnyObject = dictionary["image"] {
                if let tempProductImageURL = dictionary["image"] as? String {
                    productImageURL = NSURL(string: tempProductImageURL)!
                } else {
                    productImageURL = NSURL(string: "")!
                }
            }

            if let val: AnyObject = dictionary["originalPrice"] {
                if let tempProductOriginalPrice = dictionary["originalPrice"] as? String {
                    productOriginalPrice = tempProductOriginalPrice
                } else {
                    productOriginalPrice = ""
                }
            }

            if let val: AnyObject = dictionary["discountedPrice"] {
                if let tempDiscountedPrice = dictionary["discountedPrice"] as? String {
                    productDiscountedPrice = tempDiscountedPrice
                } else {
                    productDiscountedPrice = ""
                }
            }
            
            if let val: AnyObject = dictionary["discountPercentage"] {
                if let tempDiscountPercentege = dictionary["discountPercentage"] as? String {
                    productDiscountPercentage = tempDiscountPercentege
                } else {
                    productDiscountPercentage = ""
                }
            }
            
            if let val: AnyObject = dictionary["targetType"] {
                if let tempTargetType = dictionary["targetType"] as? String {
                    productTargetType = tempTargetType
                } else {
                    productTargetType = ""
                }
            }
            
            if let val: AnyObject = dictionary["categoryImage"] {
                if let tempCategoryImage = dictionary["categoryImage"] as? String {
                    productImageURL = NSURL(string: tempCategoryImage)!
                } else {
                    productImageURL = NSURL(string: "")!
                }
            }
            
            let homePageProductModel: HomePageProductModel = HomePageProductModel(productName: productName, productImageURL: productImageURL, productOriginalPrice: productOriginalPrice, productDiscountedPrice: productDiscountedPrice, productDiscountPercentage: productDiscountPercentage, productTarget: productTarget, productTargetType: productTargetType, productTargetUrl: "")
         
            return homePageProductModel
        } else {
            
            return HomePageProductModel(productName: "", productImageURL: NSURL(string: "")!, productOriginalPrice: "", productDiscountedPrice: "", productDiscountPercentage: "", productTarget: "", productTargetType: "", productTargetUrl: "")
        }
    }
    
    class func parseDataWithArray(datas: NSArray) -> [HomePageProductModel]{
        var models: [HomePageProductModel] = [HomePageProductModel]()
        for (index, data) in enumerate(datas) {
            let dictionary: NSDictionary = data as! NSDictionary
            var productName: String = ""
            var productImageURL: NSURL = NSURL(string: "")!
            var productOriginalPrice: String = ""
            var productDiscountedPrice: String = ""
            var productTarget: String = ""
            var productDiscountPercentage: String = ""
            var productTargetType: String = ""
                
            if let val: AnyObject = dictionary["productName"] {
                if let tempProductname = dictionary["productName"] as? String {
                    productName = tempProductname
                } else {
                    productName = ""
                }
            }
            
            if let val: AnyObject = dictionary["image"] {
                if let tempProductImageURL = dictionary["image"] as? String {
                    productImageURL = NSURL(string: tempProductImageURL)!
                } else {
                    productImageURL = NSURL(string: "")!
                }
            }
            
            if let val: AnyObject = dictionary["originalPrice"] {
                if let tempProductOriginalPrice = dictionary["originalPrice"] as? String {
                    productOriginalPrice = tempProductOriginalPrice
                } else {
                    productOriginalPrice = ""
                }
            }
            
            if let val: AnyObject = dictionary["discountedPrice"] {
                if let tempDiscountedPrice = dictionary["discountedPrice"] as? String {
                    productDiscountedPrice = tempDiscountedPrice
                } else {
                    productDiscountedPrice = ""
                }
            }
            
            if let val: AnyObject = dictionary["discountPercentage"] {
                if let tempDiscountPercentege = dictionary["discountPercentage"] as? String {
                    productDiscountPercentage = tempDiscountPercentege
                } else {
                    productDiscountPercentage = ""
                }
            }
            
            if let val: AnyObject = dictionary["targetType"] {
                if let tempTargetType = dictionary["targetType"] as? String {
                    productTargetType = tempTargetType
                } else {
                    productTargetType = ""
                }
            }
            
            if let val: AnyObject = dictionary["categoryImage"] {
                if let tempCategoryImage = dictionary["categoryImage"] as? String {
                    productImageURL = NSURL(string: tempCategoryImage)!
                } else {
                    productImageURL = NSURL(string: "")!
                }
            }
            
            let homePageProductModel: HomePageProductModel = HomePageProductModel(productName: productName, productImageURL: productImageURL, productOriginalPrice: productOriginalPrice, productDiscountedPrice: productDiscountedPrice, productDiscountPercentage: productDiscountPercentage, productTarget: productTarget, productTargetType: productTargetType, productTargetUrl: "")
            
            models.append(homePageProductModel)
    }
            
        return models
    }
        
}
