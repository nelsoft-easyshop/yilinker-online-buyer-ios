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
            
            if reviews["userId"] != nil {
                model.userId = reviews["userId"] as! Int
            }
            
//            if reviews["userId"] != nil {
//                 model.title = reviews["title"] as! String
//            }
            
            if reviews["review"] != nil {
                model.review = reviews["review"] as! String
            }
            
            if reviews["rating"] != nil {
                model.rating = reviews["rating"] as! String
            }
            
            if reviews["fullName"] != nil {
                model.fullName = reviews["fullName"] as! String
            }
            
            if reviews["firstName"] != nil {
                model.firstName = reviews["firstName"] as! String
            }
            
            if reviews["lastName"] != nil {
                model.lastName = reviews["lastName"] as! String
            }
            
            if reviews["profileImageUrl"] != nil {
                model.profileImageUrl = reviews["profileImageUrl"] as! String
            }
            
            if reviews["dateAdded"] != nil {
                model.dateAdded = reviews["dateAdded"] as! String
            }
   
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