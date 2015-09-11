//
//  TransactionDetailsProductsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/11/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDetailsProductsModel: NSObject {
    /*
    var orderProductId: [Int] = []
    var productId: [Int] = []
    var quantity: [Int] = []
    var unitPrice: [Float] = []
    var totalPrice: [Float] = []
    var productName: [String] = []
    var handlingFee: [Float] = []
    var orderProductStatusId: [Bool] = []
    var name: [String] = []
    var productDescription: [String] = []
    var productImage: [String] = []
    */
    var orderProductId: Bool = false
    var productId: String = ""
    var quantity: Int = 0
    var unitPrice: String = ""
    var totalPrice: String = ""
    var productName: String = ""
    var handlingFee: String = ""
    
    init(orderProductId: Bool, productId: String, quantity: Int, unitPrice: String, totalPrice: String, productName: String, handlingFee: String) {
        self.orderProductId = orderProductId
        self.productId = productId
        self.quantity = quantity
        self.unitPrice = unitPrice
        self.totalPrice = totalPrice
        self.productName = productName
        self.handlingFee = handlingFee
        
    }
    
    /*
    init(orderProductId: NSArray, productId: NSArray, quantity: NSArray, unitPrice: NSArray, totalPrice: NSArray, productName: NSArray, handlingFee: NSArray, orderProductStatusId: NSArray, name: NSArray, productDescription: NSArray, productImage: NSArray) {
        
        self.orderProductId = orderProductId as! [Int]
        self.productId = productId as! [Int]
        self.quantity = quantity as! [Int]
        self.unitPrice = unitPrice as! [Float]
        self.totalPrice = totalPrice as! [Float]
        self.productName = productName as! [String]
        self.handlingFee = handlingFee as! [Float]
        self.orderProductStatusId = orderProductStatusId as! [Bool]
        self.name = name as! [String]
        self.productDescription = productDescription as! [String]
        self.productImage = productImage as! [String]
        
    }
    
    class func parseDataFromDictionary(dictionary: AnyObject) -> TransactionDetailsProductsModel {
        
        var orderProductId: [Int] = []
        var productId: [Int] = []
        var quantity: [Int] = []
        var unitPrice: [Float] = []
        var totalPrice: [Float] = []
        var productName: [String] = []
        var handlingFee: [Float] = []
        var orderProductStatusId: [Bool] = []
        var name: [String] = []
        var productDescription: [String] = []
        var productImage: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let value: AnyObject = dictionary["data"] {
                let products: NSArray = value["products"] as! NSArray
                for product in products as! [NSDictionary] {
                    
                    orderProductId.append(product["orderProductId"] as! Int)
                    productId.append(product["productId"] as! Int)
                    quantity.append(product["quantity"] as! Int)
                    unitPrice.append(product["unitPrice"] as! Float)
                    totalPrice.append(product["totalPrice"] as! Float)
                    productName.append(product["productName"] as! String)
                    handlingFee.append(product["handlingFee"] as! Float)
                    
                    if let orderProductStatus: AnyObject = dictionary["orderProductStatus"] {
                        orderProductStatusId.append(orderProductStatus["orderProductStatusId"] as! Bool)
                        name.append(orderProductStatus["name"] as! String)
                        productDescription.append(orderProductStatus["description"] as! String)
                    }
                    
                    productImage.append(product["productImage"] as! String)
                }
            }
        }
        
        let transactionDetailsProductModel =  TransactionDetailsProductsModel(orderProductId: orderProductId, productId: productId, quantity: quantity, unitPrice: unitPrice, totalPrice: totalPrice, productName: productName, handlingFee: handlingFee, orderProductStatusId: orderProductStatusId, name: name, productDescription: productDescription, productImage: productImage)
        
        return transactionDetailsProductModel
    }
    */
}
