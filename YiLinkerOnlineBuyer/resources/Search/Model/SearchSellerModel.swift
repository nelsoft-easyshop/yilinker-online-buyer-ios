//
//  SearchSellerModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 10/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SearchSellerModel: NSObject {
    
    typealias Product = (productId: String, image: String)
    
    var userId: Int = 0
    var specialty: String = ""
    var storeName: String = ""
    var slug: String = ""
    var productDescription: String = ""
    var image: String = ""
    var products: [Product] = []
    
    init(userId: Int, specialty: String, storeName: String, slug: String, productDescription: String, image: String, products: [Product]) {
        
        self.userId = userId
        self.specialty = specialty
        self.storeName = storeName
        self.slug = slug
        self.productDescription = productDescription
        self.image = image
        self.products = products
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> SearchSellerModel {
        
        var userId: Int = 0
        var specialty: String = ""
        var storeName: String = ""
        var slug: String = ""
        var productDescription: String = ""
        var image: String = ""
        var products: [Product] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["userId"] as? Int {
                userId = tempVar
            }
            
            if let tempDictInner = dictionary["specialty"] as? NSDictionary {
                if let tempVar = tempDictInner["name"] as? String {
                    specialty = tempVar
                }
            }
            
            if let tempVar = dictionary["storeName"] as? String {
                storeName = tempVar
            }
            
            if let tempVar = dictionary["slug"] as? String {
                slug = tempVar
            }
            
            if let tempVar = dictionary["description"] as? String {
                productDescription = tempVar
            }
            
            if let tempVar = dictionary["image"] as? String {
                image = tempVar
            }
            
            if let tempDictInner = dictionary["products"] as? NSArray {
                for subValue in tempDictInner {
                    var product: Product = Product(productId: "", image: "")
                    if let tempVar = subValue["image"] as? String {
                        product.image = tempVar
                    }
                    
                    if let tempVar = subValue["productId"] as? String {
                        product.productId = tempVar
                    }
                    products.append(product)
                }
            }
        }
        
        return SearchSellerModel(userId: userId, specialty: specialty, storeName: storeName, slug: slug, productDescription: productDescription, image: image, products: products)
    }
}
