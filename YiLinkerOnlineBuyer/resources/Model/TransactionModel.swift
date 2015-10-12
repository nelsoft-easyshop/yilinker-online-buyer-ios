//
//  TransactionModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionModel: NSObject {
   /*
    "orders": [
    {
    "order_id": "381",
    "date_added": "2015-09-09 13:12:42",
    "invoice_number": "",
    "payment_type": "Dragonpay",
    "payment_method_id": "2",
    "order_status": "Payment Confirmed",
    "order_status_id": "2",
    "total_price": "1000.0000",
    "total_unit_price": "1000.0000",
    "total_item_price": "1000.0000",
    "total_handling_fee": "0.0000",
    "total_quantity": "1",
    "product_names": "Sample Product 1",
    "product_count": "1"
    },
    */
    var order_id: [String] = []
    var date_added: [String] = []
    var invoice_number: [String] = []
    var payment_type: [String] = []
    var payment_method_id: [String] = []
    var order_status: [String] = []
    var order_status_id: [String] = []
    var total_price: [String] = []
    var total_unit_price: [String] = []
    var total_item_price: [String] = []
    var total_handling_fee: [String] = []
    var total_quantity: [String] = []
    var product_name: [String] = []
    var product_count: [String] = []
    var is_successful: Bool = false
    
    var order_id2: String = ""
    var date_added2: String = ""
    var invoice_number2: String = ""
    var payment_type2: String = ""
    var payment_method_id2: String = ""
    var order_status2: String = ""
    var order_status_id2: String = ""
    var total_price2: String = ""
    var total_unit_price2: String = ""
    var total_item_price2: String = ""
    var total_handling_fee2: String = ""
    var total_quantity2: String = ""
    var product_name2: String = ""
    var product_count2: String = ""
    var order_count: Int = 0
    var unique_order_product_statuses: String = ""
    
    init(order_id: NSArray, date_added: NSArray, invoice_number: NSArray, payment_type: NSArray, payment_method_id: NSArray, order_status: NSArray, order_status_id: NSArray, total_price: NSArray, total_unit_price: NSArray, total_item_price: NSArray, total_handling_fee: NSArray, total_quantity: NSArray, product_name: NSArray, product_count: NSArray, is_successful: Bool){
        
        self.order_id = order_id as! [String]
        self.date_added = date_added as! [String]
        self.invoice_number = invoice_number as! [String]
        self.payment_type = payment_type as! [String]
        self.payment_method_id = payment_method_id as! [String]
        self.order_status = order_status as! [String]
        self.order_status_id = order_status_id as! [String]
        self.total_price = total_price as! [String]
        self.total_unit_price = total_unit_price as! [String]
        self.total_item_price = total_item_price as! [String]
        self.total_handling_fee = total_handling_fee as! [String]
        self.total_quantity = total_quantity as! [String]
        self.product_name = product_name as! [String]
        self.product_count = product_count as! [String]
        self.is_successful = is_successful
    }
    
    init(order_id: String, date_added: String, invoice_number: String, payment_type: String, payment_method_id: String, order_status: String, order_status_id: String, total_price: String, total_unit_price: String, total_item_price: String, total_handling_fee: String, total_quantity: String, product_name: String, product_count: String, is_successful: Bool, order_count: Int){
        
        self.order_id2 = order_id
        self.date_added2 = date_added
        self.invoice_number2 = invoice_number
        self.payment_type2 = payment_type
        self.payment_method_id2 = payment_method_id
        self.order_status2 = order_status
        self.order_status_id2 = order_status_id
        self.total_price2 = total_price
        self.total_unit_price2 = total_unit_price
        self.total_item_price2 = total_item_price
        self.total_handling_fee2 = total_handling_fee
        self.total_quantity2 = total_quantity
        self.product_name2 = product_name
        self.product_count2 = product_count
        self.is_successful = is_successful
        self.order_count = order_count
        
    }

    class func parseDataFromDictionary(dictionary: AnyObject) -> TransactionModel {
    
        var order_id: [String] = []
        var date_added: [String] = []
        var invoice_number: [String] = []
        var payment_type: [String] = []
        var payment_method_id: [String] = []
        var order_status: [String] = []
        var order_status_id: [String] = []
        var total_price: [String] = []
        var total_unit_price: [String] = []
        var total_item_price: [String] = []
        var total_handling_fee: [String] = []
        var total_quantity: [String] = []
        var product_name: [String] = []
        var product_count: [String] = []
        var message: String = ""
        var isSuccessful: Bool = false
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                let orders: NSArray = value["orders"] as! NSArray
                for order in orders as! [NSDictionary] {
                    
                    for product_status in order["unique_order_product_statuses"] as! NSArray {
                        if product_status["name"] as! String == "Item Received by Buyer" {
                            let dateComponents = NSDateComponents()
                            
                            var dates = order["date_added"] as! String
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                            let date: NSDate = dateFormatter.dateFromString(dates)!
                            
                            let dateFormatter1 = NSDateFormatter()
                            dateFormatter1.dateFormat = "MMMM dd, yyyy"
                            let dateAdded = dateFormatter1.stringFromDate(date)
                            
                            order_id.append(order["order_id"] as! String)
                            date_added.append(dateAdded)
                            invoice_number.append(order["invoice_number"] as! String)
                            payment_type.append(order["payment_type"] as! String)
                            payment_method_id.append(order["payment_method_id"] as! String)
                            order_status.append(order["order_status"] as! String)
                            order_status_id.append(order["order_status_id"] as! String)
                            total_price.append(order["total_price"] as! String)
                            total_unit_price.append(order["total_unit_price"] as! String)
                            total_item_price.append(order["total_item_price"] as! String)
                            total_handling_fee.append(order["total_handling_fee"] as! String)
                            total_quantity.append(order["total_quantity"] as! String)
                            product_name.append(order["product_names"] as! String)
                            product_count.append(order["product_count"] as! String)
                        }
                    }
                }
            }
        }
        
        let transactionModel = TransactionModel(order_id: order_id, date_added: date_added, invoice_number: invoice_number, payment_type: payment_type, payment_method_id: payment_method_id, order_status: order_status, order_status_id: order_status_id, total_price: total_price, total_unit_price: total_unit_price, total_item_price: total_item_price, total_handling_fee: total_handling_fee, total_quantity: total_quantity, product_name: product_name, product_count: product_count, is_successful: isSuccessful)
        
        return transactionModel
    }
    
    class func parseDataFromDictionary3(dictionary: AnyObject) -> TransactionModel {
        
        var order_id: [String] = []
        var date_added: [String] = []
        var invoice_number: [String] = []
        var payment_type: [String] = []
        var payment_method_id: [String] = []
        var order_status: [String] = []
        var order_status_id: [String] = []
        var total_price: [String] = []
        var total_unit_price: [String] = []
        var total_item_price: [String] = []
        var total_handling_fee: [String] = []
        var total_quantity: [String] = []
        var product_name: [String] = []
        var product_count: [String] = []
        var message: String = ""
        var isSuccessful: Bool = false
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                let orders: NSArray = value["orders"] as! NSArray
                for order in orders as! [NSDictionary] {
                    for product_status in order["unique_order_product_statuses"] as! NSArray {
                        let dateComponents = NSDateComponents()
                        
                        var dates = order["date_added"] as! String
                        let dateFormatter = NSDateFormatter()
                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                        let date: NSDate = dateFormatter.dateFromString(dates)!
                        
                        let dateFormatter1 = NSDateFormatter()
                        dateFormatter1.dateFormat = "MMMM dd, yyyy"
                        let dateAdded = dateFormatter1.stringFromDate(date)
                        
                        order_id.append(order["order_id"] as! String)
                        date_added.append(dateAdded)
                        invoice_number.append(order["invoice_number"] as! String)
                        payment_type.append(order["payment_type"] as! String)
                        payment_method_id.append(order["payment_method_id"] as! String)
                        order_status.append(order["order_status"] as! String)
                        order_status_id.append(order["order_status_id"] as! String)
                        total_price.append(order["total_price"] as! String)
                        total_unit_price.append(order["total_unit_price"] as! String)
                        total_item_price.append(order["total_item_price"] as! String)
                        total_handling_fee.append(order["total_handling_fee"] as! String)
                        total_quantity.append(order["total_quantity"] as! String)
                        product_name.append(order["product_names"] as! String)
                        product_count.append(order["product_count"] as! String)
                        
                    }
                    
                }
            }
        }
        
        let transactionModel = TransactionModel(order_id: order_id, date_added: date_added, invoice_number: invoice_number, payment_type: payment_type, payment_method_id: payment_method_id, order_status: order_status, order_status_id: order_status_id, total_price: total_price, total_unit_price: total_unit_price, total_item_price: total_item_price, total_handling_fee: total_handling_fee, total_quantity: total_quantity, product_name: product_name, product_count: product_count, is_successful: isSuccessful)
        
        return transactionModel
    }
    
    class func parseDataFromDictionary2(dictionary: AnyObject) -> TransactionModel {
        
        var order_id: String = ""
        var date_added: String = ""
        var invoice_number: String = ""
        var payment_type: String = ""
        var payment_method_id: String = ""
        var order_status: String = ""
        var order_status_id: String = ""
        var total_price: String = ""
        var total_unit_price: String = ""
        var total_item_price: String = ""
        var total_handling_fee: String = ""
        var total_quantity: String = ""
        var product_name: String = ""
        var product_count: String = ""
        var message: String = ""
        var isSuccessful: Bool = false
        var order_count: Int = 0
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                let orders: NSArray = value["orders"] as! NSArray
                order_count = orders.count
                for order in orders as! [NSDictionary] {
                    
                    let dateComponents = NSDateComponents()
                    
                    var dates = order["date_added"] as! String
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    let date: NSDate = dateFormatter.dateFromString(dates)!
                    
                    let dateFormatter1 = NSDateFormatter()
                    dateFormatter1.dateFormat = "MMMM dd, yyyy"
                    let dateAdded = dateFormatter1.stringFromDate(date)
                    
                    order_id = order["order_id"] as! String
                    date_added = dateAdded
                    invoice_number = order["invoice_number"] as! String
                    payment_type = order["payment_type"] as! String
                    payment_method_id = order["payment_method_id"] as! String
                    order_status = order["order_status"] as! String
                    order_status_id = order["order_status_id"] as! String
                    total_price = order["total_price"] as! String
                    total_unit_price = order["total_unit_price"] as! String
                    total_item_price = order["total_item_price"] as! String
                    total_handling_fee = order["total_handling_fee"] as! String
                    total_quantity = order["total_quantity"] as! String
                    product_name = order["product_names"] as! String
                    product_count = order["product_count"] as! String
                }
            }
        }
        
        let transactionModel = TransactionModel(order_id: order_id, date_added: date_added, invoice_number: invoice_number, payment_type: payment_type, payment_method_id: payment_method_id, order_status: order_status, order_status_id: order_status_id, total_price: total_price, total_unit_price: total_unit_price, total_item_price: total_item_price, total_handling_fee: total_handling_fee, total_quantity: total_quantity, product_name: product_name, product_count: product_count, is_successful: isSuccessful, order_count: order_count)
        
        return transactionModel
    }
    
}
