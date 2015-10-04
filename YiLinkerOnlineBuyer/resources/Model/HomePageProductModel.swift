//
//  HomePageProductModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HomePageProductModel: ProductModel {
    var targetType: String = ""
    var targetUrl: String = ""
    
     init(name: String, imageURL: NSURL, originalPrice: String, discountedPrice: String, discountPercentage: String, target: String, targetType: String, targetUrl: String, productId: String) {
        
        super.init(name: "", imageURL: NSURL(string: "")!, originalPrice: "", discountedPrice: "", discountPercentage: "", target: "", productId: "")
        
        self.name = name
        self.imageURL = imageURL
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
        self.discountPercentage = discountPercentage
        self.target = target
        self.targetType = targetType
        self.targetUrl = targetUrl
        self.productId = productId
    }
    
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> HomePageProductModel {
        var name: String = ""
        var imageURL: NSURL = NSURL(string: "")!
        var originalPrice: String = ""
        var discountedPrice: String = ""
        var target: String = ""
        var discountPercentage: String = ""
        var targetType: String = ""
        var productId: String = ""
        if dictionary.isKindOfClass(NSDictionary) {
           
            if let val: AnyObject = dictionary["productName"] {
                if let tempProductname = dictionary["productName"] as? String {
                    name = tempProductname
                } else {
                    name = ""
                }
            } else if let val: AnyObject = dictionary["categoryName"] {
                if let tempCategoryName = dictionary["categoryName"] as? String {
                    name = tempCategoryName
                } else {
                    name = ""
                }
            } else if let val: AnyObject = dictionary["name"] {
                if let tempProductname = dictionary["name"] as? String {
                    name = tempProductname
                } else {
                    name = ""
                }
            }

            if let val: AnyObject = dictionary["imageUrl"] {
                if let tempProductImageURL = dictionary["imageUrl"] as? String {
                    
                    imageURL = NSURL(string: tempProductImageURL)!
                } else {
                    imageURL = NSURL(string: "")!
                }
            }

            if let val: AnyObject = dictionary["originalPrice"] {
                if let tempProductOriginalPrice = dictionary["originalPrice"] as? String {
                    originalPrice = tempProductOriginalPrice
                } else {
                    originalPrice = ""
                }
            }

            if let val: AnyObject = dictionary["discountedPrice"] {
                if let tempDiscountedPrice = dictionary["discountedPrice"] as? String {
                    discountedPrice = tempDiscountedPrice
                } else {
                    discountedPrice = ""
                }
            }
            
            if let val: AnyObject = dictionary["discountedPercentage"] {
                if let tempDiscountPercentege = dictionary["discountedPercentage"] as? String {
                    discountPercentage = tempDiscountPercentege
                } else {
                    discountPercentage = ""
                }
            }
            
            if let val: AnyObject = dictionary["targetType"] {
                if let tempTargetType = dictionary["targetType"] as? String {
                    targetType = tempTargetType
                } else {
                    targetType = ""
                }
            }
            
            if let val: AnyObject = dictionary["categoryImage"] {
                if let tempCategoryImage = dictionary["categoryImage"] as? String {
                    imageURL = NSURL(string: tempCategoryImage)!
                } else {
                    imageURL = NSURL(string: "")!
                }
            }
           
            
            if let val: AnyObject = dictionary["productId"] {
                if let tempTarget = dictionary["productId"] as? String {
                    productId = tempTarget
                } else {
                    productId = ""
                }
            } else if let val: AnyObject = dictionary["target"] {
                if let tempTarget = dictionary["target"] as? String {
                    target = tempTarget
                } else {
                    target = ""
                }
            }
            
            let homePageProductModel: HomePageProductModel = HomePageProductModel(name: name, imageURL: imageURL, originalPrice: originalPrice, discountedPrice: discountedPrice, discountPercentage: discountPercentage, target: target, targetType: targetType, targetUrl: "", productId: productId)
            return homePageProductModel
        } else {
             let homePageProductModel: HomePageProductModel = HomePageProductModel(name: "", imageURL: NSURL(string:"")!, originalPrice: "", discountedPrice: "", discountPercentage: "", target: "", targetType: "", targetUrl: "", productId: "")
            return homePageProductModel
        }
    }
    
    class func parseDataWithArray(datas: NSArray) -> [HomePageProductModel]{
        
        var models: [HomePageProductModel] = [HomePageProductModel]()
        for (index, data) in enumerate(datas) {
            let dictionary: NSDictionary = data as! NSDictionary
            var name: String = ""
            var imageUrl: NSURL = NSURL(string: "")!
            var originalPrice: String = ""
            var discountedPrice: String = ""
            var target: String = ""
            var discountPercentage: String = ""
            var targetType: String = ""
            var productId: String = ""
                
            if let val: AnyObject = dictionary["productName"] {
                if let tempProductname = dictionary["productName"] as? String {
                    name = tempProductname
                } else {
                    name = ""
                }
            } else if let val: AnyObject = dictionary["categoryName"] {
                if let tempCategoryName = dictionary["categoryName"] as? String {
                    name = tempCategoryName
                } else {
                    name = ""
                }
            }
            
            if let val: AnyObject = dictionary["image"] {
                if let tempProductImageURL = dictionary["image"] as? String {
                    imageUrl = NSURL(string: tempProductImageURL)!
                } else {
                    imageUrl = NSURL(string: "")!
                }
            }
            
            if let val: AnyObject = dictionary["originalPrice"] {
                if let tempProductOriginalPrice = dictionary["originalPrice"] as? String {
                    originalPrice = tempProductOriginalPrice
                } else {
                    originalPrice = ""
                }
            }
            
            if let val: AnyObject = dictionary["discountedPrice"] {
                if let tempDiscountedPrice = dictionary["discountedPrice"] as? String {
                    discountedPrice = tempDiscountedPrice
                } else {
                    discountedPrice = ""
                }
            }
            
            if let val: AnyObject = dictionary["discountedPercentage"] {
                if let tempDiscountPercentege = dictionary["discountedPercentage"] as? String {
                    discountPercentage = tempDiscountPercentege
                } else {
                    discountPercentage = ""
                }
            }
            
            if let val: AnyObject = dictionary["targetType"] {
                if let tempTargetType = dictionary["targetType"] as? String {
                    targetType = tempTargetType
                } else {
                    targetType = ""
                }
            }
            
            if let val: AnyObject = dictionary["productId"] {
                if let tempTarget = dictionary["productId"] as? String {
                    productId = tempTarget
                } else {
                    productId = ""
                }
            } else if let val: AnyObject = dictionary["target"] {
                if let tempTarget = dictionary["target"] as? String {
                    target = tempTarget
                } else {
                    target = ""
                }
            }
            
            if let val: AnyObject = dictionary["categoryImage"] {
                if let tempCategoryImage = dictionary["categoryImage"] as? String {
                    imageUrl = NSURL(string: tempCategoryImage)!
                } else {
                    imageUrl = NSURL(string: "")!
                }
            }
            
           
            let homePageProductModel: HomePageProductModel = HomePageProductModel(name: name, imageURL: imageUrl, originalPrice: originalPrice, discountedPrice: discountedPrice, discountPercentage: discountPercentage, target: target, targetType: targetType, targetUrl: "", productId: productId)
            
            models.append(homePageProductModel)
    }
            
        return models
    }
        
}
