//
//  ProductImagesModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 9/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductImagesModel {
    
    var id: String = ""
    var imageLocation: String = ""
    var fullImageLocation: String = ""
    var isPrimary: Bool = false
    var isDeleted: Bool = false
    
    class func parseProductImagesModel(images: NSDictionary) -> ProductImagesModel! {
        var model = ProductImagesModel()
        
        model.id = ParseHelper.string(images, key: "id", defaultValue: "")
        model.imageLocation = ParseHelper.string(images, key: "imageLocation", defaultValue: "")
        model.imageLocation = model.imageLocation.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
        model.fullImageLocation = ParseHelper.string(images, key: "fullImageLocation", defaultValue: "")
        model.fullImageLocation = model.fullImageLocation.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
        model.isPrimary = ParseHelper.bool(images, key: "isPrimary", defaultValue: false)
        model.isDeleted = ParseHelper.bool(images, key: "isDeleted", defaultValue: false)
        
        return model
    }
}