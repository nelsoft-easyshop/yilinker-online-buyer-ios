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
    
    var id: [String] = []
    var name: [String] = []
    var slug: [String] = []
    var image: [String] = []
    var isParent: [Bool] = []
    
    init(message: String, isSuccessful: String, id: NSArray, name: NSArray, slug: NSArray, image: NSArray, isParent: NSArray) {
        self.message = message
        self.isSuccessful = isSuccessful
        
        self.id = id as! [String]
        self.name = name as! [String]
        self.slug = slug as! [String]
        self.image = image as! [String]
        self.isParent = isParent as! [Bool]
    }
    
    class func parseCategories(dictionary: AnyObject) -> CategoryModel {
        
        var message: String = ""
        var isSuccessful: String = ""
        
        var id: [String] = []
        var name: [String] = []
        var slug: [String] = []
        var image: [String] = []
        var isParent: [Bool] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? String {
                isSuccessful = tempVar
            }
            
            if let categories: AnyObject = dictionary["categories"] {
                
                for category in categories as! NSArray {
                    if let tempVar = category["id"] as? String {
                        id.append(tempVar)
                    }
                    
                    if let tempVar = category["name"] as? String {
                        name.append(tempVar)
                    }
                    
                    if let tempVar = category["slug"] as? String {
                        slug.append(tempVar)
                    }
                    
                    if let tempVar = category["imageUrl"] as? String {
                        image.append(tempVar)
                    }
                    
                    if let tempVar = category["isParent"] as? Bool {
                        isParent.append(tempVar)
                    }
                }
                
            }
            
        } // dictionary
        
        return CategoryModel(message: message, isSuccessful: isSuccessful, id: id, name: name, slug: slug, image: image, isParent: isParent)
    } // parse
}