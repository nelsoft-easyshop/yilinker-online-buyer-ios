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
        if images.isKindOfClass(NSDictionary) {
            
            model.id = images["id"] as! String
            model.imageLocation = images["imageLocation"] as! String
            model.imageLocation = model.imageLocation.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
            model.fullImageLocation = images["fullImageLocation"] as! String
            model.fullImageLocation = model.fullImageLocation.stringByReplacingOccurrencesOfString(" ", withString: "%20", options: nil, range: nil)
            println(model.fullImageLocation)
            model.isPrimary = images["isPrimary"] as! Bool
            model.isDeleted = images["isDeleted"] as! Bool
            
        }
        
        return model
    }
}