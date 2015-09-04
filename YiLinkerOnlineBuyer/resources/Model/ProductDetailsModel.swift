//
//  ProductDetailsModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/7/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductDetailsModel {

    var message: String = ""
    var isSuccessful: Bool = false
    
    var id: String = ""
    var title: String = ""
    var slug: String = ""
    var image: String = ""
    var images: [ProductImagesModel] = []
    var shortDescription: String = ""
    var fullDescription: String = ""
    var sellerId: Int = 0
    
    var attributes: [ProductAttributeModel] = [] //done
    var productUnits: [ProductUnitsModel] = []
    
    //DETAILS ???
    //BADGES  ???
    
    init(message: String, isSuccessful: Bool, id: String, title: String, slug: String, image: String, images: NSArray, shortDescription: String, fullDescription: String, sellerId: Int, attributes: NSArray, productUnits: NSArray) {
        
        self.message = message
        self.isSuccessful = isSuccessful
        
        self.id = id
        self.title = title
        self.slug = slug
        self.image = image
        self.images = images as! [ProductImagesModel]
        self.shortDescription = shortDescription
        self.fullDescription = fullDescription
        self.sellerId = sellerId
        
        self.attributes = attributes as! [ProductAttributeModel]
        self.productUnits = productUnits as! [ProductUnitsModel]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductDetailsModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var id: String = ""
        var title: String = ""
        var slug: String = ""
        var image: String = ""
        var images: [ProductImagesModel] = []
        var shortDescription: String = ""
        var fullDescription: String = ""
        var sellerId: Int = 0
        
        var attributes: [ProductAttributeModel] = [] //done
        var productUnits: [ProductUnitsModel] = []
        
        //DETAILS ???
        //BADGES  ???
        
        // ----
        var combinations: [ProductAvailableAttributeCombinationModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {

            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                
                if let tempVar = value["id"] as? String {
                    id = tempVar
                }
                
                if let tempVar = value["title"] as? String {
                    title = tempVar
                }
                
                if let tempVar = value["slug"] as? String {
                    slug = tempVar
                }
                
                if let tempVar = value["image"] as? String {
                    image = tempVar
                }

                for subValue in value["images"] as! NSArray {
                    let model: ProductImagesModel = ProductImagesModel.parseProductImagesModel(subValue as! NSDictionary)
                    images.append(model)
                }
                
                if let tempVar = value["shortDescription"] as? String {
                    shortDescription = tempVar
                }
                
                if let tempVar = value["fullDescription"] as? String {
                    fullDescription = tempVar
                }
                
                if let tempVar = value["sellerId"] as? Int {
                    sellerId = tempVar
                }
                
                for subValue in value["attributes"] as! NSArray {
                    let model: ProductAttributeModel = ProductAttributeModel.parseAttribute(subValue as! NSDictionary)
                    attributes.append(model)
                }

                for subValue in value["productUnits"] as! NSArray {
                    let model: ProductUnitsModel = ProductUnitsModel.parseProductUnits(subValue as! NSDictionary)
                    productUnits.append(model)
                }
                
            } // data
        } // dictionary
        
        return ProductDetailsModel(message: message,
            isSuccessful: isSuccessful,
            id: id,
            title: title,
            slug: slug,
            image: image,
            images: images,
            shortDescription: shortDescription,
            fullDescription: fullDescription,
            sellerId: sellerId,
            attributes: attributes,
            productUnits: productUnits)
        
        
    } // parseDataWithDictionary
    
}