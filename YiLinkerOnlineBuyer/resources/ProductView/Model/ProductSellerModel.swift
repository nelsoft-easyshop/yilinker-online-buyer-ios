//
//  ProductSellerModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductSellerModel {
    
    var message: String = ""
    var isSuccessful: Bool = false
    
    var productId: [String] = []
    var userId: Int = 0
    var fullName: String = ""
    var email: String = ""
    var gender: String = ""
    var nickname: String = ""
    var contactNumber: String = ""
    var specialty: String = ""
    var birthdate: String = ""
    var storeName: String = ""
    var storeDescription: String = ""
    
    var profilePhoto: String = ""
    var coverPhoto: String = ""
    var images: NSArray = []
    
    var isFollowed: Bool = false
    
    init(message: String, isSuccessful: Bool, userId: Int, fullName: String, email: String, gender: String, nickname: String, contactNumber: String, specialty: String, birthdate: String, storeName: String, storeDescription: String, profilePhoto: String, coverPhoto: String, images: NSArray, isFollowed: Bool, productId: [String]) {
        
        self.message = message
        self.isSuccessful = isSuccessful
        
        self.productId = productId
        self.userId = userId
        self.fullName = fullName
        self.email = email
        self.gender = gender
        self.nickname = nickname
        self.contactNumber = contactNumber
        self.specialty = specialty
        self.birthdate = birthdate
        self.storeName = storeName
        self.storeDescription = storeDescription
        
        self.profilePhoto = profilePhoto
        self.coverPhoto = coverPhoto
        self.images = images
        
        self.isFollowed = isFollowed
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductSellerModel! {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var productId: [String] = []
        var userId: Int = 0
        var fullName: String = ""
        var email: String = ""
        var gender: String = ""
        var nickname: String = ""
        var contactNumber: String = ""
        var specialty: String = ""
        var birthdate: String = ""
        var storeName: String = ""
        var storeDescription: String = ""
        
        var profilePhoto: String = ""
        var coverPhoto: String = ""
        var images: [String] = []
        
        var isFollowed: Bool = false
        
        if dictionary.isKindOfClass(NSDictionary) {

            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                
                if let tempVar = value["id"] as? Int {
                    userId = tempVar
                }
                
                if let tempVar = value["fullName"] as? String {
                    fullName = tempVar
                }
                
                if let tempVar = value["email"] as? String {
                    email = tempVar
                }
                
                if let tempVar = value["gender"] as? String {
                    gender = tempVar
                }
                
                if let tempVar = value["nickname"] as? String {
                    nickname = tempVar
                }
                
                if let tempVar = value["contactNumber"] as? String {
                    contactNumber = tempVar
                }
                
                if let tempVar = value["specialty"] as? String {
                    specialty = tempVar
                }
                
                if let tempVar = value["birthdate"] as? String {
                    birthdate = tempVar
                }
                
                if let tempVar = value["storeName"] as? String {
                    storeName = tempVar
                }
                
                if let tempVar = value["storeDescription"] as? String {
                    storeDescription = tempVar
                }
                
                if let tempVar = value["profilePhoto"] as? String {
                    profilePhoto = tempVar
                }
                
                if let tempVar = value["coverPhoto"] as? String {
                    coverPhoto = tempVar
                }
                
                if let tempVar = value["isFollowed"] as? Bool {
                    isFollowed = tempVar
                }
                
                for subValue in value["products"] as! NSArray {
                    images.append(subValue["imageUrl"] as! String)
                    productId.append(subValue["productId"] as! String)
                }
                
            }
            
        }
        
        return ProductSellerModel(message: message, isSuccessful: isSuccessful, userId: userId, fullName: fullName, email: email, gender: gender, nickname: nickname, contactNumber: contactNumber, specialty: specialty, birthdate: birthdate, storeName: storeName, storeDescription: storeDescription, profilePhoto: profilePhoto, coverPhoto: coverPhoto, images: images, isFollowed: isFollowed, productId: productId)
    }
}