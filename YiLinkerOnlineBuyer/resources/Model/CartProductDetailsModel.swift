//
//  CartProductDetailsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CartProductDetailsModel: NSObject {
    
    var id: Int = 0
    var title: String = ""
    var image: NSURL = NSURL(string: "")!
    var shortDescription: String = ""
    var fullDescription: String = ""
    var sellerId: Int = 0
    var originalPrice: Float = 0
    var newPrice: Float = 0
    var discount: Float = 0
    var details: [String] = []
    
    var attributes: [ProductAttributeModel] = []
    var combinations: [ProductAvailableAttributeCombinationModel] = []
    
    init(id: Int, title: String, image: NSURL, originalPrice: Float, newPrice: Float, discount: Float, shortDescription: String, fullDescription: String, sellerId: Int, details: NSArray, attributes: NSArray, combinations: NSArray) {
        
        self.id = id
        self.title = title
        self.image = image
        self.originalPrice = originalPrice
        self.newPrice = newPrice
        self.discount = discount
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.sellerId = sellerId
        self.attributes = attributes as! [ProductAttributeModel]
        self.combinations = combinations as! [ProductAvailableAttributeCombinationModel]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CartProductDetailsModel {
        
        var message: String = ""
        var isSuccessful: String = ""
        
        var id: Int = 0
        var title: String = ""
        var image: NSURL = NSURL(string: "")!
        var shortDescription: String = ""
        var fullDescription: String = ""
        var sellerId: Int = 0
        var originalPrice: Float = 0
        var newPrice: Float = 0
        var discount: Float = 0
        var details: [String] = []
        
        var attributes: [ProductAttributeModel] = []
        var combinations: [ProductAvailableAttributeCombinationModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let tempVar = dictionary["id"] as? Int {
                id = tempVar
            }
            
            if let tempVar = dictionary["title"] as? String {
                title = tempVar
            }
            
            if let tempVar = dictionary["image"] as? String {
                image = NSURL(string: tempVar)!
            }
            
            if let tempVar = dictionary["shortDescription"] as? String {
                shortDescription = tempVar
            }
            
            if let tempVar = dictionary["fullDescription"] as? String {
                fullDescription = tempVar
            }
            
            if let tempVar = dictionary["sellerId"] as? Int {
                sellerId = tempVar
            }
            
            if let tempVar = dictionary["originalPrice"] as? Float {
                originalPrice = tempVar
            }
            
            if let tempVar = dictionary["newPrice"] as? Float {
                newPrice = tempVar
            }
            
            if let tempVar = dictionary["discount"] as? Float {
                discount = tempVar
            }
            
            for subValue in dictionary["attributes"] as! NSArray {
                let model: ProductAttributeModel = ProductAttributeModel.parseAttribute(subValue as! NSDictionary)
                attributes.append(model)
            }
            
            for subValue in dictionary["availableAttributeCombi"] as! NSArray {
                let model: ProductAvailableAttributeCombinationModel = ProductAvailableAttributeCombinationModel.parseCombination(subValue as! NSDictionary)
                
                combinations.append(model)
                
                
            }
        } // end if dictionary
        
        return  CartProductDetailsModel(id: id,
            title: title, image: image,
            originalPrice: originalPrice,
            newPrice: newPrice,
            discount: discount,
            shortDescription: shortDescription,
            fullDescription: fullDescription,
            sellerId: sellerId,
            details: details,
            attributes: attributes,
            combinations: combinations)
        
        
    }// parseDataWithDictionary
    
}
