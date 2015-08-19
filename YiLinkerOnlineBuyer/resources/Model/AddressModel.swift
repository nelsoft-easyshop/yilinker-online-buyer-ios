//
//  AddressModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/18/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class AddressModel: NSObject {
    var uid: String = ""
    var city: String = ""
    var region: String = ""
    var streetAddress: String = ""
    
    init(uid: String, city: String, region: String, streetAddress: String) {
        self.uid = uid
        self.city = city
        self.region = region
        self.streetAddress = streetAddress
    }
    
    class func parseDataFromResponceObject(dictionary: NSDictionary) -> AddressModel {
        var uid: String = ""
        var city: String = ""
        var region: String = ""
        var streetAddress: String = ""
        
        if let val: AnyObject = dictionary["uid"] {
            if let tempUid = dictionary["uid"] as? String {
                uid = tempUid
            }
        }
        
        if let val: AnyObject = dictionary["city"] {
            if let tempCity = dictionary["city"] as? String {
                city = tempCity
            }
        }
        
        if let val: AnyObject = dictionary["region"] {
            if let tempRegion = dictionary["region"] as? String {
                region = tempRegion
            }
        }
        
        if let val: AnyObject = dictionary["streetAddress"] {
            if let tempAddress = dictionary["streetAddress"] as? String {
                streetAddress = tempAddress
            }
        }
        
        return AddressModel(uid: uid, city: city, region: region, streetAddress: streetAddress)
    }
}
