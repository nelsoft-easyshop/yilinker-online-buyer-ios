//
//  PaymentSuccessModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/4/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PaymentSuccessModel: NSObject {
    var isSuccessful: Bool = true
    var data: PaymentDataModel = PaymentDataModel()
    var message: String = ""
    
    init(isSuccessful: Bool, data: PaymentDataModel, message: String) {
        self.isSuccessful = isSuccessful
        self.data = data
        self.message = message
    }
    
    override init() {
        
    }
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> PaymentSuccessModel {
        var isSuccessful: Bool = true
        var data: PaymentDataModel = PaymentDataModel()
        var message: String = ""
        
        if let val: AnyObject = dictionary["isSuccessful"] {
            if let tempIsSuccessful = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempIsSuccessful
            }
        }
        
        if let val: AnyObject = dictionary["data"] {
            if let tempData = dictionary["data"] as? NSDictionary {
                
            }
        }
        
        
        if let val: AnyObject = dictionary["message"] {
            if let tempMessage = dictionary["message"] as? String {
                message = tempMessage
            }
        }
        
        if let val: AnyObject = dictionary["data"] {
            if let tempVal = dictionary["data"] as? NSDictionary {
                data = PaymentDataModel.parseDataFromDictionary(tempVal)
            }
        }
        
        return PaymentSuccessModel(isSuccessful: isSuccessful, data: data, message: message)
    }
}
