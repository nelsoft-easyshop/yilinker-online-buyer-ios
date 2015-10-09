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
}
