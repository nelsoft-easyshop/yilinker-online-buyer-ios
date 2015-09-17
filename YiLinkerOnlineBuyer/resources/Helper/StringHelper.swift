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
        let string: String = NSLocalizedString(key, tableName: "LocalizableStrings", comment: "comment")
        return string
    }
}
