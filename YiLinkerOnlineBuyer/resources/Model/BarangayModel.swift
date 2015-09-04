//
//  BarangayModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class BarangayModel {
    
    var message: String = ""
    var isSuccessful: Bool = false
    
    var barangayId: [Int] = []
    var location: [String] = []
    
    init(message: String, isSuccessful: Bool, barangayId: NSArray, location: NSArray) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.barangayId = barangayId as! [Int]
        self.location = location as! [String]
    }
    
    init() {
        
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> BarangayModel! {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var barangayId: [Int] = []
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
                    barangayId.append(subValue["barangayId"] as! Int)
                    location.append(subValue["location"] as! String)
                }
            }
        } // dictionary
        
        return BarangayModel(message: message, isSuccessful: isSuccessful, barangayId: barangayId, location: location)
    } // parse
}