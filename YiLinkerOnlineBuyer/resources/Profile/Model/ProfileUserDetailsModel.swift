//
//  ProfileUserDetails.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileUserDetailsModel: NSObject {
   
    var userId: String = ""
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
    var userDocuments: String = ""
    var transactionCount: Int = 0
    var wishlistCount: Int = 0
    var cartCount: Int = 0
    var messageCount: Int = 0
    var followingCount: Int = 0
    var isEmailSubscribed: Bool = false
    var isSmsSubscribed: Bool = false
    var isEmailVerified: Bool = false
    var isMobileVerified: Bool = false
    
    var referralCode: String = ""
    var referrerCode: String = ""
    var referrerName: String = ""
    
    var totalPoints: String = ""
    
    var country: CountryModel = CountryModel()
    var language: LanguageModel = LanguageModel()
    
    init(userId: String, fullName: String, firstName: String, lastName: String, email: String, contactNumber: String, profileImageUrl: String, coverPhoto: String, gender: String, birthdate: String, address: AddressModelV2, userDocuments: String, transactionCount: Int, wishlistCount: Int, cartCount: Int, messageCount: Int, followingCount: Int, isEmailSubscribed: Bool, isSmsSubscribed: Bool, isEmailVerified: Bool, isMobileVerified: Bool, referralCode: String, referrerCode: String, referrerName: String, totalPoints: String, country: CountryModel, language: LanguageModel) {
        self.userId = userId
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
        self.userDocuments = userDocuments
        self.transactionCount = transactionCount
        self.wishlistCount = wishlistCount
        self.cartCount = cartCount
        self.messageCount = messageCount
        self.followingCount = followingCount
        self.isEmailSubscribed = isEmailSubscribed
        self.isSmsSubscribed = isSmsSubscribed
        self.isEmailVerified = isEmailVerified
        self.isMobileVerified = isMobileVerified
        self.referralCode = referralCode
        self.referrerCode = referrerCode
        self.referrerName = referrerName
        self.totalPoints = totalPoints
        self.country = country
        self.language = language
    }
    
    override init() {
        
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProfileUserDetailsModel {
        var userId: String = ""
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
        var userDocuments: String = ""
        var transactionCount: Int = 0
        var wishlistCount: Int = 0
        var cartCount: Int = 0
        var messageCount: Int = 0
        var followingCount: Int = 0
        var isEmailSubscribed: Bool = false
        var isSmsSubscribed: Bool = false
        var isEmailVerified: Bool = false
        var isMobileVerified: Bool = false
        
        var referralCode: String = ""
        var referrerCode: String = ""
        var referrerName: String = ""
        var totalPoints: String = ""
        
        var country: CountryModel = CountryModel()
        var language: LanguageModel = LanguageModel()
        
        if let value: AnyObject = dictionary["userId"] {
            if value as! NSObject != NSNull() {
                userId = "\(value as! Int)"
                SessionManager.setUserId(userId)
            }
        }
    
        if let value: AnyObject = dictionary["fullName"] {
            if value as! NSObject != NSNull() {
                fullName = value as! String
                SessionManager.setUserFullName(fullName)
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
                SessionManager.setMobileNumber(contactNumber)
            }
        }
        
        if let value: AnyObject = dictionary["profileImageUrl"] {
            if value as! NSObject != NSNull() {
                profileImageUrl = value as! String
                SessionManager.setProfileImage(profileImageUrl)
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
        
        if let value: AnyObject = dictionary["userDocuments"] {
            if value as! NSObject != NSNull() {
                if let tempDict = value as? NSArray {
                    if tempDict.count > 0 {
                        if let file = tempDict[0]["file"] as? String {
                            userDocuments = file
                        }
                    }
                }
                
                if let tempDict = value as? NSDictionary {
                    if let file = tempDict["file"] as? String {
                        userDocuments = file
                    }
                }
                
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
                SessionManager.setUnReadMessagesCount(messageCount)
            }
        }
        
        if let value: AnyObject = dictionary["followingCount"] {
            if value as! NSObject != NSNull() {
                followingCount = value as! Int
            }
        }
        
        if let value: AnyObject = dictionary["isEmailSubscribed"] {
            if value as! NSObject != NSNull() {
                isEmailSubscribed = value as! Bool
            }
        }
        
        if let value: AnyObject = dictionary["isSmsSubscribed"] {
            if value as! NSObject != NSNull() {
                isSmsSubscribed = value as! Bool
            }
        }
        
        if let value: AnyObject = dictionary["isEmailVerified"] {
            if value as! NSObject != NSNull() {
                isEmailVerified = value as! Bool
                SessionManager.setIsEmailVerified(isEmailVerified)
            }
        }
        
        if let value: AnyObject = dictionary["isMobileVerified"] {
            if value as! NSObject != NSNull() {
                isMobileVerified = value as! Bool
                SessionManager.setIsMobileVerified(isMobileVerified)
            }
        }
        
        if let value = dictionary["referralCode"] as? String {
            referralCode = value
        }
        
        if let value = dictionary["referrerCode"] as? String {
            referrerCode = value
        }
        
        if let value = dictionary["referrerName"] as? String {
            referrerName = value
        }
        
        if let value = dictionary["totalPoints"] as? String {
            totalPoints = value
        }
        
        if let value = dictionary["country"] as? NSDictionary {
            country = CountryModel.parseDataFromDictionary(value)
            SessionManager.setSelectedCountryCode(country.code)
            SessionManager.setSelectedLanguageCode(country.defaultLanguage.code)
            language = country.defaultLanguage
        }
        
        if let value = dictionary["language"] as? NSDictionary {
            language = LanguageModel.pareseDataFromResponseObject(value)
            SessionManager.setSelectedLanguageCode(language.code)
        }
        
        return ProfileUserDetailsModel(userId: userId,
            fullName: fullName,
            firstName: firstName,
            lastName: lastName,
            email: email,
            contactNumber: contactNumber,
            profileImageUrl: profileImageUrl,
            coverPhoto: coverPhoto,
            gender: gender,
            birthdate: birthdate,
            address: address,
            userDocuments: userDocuments,
            transactionCount: transactionCount,
            wishlistCount: wishlistCount,
            cartCount: cartCount,
            messageCount: messageCount,
            followingCount: followingCount,
            isEmailSubscribed: isEmailSubscribed,
            isSmsSubscribed: isSmsSubscribed,
            isEmailVerified: isEmailVerified,
            isMobileVerified: isMobileVerified, referralCode: referralCode, referrerCode: referrerCode, referrerName: referrerName,
            totalPoints: totalPoints,
            country: country,
            language: language)
    }
    

}
