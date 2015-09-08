//
//  ProductReviewsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductReviewsModel {
    
    var userId: Int = 0
    var title: String = ""
    var review: String = ""
    var rating: String = ""
    var fullName: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var profileImageUrl: String = ""
    var dateAdded: String = ""
    
    //seller
    var ratingSellerReview: Int = 0
    var imageUrl: String = ""
    
    class func parseProductReviesModel(reviews: NSDictionary) -> ProductReviewsModel! {
        
        var model = ProductReviewsModel()
        if reviews.isKindOfClass(NSDictionary) {
            
            model.userId = reviews["userId"] as! Int
            model.title = reviews["title"] as! String
            model.review = reviews["review"] as! String
            model.rating = reviews["rating"] as! String
            model.fullName = reviews["fullName"] as! String
            model.firstName = reviews["firstName"] as! String
            model.lastName = reviews["lastName"] as! String
            model.profileImageUrl = reviews["profileImageUrl"] as! String
            model.dateAdded = reviews["dateAdded"] as! String
            
//            if let val: AnyObject = reviews["fullName"] {
//                model.fullName = reviews["fullName"] as! String
//            } else {
//                model.fullName = reviews["name"] as! String
//            }
//            
//            
//            if let val: AnyObject = reviews["profileImageUrl"] {
//                model.profileImageUrl = reviews["profileImageUrl"] as! String
//            } else {
//                model.profileImageUrl = reviews["imageUrl"] as! String
//            }
//            
//            if let val: AnyObject = reviews["rating"] {
//                if let tempRating = reviews["rating"] as? String {
//                    model.rating = reviews["rating"] as! String
//                }
//            } else {
//                model.rating = "5"
//            }
//            
//            if let val: AnyObject = reviews["title"] {
//                model.title = reviews["title"] as! String
//            }
//            
//            if let val: AnyObject = reviews["dateAdded"] {
//                model.dateAdded = reviews["dateAdded"] as! String
//            }
//            
//            if let val: AnyObject = reviews["userId"] {
//                model.userId = reviews["userId"] as! Int
//            }
//            
//            if let val: AnyObject = reviews["review"] {
//                model.review = reviews["review"] as! String
//            }
//            
//            if let val: AnyObject = reviews["message"] {
//                model.review = reviews["message"] as! String
//            }
        }
        
        return model
    }
    
    class func parseSellerProductReviesModel(reviews: NSDictionary) -> ProductReviewsModel! {
        
        var model = ProductReviewsModel()
        if reviews.isKindOfClass(NSDictionary) {
            
            model.ratingSellerReview = reviews["rating"] as! Int
            model.fullName = reviews["name"] as! String
            model.review = reviews["message"] as! String
            model.imageUrl = reviews["imageUrl"] as! String
            
        }
        
        return model
    }
    
}