//
//  RequestGenerator.swift
//  Messaging
//
//  Created by Dennis Nora on 8/2/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class RequestGenerator: NSObject {
    
    struct RGConstants {
    static let URL_MESSAGE                  = "http://yilinker-online.com/api/v1/message/"
    static let URL_GCM                      = "api/v1/gcm/"
    static let PORT                         = "4567"
    static let ACTION_METHOD_TEMPLATE       = "sample"
    
    static let ACTION_SEND_MESSAGE          = "sendMessage"
    static let ACTION_GET_CONVERSATION_HEAD = "getConversationHead"
    static let ACTION_GET_CONTACTS          = "getContacts"
    static let ACTION_GET_CONVERSATION_MESSAGES = "getConversationMessages"
    static let ACTION_SET_AS_READ           = "setConversationAsRead"
    static let ACTION_IMAGE_ATTACH          = "imageAttach"
    static let ACTION_GCM_CREATE            = "create"
    static let ACTION_GCM_DELETE            = "delete"
    static let ACTION_GCM_UPDATE            = "update"
        
    static let uploadFileType = "jpeg"
    
    }
    
    let dm = DataManager()
    
    func sendMessageEndpointAccess(
        message : String,
        recipientId : String,
        isImage: String,
        accessToken: String)
    {
        var manager = AFHTTPRequestOperationManager()
        
        var params = [
            "message"       : message,
            "recipient_id"  : recipientId,
            "is_image"      : isImage,
            "access_token"  : accessToken
        ]   as Dictionary<String, String>
        
        let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_SEND_MESSAGE
        
        manager.POST(URL, parameters: params,
            
            success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                println("Yes this was a success " +  RGConstants.ACTION_SEND_MESSAGE)
                
                let responseDict = responseObject as! Dictionary<String, AnyObject>
                self.dm.parseResponse(responseDict)
            },
            
            failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                println("We got an error here.. \(error.localizedDescription) " +  RGConstants.ACTION_SEND_MESSAGE)
            })
    }

    func getConversationHeadEndpointAccess(
        page : String,
        limit : String,
        accessToken: String)
    {
            var manager = AFHTTPRequestOperationManager()
            
            var params = [
                "page"          : page,
                "limit"         : limit,
                "access_token"  : accessToken
                ]   as Dictionary<String, String>
            
            let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_GET_CONVERSATION_HEAD
            
            manager.POST(URL, parameters: params,
                
                success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success " + RGConstants.ACTION_GET_CONVERSATION_HEAD)
                    
                    let responseDict = responseObject as! Dictionary<String, AnyObject>
                    self.dm.parseResponse(responseDict)
                },
                
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription) " + RGConstants.ACTION_GET_CONVERSATION_HEAD)
            })
    }
    
    func getContactsEndpointAccess(
        page : String,
        limit : String,
        keyword: String,
        accessToken: String)
    {
            var manager = AFHTTPRequestOperationManager()
            
            var params = [
                "page"          : page,
                "limit"         : limit,
                "keyword"       : keyword,
                "access_token"  : accessToken
                ]   as Dictionary<String, String>
            
            let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_GET_CONTACTS
            
            manager.POST(URL, parameters: params,
                
                success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success " + RGConstants.ACTION_GET_CONTACTS)
                    
                    let responseDict = responseObject as! Dictionary<String, AnyObject>
                    self.dm.parseResponse(responseDict)
                },
                
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription) " + RGConstants.ACTION_GET_CONTACTS)
            })
    }
    
    func getConversationMessagesEndpointAccess (
        controller : MessageThreadVC,
        page : String,
        limit : String,
        userId: String,
        accessToken: String) -> Array<W_Messages>?{
            var manager = AFHTTPRequestOperationManager()
            
            var params = [
                "page"          : page,
                "limit"         : limit,
                "userId"        : userId,
                "access_token"  : accessToken
                ]   as Dictionary<String, String>
            
            
            let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_GET_CONVERSATION_MESSAGES
            
            
            manager.POST(URL, parameters: params,
                
                success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success " + RGConstants.ACTION_GET_CONVERSATION_MESSAGES)
                    
                    let responseDict = responseObject as! Dictionary<String, AnyObject>
                    controller.messages = self.dm.parseResponse(responseDict) as! Array<W_Messages>
                },
                
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription) " + RGConstants.ACTION_GET_CONVERSATION_MESSAGES)
            })
            
            return nil
            
    }
    
    func setConversationAsReadEndpointAccess(
        userId: String,
        accessToken: String){
            var manager = AFHTTPRequestOperationManager()
            
            var params = [
                "userId"        : userId,
                "access_token"  : accessToken
                ]   as Dictionary<String, String>
            
            let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_SET_AS_READ
            
            manager.POST(URL, parameters: params,
                
                success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success " + RGConstants.ACTION_SET_AS_READ)
                    
                    let responseDict = responseObject as! Dictionary<String, AnyObject>
                    self.dm.parseResponse(responseDict)
                },
                
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription) " + RGConstants.ACTION_SET_AS_READ)
            })
    }
    
    func imageAttachEndpointAccess(
        imageName: String,
        accessToken: String){
            var manager = AFHTTPRequestOperationManager()
            
            var params = [
                "image"        : imageName,
                "access_token"  : accessToken
                ]   as Dictionary<String, String>
            
            let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_IMAGE_ATTACH
            
            var fileURL = NSURL.fileURLWithPath(NSBundle.mainBundle().pathForResource(imageName, ofType: RGConstants.uploadFileType)!)
            
            manager.POST(URL, parameters: params,
                constructingBodyWithBlock: { (data : AFMultipartFormData!) in
                    var res = data.appendPartWithFileURL(fileURL, name: "image", error: nil)
                },
                success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success " + RGConstants.ACTION_IMAGE_ATTACH)
                    
                    let responseDict = responseObject as! Dictionary<String, AnyObject>
                    self.dm.parseResponse(responseDict)
                },
                
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription) " + RGConstants.ACTION_IMAGE_ATTACH)
                })
    }
    
    func imageAttachDirectEndpointAccess(
        image: UIImage,
        accessToken: String){
            var manager = AFHTTPRequestOperationManager()
            
            var params = [
                "access_token"  : accessToken
                ]   as Dictionary<String, String>
            
            let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_IMAGE_ATTACH

            var imageData : NSData = UIImageJPEGRepresentation(image, 0.5)

            manager.POST(URL, parameters: params,
                constructingBodyWithBlock: { (data : AFMultipartFormData!) in
                    data.appendPartWithFormData(imageData, name: "image")
                },
                success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success " + RGConstants.ACTION_IMAGE_ATTACH)
                    
                    let responseDict = responseObject as! Dictionary<String, AnyObject>
                    self.dm.parseResponse(responseDict)
                },
                
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription) " + RGConstants.ACTION_IMAGE_ATTACH)
            })
    }
    
    
    
    func createRegistrationIdEndpointAccess(
        registrationId: String,
        accessToken: String){
            var manager = AFHTTPRequestOperationManager()
            
            var params = [
                "registrationId" : registrationId,
                "access_token"  : accessToken
                ]   as Dictionary<String, String>
            
            let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_GCM_CREATE
            
            manager.POST(URL, parameters: params,
                
                success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success " + RGConstants.ACTION_GCM_CREATE)
                    
                    let responseDict = responseObject as! Dictionary<String, AnyObject>
                    self.dm.parseResponse(responseDict)
                },
                
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription) " + RGConstants.ACTION_GCM_CREATE)
            })
    }
    
    func deleteRegistrationIdEndpointAccess(
        registrationId: String,
        accessToken: String){
            var manager = AFHTTPRequestOperationManager()
            
            var params = [
                "registrationId" : registrationId,
                "access_token"  : accessToken
                ]   as Dictionary<String, String>
            
            let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_GCM_DELETE
            
            manager.POST(URL, parameters: params,
                
                success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success " + RGConstants.ACTION_GCM_DELETE)
                    
                    let responseDict = responseObject as! Dictionary<String, AnyObject>
                    self.dm.parseResponse(responseDict)
                },
                
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription) " + RGConstants.ACTION_GCM_DELETE)
            })
    }
    
    func updateRegistrationIdEndpointAccess(
        registrationId: String,
        accessToken: String){
            var manager = AFHTTPRequestOperationManager()
            
            var params = [
                "registrationId" : registrationId,
                "access_token"  : accessToken
                ]   as Dictionary<String, String>
            
            let URL = RGConstants.URL_MESSAGE + RGConstants.ACTION_GCM_UPDATE
            
            manager.POST(URL, parameters: params,
                
                success:  { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
                    println("Yes this was a success " + RGConstants.ACTION_GCM_UPDATE)
                    
                    let responseDict = responseObject as! Dictionary<String, AnyObject>
                    self.dm.parseResponse(responseDict)
                },
                
                failure: { (operation: AFHTTPRequestOperation!, error: NSError!) in
                    println("We got an error here.. \(error.localizedDescription) " + RGConstants.ACTION_GCM_UPDATE)
            })
    }
    
}
