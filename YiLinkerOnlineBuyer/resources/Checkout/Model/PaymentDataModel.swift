//
//  PaymentDataModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/4/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PaymentDataModel: NSObject {
    var orderId: Int = 0
    var invoiceNumber: String = ""
    var totalPrice: String = ""
    var orderedProductsModel: [OrderedProductsModel] = []
    var message: String = ""
    
    init (orderId: Int, invoiceNumber: String, totalPrice: String, orderedProductsModel: [OrderedProductsModel], message: String) {
        self.orderId = orderId
        self.invoiceNumber = invoiceNumber
        self.totalPrice = totalPrice
        self.orderedProductsModel = orderedProductsModel
        self.message = message
    }
    
    override init() {
        
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> PaymentDataModel {
        var orderId: Int = 0
        var invoiceNumber: String = ""
        var orderedProductsModel: [OrderedProductsModel] = []
        var totalPriceString: String = ""
        var message: String = ""
        
        if let val: AnyObject = dictionary["orderId"] {
            if let tempOrderId = dictionary["orderId"] as? Int {
                orderId = tempOrderId
            }
        }
        
        if let val: AnyObject = dictionary["invoiceNumber"] {
            if let tempVal = dictionary["invoiceNumber"] as? String {
                invoiceNumber = tempVal
            }
        }
        
        if let val: AnyObject = dictionary["totalPrice"] {
            if let tempVal = dictionary["totalPrice"] as? String {
                totalPriceString = ("\(tempVal)")
            }
        }
        
        if let val: AnyObject = dictionary["message"] {
            if let tempVal = dictionary["message"] as? String {
                message = ("\(tempVal)")
            }
        }
        
        
        var orderProducts: [NSDictionary] = dictionary["orderProducts"] as! [NSDictionary]
        
        for productDictionary in orderProducts {
            orderedProductsModel.append(OrderedProductsModel.parseDataWithDictionary(productDictionary))
        }

        return PaymentDataModel(orderId: orderId, invoiceNumber: invoiceNumber, totalPrice: totalPriceString, orderedProductsModel: orderedProductsModel, message: message)
    }
}
