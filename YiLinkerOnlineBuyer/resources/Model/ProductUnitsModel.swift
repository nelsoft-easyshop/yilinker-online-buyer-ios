//
//  ProductUnitsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductUnitsModel {
    var productUnitId: String = ""
    var quantity: Int = 0
    var sku: String = ""
    var price: String = ""
    var discountedPrice: String = ""
    
    var createdDate: String = ""
    var createdTimzeZoneType: Int = 0
    var createdTimezone: String = ""
    
    var lastModifiedDate: String = ""
    var lastModifiedTimeZoneType: Int = 0
    var lastModifiedTimeZone: String = ""
    
    var status: Int = 0
    var imageIds: [String] = []
    var combination: [String] = []
    
    class func parseProductUnits(dictionary: NSDictionary) -> ProductUnitsModel {
        
        var model = ProductUnitsModel()
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["productUnitId"] as? String {
                model.productUnitId = tempVar
            }
            
            if let tempVar = dictionary["quantity"] as? Int {
                model.quantity = tempVar
            }
            
            if let tempVar = dictionary["sku"] as? String {
                model.sku = tempVar
            }
            
            if let tempVar = dictionary["price"] as? String {
                model.price = tempVar
            }
            
            if let tempVar = dictionary["discountedPrice"] as? String {
                model.discountedPrice = tempVar
            }
            
            if let created: AnyObject = dictionary["dateCreated"] {
                if let tempVar = created["date"] as? String {
                    model.createdDate = tempVar
                }
                
                if let tempVar = created["timezone_type"] as? Int {
                    model.createdTimzeZoneType = tempVar
                }
                
                if let tempVar = created["timezone"] as? String {
                    model.createdTimezone = tempVar
                }
            }
            
            if let lastModified: AnyObject = dictionary["dateLastModified"] {
                if let tempVar = lastModified["date"] as? String {
                    model.lastModifiedDate = tempVar
                }
                
                if let tempVar = lastModified["timezone_type"] as? Int {
                    model.lastModifiedTimeZoneType = tempVar
                }
                
                if let tempVar = lastModified["timezone"] as? String {
                    model.lastModifiedTimeZone = tempVar
                }

            }
            
            if let tempVar = dictionary["status"] as? Int {
                model.status = tempVar
            }
            
            if let tempVar = dictionary["imageIds"] as? NSArray {
                model.imageIds = tempVar as! [String]
            }
            
            if let tempVar = dictionary["combination"] as? NSArray {
                model.combination = tempVar as! [String]
            }
            
        } // if dictionary
        
        return model
        
    } // parse Product Units
}



































