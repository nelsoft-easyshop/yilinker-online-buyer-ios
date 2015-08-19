//
//  FollwedSellerModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class FollowedSellerModel {
    
    var names: [String] = []
    var specialty: [String] = []
    var images: [String] = []
    var ratings: [Int] = []
    
    init(names: NSArray, specialty: NSArray, images: NSArray, ratings: NSArray) {
        self.names = names as! [String]
        self.specialty = specialty as! [String]
        self.images = images as! [String]
        self.ratings = ratings as! [Int]
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> FollowedSellerModel {
        
        var names: [String] = []
        var specialty: [String] = []
        var images: [String] = []
        var ratings: [Int] = []
        
        for value in dictionary["sellers"] as! NSArray {
            
            if let tempVar = value["name"] as? String {
                names.append(tempVar)
            }
            
            if let tempVar = value["specialty"] as? String {
                specialty.append(tempVar)
            }
            
            if let tempVar = value["imageUrl"] as? String {
                images.append(tempVar)
            }
            
            if let tempVar = value["rating"] as? Int {
                ratings.append(tempVar)
            }

        }
        
        
        return FollowedSellerModel(names: names, specialty: specialty, images: images, ratings: ratings)
    }
    
}