//
//  LanguageHelper.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/13/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class LanguageHelper: NSObject {
    
    static let chinese = "zh"
    static let english = "en"
    
    class func currentLanguge() -> LanguageType {
        let langId = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode) as! String
        
        if langId == LanguageHelper.chinese {
            return .Chinese
        } else {
            return .English
        }
    }
    
}
