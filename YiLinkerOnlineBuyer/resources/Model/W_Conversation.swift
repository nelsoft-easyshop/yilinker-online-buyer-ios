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
   
    var title : String
    
    var thumbnail : UIImage
    var message : NSString
    var message_dt : NSDate
    var last_login_date : NSDate
    var sender : NSString
    var has_unread_message : NSString
    var user : W_User

    init(title : String, thumbnail : UIImage, message : NSString, message_dt: NSDate, last_login_date : NSDate, sender : NSString, has_unread_message : NSString, _user : W_User)
    {
        
        self.title = title
        self.thumbnail = thumbnail
        self.message = message
        self.message_dt = message_dt
        self.last_login_date = last_login_date
        self.sender = sender
        self.has_unread_message = has_unread_message
        self.user = _user
    }
    
    override init ()
    {
        self.title = ""
        self.thumbnail = UIImage(named: "Male-50.png")!
        self.message = "Hi!"
        self.message_dt = NSDate(dateString: "2015-08-02 20:28:00")
        self.last_login_date = NSDate(dateString: "2015-08-02 20:28:00")
        self.sender = ""
        self.has_unread_message = ""
        self.user = W_User()
    }
    
    func getMoc() -> NSManagedObjectContext{
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let moc = appDelegate.managedObjectContext!
        
        return moc
    }
    
    func loadAllConversations() -> Array<W_Messages>{
        var w_messages : Array<W_Messages> = []
        
        if let messages = Messages.lookUpAllConversationInMOC(getMoc()){
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
    
    func testData() -> Array<W_Conversation>
    {
        return [
            W_Conversation(title: "MessageCell", thumbnail: UIImage(named: "person1.jpg")!, message: "Hi! How are you? Long time short time make time big time small time. Hi! How are you? Long time short time make time big time small time.", message_dt: NSDate(dateString: "2015-08-03 04:56:00"), last_login_date : NSDate(), sender : "", has_unread_message : "YES", _user : W_User(full_name: "Dennis Nora", user_id: "201", profile_image_url: "N/A")),
            W_Conversation(title: "MessageCell", thumbnail: UIImage(named: "person2.jpg")!, message: "Hi! How are you? Long time short time make time big time small time. Hi! How are you? Long time short time make time big time small time.", message_dt: NSDate(dateString: "2015-08-02 04:56:00"), last_login_date : NSDate(), sender : "", has_unread_message : "YES", _user : W_User(full_name: "Jeico Malabanan", user_id: "202", profile_image_url: "N/A")),
            W_Conversation(title: "MessageCell", thumbnail: UIImage(named: "person3.jpg")!, message: "Hi! How are you? Long time short time make time big time small time. Hi! How are you? Long time short time make time big time small time.", message_dt: NSDate(dateString: "2015-08-01 05:56:00"), last_login_date : NSDate(), sender : "", has_unread_message : "YES", _user : W_User(full_name: "Francis Rey", user_id: "203", profile_image_url: "N/A"))
        ]
    }
}
