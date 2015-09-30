//
//  SellerSubCategoryModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerSubCategoryModel: NSObject {
   
    var name: [String] = []
    
    init(name: NSArray) {
        self.name = name as! [String]
    }
    
    class func parseDataFromDictionary(dictionary: AnyObject) -> SellerSubCategoryModel {
    
        var name: [String] = []
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let val: AnyObject = dictionary["name"] {
                if let categoryName = dictionary["name"] as? String {
                    name.append(categoryName)
                    println("\(name)")
                }
            }
        }
        
        let sellerSubCategoryModel = SellerSubCategoryModel(name: name)
        println(name.count)
        return sellerSubCategoryModel
    }
}
