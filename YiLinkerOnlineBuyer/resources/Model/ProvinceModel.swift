//
//  ProvinceModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProvinceModel {
    
    var message: String = ""
    var isSuccessful: Bool = false
    
    var provinceId: [Int] = []
    var location: [String] = []
    
    init(message: String, isSuccessful: Bool, provinceId: NSArray, location: NSArray) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.provinceId = provinceId as! [Int]
        self.location = location as! [String]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProvinceModel! {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var provinceId: [Int] = []
        var location: [String] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                for subValue in value as! NSArray {
                    provinceId.append(subValue["provinceId"] as! Int)
                    location.append(subValue["location"] as! String)
                }
            }
        } // dictionary
        
        return ProvinceModel(message: message, isSuccessful: isSuccessful, provinceId: provinceId, location: location)
    } // parse
}