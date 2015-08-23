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
    var sender_id   : NSNumber
    var recipient_id: NSNumber
    var message     : String
    var time_sent   : NSDate
    var is_opened   : NSNumber
    var time_seen   : NSDate
    var is_image    : NSNumber
    var image_url   : String
    
    init(
        message_id : NSNumber,
        sender_id : NSNumber,
        recipient_id : NSNumber,
        message : String,
        time_sent: NSDate,
        is_opened : NSNumber,
        time_seen: NSDate,
        is_image : NSNumber,
        image_url: String)
    {
        self.message_id = message_id
        self.sender_id = sender_id
        self.recipient_id = recipient_id
        self.message = message
        self.time_sent = time_sent
        self.is_opened = is_opened
        self.time_seen = time_seen
        self.is_image = is_image
        self.image_url = image_url
    }
    
    override init()
    {
        self.message_id = 0
        self.sender_id = 0
        self.recipient_id = 0
        self.message = "No message"
        self.time_sent = NSDate(dateString: "2015-07-24 07:17:00")
        self.is_opened = 1
        self.time_seen = NSDate(dateString: "2015-07-24 07:17:00")
        self.is_image = 0
        self.image_url = "N/A"
    }
    
    func getMoc() -> NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let moc = appDelegate.managedObjectContext!
        
        return moc
    }
    
    func persistData(){
        for message in self.testData() {
            Messages.createInMOC(getMoc(), _message: message)
        }
    }
    
    func persistData(messages : Array<W_Messages>){
        for message in messages{
            Messages.createInMOC(getMoc(), _message: message)
        }
    }
    
    func updateTimeSent(id: NSNumber, tempDt : NSDate){
        var tempMessage = Messages.getMessageByIDInMoc(getMoc(), searchID: id)
        Messages.updateTimeSentInMOC(getMoc(), _oldMessage: tempMessage!, tempDt: tempDt)
    }
    
    func updateIsOpened(id: NSNumber, isOpened : NSNumber, openDt : NSDate){
        var tempMessage = Messages.getMessageByIDInMoc(getMoc(), searchID: id)
        Messages.updateIsOpenedInMOC(getMoc(), _oldMessage: tempMessage!, isOpened: isOpened, openDt: openDt)
    }
    
    func loadConversation(recipientID : NSNumber, senderID : NSNumber) -> Array<W_Messages>{
        var w_messages : Array<W_Messages> = []
        
        if let messages = Messages.lookUpConversationInMOC(getMoc(), recipientId: recipientID, senderId: senderID) {
        
            for _message in messages{
            
                var m_id = _message.valueForKey("message_id") as! NSNumber
                var s_id = _message.valueForKey("sender_id") as! NSNumber
                var r_id = _message.valueForKey("recipient_id") as! NSNumber
                var is_opened = _message.valueForKey("is_opened") as! NSNumber
                var is_image = _message.valueForKey("is_image") as! NSNumber
            
                w_messages.append(
                    W_Messages(message_id: m_id, sender_id: s_id, recipient_id: r_id, message: _message.valueForKey("message") as! String, time_sent: _message.valueForKey("time_sent") as! NSDate, is_opened: is_opened, time_seen: _message.valueForKey("time_seen") as! NSDate, is_image: is_image, image_url: _message.valueForKey("image_url") as! String)
                )
            }
        }
        
        return w_messages
        
    }
    
    func testData() -> Array<W_Messages>
    {
        return [
            W_Messages(message_id: 1001, sender_id: 101, recipient_id: 201, message: "Hi!", time_sent: NSDate(dateString: "2015-07-24 07:17:00"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:00"), is_image: 1, image_url: "Create New-50.png"),
            W_Messages(message_id: 1000, sender_id: 101, recipient_id: 201, message: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Cras venenatis ipsum sed nisi hendrerit ornare. Nulla sit amet quam vel risus imperdiet sodales nec quis nulla. Praesent tortor enim, malesuada at augue vel, mattis mattis turpis. Ut mauris odio, consectetur lacinia mauris et, aliquet efficitur neque. Donec consectetur dignissim libero ac feugiat. Donec id dui quis nunc pretium pellentesque commodo non ex. Aliquam viverra turpis suscipit lacus fringilla tempor. Sed dignissim cursus libero eu eleifend. Quisque hendrerit sapien nec eros convallis elementum. Nullam laoreet accumsan lacinia. Ut tincidunt purus suscipit, gravida eros quis, tincidunt nulla.", time_sent: NSDate(dateString: "2015-07-24 07:17:00"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:00"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1001, sender_id: 101, recipient_id: 201, message: "Hi!", time_sent: NSDate(dateString: "2015-07-24 07:17:00"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:00"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1002, sender_id: 201, recipient_id: 101, message: "Hello!", time_sent: NSDate(dateString: "2015-07-24 07:17:01"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:01"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1003, sender_id: 101, recipient_id: 201, message: "How are you?", time_sent: NSDate(dateString: "2015-07-24 07:17:02"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:02"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1004, sender_id: 101, recipient_id: 201, message: "It's been a long time!", time_sent: NSDate(dateString: "2015-07-24 07:17:03"), is_opened : 0, time_seen: NSDate(dateString: "2015-07-24 07:17:03"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1005, sender_id: 201, recipient_id: 101, message: "Yeah!!! I'm doing okay. You?", time_sent: NSDate(dateString: "2015-07-24 07:17:04"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:04"), is_image: 0, image_url: "N/A")
            
            /*,
            W_Messages(message_id: 1006, sender_id: 102, recipient_id: 202, message: "Hi!", time_sent: NSDate(dateString: "2015-07-24 07:17:00"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:00"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1007, sender_id: 202, recipient_id: 102, message: "Hello!", time_sent: NSDate(dateString: "2015-07-24 07:17:01"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:01"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1008, sender_id: 102, recipient_id: 202, message: "How are you?", time_sent: NSDate(dateString: "2015-07-24 07:17:02"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:02"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1009, sender_id: 102, recipient_id: 202, message: "It's been a long time!", time_sent: NSDate(dateString: "2015-07-24 07:17:03"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:03"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1010, sender_id: 202, recipient_id: 102, message: "Yeah!!! I'm doing okay. You?", time_sent: NSDate(dateString: "2015-07-24 07:17:04"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:04"), is_image: 0, image_url: "N/A"),
            
            W_Messages(message_id: 1011, sender_id: 103, recipient_id: 203, message: "Hi!", time_sent: NSDate(dateString: "2015-07-24 07:17:00"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:00"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1012, sender_id: 203, recipient_id: 103, message: "H", time_sent: NSDate(dateString: "2015-07-24 07:17:01"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:01"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1013, sender_id: 103, recipient_id: 203, message: "How are you?", time_sent: NSDate(dateString: "2015-07-24 07:17:02"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:02"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1014, sender_id: 103, recipient_id: 203, message: "It's been a long time!", time_sent: NSDate(dateString: "2015-07-24 07:17:03"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:03"), is_image: 0, image_url: "N/A"),
            W_Messages(message_id: 1015, sender_id: 203, recipient_id: 103, message: "Yeah!!! I'm doing okay. You?", time_sent: NSDate(dateString: "2015-07-24 07:17:04"), is_opened: 0, time_seen: NSDate(dateString: "2015-07-24 07:17:04"), is_image: 0, image_url: "N/A")*/
            ]
    
    }
    
}
