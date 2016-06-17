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
            let keyExists = dictionary["productUnitId"] != nil
            if keyExists {
                if let tempVar = dictionary["productUnitId"] as? String {
                    model.productUnitId = tempVar
                } else {
                    model.productUnitId = "0"
                }
                
                if let tempVar = dictionary["quantity"] as? Int {
                    model.quantity = tempVar
                } else {
                    model.quantity = 0
                }
                
                if let tempVar = dictionary["sku"] as? String {
                    model.sku = tempVar
                } else {
                    model.sku = "0"
                }
                
                if let tempVar = dictionary["price"] as? String {
                    model.price = tempVar
                } else {
                    model.price = "0"
                }
                
                if let tempVar = dictionary["discount"] as? Int {
                    model.discount = tempVar
                } else {
                    model.discount = 0
                }
                
                if let tempVar = dictionary["discountedPrice"] as? String {
                    model.discountedPrice = tempVar
                } else {
                    model.discountedPrice = "0"
                }
                
                if let created: AnyObject = dictionary["dateCreated"] {
                    if let tempVar = created["date"] as? String {
                        model.createdDate = tempVar
                    } else {
                        model.createdDate = "0"
                    }
                    
                    if let tempVar = created["timezone_type"] as? Int {
                        model.createdTimzeZoneType = tempVar
                    } else {
                        model.createdTimzeZoneType = 0
                    }
                    
                    if let tempVar = created["timezone"] as? String {
                        model.createdTimezone = tempVar
                    } else {
                        model.createdTimezone = "0"
                    }
                }
                
                if let lastModified: AnyObject = dictionary["dateLastModified"] {
                    if let tempVar = lastModified["date"] as? String {
                        model.lastModifiedDate = tempVar
                    } else {
                        model.lastModifiedDate = "0"
                    }
                    
                    if let tempVar = lastModified["timezone_type"] as? Int {
                        model.lastModifiedTimeZoneType = tempVar
                    } else {
                        model.lastModifiedTimeZoneType = 0
                    }
                    
                    if let tempVar = lastModified["timezone"] as? String {
                        model.lastModifiedTimeZone = tempVar
                    } else {
                        model.lastModifiedTimeZone = "0"
                    }
                    
                }
                
                if let tempVar = dictionary["status"] as? Int {
                    model.status = tempVar
                } else {
                    model.productUnitId = "0"
                }
                
                if let tempVar = dictionary["imageIds"] as? NSArray {
                    model.imageIds = tempVar as! [String]
                } else {
                    model.imageIds = []
                }
                
                if let tempVar = dictionary["primaryImage"] as? String {
                    model.primaryImage = tempVar
                } else {
                    model.primaryImage = ""
                }
                
                if let tempVar = dictionary["combination"] as? NSArray {
                    model.combination = tempVar as! [String]
                } else {
                    model.combination = []
                }
                
                if let tempVar = dictionary["combinationNames"] as? NSArray {
                    model.combinationNames = tempVar as! [String]
                } else {
                    model.combinationNames = []
                }
            } // if exists
            
        } // if dictionary
        
        return model
        
    } // parse Product Units
}

