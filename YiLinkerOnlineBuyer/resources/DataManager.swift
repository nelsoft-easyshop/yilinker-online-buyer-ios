//
//  JsonMapper.swift
//  Messaging
//
//  Created by Dennis Nora on 8/2/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    struct DMConstants {
        static let RESPONSE_MESSAGE = "MESSAGE"
        static let RESPONSE_CONVO_HEAD = "CONVERSATION_HEAD"
        static let RESPONSE_CONTACTS = "CONTACTS"
        static let RESPONSE_CONVO_MESSAGE = "CONVERSATION_MESSAGE"
        static let RESPONSE_CONVO_AS_READ = "CONVERSATION_AS_READ"
        static let RESPONSE_IMAGE_UPLOAD = "IMAGE_UPLOAD"
        static let RESPONSE_CREATE_REGISTRATION_ID = "CREATE_REGISTRATION_ID"
        static let RESPONSE_DELETE_REGISTRATION_ID = "DELETE_REGISTRATION_ID"
        static let RESPONSE_UPDATE_REGISTRATION_ID = "UPDATE_REGISTRATION_ID"
    }
    
    func parseResponse(response : Dictionary<String, AnyObject>) -> AnyObject?{
        var response_type = response["responseType"] as! String
        var message = response["message"] as! String
        var data = response["data"] as! Dictionary<String, AnyObject>
        var is_successful = response["isSuccessful"] as! Bool
        
        var result : AnyObject?
        
        switch response_type {
        case DMConstants.RESPONSE_MESSAGE:
            self.parseMessage(data)
            // void
        case DMConstants.RESPONSE_CONVO_HEAD:
            result = self.parseConvoHeadArray(data) as Array<W_Conversation>
        case DMConstants.RESPONSE_CONTACTS:
            result = self.parseContactsArray(data) as Array<W_User>
        case DMConstants.RESPONSE_CONVO_MESSAGE:
            result = self.parseConvoMessageArray(data) as Array<W_Messages>
        case DMConstants.RESPONSE_CONVO_AS_READ:
            self.parseConvoAsRead(data)
            // void
        case DMConstants.RESPONSE_IMAGE_UPLOAD:
            self.parseImageUpload(data)
            //void
        case DMConstants.RESPONSE_CREATE_REGISTRATION_ID:
            self.parseCreateRegistrationID(data)
            //void
        case DMConstants.RESPONSE_DELETE_REGISTRATION_ID:
            self.parseDeleteRegistrationID(data)
            //void
        case DMConstants.RESPONSE_UPDATE_REGISTRATION_ID:
            self.parseUpdateRegistrationID(data)
            //void
        default:
            println("No default implementation")
        }
        
        if(is_successful){
            return result
        } else {
            //do something
        }
        
        return nil
    }
    
    func parseMessage(response : Dictionary<String, AnyObject>){
        
        var sentTo = response["sentTo"] as! String
        var dateSent = response["dateSent"] as! String
    }
    
    func parseConvoHeadSingle(response : Dictionary<String, AnyObject>) -> W_Conversation{
        
        var fullName = response["fullName"] as! String
        var userId = response["userId"] as! String
        var lastMessage = response["lastMessage"] as! String
        var lastMessageDate = NSDate(dateString: response["lastMessageDate"] as! String)
        var profileImageUrl = response["profileImageUrl"] as! String
        var lastLoginDate = NSDate(dateString: response["lastLoginDate"] as! String)
        var sender = response["sender"] as! String
        var hasUnreadMessage = response["hasUnreadMessage"] as! String
        
        var _user = W_User(full_name: fullName, user_id: userId, profile_image_url: profileImageUrl)
        var _convoHead = W_Conversation(title: "MessageCell", thumbnail: UIImage(named: "Male-100.png")!, message: lastMessage, message_dt: lastMessageDate, last_login_date: lastLoginDate, sender: sender, has_unread_message: hasUnreadMessage, _user: _user)

        return _convoHead
    }
    
    func parseConvoHeadArray(response : Dictionary<String, AnyObject>) -> Array<W_Conversation>{
        var _convoMessages = Array<W_Conversation>()
        
        if let data = response["data"] as? NSArray{
            for _data in data{
                _convoMessages.append(self.parseConvoHeadSingle(_data as! Dictionary<String, AnyObject>))
            }
        } else {
            _convoMessages.append(self.parseConvoHeadSingle(response))
        }
        
        return _convoMessages
    }
    
    func parseContactsSingle(response : Dictionary<String, AnyObject>) -> W_User{
        
        var fullName = response["fullName"] as! String
        var userId = response["userId"] as! String
        var profileImageUrl = response["profileImageUrl"] as! String
        
        var _user = W_User(full_name: fullName, user_id: userId, profile_image_url: profileImageUrl)
        
        return _user
    }
    
    func parseContactsArray(response: Dictionary<String, AnyObject>) -> Array<W_User>{
        var _contacts = Array<W_User>()
        
        if let data = response["data"] as? NSArray {
            for _data in data{
                _contacts.append(self.parseContactsSingle(_data as! Dictionary<String,AnyObject>))
            }
        } else {
            _contacts.append(self.parseContactsSingle(response))
        }
        
        return _contacts
    }
    
    func parseConvoMessageSingle(response : Dictionary<String, AnyObject>) -> W_Messages{
        
        var senderId = response["senderId"] as! NSNumber
        var recipientId = response["recipientId"] as! NSNumber
        var message = response["message"] as! String
        var isImage = response["isImage"] as! NSNumber
        var timeSent = NSDate(dateString: response["timeSent"] as! String)
        var isSeen = response["isSeen"] as! NSNumber
        var timeSeen = NSDate(dateString: response["timeSeen"] as! String)
        var imageUrl = response["imageUrl"] as! String
        
        var _message = W_Messages(message_id: 0, sender_id: senderId, recipient_id: recipientId, message: message, time_sent: timeSent, is_opened: isSeen, time_seen: timeSeen, is_image: isImage, image_url: imageUrl)
        
        return _message
    }
    
    func parseConvoMessageArray(response: Dictionary<String, AnyObject>) -> Array<W_Messages>{
        var _messages = Array<W_Messages>()
        
        if let data = response["data"] as? NSArray {
            for _data in data{
                _messages.append(self.parseConvoMessageSingle(_data as! Dictionary<String,AnyObject>))
            }
        } else {
            _messages.append(self.parseConvoMessageSingle(response))
        }
        
        return _messages
    }
    
    func parseConvoAsRead(response : Dictionary<String, AnyObject>){
        //no data
    }
    
    func parseImageUpload(response : Dictionary<String, AnyObject>){
        
        var url         = response["url"] as! String
        var filesize    = response["filesize"] as! String
        
    }
    
    func parseCreateRegistrationID(response : Dictionary<String, AnyObject>){
        
        //no data

    }
    
    func parseDeleteRegistrationID(response : Dictionary<String, AnyObject>){
        
        //no data

    }
    
    func parseUpdateRegistrationID(response : Dictionary<String, AnyObject>){
        
        //no data

    }
    
}
