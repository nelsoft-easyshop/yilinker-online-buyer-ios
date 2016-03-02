//
//  PointModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PointModel: NSObject {
    var date: String = ""
    var details: String = ""
    var points: String = ""
    
    init(date: String, details: String, points: String) {
        self.date = date
        self.details = details
        self.points = points
    }
}
