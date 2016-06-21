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
    var name: String = ""
    
    override init() {
        
    }
    
    init(image: String, target: TargetModel) {
        self.image = image
        self.target = target
    }
    
    init(image: String, target: TargetModel, name: String) {
        self.image = image
        self.target = target
        self.name = name
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> DataImageModel {
        var image: String = ""
        var target: TargetModel = TargetModel()
        var name: String = ""
        
        if let temp = dictionary["image"] as? String {
            image = temp
        } else if let temp = dictionary["flag"] as? String {
            image = temp
        }
        
        if let temp = dictionary["target"] as? NSDictionary {
            target = TargetModel.parseDataFromDictionary(temp)
        }
        
        if let temp = dictionary["name"] as? String {
            name = temp
        }
        
        if name != "" {
            return DataImageModel(image: image, target: target, name: name)
        } else {
           return DataImageModel(image: image, target: target)
        }
    }
}
