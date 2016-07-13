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
    var longDescription: String = ""
    var shortDescription: String = ""
    var attributeName: [String] = []
    var attributeValue: [String] = []
    var isCancellable: Bool = false
    var hasFeedback: Bool = false
    var orderProductId: Int = 0
    var orderProductStatusId: Int = 0
    
    
    /*
    deliveryLogs =     {
    deliveryRider =         {
    contactNumber = 09000000000;
    deliveryRider = "Online QA";
    pickupRider = "";
    };
    lastActionType = "Received by Recipient";
    lastCheckedInBy = "Online QA";
    lastCheckedInDate =         {
    date = "2016-07-10 19:41:03.000000";
    timezone = "Asia/Manila";
    "timezone_type" = 3;
    };
    lastCheckedinLocation = "Home address  Bagong Lipunan Ng Crame Quezon City Metro Manila-Quezon City";
    pickupRider =         {
    contactNumber = 09000000000;
    pickupRider = "Online QA";
    };
    };
    */
    
    init(productImage: String, sku: String, color: String, size: String, width: String, height: String, length: String, weight: String, brandName: String, longDescription: String, shortDescription: String, attributeName: NSArray, attributeValue: NSArray, isCancellable: Bool, hasFeedback: Bool, orderProductId: Int, orderProductStatusId: Int) {
        self.productImage = productImage
        self.sku = sku
        self.color = color
        self.size = size
        self.width = width
        self.height = height
        self.length = length
        self.weight = weight
        self.brandName = brandName
        self.longDescription = longDescription
        self.shortDescription = shortDescription
        self.attributeName = attributeName as! [String]
        self.attributeValue = attributeValue as! [String]
        self.isCancellable = isCancellable
        self.hasFeedback = hasFeedback
        self.orderProductId = orderProductId
        self.orderProductStatusId = orderProductStatusId
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
        var longDescription: String = ""
        var shortDescription: String = ""
        var isCancellable: Bool = false
        var hasFeedback: Bool = false
        var orderProductId: Int = 0
        var orderProductStatusId: Int = 0
        
        var attributeName: [String] = []
        var attributeValue: [String] = []
        
        var skuTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_SKU_LOCALIZE_KEY")
        var brandTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_BRAND_LOCALIZE_KEY")
        var widthTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_WIDTH_LOCALIZE_KEY")
        var heightTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_HEIGHT_LOCALIZE_KEY")
        var lengthTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_LENGTH_LOCALIZE_KEY")
        var weightTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_WEIGHT_LOCALIZE_KEY")
        var colorTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_COLOR_LOCALIZE_KEY")
        var sizeTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_SIZE_LOCALIZE_KEY")
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let value: AnyObject = dictionary["data"] {
                
                if let val = value["productImage"] as? String {
                    productImage = val
                } else {
                    productImage = ""
                }
                
                if let val = value["isCancellable"] as? Bool {
                    isCancellable = val
                } else {
                    isCancellable = false
                }
                
                if let val = value["hasProductReview"] as? Bool {
                    hasFeedback = val
                } else {
                    hasFeedback = false
                }
                
                if let val = value["orderProductId"] as? Int {
                    orderProductId = val
                } else {
                    orderProductId = 0
                }
                
                if let val = value["sku"] as? String {
                    sku = val
                    attributeName.append(skuTitle)
                    attributeValue.append(sku)
                } else {
                    sku = ""
                    attributeName.append(skuTitle)
                    attributeValue.append(sku)
                }
                
                if let brand: AnyObject = value["brand"] {
                    if let val = brand["name"] as? String {
                        brandName = val
                        attributeName.append(brandTitle)
                        attributeValue.append(brandName)
                    } else {
                        brandName = ""
                        attributeName.append(brandTitle)
                        attributeValue.append(brandName)
                    }
                }
                
                if let order: AnyObject = value["orderProductStatus"] {
                    if let val = order["orderProductStatusId"] as? Int {
                        orderProductStatusId = val
                    } else {
                        orderProductStatusId = 0
                    }
                }
                
                let attributes: NSArray = value["attributes"] as! NSArray
                for attribute in attributes as! [NSDictionary] {
                    attributeName.append(attribute["attributeName"] as! String)
                    attributeValue.append(attribute["attributeValue"] as! String)
                }
                
                if let attributes: AnyObject = value["attributes"] {
                    if let val = attributes["Color"] as? String {
                        color = val
                    } else {
                        color = ""
                    }
                    
                    if let val = attributes["Size"] as? String {
                        size = val
                    } else {
                        size = ""
                    }
                }
                
                if let val = value["width"] as? String {
                    width = val
                    attributeName.append(widthTitle)
                    attributeValue.append(width)
                } else {
                    width = ""
                    attributeName.append(widthTitle)
                    attributeValue.append(width)
                }
                
                if let val = value["height"] as? String {
                    height = val
                    attributeName.append(heightTitle)
                    attributeValue.append(height)
                } else {
                    height = ""
                    attributeName.append(heightTitle)
                    attributeValue.append(height)
                }
                
                if let val = value["length"] as? String {
                    length = val
                    attributeName.append(lengthTitle)
                    attributeValue.append(length)
                } else {
                    length = ""
                    attributeName.append(lengthTitle)
                    attributeValue.append(length)
                }
                
                if let val = value["weight"] as? String {
                    weight = val
                    attributeName.append(weightTitle)
                    attributeValue.append(weight)
                } else {
                    weight = ""
                    attributeName.append(weightTitle)
                    attributeValue.append(weight)
                }
                
                if let val = value["description"] as? String {
                    longDescription = val
                } else {
                   longDescription = ""
                }
                
                if let val = value["shortDescription"] as? String {
                    shortDescription = val
                } else {
                    shortDescription = ""
                }
                
            }
        }
        
        let transactionProductDetailsModel = TransactionProductDetailsModel(productImage: productImage, sku: sku, color: color, size: size, width: width, height: height, length: length, weight: weight, brandName: brandName, longDescription: longDescription, shortDescription: shortDescription, attributeName: attributeName, attributeValue: attributeValue, isCancellable: isCancellable, hasFeedback: hasFeedback, orderProductId
            : orderProductId, orderProductStatusId: orderProductStatusId)
        
        return transactionProductDetailsModel
        
    }
    
}
