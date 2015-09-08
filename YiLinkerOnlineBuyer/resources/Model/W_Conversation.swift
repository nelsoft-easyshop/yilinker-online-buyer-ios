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
    var sender : NSString
    var hasUnreadMessage : NSString

    init(contact : W_Contact, lastMessage : NSString, lastMessageDt: NSDate, lastLoginDate : NSDate?, sender : NSString, hasUnreadMessage : NSString)
    {
        self.contact = contact
        self.lastMessage = lastMessage
        self.lastMessageDt = lastMessageDt
        
        if let t = lastLoginDate {
            self.lastLoginDate = lastLoginDate
        }
        self.sender = sender
        self.hasUnreadMessage = hasUnreadMessage
    }
    
    override init ()
    {
        self.contact = W_Contact()
        self.lastMessage = "Hi!"
        self.lastMessageDt = NSDate(dateString: "2015-08-02 20:28:00")
        self.lastLoginDate = NSDate(dateString: "2015-08-02 20:28:00")
        self.sender = ""
        self.hasUnreadMessage = ""
    }
    
    
    class func parseConversations(dictionary: AnyObject) -> Array<W_Conversation> {
        
        var parsedConversations : Array<W_Conversation> = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            
            if let contacts: AnyObject = dictionary["data"] {
                
                
                for contact in contacts as! NSArray {
                    var fullName                : String = ""
                    var userRegistrationIds     : String = ""
                    var userIdleRegistrationIds : String = ""
                    var userId                  : String = ""
                    var profileImageUrl         : String = ""
                    var isOnline                : String = "0"
                    var lastMessage             : String = ""
                    var lastMessageDt           : String = ""
                    var lastLoginDate           : String = ""
                    var sender                  : String = ""
                    var hasUnreadMessage        : String = ""
                    
                    println(contact)
                    
                    if let tempVar = contact["fullName"] as? String {
                        fullName = tempVar
                    }
                    
                    if let tempVar = contact["userId"] as? String {
                        userId = tempVar
                    }
                    
                    if let tempVar = contact["profileImageUrl"] as? String {
                        profileImageUrl = tempVar
                    }
                    
                    if let tempVar = contact["isOnline"] as? String {
                        isOnline = tempVar
                    }
                    
                    if let tempVar = contact["lastMessage"] as? String {
                        lastMessage = tempVar
                    }
                    
                    if let tempVar = contact["lastMessageDate"] as? String {
                        lastMessageDt = tempVar
                    }
                    
                    if let tempVar = contact["lastLoginDate"] as? String {
                        lastLoginDate = tempVar
                    }
                    
                    if let tempVar = contact["sender"] as? String {
                        sender = tempVar
                    }
                    
                    if let tempVar = contact["hasUnreadMessage"] as? String {
                        hasUnreadMessage = tempVar
                    }
                    
                    var temp : NSDate? = nil
                    if (lastLoginDate != ""){
                        temp = NSDate(dateString: lastLoginDate)
                    }
                    
                    parsedConversations.append(W_Conversation(contact: W_Contact(fullName: fullName, userRegistrationIds: userRegistrationIds, userIdleRegistrationIds: userIdleRegistrationIds, userId: userId, profileImageUrl: profileImageUrl, isOnline: isOnline), lastMessage: lastMessage, lastMessageDt: NSDate(dateString: lastMessageDt), lastLoginDate: temp, sender: sender, hasUnreadMessage: hasUnreadMessage))
                    
                }
                
            }
            
        } // dictionary
        
        return parsedConversations
    } // parse

    
    func testData() -> Array<W_Conversation>
    {
        return [
            W_Conversation(contact : W_Contact(fullName: "Dennis Nora", userRegistrationIds: "", userIdleRegistrationIds: "", userId: "201", profileImageUrl: "N/A", isOnline: "0"), lastMessage: "Hi! How are you? Long time short time make time big time small time. Hi! How are you? Long time short time make time big time small time.", lastMessageDt: NSDate(dateString: "2015-08-03 04:56:00"), lastLoginDate : NSDate(), sender : "", hasUnreadMessage : "YES"),
            W_Conversation(contact : W_Contact(fullName: "Dennis Nora", userRegistrationIds: "", userIdleRegistrationIds: "", userId: "201", profileImageUrl: "N/A", isOnline: "1"), lastMessage: "Hi! How are you? Long time short time make time big time small time. Hi! How are you? Long time short time make time big time small time.", lastMessageDt: NSDate(dateString: "2015-08-02 04:56:00"), lastLoginDate : NSDate(), sender : "", hasUnreadMessage : "YES"),
            W_Conversation(contact : W_Contact(fullName: "Dennis Nora", userRegistrationIds: "", userIdleRegistrationIds: "", userId: "201", profileImageUrl: "N/A", isOnline: "1"), lastMessage: "Hi! How are you? Long time short time make time big time small time. Hi! How are you? Long time short time make time big time small time.", lastMessageDt: NSDate(dateString: "2015-08-01 05:56:00"), lastLoginDate : NSDate(), sender : "", hasUnreadMessage : "YES")
        ]
    }
}
