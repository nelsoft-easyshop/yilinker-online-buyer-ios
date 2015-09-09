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
    
    init(order_id: NSArray, date_added: NSArray, invoice_number: NSArray, payment_type: NSArray, payment_method_id: NSArray, order_status: NSArray, order_status_id: NSArray, total_price: NSArray, total_unit_price: NSArray, total_item_price: NSArray, total_handling_fee: NSArray, total_quantity: NSArray, product_name: NSArray, product_count: NSArray){
        
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
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let
        }
    }
}
