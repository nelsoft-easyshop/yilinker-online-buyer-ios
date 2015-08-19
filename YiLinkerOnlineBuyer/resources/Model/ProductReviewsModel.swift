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
            model.fullName = reviews["fullName"] as! String
            model.profileImageUrl = reviews["profileImageUrl"] as! String
            model.rating = reviews["rating"] as! String
            model.title = reviews["title"] as! String
            model.dateAdded = reviews["dateAdded"] as! String
            model.userId = reviews["userId"] as! Int
            model.review = reviews["review"] as! String
        }

        return model
    }
    
}