//
//  ProductModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductModel: NSObject {
    var productName: String = ""
    var productImageURL: NSURL?
    var productOriginalPrice: NSNumber = 0.0
    var productDiscountedPrice: NSNumber = 0.0
    var productDiscountPercentage: NSNumber = 0.0
    var productSlug: String = ""
    
    init(productName: String, productImageURL: NSURL, productOriginalPrice: NSNumber, productDiscountedPrice: NSNumber, productDiscountPercentage: NSNumber, productSlug: String) {
        self.productName = productName
        self.productImageURL = productImageURL
        self.productOriginalPrice = productOriginalPrice
        self.productDiscountedPrice = productDiscountedPrice
        self.productDiscountPercentage = productDiscountPercentage
        self.productSlug = productSlug
    }
}
