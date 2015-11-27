//
//  DataImageModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/27/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class DataImageModel: NSObject {
    var image: String = ""
    var target: TargetModel = TargetModel()
    
    override init() {
        
    }
    
    init(image: String, target: TargetModel) {
        self.image = image
        self.target = target
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> DataImageModel {
        var image: String = ""
        var target: TargetModel = TargetModel()
        
        if let temp = dictionary["image"] as? String {
            image = temp
        }
        
        if let temp = dictionary["target"] as? NSDictionary {
            target = TargetModel.parseDataFromDictionary(temp)
        }
        
        
        return DataImageModel(image: image, target: target)
    }
}
