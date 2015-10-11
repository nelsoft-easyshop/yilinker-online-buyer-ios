

//
//  W_Messages.swift
//  Messaging
//
//  Created by Dennis Nora on 8/2/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit
import CoreData

extension NSDate
{
    convenience
    init(dateString:String) {
        let dateStringFormatter = NSDateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
        let d = dateStringFormatter.dateFromString(dateString)!
        self.init(timeInterval:0, sinceDate:d)
    }
}

class W_Messages: NSObject {
    
    var message_id  : NSNumber
    var senderId   : Int
    var recipientId: Int
    var message     : String
    var isImage    : String
    var timeSent   : NSDate
    var isSeen   : String
    var timeSeen   : NSDate?
    var isSent : String
    
    init(
        message_id : NSNumber,
        senderId : Int,
        recipientId : Int,
        message : String,
        isImage : String,
        timeSent: NSDate,
        isSeen : String,
        timeSeen: NSDate?,
        isSent : String)
    {
        self.message_id = message_id
        self.senderId = senderId
        self.recipientId = recipientId
        self.message = message
        self.isImage = isImage
        self.timeSent = timeSent
        self.isSeen = isSeen
        
        if let t = timeSeen {
            self.timeSeen = timeSeen
        }
        self.isSent = isSent
    }
    
    override init()
    {
        self.message_id = 0
        self.senderId = 0
        self.recipientId = 0
        self.message = "No message"
        self.isImage = "0"
        self.timeSent = NSDate(dateString: "2015-07-24 07:17:00")
        self.isSeen = "1"
        self.timeSeen = NSDate(dateString: "2015-07-24 07:17:00")
        self.isSent = "0"
    }
    
    class func parseUploadImageResponse(dictionary : AnyObject) -> String {
        
        var url : String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let response: AnyObject = dictionary["data"] {
                
                if let tempVar = response["url"] as? String {
                    url = tempVar
                }
            }
            
        }
        
        return url
    }
    
    
    class func parseMessages(dictionary: AnyObject) -> Array<W_Messages> {
        
        var parsedMessages : Array<W_Messages> = []
        if dictionary.isKindOfClass(NSDictionary) {
            
            
            if let messages: AnyObject = dictionary["data"] {
                
                
                for message in messages as! NSArray {
                    //println(message)
                    var message_id  : Int = 0
                    var senderId    : Int = 0
                    var recipientId : Int = 0
                    var lastMessage : String = ""
                    var isImage     : String = "0"
                    var timeSent    : String = ""
                    var isSeen      : String = "0"
                    var timeSeen    : String = ""
                    var isSent      : String = "1"
                    
                    if let tempVar = message["messageId"] as? Int {
                        message_id = tempVar
                    }
                    
                    if let tempVar = message["senderId"] as? Int {
                        senderId = tempVar
                    }
                    
                    if let tempVar = message["recipientId"] as? Int {
                        recipientId = tempVar
                    }
                    
                    if let tempVar = message["message"] as? String {
                        lastMessage = tempVar
                    }
                    
                    if let tempVar = message["isImage"] as? String {
                        println("isimage")
                        isImage = tempVar
                    }
                    
                    if let tempVar = message["timeSent"] as? String {
                        timeSent = tempVar
                    }
                    
                    if let tempVar = message["isSeen"] as? String {
                        isSeen = tempVar
                    }
                    
                    if let tempVar = message["timeSeen"] as? String {
                        timeSeen = tempVar
                    }
                    
                    if let tempVar = message["isSent"] as? String {
                        println("isSent")
                        isSent = tempVar
                    }
                    
                    var dateSeen : NSDate? = nil
                    
                    if (timeSeen != "") {
                        dateSeen = NSDate(dateString: timeSeen)
                    }
                    
                    parsedMessages.append(W_Messages(message_id: message_id, senderId: senderId, recipientId: recipientId, message: lastMessage, isImage: isImage, timeSent: NSDate(dateString: timeSent), isSeen: isSeen, timeSeen: dateSeen, isSent: isSent))
                }
                
            }
            
        } // dictionary
        
        return parsedMessages.reverse()
    } // parse
}
