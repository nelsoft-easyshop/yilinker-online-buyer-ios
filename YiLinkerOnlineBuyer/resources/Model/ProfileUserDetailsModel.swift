//
//  ProfileUserDetails.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileUserDetailsModel: NSObject {
   
    var fullName: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var contactNumber: String = ""
    var profileImageUrl: String = ""
    var coverPhoto: String = ""
    var gender: String = ""
    var birthdate: String = ""
    
    var address: AddressModelV2 = AddressModelV2()
    
    var transactionCount: Int = 0
    var wishlistCount: Int = 0
    var cartCount: Int = 0
    var messageCount: Int = 0
    var followingCount: Int = 0
    
    init(fullName: String, firstName: String, lastName: String, email: String, contactNumber: String, profileImageUrl: String, coverPhoto: String, gender: String, birthdate: String, address: AddressModelV2, transactionCount: Int, wishlistCount: Int, cartCount: Int, messageCount: Int, followingCount: Int){
        self.fullName = fullName
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.contactNumber = contactNumber
        self.profileImageUrl = profileImageUrl
        self.coverPhoto = coverPhoto
        self.gender = gender
        self.birthdate = birthdate
        self.address = address
        self.transactionCount = transactionCount
        self.wishlistCount = wishlistCount
        self.cartCount = cartCount
        self.messageCount = messageCount
        self.followingCount = followingCount
    }
    
    override init() {
        
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProfileUserDetailsModel {
        var fullName: String = ""
        var firstName: String = ""
        var lastName: String = ""
        var email: String = ""
        var contactNumber: String = ""
        var profileImageUrl: String = ""
        var coverPhoto: String = ""
        var gender: String = ""
        var birthdate: String = ""

        var address: AddressModelV2 = AddressModelV2()
        
        var transactionCount: Int = 0
        var wishlistCount: Int = 0
        var cartCount: Int = 0
        var messageCount: Int = 0
        var followingCount: Int = 0
    
        if let value: AnyObject = dictionary["fullName"] {
            if value as! NSObject != NSNull() {
                fullName = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["firstName"] {
            if value as! NSObject != NSNull() {
                firstName = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["lastName"] {
            if value as! NSObject != NSNull() {
                lastName = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["email"] {
            if value as! NSObject != NSNull() {
                email = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["contactNumber"] {
            if value as! NSObject != NSNull() {
                contactNumber = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["profileImageUrl"] {
            if value as! NSObject != NSNull() {
                profileImageUrl = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["coverPhoto"] {
            if value as! NSObject != NSNull() {
                coverPhoto = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["gender"] {
            if value as! NSObject != NSNull() {
                gender = value as! String
            }
        }
        
        if let value: AnyObject = dictionary["birthdate"] {
            if value as! NSObject != NSNull() {
                birthdate = value as! String
            }
        }
        
        
        if let value: AnyObject = dictionary["address"] {
            if value as! NSObject != NSNull() {
                address = AddressModelV2.parseAddressFromDictionary(value as! NSDictionary)
            }
        }
        
        if let value: AnyObject = dictionary["transactionCount"] {
            if value as! NSObject != NSNull() {
                transactionCount = value as! Int
            }
        }
        
        if let value: AnyObject = dictionary["wishlistCount"] {
            if value as! NSObject != NSNull() {
                wishlistCount = value as! Int
            }
        }
        
        if let value: AnyObject = dictionary["cartCount"] {
            if value as! NSObject != NSNull() {
                cartCount = value as! Int
            }
        }
        
        if let value: AnyObject = dictionary["messageCount"] {
            if value as! NSObject != NSNull() {
                messageCount = value as! Int
            }
        }
        
        if let value: AnyObject = dictionary["followingCount"] {
            if value as! NSObject != NSNull() {
                followingCount = value as! Int
            }
        }
        
        return ProfileUserDetailsModel(fullName: fullName,
            firstName: firstName,
            lastName: lastName,
            email: email,
            contactNumber: contactNumber,
            profileImageUrl: profileImageUrl,
            coverPhoto: coverPhoto,
            gender: gender,
            birthdate: birthdate,
            address: address,
            transactionCount: transactionCount,
            wishlistCount: wishlistCount,
            cartCount: cartCount,
            messageCount: messageCount,
            followingCount: followingCount)
    }
    

}
