//
//  ActivityModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityModel: NSObject {
    var time: String = ""
    var details: String = ""
    
    init(time: String, details: String) {
        self.time = time
        self.details = details
    }
}
