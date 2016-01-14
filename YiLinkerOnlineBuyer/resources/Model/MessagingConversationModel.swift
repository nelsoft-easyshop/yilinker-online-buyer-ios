//
//  MessagingConversationModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 1/8/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class MessagingConversationModel: NSObject {
   
    var contactDetails: MessagingContactModel?
    var sender: String = ""
    var message: String = ""
    var isImage: String = ""
    var lastMessageDate: String = ""
    var lastLoginDate: String = ""
    
    init(contactDetails: MessagingContactModel, sender: String, message: String, isImage: String, lastMessageDate: String, lastLoginDate: String) {
        self.contactDetails = contactDetails
        self.sender = sender
        self.message = message
        self.isImage = isImage
        self.lastMessageDate = lastMessageDate
        self.lastLoginDate = lastLoginDate
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> MessagingConversationModel {
        var contactDetails: MessagingContactModel = MessagingContactModel()
        var sender: String = ""
        var message: String = ""
        var isImage: String = ""
        var lastMessageDate: String = ""
        var lastLoginDate: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["userId"] != nil {
                if let tempVar = dictionary["userId"] as? Int {
                    contactDetails.userId = "\(tempVar)"
                } else if let tempVar = dictionary["userId"] as? String {
                    contactDetails.userId = tempVar
                }
            }
            
            if dictionary["slug"] != nil {
                if let tempVar = dictionary["slug"] as? String {
                    contactDetails.slug = tempVar
                }
            }
            
            if dictionary["fullName"] != nil {
                if let tempVar = dictionary["fullName"] as? String {
                    contactDetails.fullName = tempVar
                }
            }
            
            if dictionary["profileImageUrl"] != nil {
                if let tempVar = dictionary["profileImageUrl"] as? String {
                    contactDetails.profileImageUrl = tempVar
                }
            }
            
            if dictionary["profileThumbnailImageUrl"] != nil {
                if let tempVar = dictionary["profileThumbnailImageUrl"] as? String {
                    contactDetails.profileThumbnailImageUrl = tempVar
                }
            }
            
            if dictionary["profileSmallImageUrl"] != nil {
                if let tempVar = dictionary["profileSmallImageUrl"] as? String {
                    contactDetails.profileSmallImageUrl = tempVar
                }
            }
            
            if dictionary["profileMediumImageUrl"] != nil {
                if let tempVar = dictionary["profileMediumImageUrl"] as? String {
                    contactDetails.profileMediumImageUrl = tempVar
                }
            }
            
            if dictionary["profileLargeImageUrl"] != nil {
                if let tempVar = dictionary["profileLargeImageUrl"] as? String {
                    contactDetails.profileLargeImageUrl = tempVar
                }
            }
            
            if dictionary["isOnline"] != nil {
                if let tempVar = dictionary["isOnline"] as? String {
                    contactDetails.isOnline = tempVar
                }
            }
            
            if dictionary["hasUnreadMessage"] != nil {
                if let tempVar = dictionary["hasUnreadMessage"] as? String {
                    contactDetails.hasUnreadMessage = tempVar
                }
            }
            
            if dictionary["sender"] != nil {
                if let tempVar = dictionary["sender"] as? String {
                    sender = tempVar
                }
            }
            
            if dictionary["message"] != nil {
                if let tempVar = dictionary["message"] as? String {
                    message = tempVar
                }
            }
            
            if dictionary["isImage"] != nil {
                if let tempVar = dictionary["isImage"] as? String {
                    isImage = tempVar
                }
            }
            
            if dictionary["lastMessageDate"] != nil {
                if let tempVar = dictionary["lastMessageDate"] as? String {
                    lastMessageDate = tempVar
                }
            }
            
            if dictionary["lastLoginDate"] != nil {
                if let tempVar = dictionary["lastLoginDate"] as? String {
                    lastLoginDate = tempVar
                }
            }
        }
        
        return MessagingConversationModel(contactDetails: contactDetails, sender: sender, message: message, isImage: isImage, lastMessageDate: lastMessageDate, lastLoginDate: lastLoginDate)
    }
}
