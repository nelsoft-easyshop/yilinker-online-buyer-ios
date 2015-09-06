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
    
    //For feed back seller reviews
    var rating: String = ""
    var image_url: NSURL = NSURL(string: "")!
    var user_rating: String = ""
    var message: String = ""
    
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
    
    init(name : String, email : String, gender : String, nickname : String, contact_number : String, specialty : String, birthdate : String, store_name : String, store_description : String, avatar : NSURL, cover_photo : NSURL, is_allowed : Bool, store_address: String, products : [HomePageProductModel], reviews : [ProductReviewsModel]) {
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
    }
    
    init(rating : String, product_reviews: [ProductReviewsModel]){
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
            
            var myArrayOfDictProducts: NSArray = [

                ["name": "Nike",
                    "image": "http://www.dividend.com/assets/dividend/nke/nike-shoes-bb098f57129e558e1cdf393c308987bf.jpg",
                    "target": "nike1",
                    "targetType": ""]
                ,
                ["name": "Nike", "image": "http://www.dividend.com/assets/dividend/nke/nike-shoes-bb098f57129e558e1cdf393c308987bf.jpg", "target": "nike1", "targetType": ""]

                , ["name": "vans shoes",
                    "image": "http://content.nike.com/content/dam/one-nike/en_us/season-2013-ho/Shop/NIKEiD/NIKEiD_P2_Basketball_20131112_FILT.jpg.transform/full-screen/image.jpg",
                    "target": "",
                    "targetType": ""]
                , ["name": "rebook shoes",
                    "image": "http://www.vulcan100.com/image/data/0/nike-vip/Nike-Air-Max-Mens/Air-Max-90-Mens-Shoes/Air-Max-90-Hyperfuse-Prm/New-Release-Nike-Air-Max-90-Hyperfuse-PRM-Mens-Shoes-2014-Dark-Blue-Buy-Online-3569.jpg",
                    "target": "",
                    "targetType": ""]
                , ["name": "vans shoes",
                    "image": "http://picture-cdn.wheretoget.it/e9ptj2-l-610x610-shoes-nike-nike+roshe+run-tropical+print-womens+nike+shoes+roshe+runs-nike+roshe+run+running+shoes-earphones-gloves-nike+running+shoes-flower+print-hawaiian+print-summer-nike+tropi.jpg",
                    "target": "",
                    "targetType": ""]
            ]
            
            var dictProducts:NSDictionary = ["products" : myArrayOfDictProducts]
            
            if let val: AnyObject = dictProducts["products"] {
                let products: NSArray = dictProducts["products"] as! NSArray
                for productDictionary in products as! [NSDictionary] {
                    let productModel: HomePageProductModel = HomePageProductModel.parseDataWithDictionary(productDictionary)
                    sellerProductModel.append(productModel)
                }
            }
            
            var myArrayOfDictRatings: NSArray = [
                ["name": "Alvin Tandoc",
                    "imageUrl": "https://c1.staticflickr.com/7/6149/6196728559_c3a57d2711_b.jpg",
                    "rating": 5,
                    "message": "My order delivered on time! Thank you and God Bless"]
                , ["name": "Joriel Fronda",
                    "imageUrl": "https://c2.staticflickr.com/4/3382/3545724212_986ae8f5f9.jpg",
                    "rating": 2,
                    "message": "I received the item with slight scratches. :("]
                , ["name": "RJ Constantino",
                    "imageUrl": "http://36.media.tumblr.com/tumblr_md2ljah1Xa1rwzadbo1_500.jpg",
                    "rating": 5,
                    "message": "Thank you for this! I like it!"]
                , [ "name": "JP Chan",
                    "imageUrl": "https://c2.staticflickr.com/4/3382/3545724212_986ae8f5f9.jpg",
                    "rating": 2,
                    "message": "The item is damaged!"]

            ]
            
            var dictReviews:NSDictionary = ["reviews" : myArrayOfDictRatings]
            
            if let val: AnyObject = dictReviews["reviews"] {
                var reviewArray: NSArray = dictReviews["reviews"] as! NSArray
                
                for (index, review) in enumerate(reviewArray) {
                    let reviewDictionary: NSDictionary = review as! NSDictionary
                    let productReviewModel: ProductReviewsModel = ProductReviewsModel.parseSellerProductReviesModel(reviewDictionary)
                    productReviews.append(productReviewModel)
                }
            }
            
            if let val: AnyObject = value["storeAddress"] {
               // var reviewArray: NSDictionary = dictReviews["storeAddress"] as! NSDictionary
                var unitNumber: String = ""
                var bldgName: String = ""
                var streetNumber: String = ""
                var streetName: String = ""
                var subdivision: String = ""
                var zipCode: String = ""
                /*var streetAddress: String = ""
                var province: String = ""
                var city: String = ""
                var municipality: String = ""
                var barangay: String = ""*/
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
                
                store_address = unitNumber + " " + bldgName + ", " + streetName + ", " + subdivision + ", " + zipCode
            }
            
        }
        
        let sellerModel: SellerModel = SellerModel(name: name, email: email, gender: gender, nickname: nickname, contact_number: contact_number, specialty: contact_number, birthdate: birthdate, store_name: store_name, store_description: store_description, avatar: avatar, cover_photo: cover_photo, is_allowed: is_followed, store_address: store_address, products:sellerProductModel, reviews: productReviews)
        
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
    
    class func parseSellerReviewsDataFromDictionary(dictionary: NSDictionary) -> SellerModel {
        
        var rating: String = ""
         var productReviews: [ProductReviewsModel] = [ProductReviewsModel]()
        
        if let tempRating = dictionary["rating"] as? String {
            rating = tempRating
        }
        
        var dictReviews:NSDictionary = ["reviews" : dictionary]
        
        if let val: AnyObject = dictReviews["reviews"] {
            var reviewArray: NSArray = dictReviews["reviews"] as! NSArray
            
            for (index, review) in enumerate(reviewArray) {
                let reviewDictionary: NSDictionary = review as! NSDictionary
                let productReviewModel: ProductReviewsModel = ProductReviewsModel.parseProductReviesModel(reviewDictionary)
                productReviews.append(productReviewModel)
            }
        }
        
        let sellerModel: SellerModel = SellerModel(rating: rating, product_reviews: productReviews)
        return sellerModel
        
    }
}
