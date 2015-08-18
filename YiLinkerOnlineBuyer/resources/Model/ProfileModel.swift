//
//  ProfileModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/18/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {
    
    var address: AddressModel = AddressModel(uid: "", city: "", region: "", streetAddress: "")
    var emailAddress: String = ""
    var imageUrl: NSURL = NSURL(string: "")!
    var name: String = ""
    
    var isSuccessful: Bool = false
    var message: String = ""
    
    init(address: AddressModel, emailAddress: String, imageUrl: NSURL, name: String, isSuccessful: Bool, message: String) {
        self.address = address
        self.emailAddress = emailAddress
        self.imageUrl = imageUrl
        self.name = name
        self.isSuccessful = isSuccessful
        self.message = message
    }
    
    class func pareseDataFromResponseObject(dictionary: NSDictionary) -> ProfileModel {
        var address: AddressModel = AddressModel(uid: "", city: "", region: "", streetAddress: "")
        var emailAddress: String = ""
        var imageUrl: NSURL = NSURL(string: "")!
        var name: String = ""
        
        var isSuccessful: Bool = false
        var message: String = ""
        
        if let val: AnyObject = dictionary["isSuccessful"] {
            if let tempIsSuccessful = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempIsSuccessful
            }
        }
        
        var dataDictionary: NSDictionary = dictionary["data"] as! NSDictionary
        
        if let val: AnyObject = dataDictionary["emailAddress"] {
            if let tempEmailAddress = dataDictionary["emailAddress"] as? String {
                emailAddress = tempEmailAddress
            }
        }
        
        if let val: AnyObject = dataDictionary["imageUrl"] {
            if let tempImageUrl = dataDictionary["imageUrl"] as? String {
                imageUrl = NSURL(string: tempImageUrl)!
            }
        }
        
        if let val: AnyObject = dataDictionary["address"] {
            if let tempAddress = dataDictionary["address"] as? NSDictionary {
                let addressDictionary: NSDictionary = dataDictionary["address"] as! NSDictionary
                address = AddressModel.parseDataFromResponceObject(addressDictionary)
            }
        }
        
        if let val: AnyObject = dataDictionary["message"] {
            if let tempMessage = dataDictionary["message"] as? String {
                message = tempMessage
            }
        }
        
        if let val: AnyObject = dataDictionary["name"] {
            if let tempName = dataDictionary["name"] as? String {
                name = tempName
            }
        }
        
        return ProfileModel(address: address, emailAddress: emailAddress, imageUrl: imageUrl, name: name, isSuccessful: isSuccessful, message: message)
    }
}
