//
//  RegisterModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

class RegisterModel {
    var isSuccessful: Bool = false
    var message: String = ""
    var data: NSArray = []
    
    init (isSuccessful: Bool, message: String, data: NSArray) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.data = data
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> RegisterModel {
        var isSuccessful: Bool = false
        var message: String = ""
        var data: NSArray = []
        
        if let val: AnyObject = dictionary["isSuccessful"] {
            if let tempIsSuccessful = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempIsSuccessful
            }
        }
        
        if let val: AnyObject = dictionary["message"] {
            if let tempMessage = dictionary["message"] as? String {
                message = tempMessage
            }
        }
        
        
        if let val: AnyObject = dictionary["data"] {
            if let tempData = dictionary["data"] as? NSArray {
                data = tempData
            }
        }
        
        let registerModel: RegisterModel = RegisterModel(isSuccessful: isSuccessful, message: message, data: data)
        
        return registerModel
    }
}
