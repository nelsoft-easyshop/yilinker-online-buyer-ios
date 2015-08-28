//
//  SellerModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/6/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerModel: NSObject {
    var name: String = ""
    var avatar: NSURL = NSURL(string: "")!
    var specialty: String = ""
    var target: String = ""
    var products: [HomePageProductModel] = [HomePageProductModel]()
    var address: String = ""
    var coverPhoto: NSURL = NSURL(string: "")!
    var ratingAndFeedback: Int = 0
    var sellerAbout: String = ""
    var moreSellertarget: String = ""
    var reviews: [ProductReviewsModel] = [ProductReviewsModel]()
    
    init(name: String, avatar: NSURL, specialty: String, target: String, products: [HomePageProductModel]) {
        self.name = name
        self.avatar = avatar
        self.specialty = specialty
        self.target = target
        self.products = products
    }
    
    init(name: String, avatar: NSURL, specialty: String, target: String, products: [HomePageProductModel], address: String, coverPhoto: NSURL, ratingAndFeedback: Int,
        sellerAbout: String, moreSellertarget: String, reviews: [ProductReviewsModel]) {
            self.name = name
            self.avatar = avatar
            self.specialty = specialty
            self.target = target
            self.products = products
            self.address = address
            self.coverPhoto = coverPhoto
            self.ratingAndFeedback = ratingAndFeedback
            self.sellerAbout = sellerAbout
            self.moreSellertarget = moreSellertarget
            self.reviews = reviews
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> SellerModel {
        var name: String = ""
        var avatar: NSURL = NSURL(string: "")!
        var specialty: String = ""
        var target: String = ""
        var products: [ProductModel]?
        
        var address: String = ""
        var sellerCoverPhoto: NSURL = NSURL(string: "")!
        var ratingAndFeedback: Int = 0
        var sellerAbout: String = ""
        var moreSellertarget: String = ""
        var reviews: [ProductReviewsModel] = [ProductReviewsModel]()
        

        if let tempSellerAvatar = dictionary["image"] as? String {
            avatar = NSURL(string: tempSellerAvatar)!
        } else if let tempSellerAvatar = dictionary["sellerAvatar"] as? String {
            avatar = NSURL(string: tempSellerAvatar)!
        } else {
            avatar = NSURL(string: "")!
        }
        
        if let tempName = dictionary["sellerName"] as? String {
            name = tempName
        } else if let tempName = dictionary["name"] as? String {
            name = tempName
        } else {
            name = ""
        }
        
        if let tempSpecialty = dictionary["specialty"] as? String {
            specialty = tempSpecialty
        } else {
            specialty = ""
        }
        
        var homePageProductModels: [HomePageProductModel] = [HomePageProductModel]()
        
        if let val: AnyObject = dictionary["products"] {
            let products: NSArray = dictionary["products"] as! NSArray
            for productDictionary in products as! [NSDictionary] {
                let productModel: HomePageProductModel = HomePageProductModel.parseDataWithDictionary(productDictionary)
                homePageProductModels.append(productModel)
            }
        }
        
        if let val: AnyObject = dictionary["address"] {
            if let tempAddress = dictionary["address"] as? String {
                address = tempAddress
            }
        }
        
        if let val: AnyObject = dictionary["sellerCoverPhoto"] {
            if let tempSellerCoverPhoto = dictionary["sellerCoverPhoto"] as? String {
                sellerCoverPhoto = NSURL(string: tempSellerCoverPhoto)!
            }
        }
        
        
        if let val: AnyObject = dictionary["ratingAndFeedback"] {
            if let tempRatingAndFeedback = dictionary["ratingAndFeedback"] as? Int {
                ratingAndFeedback = tempRatingAndFeedback
            }
        }
        
        
        if let val: AnyObject = dictionary["sellerAbout"] {
            if let tempSellerAbout = dictionary["sellerAbout"] as? String {
                sellerAbout = tempSellerAbout
            }
        }
        
        if let val: AnyObject = dictionary["sellerAbout"] {
            if let tempSellerAbout = dictionary["sellerAbout"] as? String {
                sellerAbout = tempSellerAbout
            }
        }
        
        if let val: AnyObject = dictionary["reviews"] {
            var reviewArray: NSArray = dictionary["reviews"] as! NSArray
            
            for (index, review) in enumerate(reviewArray) {
                let reviewDictionary: NSDictionary = review as! NSDictionary
                let productReviewModel: ProductReviewsModel = ProductReviewsModel.parseProductReviesModel(reviewDictionary)
                reviews.append(productReviewModel)
            }
        }
        
        if let val: AnyObject = dictionary["sellerAbout"] {
            let sellerModel: SellerModel = SellerModel(name: name, avatar: avatar, specialty: specialty, target: target, products: homePageProductModels, address: address, coverPhoto: sellerCoverPhoto, ratingAndFeedback: ratingAndFeedback, sellerAbout: sellerAbout, moreSellertarget: moreSellertarget, reviews: reviews)
            return sellerModel
        } else {
            let sellerModel: SellerModel = SellerModel(name: name, avatar: avatar, specialty: specialty, target: target, products: homePageProductModels)
            return sellerModel
        }
    }
}
