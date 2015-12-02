//
//  HomeSellerModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 12/1/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HomeSellerModel: NSObject {
    var name: String = ""
    var specialty: String = ""
    var image: String = ""
    var data: [HomeProductModel] = []
    var target: TargetModel = TargetModel()
    
    override init() {
        
    }
    
    init(name: String, specialty: String, image: String, target: TargetModel ,data: [HomeProductModel]) {
        self.name = name
        self.specialty = specialty
        self.image = image
        self.data = data
        self.target = target
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> HomeSellerModel {
       
        var name: String = ""
        var specialty: String = ""
        var image: String = ""
        var data: [HomeProductModel] = []
        var target: TargetModel = TargetModel()
        
        if let temp = dictionary["name"] as? String {
            name = temp
        }
        
        if let temp = dictionary["specialty"] as? String {
            specialty = temp
        }
        
        if let temp = dictionary["image"] as? String {
            image = temp
        }
        
        if let temp = dictionary["target"] as? NSDictionary {
            target = TargetModel.parseDataFromDictionary(temp)
        }
        
        if let tempDictionaries = dictionary["data"] as? [NSDictionary] {
            for tempDictionary in tempDictionaries {
                data.append(HomeProductModel.parseDataFromDictionary(tempDictionary))
            }
        }
        
        return HomeSellerModel(name: name, specialty: specialty, image: image, target: target, data: data)
    }
}
