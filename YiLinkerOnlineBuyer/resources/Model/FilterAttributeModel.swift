//
//  FilterAttributeModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class FilterAttributeModel: NSObject {
    var title: String = ""
    var attributes: [String] = []
    
    init(title: String, attributes: [String]) {
        self.title = title
        self.attributes = attributes
    }
}
