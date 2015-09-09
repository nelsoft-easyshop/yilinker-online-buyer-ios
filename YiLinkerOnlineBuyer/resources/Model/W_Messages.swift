

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
    var senderId   : String
    var recipientId: String
    var message     : String
    var isImage    : String
    var timeSent   : NSDate
    var isSeen   : String
    var timeSeen   : NSDate?
    var isSent : String
    
    init(
        message_id : NSNumber,
        senderId : String,
        recipientId : String,
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
        self.senderId = "0"
        self.recipientId = "0"
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
                    println(message)
                    var message_id  : Int = 0
                    var senderId    : String = ""
                    var recipientId : String = ""
                    var lastMessage : String = ""
                    var isImage     : String = "0"
                    var timeSent    : String = ""
                    var isSeen      : String = "0"
                    var timeSeen    : String = ""
                    var isSent      : String = "1"
                    
                    if let tempVar = message["message_id"] as? Int {
                        message_id = tempVar
                    }
                    
                    if let tempVar = message["senderId"] as? String {
                        senderId = tempVar
                    }
                    
                    if let tempVar = message["recipientId"] as? String {
                        recipientId = tempVar
                    }
                    
                    if let tempVar = message["message"] as? String {
                        lastMessage = tempVar
                    }
                    
                    if let tempVar = message["isImage"] as? String {
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
    
    
    
    func testData() -> Array<W_Messages>
    {
        return [
            W_Messages(message_id: 1001, senderId: "101", recipientId: "201", message: "Hi!", isImage: "1", timeSent: NSDate(dateString: "2015-07-24 07:17:00"), isSeen: "0", timeSeen: NSDate(dateString: "2015-07-24 07:17:00"), isSent: "1"),
            W_Messages(message_id: 1000, senderId: "101", recipientId: "201", message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis ipsum sed nisi hendrerit ornare. Nulla sit amet quam vel risus imperdiet sodales nec quis nulla. Praesent tortor enim, malesuada at augue vel, mattis mattis turpis. Ut mauris odio, consectetur lacinia mauris et, aliquet efficitur neque. Donec consectetur dignissim libero ac feugiat. Donec id dui quis nunc pretium pellentesque commodo non ex. Aliquam viverra turpis suscipit lacus fringilla tempor. Sed dignissim cursus libero eu eleifend. Quisque hendrerit sapien nec eros convallis elementum. Nullam laoreet accumsan lacinia. Ut tincidunt purus suscipit, gravida eros quis, tincidunt nulla.", isImage: "0", timeSent: NSDate(dateString: "2015-07-24 07:17:00"), isSeen: "0", timeSeen: NSDate(dateString: "2015-07-24 07:17:00"), isSent: "1"),
            W_Messages(message_id: 1001, senderId: "101", recipientId: "201", message: "Hi!", isImage: "0", timeSent: NSDate(dateString: "2015-07-24 07:17:00"), isSeen: "0", timeSeen: NSDate(dateString: "2015-07-24 07:17:00"), isSent: "1"),
            W_Messages(message_id: 1002, senderId: "201", recipientId: "101", message: "Hello!", isImage: "0", timeSent: NSDate(dateString: "2015-07-24 07:17:01"), isSeen: "0", timeSeen: NSDate(dateString: "2015-07-24 07:17:01"), isSent: "1"),
            W_Messages(message_id: 1003, senderId: "101", recipientId: "201", message: "How are you?", isImage: "0", timeSent: NSDate(dateString: "2015-07-24 07:17:02"), isSeen: "0", timeSeen: NSDate(dateString: "2015-07-24 07:17:02"),isSent:  "1"),
            W_Messages(message_id: 1004, senderId: "101", recipientId: "201", message: "It's been a long time!", isImage: "0", timeSent: NSDate(dateString: "2015-07-24 07:17:03"), isSeen : "0", timeSeen: NSDate(dateString: "2015-07-24 07:17:03"), isSent: "1"),
            W_Messages(message_id: 1005, senderId: "201", recipientId: "101", message: "Yeah!!! I'm doing okay. You?", isImage: "0", timeSent: NSDate(dateString: "2015-07-24 07:17:04"), isSeen: "0", timeSeen: NSDate(dateString: "2015-07-24 07:17:04"), isSent: "1")
        ]
        
    }
    
}
