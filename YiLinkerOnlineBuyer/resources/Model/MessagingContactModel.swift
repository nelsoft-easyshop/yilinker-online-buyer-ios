//
//  MessagingContactModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 1/8/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class MessagingContactModel: NSObject {
    
    var userId: String = ""
    var slug: String = ""
    var fullName: String = ""
    var profileImageUrl: String = ""
    var profileThumbnailImageUrl: String = ""
    var profileSmallImageUrl: String = ""
    var profileMediumImageUrl: String = ""
    var profileLargeImageUrl: String = ""
    var isOnline: String = "0"
    var hasUnreadMessage: String = ""
    
    override init() {
        
    }
    
    init(userId: String, slug: String, fullName: String, profileImageUrl: String, profileThumbnailImageUrl: String, profileSmallImageUrl: String, profileMediumImageUrl: String, profileLargeImageUrl: String, isOnline: String, hasUnreadMessage: String) {
        self.userId = userId
        self.slug = slug
        self.fullName = fullName
        self.profileImageUrl = profileImageUrl
        self.profileThumbnailImageUrl = profileThumbnailImageUrl
        self.profileSmallImageUrl = profileSmallImageUrl
        self.profileMediumImageUrl = profileMediumImageUrl
        self.profileLargeImageUrl = profileLargeImageUrl
        self.isOnline = isOnline
        self.hasUnreadMessage = hasUnreadMessage
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> MessagingContactModel {
        var userId: String = ""
        var slug: String = ""
        var fullName: String = ""
        var profileImageUrl: String = ""
        var profileThumbnailImageUrl: String = ""
        var profileSmallImageUrl: String = ""
        var profileMediumImageUrl: String = ""
        var profileLargeImageUrl: String = ""
        var isOnline: String = "0"
        var hasUnreadMessage: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["userId"] != nil {
                if let tempVar = dictionary["userId"] as? Int {
                    userId = "\(tempVar)"
                } else if let tempVar = dictionary["userId"] as? String {
                    userId = tempVar
                }
            }
            
            if dictionary["slug"] != nil {
                if let tempVar = dictionary["slug"] as? String {
                    slug = tempVar
                }
            }
            
            if dictionary["fullName"] != nil {
                if let tempVar = dictionary["fullName"] as? String {
                    fullName = tempVar
                }
            }
            
            if dictionary["profileImageUrl"] != nil {
                if let tempVar = dictionary["profileImageUrl"] as? String {
                    profileImageUrl = tempVar
                }
            }
            
            if dictionary["profileThumbnailImageUrl"] != nil {
                if let tempVar = dictionary["profileThumbnailImageUrl"] as? String {
                    profileThumbnailImageUrl = tempVar
                }
            }
            
            if dictionary["profileSmallImageUrl"] != nil {
                if let tempVar = dictionary["profileSmallImageUrl"] as? String {
                    profileSmallImageUrl = tempVar
                }
            }
            
            if dictionary["profileMediumImageUrl"] != nil {
                if let tempVar = dictionary["profileMediumImageUrl"] as? String {
                    profileMediumImageUrl = tempVar
                }
            }
            
            if dictionary["profileLargeImageUrl"] != nil {
                if let tempVar = dictionary["profileLargeImageUrl"] as? String {
                    profileLargeImageUrl = tempVar
                }
            }
            
            if dictionary["isOnline"] != nil {
                if let tempVar = dictionary["isOnline"] as? String {
                    isOnline = tempVar
                }
            }
            
            if dictionary["hasUnreadMessage"] != nil {
                if let tempVar = dictionary["hasUnreadMessage"] as? String {
                    hasUnreadMessage = tempVar
                }
            }
        }
        
        return MessagingContactModel(userId: userId, slug: slug, fullName: fullName, profileImageUrl: profileImageUrl, profileThumbnailImageUrl: profileThumbnailImageUrl, profileSmallImageUrl: profileSmallImageUrl, profileMediumImageUrl: profileMediumImageUrl, profileLargeImageUrl: profileLargeImageUrl, isOnline: isOnline, hasUnreadMessage: hasUnreadMessage)
    }
    
    
}
