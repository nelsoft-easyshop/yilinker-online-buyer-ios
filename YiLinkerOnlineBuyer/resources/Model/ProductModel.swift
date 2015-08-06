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
    var productOriginalPrice: String = ""
    var productDiscountedPrice: String = ""
    var productDiscountPercentage: String = ""
    var productTarget: String = ""
    
    init(productName: String, productImageURL: NSURL, productOriginalPrice: String, productDiscountedPrice: String, productDiscountPercentage: String, productTarget: String) {
        self.productName = productName
        self.productImageURL = productImageURL
        self.productOriginalPrice = productOriginalPrice
        self.productDiscountedPrice = productDiscountedPrice
        self.productDiscountPercentage = productDiscountPercentage
        self.productTarget = productTarget
    }
}
