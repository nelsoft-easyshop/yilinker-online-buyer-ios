//
//  ProductDetailsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/7/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductDetailsModel {

    var id: Int = 0
    var title: String = ""
    var shortDescription: String = ""
    var fullDescription: String = ""
    var sellerId: Int = 0
    var originalPrice: Float = 0
    var newPrice: Float = 0
    var discount: Float = 0
    var details: [String] = []
    
    var attributes: [ProductAttributeModel] = []
    var combinations: [ProductAvailableAttributeCombinationModel] = []
    
    init(id: Int, title: String, originalPrice: Float, newPrice: Float, discount: Float, shortDescription: String, fullDescription: String, sellerId: Int, details: NSArray, attributes: NSArray, combinations: NSArray) {
        
        self.id = id
        self.title = title
        self.originalPrice = originalPrice
        self.newPrice = newPrice
        self.discount = discount
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.details = details as! [String]
        self.sellerId = sellerId
        self.attributes = attributes as! [ProductAttributeModel]
        self.combinations = combinations as! [ProductAvailableAttributeCombinationModel]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductDetailsModel {
        
        var message: String = ""
        var isSuccessful: String = ""
        
        var id: Int = 0
        var title: String = ""
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
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? String {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                
                if let tempVar = value["id"] as? Int {
                    id = tempVar
                }
                
                if let tempVar = value["title"] as? String {
                    title = tempVar
                }
                
                if let tempVar = value["shortDescription"] as? String {
                    shortDescription = tempVar
                }
                
                if let tempVar = value["fullDescription"] as? String {
                    fullDescription = tempVar
                }
                
                if let tempVar = value["sellerId"] as? Int {
                    sellerId = tempVar
                }
             
                if let tempVar = value["originalPrice"] as? Float {
                    originalPrice = tempVar
                }
                
                if let tempVar = value["newPrice"] as? Float {
                    newPrice = tempVar
                }
                
                if let tempVar = value["discount"] as? Float {
                    discount = tempVar
                }
                
                for subValue in value["attributes"] as! NSArray {
                    let model: ProductAttributeModel = ProductAttributeModel.parseAttribute(subValue as! NSDictionary)
                    attributes.append(model)
                }

                for subValue in value["availableAttributeCombi"] as! NSArray {
                    let model: ProductAvailableAttributeCombinationModel = ProductAvailableAttributeCombinationModel.parseCombination(subValue as! NSDictionary)
                    
                    combinations.append(model)
                }
                
                if let tempVar = value["details"] as? NSArray {
                    details = tempVar as! [String]
                }
            }
        } // end if dictionary
        
        return  ProductDetailsModel(id: id,
            title: title,
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