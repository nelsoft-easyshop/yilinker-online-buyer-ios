//
//  ProductReviewsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductReviewsModel {
    
    var name: String = ""
    var imageUrl: String = ""
    var rating: Float = 0
    var message: String = ""
    
    class func parseProductReviesModel(reviews: NSDictionary) -> ProductReviewsModel! {
        
        var model = ProductReviewsModel()
        if reviews.isKindOfClass(NSDictionary) {
            model.name = reviews["name"] as! String
            model.imageUrl = reviews["imageUrl"] as! String
            model.rating = reviews["rating"] as! Float
            model.message = reviews["message"] as! String
        }

        return model
    }
    
}