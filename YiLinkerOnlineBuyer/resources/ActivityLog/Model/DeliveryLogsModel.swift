//
//  DeliveryLogsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class DeliveryLogsModel: NSObject {
    var isSuccessful: Bool = false
    var message: String = ""
    var orderProductId: String = ""
    var productName: String = ""
    var deliveryLogs: [DeliveryLogsItemModel] = []
    
    init(isSuccessful: Bool, message: String, orderProductId: String, productName: String, deliveryLogs: [DeliveryLogsItemModel]) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.orderProductId = orderProductId
        self.productName = productName
        self.deliveryLogs = deliveryLogs
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> DeliveryLogsModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var orderProductId: String = ""
        var productName: String = ""
        var deliveryLogs: [DeliveryLogsItemModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["message"] != nil {
                if let tempVar = dictionary["message"] as? String {
                    message = tempVar
                }
            }
            
            if dictionary["isSuccessful"] != nil {
                if let tempVar = dictionary["isSuccessful"] as? Bool {
                    isSuccessful = tempVar
                }
            }
            
            if dictionary["data"] != nil {
                if let tempDict = dictionary["data"] as? NSDictionary {
                    if tempDict["orderProductId"] != nil {
                        if let tempVar = tempDict["orderProductId"] as? String {
                            orderProductId = tempVar
                        }
                    }
                    
                    if tempDict["productName"] != nil {
                        if let tempVar = tempDict["productName"] as? String {
                            productName = tempVar
                        }
                    }
                    
                    if tempDict["deliveryLogs"] != nil {
                        for subValue in tempDict["deliveryLogs"] as! NSArray {
                            let model: DeliveryLogsItemModel = DeliveryLogsItemModel.parseDataWithDictionary(subValue as! NSDictionary)
                            deliveryLogs.append(model)
                        }
                    }
                }
            }
        }
        
        return DeliveryLogsModel(isSuccessful: isSuccessful, message: message, orderProductId: orderProductId, productName: productName, deliveryLogs: deliveryLogs)
    }
}

