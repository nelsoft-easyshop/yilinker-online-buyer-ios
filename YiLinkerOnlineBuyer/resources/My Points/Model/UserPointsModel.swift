//
//  UserPointsModel.swift
//  YiLinkerOnlineSeller
//
//  Created by John Paul Chan on 9/7/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class UserPointsModel: NSObject {
   
    var isSuccessful: Bool = false
    var message: String = ""
    var data: String = ""
    
    init(isSuccessful: Bool, message: String, data: String) {
        self.isSuccessful = isSuccessful
        self.message = message
        self.data = data
    }
}
