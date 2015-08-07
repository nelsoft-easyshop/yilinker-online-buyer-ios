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
    var images: NSArray = NSArray()
    
    init(name: String, avatar: NSURL, specialty: String, target: String, images: NSArray) {
        self.name = name
        self.avatar = avatar
        self.specialty = specialty
        self.target = target
        self.images = images
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> SellerModel {
        var name: String = ""
        var avatar: NSURL = NSURL(string: "")!
        var specialty: String = ""
        var target: String = ""
        var images: NSArray = NSArray()
        
        if let tempSellerAvatar = dictionary["sellerAvatar"] as? String {
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
        
        if let tempImages = dictionary["images"] as? NSArray {
            var url: [String] = []
            
            for tempDictionary in tempImages as! [NSDictionary] {
                url.append(tempDictionary["imageUrl"] as! String)
            }
            
            images = url
            
        } else {
            images = NSArray()
        }
        
        let sellerModel: SellerModel = SellerModel(name: name, avatar: avatar, specialty: specialty, target: target, images: images)

        return sellerModel
    }
}
