//
//  ProductAttributeModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/7/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductAttributeModel {
    
    var attributeId: String = ""
    var attributeName: String = ""
    var valueId: [String] = []
    var valueName: [String] = []
    
    class func parseAttribute(attributes: NSDictionary) -> ProductAttributeModel {
        
        var model = ProductAttributeModel()
        
        if attributes.isKindOfClass(NSDictionary) {
            
            model.attributeId = attributes["id"] as! String
            model.attributeName = attributes["groupName"] as! String
            
            for value in attributes["items"] as! NSArray {
                model.valueId.append(value["id"] as! String)
                model.valueName.append(value["name"] as! String)
            }
        }
        
        return model
    }
}