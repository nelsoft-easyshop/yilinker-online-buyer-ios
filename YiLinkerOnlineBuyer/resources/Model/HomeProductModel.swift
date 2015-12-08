//
//  HomeProductModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HomeProductModel: NSObject {
    var name: String = ""
    var originalPrice: String = ""
    var discountedPrice: String = ""
    var discountPercentage: String = ""
    var currency: String = ""
    var image: String = ""
    var target: TargetModel = TargetModel()
    
    override init() {
        
    }
    
    init(name: String, originalPrice: String, discountedPrice: String, discountPercentage: String, currency: String, image: String, target: TargetModel) {
        self.name = name
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
        self.discountPercentage = discountPercentage
        self.currency = currency
        self.image = image
        self.target = target
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> HomeProductModel {
        var name: String = ""
        var originalPrice: String = ""
        var discountedPrice: String = ""
        var discountPercentage: String = ""
        var currency: String = ""
        var image: String = ""
        var target: TargetModel = TargetModel()
        
        if let tempName = dictionary["name"] as? String {
            name = tempName
        }
        
        if let temp = dictionary["originalPrice"] as? String {
            originalPrice = temp
        }
        
        if let temp = dictionary["discountedPrice"] as? String {
            discountedPrice = temp
        }
        
        if let tempDiscountPercentage = dictionary["discountPercentage"] as? String {
            discountPercentage = tempDiscountPercentage
        }
        
        if let temp = dictionary["currency"] as? String {
            currency = temp
        }
        
        if let temp = dictionary["image"] as? String {
            image = temp
        }
        
        if let temp = dictionary["target"] as? NSDictionary {
            target = TargetModel.parseDataFromDictionary(temp)
        }
        
        return HomeProductModel(name: name, originalPrice: originalPrice, discountedPrice: discountedPrice, discountPercentage: discountPercentage, currency: currency, image: image, target: target)
    }
}
