//
//  DeliveryLogsItemModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class DeliveryLogsItemModel: NSObject {
    var actionType: String = ""
    var date: String = ""
    var location: String = ""
    var riderName: String = ""
    var clientSignature: String = ""
    
    init(actionType: String, date: String, location: String, riderName: String, clientSignature: String) {
        self.actionType = actionType
        self.date = date
        self.location = location
        self.riderName = riderName
        self.clientSignature = clientSignature
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> DeliveryLogsItemModel {
        
        var actionType: String = ""
        var date: String = ""
        var location: String = ""
        var riderName: String = ""
        var clientSignature: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["actionType"] != nil {
                if let tempVar = dictionary["actionType"] as? String {
                    actionType = tempVar
                }
            }
            
            if dictionary["date"] != nil {
                if let tempDict = dictionary["date"] as? NSDictionary {
                    if tempDict["date"] != nil {
                        if let tempVar = tempDict["date"] as? String {
                            date = tempVar
                        }
                    }
                }
            }
            
            if dictionary["location"] != nil {
                if let tempVar = dictionary["location"] as? String {
                    location = tempVar
                }
            }
            
            if dictionary["riderName"] != nil {
                if let tempVar = dictionary["riderName"] as? String {
                    riderName = tempVar
                }
            }
            
            if dictionary["clientSignature"] != nil {
                if let tempVar = dictionary["clientSignature"] as? String {
                    clientSignature = tempVar
                }
            }
        }
        
        return DeliveryLogsItemModel(actionType: actionType, date: date, location: location, riderName: riderName, clientSignature: clientSignature)
    }
    
}