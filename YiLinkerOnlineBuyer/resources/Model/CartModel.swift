//
//  CartModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CartModel: NSObject {
   
    var selected: Bool = false
    var unitId: Int = 0
    var productDetails: CartProductDetailsModel!
    var selectedAttributes: [Int] = []
    var quantity: Int = 0
    
    
    init(unitId: Int, productDetails: CartProductDetailsModel!, selectedAttributes: [Int], quantity: Int, selected: Bool){
        self.unitId = unitId
        self.productDetails = productDetails
        self.selectedAttributes = selectedAttributes
        self.quantity = quantity
        self.selected = selected
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> CartModel {
        var unitId: Int = 0
        var productDetails: CartProductDetailsModel?
        var selectedAttributes: [Int] = []
        var quantity: Int = 0
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let tempVar = dictionary["unitId"] as? Int {
                unitId = tempVar
            }
            
            if let tempVar = dictionary["product"] as? NSDictionary {
                productDetails = CartProductDetailsModel.parseDataWithDictionary(tempVar)
            }
            
            if let tempVar = dictionary["selectedAttributes"] as? NSArray {
                selectedAttributes = tempVar as! [Int]
            }
            
            if let tempVar = dictionary["quantity"] as? Int {
                quantity = tempVar
            }
        }
        
        return CartModel(unitId: unitId, productDetails: productDetails!, selectedAttributes: selectedAttributes, quantity: quantity, selected: false)
    }
}
