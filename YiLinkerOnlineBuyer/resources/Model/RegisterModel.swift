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
    var accessToken: String = ""
    var refreshToken: String = ""
    var data: NSArray = []
    
    init (isSuccessful: Bool, message: String, data: NSArray) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.data = data
    }
    
    init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> RegisterModel {
        var isSuccessful: Bool = false
        var message: String = ""
        var data: NSArray = []
        
        var accessToken: String = ""
        var refreshToken: String = ""
        
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
        
        if let val: AnyObject = dictionary["authToken"] {
            if let tempAccessToken = dictionary["authToken"] as? String {
                accessToken = tempAccessToken
            }
        }
        
        if let val: AnyObject = dictionary["refreshToken"] {
            if let tempRefreshToken = dictionary["refreshToken"] as? String {
                refreshToken = tempRefreshToken
            }
        }
        
        
        if let val: AnyObject = dictionary["data"] {
            let registerModel: RegisterModel = RegisterModel(isSuccessful: isSuccessful, message: message, data: data)
            return registerModel
        } else {
            let registerModel: RegisterModel = RegisterModel(accessToken: accessToken, refreshToken: refreshToken)
            return registerModel
        }
        
    }
}
