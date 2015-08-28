//
//  CityModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class CityModel {
    
    var message: String = ""
    var isSuccessful: Bool = false
    
    var cityId: [Int] = []
    var location: [String] = []
    
    init(message: String, isSuccessful: Bool, cityId: NSArray, location: NSArray) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.cityId = cityId as! [Int]
        self.location = location as! [String]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CityModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var cityId: [Int] = []
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
                    cityId.append(subValue["cityId"] as! Int)
                    location.append(subValue["location"] as! String)
                }
            }
        } // dictionary
        
        return CityModel(message: message, isSuccessful: isSuccessful, cityId: cityId, location: location)
    } // parse
}