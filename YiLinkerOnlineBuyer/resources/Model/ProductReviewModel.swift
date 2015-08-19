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
    var ratingAverage: Int = 0
    var reviews: [ProductReviewsModel] = []
    
    init(message: String, isSuccessful: Bool, ratingAverage: Int, reviews: NSArray) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.ratingAverage = ratingAverage
        self.reviews = reviews as! [ProductReviewsModel]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductReviewModel! {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var ratingAverage: Int = 0
        var reviews: [ProductReviewsModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                if let tempVar = value["ratingAverage"] as? Int {
                    ratingAverage = tempVar
                }
                
                for subValue in value["reviews"] as! NSArray {
                    let model: ProductReviewsModel = ProductReviewsModel.parseProductReviesModel(subValue as! NSDictionary)
                    reviews.append(model)
                }
            }
        } // dictionary
        
        return ProductReviewModel(message: message, isSuccessful: isSuccessful, ratingAverage: ratingAverage, reviews: reviews)
    } // parse
}