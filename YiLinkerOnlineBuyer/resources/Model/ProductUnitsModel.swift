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
    var discount: Int = 0
    
    var createdDate: String = ""
    var createdTimzeZoneType: Int = 0
    var createdTimezone: String = ""
    
    var lastModifiedDate: String = ""
    var lastModifiedTimeZoneType: Int = 0
    var lastModifiedTimeZone: String = ""
    
    var status: Int = 0
    var imageIds: [String] = []
    var combination: [String] = []
    var combinationNames: [String] = []
    var primaryImage: String = ""
    
    class func parseProductUnits(dictionary: NSDictionary) -> ProductUnitsModel {
        
        var model = ProductUnitsModel()
        
        if dictionary.isKindOfClass(NSDictionary) {
            model.productUnitId = ParseHelper.string(dictionary, key: "productUnitId", defaultValue: "0")
            model.quantity = ParseHelper.int(dictionary, key: "quantity", defaultValue: 0)
            model.sku = ParseHelper.string(dictionary, key: "sku", defaultValue: "0")
            model.price = ParseHelper.string(dictionary, key: "price", defaultValue: "0")
            model.discount = ParseHelper.int(dictionary, key: "discount", defaultValue: 0)
            model.discountedPrice = ParseHelper.string(dictionary, key: "discountedPrice", defaultValue: "0")
            model.status = ParseHelper.int(dictionary, key: "status", defaultValue: 0)
            model.imageIds = ParseHelper.array(dictionary, key: "imageIds", defaultValue: []) as! [String]
            model.primaryImage = ParseHelper.string(dictionary, key: "primaryImage", defaultValue: "0")
            model.combination = ParseHelper.array(dictionary, key: "combination", defaultValue: []) as! [String]
            model.combinationNames = ParseHelper.array(dictionary, key: "combinationNames", defaultValue: []) as! [String]
                
            if let created: AnyObject = dictionary["dateCreated"] {
                model.createdDate = ParseHelper.string(created, key: "date", defaultValue: "0")
                model.createdTimzeZoneType = ParseHelper.int(created, key: "timezone_type", defaultValue: 0)
                model.createdTimezone = ParseHelper.string(created, key: "timezone", defaultValue: "0")
            }
            
            if let lastModified: AnyObject = dictionary["dateLastModified"] {
                model.lastModifiedDate = ParseHelper.string(lastModified, key: "date", defaultValue: "0")
                model.lastModifiedTimeZoneType = ParseHelper.int(lastModified, key: "timezone_type", defaultValue: 0)
                model.lastModifiedTimeZone = ParseHelper.string(lastModified, key: "timezone", defaultValue: "0")
            }
            
        } // if dictionary
        
        return model
        
    } // parse Product Units
}

