//
//  ProductReviewModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductReviewModel {
    
    var message: String = ""
    var isSuccessful: Bool = false
    var rating: Float = 0.0
    var reviews: [ProductReviewsModel] = []
    
    init(message: String, isSuccessful: Bool, rating: Float, reviews: NSArray) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.rating = rating
        self.reviews = reviews as! [ProductReviewsModel]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductReviewModel! {
        
        var message: String = ""
        var isSuccessful: Bool = false
        var rating: Float = 0.0
        var reviews: [ProductReviewsModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                if let tempVar = value["rating"] as? Float {
                    rating = tempVar
                }
                
                for subValue in value["reviews"] as! NSArray {
                    let model: ProductReviewsModel = ProductReviewsModel.parseProductReviesModel(subValue as! NSDictionary)
                    reviews.append(model)
                }
            }
            
            return ProductReviewModel(message: message, isSuccessful: isSuccessful, rating: rating, reviews: reviews)
        } else {
            return ProductReviewModel(message: "", isSuccessful: false, rating: 0.0, reviews: [])
        }
        
        
    }
}