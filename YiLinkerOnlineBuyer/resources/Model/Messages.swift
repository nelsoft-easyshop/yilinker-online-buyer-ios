//
//  Messages.swift
//  
//
//  Created by Dennis Nora on 8/2/15.
//
//

import Foundation
import CoreData

class Messages: NSManagedObject {

    @NSManaged var message_id: NSNumber
    @NSManaged var sender_id: NSNumber
    @NSManaged var recipient_id: NSNumber
    @NSManaged var message: String
    @NSManaged var time_sent: NSDate
    @NSManaged var is_opened: NSNumber
    @NSManaged var time_seen: NSDate
    @NSManaged var is_image: NSNumber
    @NSManaged var image_url: String

    class func createInMOC(moc: NSManagedObjectContext, _message: W_Messages) -> Messages{
        
        let messageObject = NSEntityDescription.insertNewObjectForEntityForName("Messages", inManagedObjectContext:moc) as! Messages
        
        messageObject.message_id = _message.message_id
        messageObject.sender_id  = _message.sender_id
        messageObject.recipient_id = _message.recipient_id
        messageObject.message    = _message.message
        messageObject.time_sent  = _message.time_sent
        messageObject.is_opened  = _message.is_opened
        messageObject.time_seen  = _message.time_seen
        messageObject.is_image   = _message.is_image
        messageObject.image_url  = _message.image_url
        
        return messageObject
    
    }
    
    class func updateTimeSentInMOC(moc: NSManagedObjectContext, _oldMessage: Messages, tempDt:NSDate) -> Messages?{
        
        _oldMessage.time_sent = tempDt
        
        var saveError : NSError? = nil
        if(moc.save(&saveError)){
            //println("error ?" \(saveError))
            return nil
        } else {
            return _oldMessage
        }
    }
    
    class func updateIsOpenedInMOC(moc: NSManagedObjectContext, _oldMessage: Messages, isOpened:NSNumber, openDt : NSDate) -> Messages?{
        
        _oldMessage.is_opened = isOpened
        _oldMessage.time_seen = openDt
        
        var saveError : NSError? = nil
        if(moc.save(&saveError)){
            //println("error ?" \(saveError))
            return nil
        } else {
            return _oldMessage
        }
    }
    
    class func lookUpConversationInMOC(moc: NSManagedObjectContext, recipientId : NSNumber, senderId : NSNumber) -> Array<Messages>?{
        
        println("search : \(recipientId) <-> \(senderId)")
        
        let fetchConversationRequest = NSFetchRequest(entityName: "Messages")
        let sortItemByDate = NSSortDescriptor(key: "time_sent", ascending: false)
        let predicate = NSPredicate(format: "sender_id == %d AND recipient_id == %d", senderId, recipientId)
        
        var error = NSErrorPointer()
        
        fetchConversationRequest.predicate = predicate
        fetchConversationRequest.sortDescriptors = [sortItemByDate]
        fetchConversationRequest.fetchBatchSize = 50
        fetchConversationRequest.fetchLimit = 1
        
        let fetchResults = moc.executeFetchRequest(fetchConversationRequest, error: error)
        
        if (fetchResults?.count != 0){
            return fetchResults as? Array<Messages>
        } else {
            return nil
        }
    }
    
    class func lookUpAllConversationInMOC(moc: NSManagedObjectContext) -> Array<Messages>?{
        
        let fetchConversationsRequest = NSFetchRequest(entityName: "Messages")
        let sortItemByDate = NSSortDescriptor(key: "time_sent", ascending: false)
        //let predicate = NSPredicate(format: "sender_id == %d AND recipient_id == %d", senderId, recipientId)
        
        var error = NSErrorPointer()
        
        //fetchConversationsRequest.predicate = predicate
        fetchConversationsRequest.sortDescriptors = [sortItemByDate]
        fetchConversationsRequest.fetchBatchSize = 50
        fetchConversationsRequest.fetchLimit = 1
        
        let fetchResults = moc.executeFetchRequest(fetchConversationsRequest, error: error)
        
        if (fetchResults?.count != 0){
            return fetchResults as? Array<Messages>
        } else {
            return nil
        }
    }

    class func getMessageByIDInMoc(moc: NSManagedObjectContext, searchID : NSNumber) -> Messages?{
        
        println("searchID: \(searchID)")
        
        let fetchMessageRequest = NSFetchRequest(entityName: "Messages")
        let sortItem = NSSortDescriptor(key: "message_id", ascending: true)
        let predicate = NSPredicate(format: "message_id == %d", searchID)
        
        var error = NSErrorPointer()
        
        fetchMessageRequest.predicate = predicate
        fetchMessageRequest.sortDescriptors = [sortItem]
        fetchMessageRequest.fetchBatchSize = 1
        fetchMessageRequest.fetchLimit = 1
        
        let fetchResults = moc.executeFetchRequest(fetchMessageRequest, error: error)
        
        if (fetchResults?.count != 0){
            if let fetchedMessage : Messages = fetchResults![0] as? Messages{
                return fetchedMessage
            }
        } else {
            return nil
        }
        return nil
    }
    
}
