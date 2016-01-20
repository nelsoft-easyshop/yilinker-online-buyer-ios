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
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var id: [Int] = []
        var fullName: [String] = []
        var storeName: [String] = []
        var profileImageUrl: [String] = []
        var specialty: [String] = []
        var rating: [Int] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let categories: AnyObject = dictionary["data"] {
                for category in categories as! NSArray {
                    if let tempVar = category["sellerId"] as? Int {
                        id.append(tempVar)
                    } else {
                        id.append(0)
                    }
                    
                    if let tempVar = category["fullName"] as? String {
                        fullName.append(tempVar)
                    } else {
                        fullName.append("Not Available")
                    }
                    
                    if let tempVar = category["storeName"] as? String {
                        storeName.append(tempVar)
                    } else {
                        storeName.append("Not Available")
                    }
                    
                    if let tempVar = category["profileImageUrl"] as? String {
                        profileImageUrl.append(tempVar)
                    } else {
                        profileImageUrl.append("")
                    }
                    
                    if let tempVar = category["specialty"] as? String {
                        specialty.append(tempVar)
                    } else {
                        specialty.append("Not Available")
                    }
                    
                    if let tempVar = category["rating"] as? Int {
                        rating.append(tempVar)
                    } else {
                        rating.append(0)
                    }
                }
            }
            
        } // dictionary
        
        
        return FollowedSellerModel(message: message, isSuccessful: isSuccessful, id: id, fullName: fullName, storeName: storeName, profileImageUrl: profileImageUrl, specialty: specialty, rating: rating)
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