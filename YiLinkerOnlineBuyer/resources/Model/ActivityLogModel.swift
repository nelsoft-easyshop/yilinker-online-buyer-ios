//
//  ActivityLogModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityLogModel: NSObject {
    var date: String = ""
    var activities: [ActivityModel] = []
    
    init(date: String, activities: [ActivityModel]) {
        self.date = date
        self.activities = activities
    }
}
