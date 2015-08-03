//
//  HomePageProductModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HomePageProductModel: ProductModel {
    var productAction: String = ""
    var productTargetUrl: String = ""
    
     init(productName: String, productImageURL: NSURL, productOriginalPrice: NSNumber, productDiscountedPrice: NSNumber, productDiscountPercentage: NSNumber, productSlug: String, productAction: String, productTargetUrl: String) {
        
        super.init(productName: "", productImageURL: NSURL(string: "")!, productOriginalPrice: 0, productDiscountedPrice: 0, productDiscountPercentage: 0, productSlug: "")
        
        self.productName = productName
        self.productImageURL = productImageURL
        self.productOriginalPrice = productOriginalPrice
        self.productDiscountedPrice = productDiscountedPrice
        self.productDiscountPercentage = productDiscountPercentage
        self.productSlug = productSlug
        self.productAction = productAction
        self.productTargetUrl = productTargetUrl
    }
}
