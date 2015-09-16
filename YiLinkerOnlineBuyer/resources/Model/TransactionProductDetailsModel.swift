//
//  TransactionProductDetailsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/16/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionProductDetailsModel: NSObject {
   /*
    "productImage": "",
    "sku": "",
    "attributes": {
    "Color": "Blue",
    "Size": "Large"
    },
    "originalUnitPrice": "0.0000",
    "discount": "0.00",
    "width": "0.00",
    "height": "0.00",
    "length": "0.00",
    "weight": "0.00”,
    
    "brand": {
    "name": "Custom",
    "id": 1
    }
    */
    
    var productImage: String = ""
    var sku: String = ""
    var color: String = ""
    var size: String = ""
    var width: String = ""
    var height: String = ""
    var length: String = ""
    var weight: String = ""
    var brandName: String = ""
    
    init(productImage: String, sku: String, color: String, size: String, width: String, height: String, length: String, weight: String, brandName: String) {
        self.productImage = productImage
        self.sku = sku
        self.color = color
        self.size = size
        self.width = width
        self.height = height
        self.length = length
        self.weight = weight
        self.brandName = brandName
    }
    
    class func parseFromDataDictionary(dictionary: AnyObject) -> TransactionProductDetailsModel {
        
        var productImage: String = ""
        var sku: String = ""
        var color: String = ""
        var size: String = ""
        var width: String = ""
        var height: String = ""
        var length: String = ""
        var weight: String = ""
        var brandName: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let value: AnyObject = dictionary["data"] {
                
                if let val = value["productImage"] as? String {
                    productImage = val
                }
                
                if let val = value["sku"] as? String {
                    productImage = val
                }
                
                if let attributes: AnyObject = value["attributes"] {
                    if let val = attributes["Color"] as? String {
                        color = val
                    }
                    
                    if let val = attributes["Size"] as? String {
                        size = val
                    }
                }
                
                if let val = value["width"] as? String {
                    width = val
                }
                
                if let val = value["height"] as? String {
                    height = val
                }
                
                if let val = value["length"] as? String {
                    length = val
                }
                
                if let val = value["weight"] as? String {
                    weight = val
                }
                
                if let brand: AnyObject = value["brand"] {
                    if let val = brand["name"] as? String {
                        brandName = val
                    }
                }
                
            }
        }
        
        let transactionProductDetailsModel = TransactionProductDetailsModel(productImage: productImage, sku: sku, color: color, size: size, width: width, height: height, length: length, weight: weight, brandName: brandName)
        
        return transactionProductDetailsModel
        
    }
    
}
