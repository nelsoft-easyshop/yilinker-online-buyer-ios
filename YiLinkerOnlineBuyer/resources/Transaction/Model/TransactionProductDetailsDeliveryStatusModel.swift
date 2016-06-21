//
//  TransactionProductDetailsDeliveryStatusModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/13/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionProductDetailsDeliveryStatusModel: NSObject {
    
    var lastCheckedInBy: String = ""
    var lastCheckedInLocation: String = ""
    var pickupRider: String = ""
    var pickupRiderContactNumber: String = ""
    var deliveryRider: String = ""
    var deliveryRiderContactNumber: String = ""
    
    init(lastCheckedInBy: String, lastCheckedInLocation: String, pickupRider: String, pickupRiderContactNumber: String, deliveryRider: String, deliveryRiderContactNumber: String) {
        self.lastCheckedInBy = lastCheckedInBy
        self.lastCheckedInLocation = lastCheckedInLocation
        self.pickupRider = pickupRider
        self.pickupRiderContactNumber = pickupRiderContactNumber
        self.deliveryRider = deliveryRider
        self.deliveryRiderContactNumber = deliveryRiderContactNumber
    }
    
    class func parseDataFromDictionary(dictionary: AnyObject) -> TransactionProductDetailsDeliveryStatusModel {
        
        var lastCheckedInBy: String = ""
        var lastCheckedInLocation: String = ""
        var pickupRider: String = ""
        var pickupRiderContactNumber: String = ""
        var deliveryRider: String = ""
        var deliveryRiderContactNumber: String = ""
        
        let deliveryStatus: NSArray = dictionary["data"] as! NSArray
        if deliveryStatus.count != 0 {
            for delivery in deliveryStatus as! [NSDictionary] {
                if let val = delivery["lastCheckedInBy"] as? String {
                    lastCheckedInBy = val
                } else {
                    lastCheckedInBy = "-"
                }
                
                if let val = delivery["lastCheckedInLocation"] as? String {
                    lastCheckedInLocation = val
                } else {
                    lastCheckedInLocation = "-"
                }
                
                if let val = delivery["pickupRider"] as? String {
                    pickupRider = val
                } else {
                    pickupRider = ""
                }
                
                if let val = delivery["pickupRiderContactNumber"] as? String {
                    pickupRiderContactNumber = val
                } else {
                    pickupRiderContactNumber = ""
                }
                
                if let val = delivery["deliveryRider"] as? String {
                    deliveryRider = val
                } else {
                    deliveryRider = "-"
                }
                
                if let val = delivery["deliveryRiderContactNumber"] as? String {
                    deliveryRiderContactNumber = val
                } else {
                    deliveryRiderContactNumber = ""
                }
            }
        } else {
            lastCheckedInBy = ""
            lastCheckedInLocation = ""
            pickupRider = ""
            pickupRiderContactNumber = ""
            deliveryRider = ""
            deliveryRiderContactNumber = ""
        }
        
        var deliveryStatusModel = TransactionProductDetailsDeliveryStatusModel(lastCheckedInBy: lastCheckedInBy, lastCheckedInLocation: lastCheckedInLocation, pickupRider: pickupRider, pickupRiderContactNumber: pickupRiderContactNumber, deliveryRider: deliveryRider, deliveryRiderContactNumber: deliveryRiderContactNumber)
        
        return deliveryStatusModel
    }
}
