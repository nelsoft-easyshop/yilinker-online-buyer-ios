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
    var additionalInfo: String = ""
    var fullLocation: String = ""
    
    //For creating address
    var barangayId: Int = 0
    var cityId: Int = 0
    var provinceId: Int = 0
    
    init() {
        
    }
    
    init(userAddressId: Int, locationId: Int, title: String, unitNumber: String, buildingName: String, streetNumber: String, streetName: String, subdivision: String, zipCode: String, streetAddress: String, country: String, island: String, region: String, province: String, city: String, municipality: String, barangay: String, longitude: String, landline: String, latitude: String, isDefault: Bool, additionalInfo: String, fullLocation: String, barangayId: Int, cityId: Int, provinceId: Int) {
        
        self.userAddressId = userAddressId
        self.locationId = locationId
        self.title = title
        self.unitNumber = unitNumber
        self.buildingName = buildingName
        self.streetNumber = streetNumber
        self.streetName = streetName
        self.subdivision = subdivision
        self.zipCode = zipCode
        self.streetAddress = streetAddress
        self.country = country
        self.island = island
        self.region = region
        self.province = province
        self.city = city
        self.municipality = municipality
        self.barangay = barangay
        self.longitude = longitude
        self.landline = landline
        self.latitude = latitude
        self.isDefault = isDefault
        self.additionalInfo = additionalInfo
        self.fullLocation = fullLocation
        
        self.barangayId = barangayId
        self.cityId = cityId
        self.provinceId = provinceId
    }
    
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
                    if value as? String != nil {
                        model.city = value as! String
                    }
                }
                
            }
            
            if let value: AnyObject = reviews["municipality"] {
                if value as! NSObject != NSNull() {
                    model.municipality = value as! String
                }
                
            }
            
            if let value: AnyObject = reviews["barangay"] {
                if value as! NSObject != NSNull() {
                    if value as? String != nil {
                        model.barangay = value as! String
                    }
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
                    model.isDefault = value.boolValue
                }
            }
            
            if let value: AnyObject = reviews["provinceId"] {
                if value as! NSObject != NSNull() {
                    model.provinceId = value as! Int
                }
            }
            
            if let value: AnyObject = reviews["cityId"] {
                if value as! NSObject != NSNull() {
                    model.cityId = value as! Int
                }
            }
            
            if let value: AnyObject = reviews["barangayId"] {
                if value as! NSObject != NSNull() {
                    model.barangayId = value as! Int
                }
            }
            
            if let value: AnyObject = reviews["fullLocation"] {
                if value as! NSObject != NSNull() {
                    model.fullLocation = value as! String
                }
            }

        }
        
        return model
    }
    
    func copy() -> AddressModelV2 {
        let copy: AddressModelV2 = AddressModelV2(userAddressId: userAddressId, locationId: locationId, title: title, unitNumber: unitNumber, buildingName: buildingName, streetNumber: streetNumber, streetName: streetName, subdivision: subdivision, zipCode: zipCode, streetAddress: streetAddress, country: country, island: island, region: region, province: province, city: city, municipality: municipality, barangay: barangay, longitude: longitude, landline: landline, latitude: latitude, isDefault: isDefault, additionalInfo: additionalInfo, fullLocation: fullLocation, barangayId: barangayId, cityId: cityId, provinceId: provinceId)
        
        return copy
    }

    
}