//
//  DisputeReasonsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 10/6/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class DisputeReasonsModel: NSObject {
    var message: String = ""
    var isSuccessful: Bool = false
    var refundId: [Int] = []
    var refundReason: [String] = []
    var replacementId: [Int] = []
    var replacementReason: [String] = []
    
    init(message: String, isSuccessful: Bool, refundId: [Int], refundReason: [String], replacementId: [Int], replacementReason: [String]) {
        self.message = message
        self.isSuccessful = isSuccessful
        
        self.refundId = refundId
        self.refundReason = refundReason
        self.replacementId = replacementId
        self.replacementReason = replacementReason
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> DisputeReasonsModel! {
        
        var message: String = ""
        var isSuccessful: Bool = false
        var refundId: [Int] = []
        var refundReason: [String] = []
        var replacementId: [Int] = []
        var replacementReason: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            for value in dictionary["data"] as! NSArray {
                if value["key"] as! String == "Replacement" {
                    if !(value["reasons"] is NSNull) {
                        for subValue in value["reasons"] as! NSArray {
                            replacementId.append(subValue["id"] as! Int)
                            replacementReason.append(subValue["reason"] as! String)
                        }
                    }
                } else if value["key"] as! String == "Refund" {
                    if !(value["reasons"] is NSNull) {
                        for subValue in value["reasons"] as! NSArray {
                            refundId.append(subValue["id"] as! Int)
                            refundReason.append(subValue["reason"] as! String)
                        }
                    }
                }
            }
        } // dictionary
        
        return DisputeReasonsModel(message: message, isSuccessful: isSuccessful, refundId: refundId, refundReason: refundReason, replacementId: replacementId, replacementReason: replacementReason)
    } // parse
}
