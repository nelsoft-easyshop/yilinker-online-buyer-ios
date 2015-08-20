//
//  ProductReviewsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductReviewsModel {
    
    var fullName: String = ""
    var profileImageUrl: String = ""
    var rating: String = ""
    var title: String = ""
    var review: String = ""
    var dateAdded: String = ""
    var userId: Int = 0
    
    class func parseProductReviesModel(reviews: NSDictionary) -> ProductReviewsModel! {
        
        var model = ProductReviewsModel()
        if reviews.isKindOfClass(NSDictionary) {
            
            if let val: AnyObject = reviews["fullName"] {
                model.fullName = reviews["fullName"] as! String
            } else {
                model.fullName = reviews["name"] as! String
            }
            
            
            if let val: AnyObject = reviews["profileImageUrl"] {
                model.profileImageUrl = reviews["profileImageUrl"] as! String
            } else {
                model.profileImageUrl = reviews["imageUrl"] as! String
            }
            
            if let val: AnyObject = reviews["rating"] {
                if let tempRating = reviews["ratins"] as? String {
                    model.rating = reviews["rating"] as! String
                }
            } else {
                model.rating = "5"
            }
            
            if let val: AnyObject = reviews["title"] {
                model.title = reviews["title"] as! String
            }
            
            if let val: AnyObject = reviews["dateAdded"] {
                model.dateAdded = reviews["dateAdded"] as! String
            }
            
            if let val: AnyObject = reviews["userId"] {
                model.userId = reviews["userId"] as! Int
            }
            
            if let val: AnyObject = reviews["review"] {
                model.review = reviews["review"] as! String
            }
        }

        return model
    }
    
}