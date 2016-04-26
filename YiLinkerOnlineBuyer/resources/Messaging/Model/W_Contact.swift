//
//  W_Contact.swift
//  Messaging
//
//  Created by Dennis Nora on 8/15/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class W_Contact: NSObject {
    
    var fullName  : String
    var userRegistrationIds : String
    var userIdleRegistrationIds : String
    var userId   : String
    var profileImageUrl: String
    var isOnline : String
    
    init(
        fullName  : String,
        userRegistrationIds : String,
        userIdleRegistrationIds : String,
        userId   : String,
        profileImageUrl: String,
        isOnline : String
        ){
            self.fullName = fullName
            self.userRegistrationIds = userRegistrationIds
            self.userIdleRegistrationIds = userIdleRegistrationIds
            self.userId = userId
            self.profileImageUrl = profileImageUrl
            self.isOnline = isOnline
    }
    
    override init(){
        self.fullName = ""
        self.userRegistrationIds = ""
        self.userIdleRegistrationIds = ""
        self.userId = ""
        self.profileImageUrl = ""
        self.isOnline = "0"
    }
    
    class func parseContacts(dictionary: AnyObject) -> Array<W_Contact> {
        
        var parsedContacts : Array<W_Contact> = []
        if dictionary.isKindOfClass(NSDictionary) {
            
            
            if let contacts: AnyObject = dictionary["data"] {
                
                
                for contact in contacts as! NSArray {
                    var fullName                : String = ""
                    var userRegistrationIds     : String = ""
                    var userIdleRegistrationIds : String = ""
                    var userId                  : String = ""
                    var profileImageUrl         : String = ""
                    var isOnline                : String = ""
                    
                    if let tempVar = contact["fullName"] as? String {
                        fullName = tempVar
                    }
                    
                    if let tempVar = contact["userRegistrationIds"] as? String {
                        userRegistrationIds = tempVar
                    }
                    
                    if let tempVar = contact["userIdleRegistrationIds"] as? String {
                        userIdleRegistrationIds = tempVar
                    }
                    
                    if let tempVar = contact["userId"] as? String {
                        userId = tempVar
                    }
                    
                    if let tempVar = contact["userId"] as? Int {
                        userId = "\(tempVar)"
                    }
                    
                    if let tempVar = contact["profileImageUrl"] as? String {
                        profileImageUrl = tempVar
                    }
                    
                    if let tempVar = contact["isOnline"] as? String {
                        isOnline = tempVar
                    }
                    
                    parsedContacts.append(W_Contact(fullName: fullName, userRegistrationIds: userRegistrationIds, userIdleRegistrationIds: userIdleRegistrationIds, userId: userId, profileImageUrl: profileImageUrl, isOnline: isOnline
                        ))
                }
                
            }
            
        } // dictionary
        
        return parsedContacts
    } // parse
    
}
