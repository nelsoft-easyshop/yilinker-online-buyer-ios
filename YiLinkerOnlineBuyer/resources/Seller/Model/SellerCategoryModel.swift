//
//  SellerCategoryModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerCategoryModel: NSObject {
   /*
    "data": [
    {
    "categoryId": 6,
    "name": "Books, Music & Movies",
    "parentId": null,
    "sortOrder": 0,
    "products": [],
    "subcategories": [
    {
    "categoryId": 283,
    "name": "Test Category 56",
    "parentId": 6,
    "sortOrder": 0,
    "products": [],
    "subcategories": []
    }
    */
    var categoryId: [Int] = []
    var name: [String] = []
    var subCategories: String = ""
    var subCategories2: [String] = []
    var subCategories3: [NSArray] = []
    var isSuccessful: Bool = false
    var categoryName: String = ""
    var categorySubs: String = ""
    var categorySubs2: NSArray = []
    var categoryId2: Int = 0
    
    init(name: NSArray, categoryId: NSArray, subCategories2: NSArray, subCategories: String, isSuccessful: Bool, subCategories3: NSArray){
        self.name = name as! [String]
        self.categoryId =  categoryId as! [Int]
        self.subCategories = subCategories
        self.subCategories2 = subCategories2 as! [String]
        self.subCategories3 = subCategories3 as! [NSArray]
        self.isSuccessful = isSuccessful
    }
    
    init(name: String, categoryId: Int, subCategories: String, subCategories2: NSArray){
        self.categoryName = name
        self.categorySubs = subCategories
        self.categorySubs2 = subCategories2
        self.categoryId2 = categoryId
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> SellerCategoryModel {
        var categoryId: [Int] = []
        var name: [String] = []
        var subCategories: String = ""
        var subCategories2: [String] = []
        var isSuccessful: Bool = false
        var subCategories3: [NSArray] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["isSuccessful"] != nil {
                if let tempVar = dictionary["isSuccessful"] as? Bool {
                    isSuccessful = tempVar
                }
            }
            
            if let tempArr = dictionary["data"] as? NSArray {
                for subValue in tempArr as NSArray {
                    name.append(subValue["name"] as! String)
                   
                    if let x = subValue["categoryId"] as? Int {
                        categoryId.append(x)
                    } else {
                        categoryId.append(0)
                    }
                    
                    if let tempArr2 = subValue["subcategories"] as? NSArray {
                        subCategories3.append(subValue["subcategories"] as! NSArray)
                        var i: Int = tempArr2.count
                        if tempArr2.count != 0 {
                            for subValue2 in tempArr2 as NSArray {
                                if tempArr2.count == 1 {
                                     subCategories += (subValue2["name"] as! String)
                                } else {
                                    if i > 1 {
                                        subCategories += (subValue2["name"] as! String) + ", "
                                        i -= 1
                                    } else {
                                        subCategories += (subValue2["name"] as! String)
                                    }
                                }
                               
                            }
                        } else {
                            subCategories = "No sub-category available"
                        }
                    }
                    println("sub categories \(subCategories)")
                    subCategories2.append(subCategories)
                    subCategories = ""
                }
            }
            

        }
        
        let sellerCategory = SellerCategoryModel(name: name, categoryId: categoryId, subCategories2: subCategories2, subCategories: subCategories, isSuccessful: isSuccessful, subCategories3: subCategories3)
        return sellerCategory
    }
}
