//
//  ProductModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductModel: NSObject {
    var name: String = ""
    var imageURL: NSURL?
    var originalPrice: String = ""
    var discountedPrice: String = ""
    var discountPercentage: String = ""
    var target: String = ""
    
    init(name: String, imageURL: NSURL, originalPrice: String, discountedPrice: String, discountPercentage: String, target: String) {
        self.name = name
        self.imageURL = imageURL
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
        self.discountPercentage = discountPercentage
        self.target = target
    }
}
