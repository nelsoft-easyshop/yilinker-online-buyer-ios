//
//  AddressModelV2.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class AddressModelV2 {
    
    var userAddressId: Int = 0
    var locationId: Int = 0
    var title: String = ""
    var unitNumber: String = ""
    var buildingName: String = ""
    var streetNumber: String = ""
    var streetName: String = ""
    var subdivision: String = ""
    var zipCode: String = ""
    var streetAddress: String = ""
    var country: String = ""
    var island: String = ""
    var region: String = ""
    var province: String = ""
    var city: String = ""
    var municipality: String = ""
    var barangay: String = ""
    var longitude: String = ""
    var landline: String = ""
    var latitude: String = ""
    var isDefault: Bool = false
    
    class func parseAddressFromDictionary(reviews: NSDictionary) -> AddressModelV2 {
        
        var model = AddressModelV2()
        
        if reviews.isKindOfClass(NSDictionary) {
            
            if let value: AnyObject = reviews["userAddressId"] {
                if value as! NSObject != NSNull() {
                    model.userAddressId = value as! Int
                }
            }
            
            if let value: AnyObject = reviews["locationId"] {
                if value as! NSObject != NSNull() {
                    model.locationId = value as! Int
                }
            }
            
            if let value: AnyObject = reviews["title"] {
                if value as! NSObject != NSNull() {
                    model.title = value as! String
                }
            }
            
            if let value: AnyObject = reviews["unitNumber"] {
                if value as! NSObject != NSNull() {
                    model.unitNumber = value as! String
                }
            }
            
            if let value: AnyObject = reviews["buildingName"] {
                if value as! NSObject != NSNull() {
                    model.buildingName = value as! String
                }
            }
            
            if let value: AnyObject = reviews["streetNumber"] {
                if value as! NSObject != NSNull() {
                    model.streetNumber = value as! String
                }
            }
            
            if let value: AnyObject = reviews["streetName"] {
                if value as! NSObject != NSNull() {
                    model.streetName = value as! String
                }
            }
            
            if let value: AnyObject = reviews["subdivision"] {
                if value as! NSObject != NSNull() {
                    model.subdivision = value as! String
                }
            }
            
            if let value: AnyObject = reviews["zipCode"] {
                if value as! NSObject != NSNull() {
                    model.zipCode = value as! String
                }
            }
            
            if let value: AnyObject = reviews["streetAddress"] {
                if value as! NSObject != NSNull() {
                    model.streetAddress = value as! String
                }
            }
            
            if let value: AnyObject = reviews["country"] {
                if value as! NSObject != NSNull() {
                    model.country = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["island"] {
                if value as! NSObject != NSNull() {
                    model.island = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["region"] {
                if value as! NSObject != NSNull() {
                    model.region = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["province"] {
                if value as! NSObject != NSNull() {
                    model.province = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["city"] {
                if value as! NSObject != NSNull() {
                    model.city = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["municipality"] {
                if value as! NSObject != NSNull() {
                    model.municipality = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["barangay"] {
                if value as! NSObject != NSNull() {
                    model.barangay = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["longitude"] {
                if value as! NSObject != NSNull() {
                    model.longitude = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["latitude"] {
                if value as! NSObject != NSNull() {
                    model.latitude = value as! String
                }
            }
            
            if let value: AnyObject = reviews["landline"] {
                if value as! NSObject != NSNull() {
                    model.landline = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["isDefault"] {
                if value as! NSObject != NSNull() {
                    model.isDefault = value as! Bool
                }
            }
        }
        
        return model
    }
    
}