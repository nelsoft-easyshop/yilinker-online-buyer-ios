//
//  ActivityLogItemModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 11/16/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityLogItemModel: NSObject {
    
    var date: String = ""
    var type: String = ""
    var text: String = ""
    
    init(date: String, type: String, text: String){
        self.date = date
        self.type = type
        self.text = text
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ActivityLogItemModel {
        
        var date: String = ""
        var type: String = ""
        var text: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["date"] != nil {
                let tempDict: NSDictionary = dictionary["date"] as! NSDictionary
                if let tempVar = tempDict["date"] as? String {
                    date = tempVar
                }
            }
            
            if dictionary["type"] != nil {
                if let tempVar = dictionary["type"] as? String {
                    type = tempVar
                }
            }
            
            if dictionary["text"] != nil {
                if let tempVar = dictionary["text"] as? String {
                    text = tempVar
                }
            }
        }
        
        return ActivityLogItemModel(date: date, type: type, text: text)
    }
}
