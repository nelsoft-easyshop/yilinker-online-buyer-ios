//
//  BasicInfoModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 2/5/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class BasicInfoModel: NSObject {
    var isVerified: Bool = false
    var isSuccessful: Bool = false
    var message: String = ""
    
    override init() {}
    
    init(isVerified: Bool, isSuccessful: Bool, message: String) {
        self.isVerified = isVerified
        self.isSuccessful = isSuccessful
        self.message = message
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> BasicInfoModel {
        var isVerified: Bool = false
        var isSuccessful: Bool = false
        var message: String = ""
        
        if let temp = dictionary["isSuccessful"] as? Bool {
            isSuccessful = temp
        }
        
        if let dataDictionary = dictionary["data"] as? NSDictionary {
            if let temp = dataDictionary["isVerified"] as? Bool {
                isVerified = temp
            }
        }
        
        if let temp = dictionary["message"] as? String {
            message = temp
        }
        
        return BasicInfoModel(isVerified: isVerified, isSuccessful: isSuccessful, message: message)
    }
}
