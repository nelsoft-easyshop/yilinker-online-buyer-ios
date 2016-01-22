//
//  FollwedSellerModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class FollowedSellerModel {
    
    var message: String = ""
    var isSuccessful: Bool = false
    var error_description: String = ""

    var id: [Int] = []
    var fullName: [String] = []
    var storeName: [String] = []
    var profileImageUrl: [String] = []
    var specialty: [String] = []
    var rating: [Int] = []
    
    init(message: String, isSuccessful: Bool, id: NSArray, fullName: NSArray, storeName: NSArray, profileImageUrl: NSArray, specialty: NSArray, rating: NSArray) {
        
        self.message = message
        self.isSuccessful = isSuccessful
        
        self.id = id as! [Int]
        self.fullName = fullName as! [String]
        self.storeName = storeName as! [String]
        self.profileImageUrl = profileImageUrl as! [String]
        self.specialty = specialty as! [String]
        self.rating = rating as! [Int]
    }
    
    init(message: String, isSuccessful: Bool, error_description: String) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.error_description = error_description
    }

    
    class func parseDataWithDictionary(dictionary: AnyObject) -> FollowedSellerModel {
        
        if dictionary.isKindOfClass(NSDictionary) {
            let isSuccessful = ParseHelper.bool(dictionary, key: "isSuccessful", defaultValue: false)
            let message = ParseHelper.string(dictionary, key: "message", defaultValue: "")

            var id: [Int] = []
            var fullName: [String] = []
            var storeName: [String] = []
            var profileImageUrl: [String] = []
            var specialty: [String] = []
            var rating: [Int] = []

            if let categories: AnyObject = dictionary["data"] {
                for category in categories as! NSArray {
                    id.append(ParseHelper.int(category, key: "sellerId", defaultValue: 0))
                    fullName.append(ParseHelper.string(category, key: "fullName", defaultValue: "-"))
                    storeName.append(ParseHelper.string(category, key: "storeName", defaultValue: "-"))
                    profileImageUrl.append(ParseHelper.string(category, key: "thumbnailImageUrl", defaultValue: "-"))
                    specialty.append(ParseHelper.string(category, key: "specialty", defaultValue: "-"))
                    rating.append(ParseHelper.int(category, key: "rating", defaultValue: 0))
                }
            }
            return FollowedSellerModel(message: message, isSuccessful: isSuccessful, id: id, fullName: fullName, storeName: storeName, profileImageUrl: profileImageUrl, specialty: specialty, rating: rating)
        } else {
            return FollowedSellerModel(message: "", isSuccessful: false, id: [Int](), fullName: [String](), storeName: [String](), profileImageUrl: [String](), specialty: [String](), rating: [Int]())
        }
    }
    
    class func parseFollowSellerDataWithDictionary(dictionary: AnyObject) -> FollowedSellerModel {
        
        var message: String = ""
        var isSuccessful: Bool = false
        var error_description: String = ""
        if let imessage = dictionary["message"] as? String {
            message = imessage
        }
        
        if let is_successful = dictionary["isSuccessful"] as? Bool {
            isSuccessful = is_successful
        }
        
        if let error_desc = dictionary["error_description"] as? String {
            error_description = error_desc
        }
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            
            
        } else {
            println("error")
        }// dictionary
        
        
        return FollowedSellerModel(message: message, isSuccessful: isSuccessful, error_description: error_description)
    }
    
    
}