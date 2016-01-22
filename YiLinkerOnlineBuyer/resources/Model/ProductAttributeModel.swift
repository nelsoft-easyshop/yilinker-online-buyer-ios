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
    var choices: [String] = []
    
    class func parseAttribute(attributes: NSDictionary) -> ProductAttributeModel {
        
        var model = ProductAttributeModel()
        
        if attributes.isKindOfClass(NSDictionary) {
            model.attributeId = ParseHelper.string(attributes, key: "id", defaultValue: "")
            model.attributeName = ParseHelper.string(attributes, key: "groupName", defaultValue: "")
            
            for value in attributes["items"] as! NSArray {
                model.valueId.append(ParseHelper.string(value, key: "id", defaultValue: ""))
                model.valueName.append(ParseHelper.string(value, key: "name", defaultValue: ""))
            }
            
            for value in attributes["choices"] as! NSArray {
                model.choices.append(value as! String)
            }
        }
        
        return model
    }
}