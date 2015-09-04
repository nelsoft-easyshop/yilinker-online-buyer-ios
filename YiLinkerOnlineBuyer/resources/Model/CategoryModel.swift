//
//  CategoryModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/16/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class CategoryModel {
    
    var message: String = ""
    var isSuccessful: String = ""
    
    var id: [Int] = []
    var name: [String] = []
    var image: [String] = []
    var hasChildren: [Bool] = []
    
    init(message: String, isSuccessful: String, id: NSArray, name: NSArray, image: NSArray, hasChildren: NSArray) {
        self.message = message
        self.isSuccessful = isSuccessful
        
        self.id = id as! [Int]
        self.name = name as! [String]
        self.image = image as! [String]
        self.hasChildren = hasChildren as! [Bool]
    }
    
    class func parseCategories(dictionary: AnyObject) -> CategoryModel {
        
        var message: String = ""
        var isSuccessful: String = ""
        
        var id: [Int] = []
        var name: [String] = []
        var image: [String] = []
        var hasChildren: [Bool] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? String {
                isSuccessful = tempVar
            }
            
            if let categories: AnyObject = dictionary["data"] {
                
                for category in categories as! NSArray {
                    if let tempVar = category["productCategoryId"] as? Int {
                        id.append(tempVar)
                    }
                    
                    if let tempVar = category["name"] as? String {
                        name.append(tempVar)
                    }
                    
                    if let tempVar = category["image"] as? String {
                        image.append(tempVar)
                    }
                    
                    if let tempVar = category["hasChildren"] as? String {
                        let stringToBool = NSString(string: tempVar)
                        hasChildren.append(stringToBool.boolValue)
                    }
                }
                
            }
            
        } // dictionary
        
        return CategoryModel(message: message, isSuccessful: isSuccessful, id: id, name: name, image: image, hasChildren: hasChildren)
    } // parse
}