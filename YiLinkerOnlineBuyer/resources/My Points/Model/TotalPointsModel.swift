//
//  TotalPointsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class TotalPointsModel: NSObject {
    var isSuccessful: Bool = false
    var message: String = ""
    var data: String = ""
    
    init(isSuccessful: Bool, message: String, data: String) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.data = data
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> TotalPointsModel {
        
        var isSuccessful: Bool = false
        var message: String = ""
        var data: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["message"] != nil {
                if let tempVar = dictionary["message"] as? String {
                    message = tempVar
                }
            }
            
            if dictionary["data"] != nil {
                if let tempVar = dictionary["data"] as? String {
                    data = tempVar
                }
            }
            
            if dictionary["isSuccessful"] != nil {
                if let tempVar = dictionary["isSuccessful"] as? Bool {
                    isSuccessful = tempVar
                }
            }
        }
        
        return TotalPointsModel(isSuccessful: isSuccessful, message: message, data: data)
    }
}
