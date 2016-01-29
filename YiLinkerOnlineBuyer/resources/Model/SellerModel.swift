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
    var userId: Int = 0
    
    //For seller
    var email: String = ""
    var gender: String = ""
    var nickname: String = ""
    var contact_number: String = ""
    var birthdate: String = ""
    var store_name: String = ""
    var store_description = ""
    var is_allowed: Bool = false
    var store_address: String = ""
    var isAffiliated: Bool = false
    
    //For feed back seller reviews
    var rating: Int = 0
    var image_url: NSURL = NSURL(string: "")!
    var user_rating: String = ""
    var message: String = ""
    
    override init() {
        
    }
    
    init(name: String, avatar: NSURL, specialty: String, target: String, products: [HomePageProductModel]) {
        self.name = name
        self.avatar = avatar
        self.specialty = specialty
        self.target = target
        self.products = products
    }
    
    init(name: String, avatar: NSURL, specialty: String, target: String, products: [HomePageProductModel], userId: Int) {
        self.name = name
        self.avatar = avatar
        self.specialty = specialty
        self.target = target
        self.products = products
        self.userId = userId
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
    
    init(name : String, email : String, gender : String, nickname : String, contact_number : String, specialty : String, birthdate : String, store_name : String, store_description : String, avatar : NSURL, cover_photo : NSURL, is_allowed : Bool, store_address: String, products : [HomePageProductModel], reviews : [ProductReviewsModel], isAffiliated: Bool) {
        self.name = name
        self.email = email
        self.gender = gender
        self.nickname = nickname
        self.contact_number = contact_number
        self.specialty = specialty
        self.birthdate = birthdate
        self.store_name = store_name
        self.store_description = store_description
        self.avatar = avatar
        self.coverPhoto = cover_photo
        self.is_allowed = is_allowed
        self.products = products
        self.reviews = reviews
        self.store_address = store_address
        self.isAffiliated = isAffiliated
    }
    
    init(rating : Int, product_reviews: [ProductReviewsModel]){
        self.reviews = product_reviews
        self.rating = rating
    }
    
    class func parseSellerDataFromDictionary(dictionary: NSDictionary) -> SellerModel {
        
        var name: String = ""
        var email: String = ""
        var gender: String = ""
        var nickname: String = ""
        var contact_number: String = ""
        var specialty: String = ""
        var birthdate: String = ""
        var store_name: String = ""
        var store_description: String = ""
        var avatar: NSURL = NSURL(string: "")!
        var cover_photo: NSURL = NSURL(string: "")!
        var is_followed: Bool = false
        var sellerProductModel: [HomePageProductModel] = [HomePageProductModel]()
        var productReviews: [ProductReviewsModel] = [ProductReviewsModel]()
        var store_address: String = ""
        var isAffiliated: Bool = false
        
        if let value: AnyObject = dictionary["data"] {
            
            if let sellerName = value["fullName"] as? String {
                name = sellerName
            } else {
                name = ""
            }
            
            if let sellerEmail = value["email"] as? String {
                email = sellerEmail
            } else {
                email = ""
            }
            
            if let sellerGender = value["gender"] as? String {
                gender = sellerGender
            } else {
                gender = ""
            }
            
            if let sellerNickname = value["nickname"] as? String {
                nickname = sellerNickname
            } else {
                nickname = ""
            }
            
            if let sellerContactNumber = value["contactNumber"] as? String {
                contact_number = sellerContactNumber
            } else {
                contact_number = ""
            }
            
            if let sellerSpecialty = value["specialty"] as? String {
                specialty = sellerSpecialty
            } else {
                specialty = ""
            }
            
            if let sellerBirthdate = value["birthdate"] as? String {
                birthdate = sellerBirthdate
            } else {
                birthdate = ""
            }
            
            if let sellerStoreName = value["storeName"] as? String {
                store_name = sellerStoreName
            } else {
                store_name = ""
            }
            
            if let sellerStoreDescription = value["storeDescription"] as? String {
                store_description = sellerStoreDescription
            } else {
                store_description = ""
            }
            
            if let sellerProfilePhoto = value["profilePhoto"] as? String {
                avatar = NSURL(string: sellerProfilePhoto)!
            } else {
                avatar = NSURL(string: "")!
            }
            
            if let sellerCoverPhoto = value["coverPhoto"] as? String {
                cover_photo = NSURL(string: sellerCoverPhoto)!
            } else {
                cover_photo = NSURL(string: "")!
            }
            
            if let sellerIsFollowed = value["isFollowed"] as? Bool {
                is_followed = sellerIsFollowed
            } else {
                is_followed = false
            }
            
            if let affiliated = value["isAffiliate"] as? Bool {
                isAffiliated = affiliated
            } else {
                isAffiliated = false
            }
           
            let products: NSArray = value["products"] as! NSArray
            for productDictionary in products as! [NSDictionary] {
                let productModel: HomePageProductModel = HomePageProductModel.parseDataWithDictionary(productDictionary)
                sellerProductModel.append(productModel)
            }
            
            if let val: AnyObject = value["storeAddress"] {
                var unitNumber: String = ""
                var bldgName: String = ""
                var streetNumber: String = ""
                var streetName: String = ""
                var subdivision: String = ""
                var zipCode: String = ""
                var fullLocation: String = ""
                
                if let temUnitNo = val["unitNumber"] as? String {
                    unitNumber = temUnitNo
                }
                
                if let temBldgNo = val["buildingName"] as? String {
                    bldgName = temBldgNo
                }
                
                if let temStreetNo = val["streetNumber"] as? String {
                    streetNumber = temStreetNo
                }
                
                if let temSubdivision = val["subdivision"] as? String {
                    subdivision = temSubdivision
                }
                
                if let temZipCode = val["zipCode"] as? String {
                    zipCode = temZipCode
                }
                
                if let temFullLocation = val["fullLocation"] as? String {
                    fullLocation = temFullLocation
                }
                
                store_address = fullLocation
            }
            
        }
        
        let sellerModel: SellerModel = SellerModel(name: name, email: email, gender: gender, nickname: nickname, contact_number: contact_number, specialty: contact_number, birthdate: birthdate, store_name: store_name, store_description: store_description, avatar: avatar, cover_photo: cover_photo, is_allowed: is_followed, store_address: store_address, products:sellerProductModel, reviews: productReviews, isAffiliated: isAffiliated)
        
        return sellerModel
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
        var userId: Int = 0
        
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
        
        if let val: AnyObject = dictionary["userId"] {
            if let tempUserId = dictionary["userId"] as? Int {
                userId = tempUserId
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
            let sellerModel: SellerModel = SellerModel(name: name, avatar: avatar, specialty: specialty, target: target, products: homePageProductModels, userId: userId)
            return sellerModel
        }
    }
    
    //use this one
    class func parseSellerReviewsDataFromDictionary(dictionary: NSDictionary) -> SellerModel {
        
        var rating: Int = 0
        var productReviews: [ProductReviewsModel] = [ProductReviewsModel]()
        
        if let value: AnyObject = dictionary["data"] {
            if let tempRating = value["ratingAverage"] as? Int {
                rating = tempRating
            }
            
            if let val: AnyObject = value["reviews"] {
                var reviewArray: NSArray = value["reviews"] as! NSArray
                
                for (index, review) in enumerate(reviewArray) {
                    let reviewDictionary: NSDictionary = review as! NSDictionary
                    let productReviewModel: ProductReviewsModel = ProductReviewsModel.parseSellerProductReviewsModel(reviewDictionary)
                    productReviews.append(productReviewModel)
                }
            }
        }
        
        let sellerModel: SellerModel = SellerModel(rating: rating, product_reviews: productReviews)
        return sellerModel
    }
    
    class func parseSellerReviewsDataFromDictionary2(dictionary: NSDictionary) -> SellerModel {
        
        var rating: Int = 0
        var productReviews: [ProductReviewsModel] = [ProductReviewsModel]()
        
        if let value: AnyObject = dictionary["data"] {
            if let tempRating = value["ratingAverage"] as? Int {
                rating = tempRating
            }
            
            if let val: AnyObject = value["reviews"] {
                var reviewArray: NSArray = value["reviews"] as! NSArray
                
                for (index, review) in enumerate(reviewArray) {
                    let reviewDictionary: NSDictionary = review as! NSDictionary
                    let productReviewModel: ProductReviewsModel = ProductReviewsModel.parseSellerProductReviewsModel2(reviewDictionary)
                    productReviews.append(productReviewModel)
                }
            }
        }
        
        let sellerModel: SellerModel = SellerModel(rating: rating, product_reviews: productReviews)
        return sellerModel
        
    }
}
