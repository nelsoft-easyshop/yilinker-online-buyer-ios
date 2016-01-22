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
    var attributes: [ProductAttributeModel] = []
    var productUnits: [ProductUnitsModel] = []
    
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
        
        var attributes: [ProductAttributeModel] = []
        var productUnits: [ProductUnitsModel] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
        
            message = ParseHelper.string(dictionary, key: "message", defaultValue: "")
            isSuccessful = ParseHelper.bool(dictionary, key: "isSuccessful", defaultValue: false)
            
            if let value: AnyObject = dictionary["data"] {
                id = ParseHelper.string(value, key: "id", defaultValue: "")
                title = ParseHelper.string(value, key: "title", defaultValue: "")
                slug = ParseHelper.string(value, key: "slug", defaultValue: "")
                image = ParseHelper.string(value, key: "image", defaultValue: "")
                shortDescription = ParseHelper.string(value, key: "shortDescription", defaultValue: "")
                fullDescription = ParseHelper.string(value, key: "fullDescription", defaultValue: "")
                sellerId = ParseHelper.int(value, key: "sellerId", defaultValue: 0)
                
                for subValue in value["images"] as! NSArray {
                    let model: ProductImagesModel = ProductImagesModel.parseProductImagesModel(subValue as! NSDictionary)
                    images.append(model)
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