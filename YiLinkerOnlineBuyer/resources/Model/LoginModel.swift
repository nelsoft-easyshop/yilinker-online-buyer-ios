//
//  LoginModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 10/6/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LoginModel: NSObject {
    var isSuccessful: Bool = false
    var message: String = ""
    var dataDictionary: NSDictionary = NSDictionary()
    
    init(isSuccessful: Bool, message: String, dataDictionary: NSDictionary) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.dataDictionary = dataDictionary
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> LoginModel {
        var isSuccessful: Bool = false
        var message: String = ""
        var dataDictionary: NSDictionary = NSDictionary()
        
        if let value = dictionary["isSuccessful"] as? Bool {
            isSuccessful = value
        }
        
        if let value = dictionary["message"] as? String {
            message = value
        }
        
        if let value = dictionary["data"] as? NSDictionary {
            dataDictionary = value
        }
        
        return LoginModel(isSuccessful: isSuccessful, message: message, dataDictionary: dataDictionary)
    }
}
