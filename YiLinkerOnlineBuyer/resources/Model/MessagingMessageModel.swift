//
//  MessagingMessageModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 1/8/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class MessagingMessageModel: NSObject {

    var messageId: String = ""
    var senderId: String = ""
    var recipientId: String = ""
    var senderProfileImageUrl: String = ""
    var senderProfileThumbnailImageUrl: String = ""
    var senderProfileSmallImageUrl: String = ""
    var senderProfileMediumImageUrl: String = ""
    var senderProfileLargeImageUrl: String = ""
    var message: String = ""
    var isImage: String = ""
    var timeSent: String = ""
    var isSeen: String = ""
    var timeSeen: String = ""
    var isSenderOnline: String = ""
    
    init(messageId: String, senderId: String, recipientId: String, senderProfileImageUrl: String, senderProfileThumbnailImageUrl: String, senderProfileSmallImageUrl: String, senderProfileMediumImageUrl: String, senderProfileLargeImageUrl: String, message: String, isImage: String, timeSent: String, isSeen: String, timeSeen: String, isSenderOnline: String) {
        self.messageId = messageId
        self.senderId = senderId
        self.recipientId = recipientId
        self.senderProfileImageUrl = senderProfileImageUrl
        self.senderProfileThumbnailImageUrl = senderProfileThumbnailImageUrl
        self.senderProfileSmallImageUrl = senderProfileSmallImageUrl
        self.senderProfileMediumImageUrl = senderProfileMediumImageUrl
        self.senderProfileLargeImageUrl = senderProfileLargeImageUrl
        self.message = message
        self.isImage = isImage
        self.timeSent = timeSent
        self.isSeen = isSeen
        self.timeSeen = timeSeen
        self.isSenderOnline = isSenderOnline
    }
    
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> MessagingMessageModel {
        var messageId: String = ""
        var senderId: String = ""
        var recipientId: String = ""
        var senderProfileImageUrl: String = ""
        var senderProfileThumbnailImageUrl: String = ""
        var senderProfileSmallImageUrl: String = ""
        var senderProfileMediumImageUrl: String = ""
        var senderProfileLargeImageUrl: String = ""
        var message: String = ""
        var isImage: String = ""
        var timeSent: String = ""
        var isSeen: String = ""
        var timeSeen: String = ""
        var isSenderOnline: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if dictionary["messageId"] != nil {
                if let tempVar = dictionary["messageId"] as? Int {
                    messageId = "\(tempVar)"
                }
            }
            
            if dictionary["senderId"] != nil {
                if let tempVar = dictionary["senderId"] as? Int {
                    senderId = "\(tempVar)"
                }
            }
            
            if dictionary["recipientId"] != nil {
                if let tempVar = dictionary["recipientId"] as? Int {
                    recipientId = "\(tempVar)"
                }
            }
            
            if dictionary["senderProfileImageUrl"] != nil {
                if let tempVar = dictionary["senderProfileImageUrl"] as? String {
                    senderProfileImageUrl = tempVar
                }
            }
            
            if dictionary["senderProfileThumbnailImageUrl"] != nil {
                if let tempVar = dictionary["senderProfileThumbnailImageUrl"] as? String {
                    senderProfileThumbnailImageUrl = tempVar
                }
            }
            
            if dictionary["senderProfileSmallImageUrl"] != nil {
                if let tempVar = dictionary["senderProfileSmallImageUrl"] as? String {
                    senderProfileSmallImageUrl = tempVar
                }
            }
            
            if dictionary["senderProfileMediumImageUrl"] != nil {
                if let tempVar = dictionary["senderProfileMediumImageUrl"] as? String {
                    senderProfileMediumImageUrl = tempVar
                }
            }
            
            if dictionary["senderProfileLargeImageUrl"] != nil {
                if let tempVar = dictionary["senderProfileLargeImageUrl"] as? String {
                    senderProfileLargeImageUrl = tempVar
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
            
            if dictionary["timeSent"] != nil {
                if let tempVar = dictionary["timeSent"] as? String {
                    timeSent = tempVar
                }
            }
            
            if dictionary["isSeen"] != nil {
                if let tempVar = dictionary["isSeen"] as? String {
                    isSeen = tempVar
                }
            }
            
            if dictionary["timeSeen"] != nil {
                if let tempVar = dictionary["timeSeen"] as? String {
                    timeSeen = tempVar
                }
            }
            
            if dictionary["isSenderOnline"] != nil {
                if let tempVar = dictionary["isSenderOnline"] as? String {
                    isSenderOnline = tempVar
                }
            }
        }
        
        return MessagingMessageModel(messageId: messageId, senderId: senderId, recipientId: recipientId, senderProfileImageUrl: senderProfileImageUrl, senderProfileThumbnailImageUrl: senderProfileThumbnailImageUrl, senderProfileSmallImageUrl: senderProfileSmallImageUrl, senderProfileMediumImageUrl: senderProfileMediumImageUrl, senderProfileLargeImageUrl: senderProfileLargeImageUrl, message: message, isImage: isImage, timeSent: timeSent, isSeen: isSeen, timeSeen: timeSeen, isSenderOnline: isSenderOnline)
    }
}
