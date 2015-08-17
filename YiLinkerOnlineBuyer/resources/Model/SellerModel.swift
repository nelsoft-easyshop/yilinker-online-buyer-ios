//
//  SellerModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/6/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerModel: NSObject {
    var name: String = ""
    var avatar: NSURL = NSURL(string: "")!
    var specialty: String = ""
    var target: String = ""
    var products: [HomePageProductModel] = [HomePageProductModel]()
    
    init(name: String, avatar: NSURL, specialty: String, target: String, products: [HomePageProductModel]) {
        self.name = name
        self.avatar = avatar
        self.specialty = specialty
        self.target = target
        self.products = products
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> SellerModel {
        var name: String = ""
        var avatar: NSURL = NSURL(string: "")!
        var specialty: String = ""
        var target: String = ""
        var products: [ProductModel]?
        
        if let tempSellerAvatar = dictionary["image"] as? String {
            avatar = NSURL(string: tempSellerAvatar)!
        } else {
            avatar = NSURL(string: "")!
        }
        
        if let tempName = dictionary["sellerName"] as? String {
            name = tempName
        } else {
            name = ""
        }
        
        if let tempSpecialty = dictionary["specialty"] as? String {
            specialty = tempSpecialty
        } else {
            specialty = ""
        }
        
        var homePageProductModels: [HomePageProductModel] = [HomePageProductModel]()
        
        if let val: AnyObject = dictionary["products"] {
            let products: NSArray = dictionary["products"] as! NSArray
            for productDictionary in products as! [NSDictionary] {
                let productModel: HomePageProductModel = HomePageProductModel.parseDataWithDictionary(productDictionary)
                homePageProductModels.append(productModel)
            }
        }
        
        let sellerModel: SellerModel = SellerModel(name: name, avatar: avatar, specialty: specialty, target: target, products: homePageProductModels)

        return sellerModel
    }
}
