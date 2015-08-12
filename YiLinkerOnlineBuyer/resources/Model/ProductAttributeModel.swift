//
//  ProductAttributeModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/7/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductAttributeModel {
    
    var attributeId: Int = 0
    var attributeName: String = ""
    var valueId: [Int] = []
    var valueName: [String] = []
    
    class func parseAttribute(attributes: NSDictionary) -> ProductAttributeModel {
        
        var model = ProductAttributeModel()
        
        if attributes.isKindOfClass(NSDictionary) {
            
            model.attributeId = attributes["id"] as! Int
            model.attributeName = attributes["name"] as! String

            for value in attributes["items"] as! NSArray {
                model.valueId.append(value["id"] as! Int)
                model.valueName.append(value["name"] as! String)
            }
        }
        
        return model
    }
}