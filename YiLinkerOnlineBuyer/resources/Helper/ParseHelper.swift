//
//  ParseHelper.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 1/21/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ParseHelper: NSObject {

    // Use this when parsing string
    class func string(object: AnyObject, key: String, defaultValue: String) -> String {
        let dictionary = object as! NSDictionary
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? String {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing int
    class func int(object: AnyObject, key: String, defaultValue: Int) -> Int {
        let dictionary = object as! NSDictionary
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? Int {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing bool
    class func bool(object: AnyObject, key: String, defaultValue: Bool) -> Bool {
        let dictionary = object as! NSDictionary
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? Bool {
                return parsedValue
            }
        }
        
        return defaultValue
    }
    
    // Use this when parsing array
    class func array(object: AnyObject, key: String, defaultValue: NSArray) -> NSArray {
        let dictionary = object as! NSDictionary
        if dictionary[key] != nil {
            if let parsedValue = dictionary[key] as? NSArray {
                return parsedValue
            }
        }
        
        return defaultValue
    }
}
