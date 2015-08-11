//
//  ProductSellerModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class ProductSellerModel {
    
    var message: String = ""
    var isSuccessful: Bool = false
    
    var id: String = ""
    var name: String = ""
    var specialty: String = ""
    var logoUrl: String = ""
    var images: NSArray = []
    var description: String = ""
    var contactNo: String = ""
    
    init(message: String, isSuccessful: Bool, id: String, name: String, specialty: String, logoUrl: String, images: NSArray, description: String, contactNo: String) {
        self.message = message
        self.isSuccessful = isSuccessful
        
        self.id = id
        self.name = name
        self.specialty = specialty
        self.logoUrl = logoUrl
        self.images = images
        self.description = description
        self.contactNo = contactNo
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ProductSellerModel! {
        
        var message: String = ""
        var isSuccessful: Bool = false
        
        var id: String = ""
        var name: String = ""
        var specialty: String = ""
        var logoUrl: String = ""
        var images: NSArray = []
        var description: String = ""
        var contactNo: String = ""
        
        if dictionary.isKindOfClass(NSDictionary) {
            
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                
                if let tempVar = value["id"] as? String {
                    id = tempVar
                }
                
                if let tempVar = value["name"] as? String {
                    name = tempVar
                }
                
                if let tempVar = value["specialty"] as? String {
                    specialty = tempVar
                }
                
                if let tempVar = value["logoUrl"] as? String {
                    logoUrl = tempVar
                }
                
                if let tempVar = value["images"] as? NSArray {
                    images = tempVar
                }
                
                if let tempVar = value["description"] as? String {
                    description = tempVar
                }
                
                if let tempVar = value["contactNo"] as? String {
                    contactNo = tempVar
                }
                
            }
            
            return ProductSellerModel(message: message, isSuccessful: isSuccessful, id: id, name: name, specialty: specialty, logoUrl: logoUrl, images: images, description: description, contactNo: contactNo)
        } else {
            return ProductSellerModel(message: "", isSuccessful: false, id: "", name: "", specialty: "", logoUrl: "", images: [], description: "", contactNo: "")
        }
    }
}