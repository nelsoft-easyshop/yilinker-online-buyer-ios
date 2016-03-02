//
//  Conversation.swift
//  Messaging
//
//  Created by Dennis Nora on 8/2/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit
import CoreData

class W_Conversation: NSObject {
    
    var contact : W_Contact
    var lastMessage : NSString
    var lastMessageDt : NSDate
    var lastLoginDate : NSDate?
    var sender : String
    var hasUnreadMessage : String
    var isImage : String
    
    init(contact : W_Contact, lastMessage : NSString, lastMessageDt: NSDate, lastLoginDate : NSDate?, sender : String, hasUnreadMessage : String, isImage : String)
    {
        self.contact = contact
        self.lastMessage = lastMessage
        self.lastMessageDt = lastMessageDt
        
        if let t = lastLoginDate {
            self.lastLoginDate = lastLoginDate
        }
        self.sender = sender
        self.hasUnreadMessage = hasUnreadMessage
        self.isImage = isImage
    }
    
    override init ()
    {
        self.contact = W_Contact()
        self.lastMessage = "Hi!"
        self.lastMessageDt = NSDate(dateString: "2015-08-02 20:28:00")
        self.lastLoginDate = NSDate(dateString: "2015-08-02 20:28:00")
        self.sender = "0"
        self.hasUnreadMessage = "0"
        self.isImage = "0"
    }
    
    
    class func parseConversations(dictionary: AnyObject) -> Array<W_Conversation> {
        
        var parsedConversations : Array<W_Conversation> = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            
            if let conversations: AnyObject = dictionary["data"] {
                
                
                for conversation in conversations as! NSArray {
                    println(conversation)
                    var fullName                : String = ""
                    var userRegistrationIds     : String = ""
                    var userIdleRegistrationIds : String = ""
                    var userId                  : String = ""
                    var profileImageUrl         : String = ""
                    var isOnline                : String = ""
                    var lastMessage             : String = ""
                    var lastMessageDt           : String = ""
                    var lastLoginDate           : String = ""
                    var sender                  : String = ""
                    var hasUnreadMessage        : String = ""
                    var isImage                 : String = ""
                    
                    if let tempVar = conversation["fullName"] as? String {
                        fullName = tempVar
                    }
                    
                    if let tempVar = conversation["userId"] as? String {
                        userId = tempVar
                    }
                    
                    if let tempVar = conversation["profileImageUrl"] as? String {
                        profileImageUrl = tempVar
                    }
                    
                    if let tempVar = conversation["isOnline"] as? String {
                        isOnline = tempVar
                    }
                    
                    if let tempVar = conversation["message"] as? String {
                        lastMessage = tempVar
                    }
                    
                    if let tempVar = conversation["lastMessageDate"] as? String {
                        lastMessageDt = tempVar
                    }
                    
                    if let tempVar = conversation["lastLoginDate"] as? String {
                        lastLoginDate = tempVar
                    }
                    
                    if let tempVar = conversation["sender"] as? String {
                        sender = tempVar
                    }
                    
                    if let tempVar = conversation["hasUnreadMessage"] as? String {
                        hasUnreadMessage = tempVar
                    }
                    
                    if let tempVar = conversation["isImage"] as? String {
                        isImage = tempVar
                    }
                    
                    var temp : NSDate? = nil
                    if (lastLoginDate != ""){
                        temp = NSDate(dateString: lastLoginDate)
                    }
                    println("ONLINE : \(isOnline)")
                    println("USER ID : \(userId)")
                    parsedConversations.append(W_Conversation(contact: W_Contact(fullName: fullName, userRegistrationIds: userRegistrationIds, userIdleRegistrationIds: userIdleRegistrationIds, userId: userId, profileImageUrl: profileImageUrl, isOnline: isOnline), lastMessage: lastMessage, lastMessageDt: NSDate(dateString: lastMessageDt), lastLoginDate: temp, sender: sender, hasUnreadMessage: hasUnreadMessage, isImage : isImage))
                }
                
            }
            
        } // dictionary
        
        return parsedConversations
    } // parse
    
}
