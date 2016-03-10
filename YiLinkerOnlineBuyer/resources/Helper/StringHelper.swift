//
//  StringHelper.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/16/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class StringHelper: NSObject {
    class func localizedStringWithKey(key: String) -> String {
        let string: String = NSLocalizedString(key, tableName: "LocalizableString", comment: "comment")
        return string
    }
    
    class func required(text: String) -> NSAttributedString {
        var string = "\(text)*"
        var myMutableString = NSMutableAttributedString(string: string)
        let stringCount: Int = count(string)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: stringCount - 1,length:1))
        return myMutableString
    }
    
    class func convertDictionaryToJsonString(dictionary: NSDictionary) -> NSString {
        let data = NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: nil)
        let string = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
        return string!
    }
    
    class func convertStringToDictionary(text: String) -> NSDictionary {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            var error: NSError?
            let json: NSDictionary = (NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.allZeros, error: &error) as? NSDictionary)!
            if error != nil {
                println(error)
            }
            return json
        }
        
        return NSDictionary()
    }
    
    class func convertStringToUrl(string: String) -> NSURL {
        var url : NSString = string
        var urlStr : NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        return NSURL(string: urlStr as String)!
    }
}
