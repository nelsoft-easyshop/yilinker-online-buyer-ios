//
//  ErrorModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ErrorModel: NSObject {
    var message: String = ""
    var title: String = ""
    var isSuccessful: Bool = false
    
    init (message: String, title: String, isSuccessful: Bool) {
        self.message = message
        self.title = title
        self.isSuccessful = isSuccessful
    }
    
    class func parseErrorWithResponce(dictionary: NSDictionary) -> ErrorModel {
        var message: String = ""
        var title: String = ""
        var isSuccessful: Bool = false
        
        if let value: AnyObject = dictionary["errorTitle"] {
            if (value as! NSObject != NSNull() && value as? String != nil) {
                title = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["isSuccessful"] {
            if (value as! NSObject != NSNull() && value as? Int != nil) {
                isSuccessful = value.boolValue
            }
        }
        
        if let values: AnyObject = dictionary["data"] {
            if let temp = dictionary["data"] as? NSDictionary {
                let errors: [String] = temp["errors"] as! [String]
                for error in errors {
                    message = "\(message) \(error)"
                }
            }
        }
        
        return ErrorModel(message: message, title: title, isSuccessful: isSuccessful)
    }
}
