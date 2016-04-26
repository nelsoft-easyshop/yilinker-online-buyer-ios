//
//  PointModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PointModel: NSObject {
    var amount: String = ""
    var pointDescription: String = ""
    var date: String = ""
    
    init(amount: String, pointDescription: String, date: String) {
        self.amount = amount
        self.pointDescription = pointDescription
        self.date = date
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> PointModel {
        
        var amount: String = ""
        var pointDescription: String = ""
        var date: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if dictionary["amount"] != nil {
                if let tempVar = dictionary["amount"] as? String {
                    amount = tempVar
                }
            }
            
            if dictionary["description"] != nil {
                if let tempVar = dictionary["description"] as? String {
                    pointDescription = tempVar
                }
            }
            
            if dictionary["date"] != nil {
                if let tempVar = dictionary["date"] as? String {
                    date = tempVar
                }
            }
        }
        
        return PointModel(amount: amount, pointDescription: pointDescription, date: date)
    }
}
