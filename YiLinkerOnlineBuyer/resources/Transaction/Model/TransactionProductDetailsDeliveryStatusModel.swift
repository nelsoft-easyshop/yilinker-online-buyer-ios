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
        var deliveryStatusModel: TransactionProductDetailsDeliveryStatusModel?
        
        let deliveryStatus: NSDictionary = dictionary["data"] as! NSDictionary
        var lastCheckedInBy: String = ""
        var lastCheckedInLocation: String = ""
        var pickupRider: String = ""
        var pickupRiderContactNumber: String = ""
        var deliveryRider: String = ""
        var deliveryRiderContactNumber: String = ""
        
        if let deliveryLogs = deliveryStatus["deliveryLogs"] as? NSDictionary {
            if let rider = deliveryLogs["deliveryRider"] as? NSDictionary {
                if let val = rider["deliveryRider"] as? String {
                    deliveryRider = val
                } else {
                    deliveryRider = "-"
                }
                
                if let val = rider["contactNumber"] as? String {
                    deliveryRiderContactNumber = val
                } else {
                    deliveryRiderContactNumber = ""
                }
            }
            
            if let pickUpRider = deliveryLogs["pickupRider"] as? NSDictionary {
                if let val = pickUpRider["pickupRider"] as? String {
                    pickupRider = val
                } else {
                    pickupRider = "-"
                }
                
                if let val = pickUpRider["contactNumber"] as? String {
                    pickupRiderContactNumber = val
                } else {
                    pickupRiderContactNumber = ""
                }
            }
            
            if let val = deliveryLogs["lastCheckedInBy"] as? String {
                lastCheckedInBy = val
            } else {
                lastCheckedInBy = "-"
            }
            
            if let val = deliveryLogs["lastCheckedinLocation"] as? String {
                lastCheckedInLocation = val
            } else {
                lastCheckedInLocation = "-"
            }
        }
        
        return TransactionProductDetailsDeliveryStatusModel(lastCheckedInBy: lastCheckedInBy, lastCheckedInLocation: lastCheckedInLocation, pickupRider: pickupRider, pickupRiderContactNumber: pickupRiderContactNumber, deliveryRider: deliveryRider, deliveryRiderContactNumber: deliveryRiderContactNumber)
        
        /*if deliveryStatus.count != 0 {
        
        
            var delivery: NSDictionary = deliveryStatus[0] as! NSDictionary
            
            
            
        } else {
            
            var lastCheckedInBy: String = ""
            var lastCheckedInLocation: String = ""
            var pickupRider: String = ""
            var pickupRiderContactNumber: String = ""
            var deliveryRider: String = ""
            var deliveryRiderContactNumber: String = ""
            
            lastCheckedInBy = ""
            lastCheckedInLocation = ""
            pickupRider = ""
            pickupRiderContactNumber = ""
            deliveryRider = ""
            deliveryRiderContactNumber = ""
            deliveryStatusModel = TransactionProductDetailsDeliveryStatusModel(lastCheckedInBy: lastCheckedInBy, lastCheckedInLocation: lastCheckedInLocation, pickupRider: pickupRider, pickupRiderContactNumber: pickupRiderContactNumber, deliveryRider: deliveryRider, deliveryRiderContactNumber: deliveryRiderContactNumber)
            return deliveryStatusModel!
        }*/
    }
}
