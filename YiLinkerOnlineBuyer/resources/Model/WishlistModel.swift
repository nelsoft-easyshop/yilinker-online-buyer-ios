//
//  CartModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class WishlistModel: NSObject {
    
    var selected: Bool = false
    var unitId: Int = 0
    var itemId: Int = 0
    var productDetails: WishlistProductDetailsModel!
    var quantity: Int = 0
    
    
    init(unitId: Int, itemId: Int, productDetails: WishlistProductDetailsModel!, quantity: Int, selected: Bool){
        self.unitId = unitId
        self.itemId = itemId
        self.productDetails = productDetails
        self.quantity = quantity
        self.selected = selected
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> WishlistModel {
        var unitId: Int = 0
        var itemId: Int = 0
        var productDetails: WishlistProductDetailsModel?
        var quantity: Int = 0
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let tempVar = dictionary["unitId"] as? Int {
                unitId = tempVar
            }
            
            if let tempVar = dictionary["itemId"] as? Int {
                itemId = tempVar
            }
            
            if let tempVar = dictionary["product"] as? NSDictionary {
                productDetails = WishlistProductDetailsModel.parseDataWithDictionary(tempVar)
            }
            
            if let tempVar = dictionary["quantity"] as? Int {
                quantity = tempVar
            }
        }
        
        return WishlistModel(unitId: unitId, itemId: itemId, productDetails: productDetails!, quantity: quantity, selected: false)
    }
}
