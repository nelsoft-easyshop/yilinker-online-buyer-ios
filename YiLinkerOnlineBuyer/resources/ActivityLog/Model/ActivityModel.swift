//
//  ActivityModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityModel: NSObject {
    var time: String = ""
    var details: String = ""
    
    init(time: String, details: String) {
        self.time = time
        self.details = details
    }
    
    init(time: String) {
        self.time = time
    }
    
    class func parsaDataFromDictionary(dictionary: AnyObject) -> ActivityModel! {
        
        var time: String = ""
        var details: String = ""
        if dictionary.isKindOfClass(NSDictionary){
            let date: NSDictionary = dictionary["date"] as! NSDictionary
            if let value = date["date"] as? String {
                time = value
            }
            
            if let text = dictionary["text"] as? String {
                details = text
            }
        }
        
        let activityModel = ActivityModel(time: time, details: details)
        
        return activityModel
        
    }
}
