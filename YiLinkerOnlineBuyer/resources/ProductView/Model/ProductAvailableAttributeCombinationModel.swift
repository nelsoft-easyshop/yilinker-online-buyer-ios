//
//  s
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/10/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductAvailableAttributeCombinationModel {
    
    var quantity: Int = 0
    var combination: [Int] = []
    var images: [String] = []
    
    class func parseCombination(value: NSDictionary) -> ProductAvailableAttributeCombinationModel {
        
        var model = ProductAvailableAttributeCombinationModel()
        
        if value.isKindOfClass(NSDictionary) {
            
            model.quantity = value["quantity"] as! Int
            
            for subValue in value["combination"] as! NSArray {
                model.combination.append(subValue as! Int)
            }
            
            for subValue in value["images"] as! NSArray {
                model.images.append(subValue as! String)
            }
        }
        
        return model
    }
}