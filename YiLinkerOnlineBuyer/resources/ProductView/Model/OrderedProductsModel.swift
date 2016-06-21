//
//  OrderedProductsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/4/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class OrderedProductsModel: NSObject {
    var orderProductId: Int = 0
    var quantity: Int = 0
    var unitPrice: String = ""
    var totalPrice: Int = 0
    var productName: String = ""
    var handlingFee: Int = 0
    
    init(orderProductId: Int, quantity: Int, unitPrice: String, totalPrice: Int, productName: String, handlingFee: Int) {
        self.orderProductId = orderProductId
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
        self.productName = productName
        self.handlingFee = handlingFee
    }
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> OrderedProductsModel {
        var orderProductId: Int = 0
        var quantity: Int = 0
        var unitPrice: String = ""
        var totalPrice: Int = 0
        var productName: String = ""
        var handlingFee: Int = 0
    
        if let val: AnyObject = dictionary["orderProductId"] {
            if let tempVal = dictionary["orderProductId"] as? Int {
                orderProductId = tempVal
            }
        }
        
        if let val: AnyObject = dictionary["quantity"] {
            if let tempVal = dictionary["quantity"] as? Int {
                quantity = tempVal
            }
        }
        
        if let val: AnyObject = dictionary["unitPrice"] {
            if let tempVal = dictionary["unitPrice"] as? String {
                unitPrice = tempVal
            }
        }
        
        if let val: AnyObject = dictionary["totalPrice"] {
            if let tempVal = dictionary["totalPrice"] as? Int {
                totalPrice = tempVal
            }
        }
        
        if let val: AnyObject = dictionary["productName"] {
            if let tempVal = dictionary["productName"] as? String {
                productName = tempVal
            }
        }
        
        if let val: AnyObject = dictionary["handlingFee"] {
            if let tempVal = dictionary["handlingFee"] as? Int {
                handlingFee = tempVal
            }
        }
        
        return OrderedProductsModel(orderProductId: orderProductId, quantity: quantity, unitPrice: unitPrice, totalPrice: totalPrice, productName: productName, handlingFee: handlingFee)
    }
}
