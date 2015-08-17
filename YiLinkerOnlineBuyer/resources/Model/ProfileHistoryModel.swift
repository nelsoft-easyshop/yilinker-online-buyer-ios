//
//  ProductHistoryModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileHistoryModel: NSObject {
    var name: String = ""
    var imageURL: NSURL?
    var price: String = ""
    var dateOrdered: String = ""
    var status: String = ""
    
    init(name: String, imageURL: NSURL, price: String, dateOrdered: String, status: String) {
        self.name = name
        self.imageURL = imageURL
        self.price = price
        self.dateOrdered = dateOrdered
        self.status = status
    }
}
