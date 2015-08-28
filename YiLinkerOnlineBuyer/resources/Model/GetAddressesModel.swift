//
//  GetAddressesModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

class GetAddressesModel: NSObject {
    
    var message: String = ""
    var isSuccessful: Bool = false
    var listOfAddress: [AddressModelV2] = []
    
    init(message: String, isSuccessful: Bool, listOfAddress: [AddressModelV2]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.listOfAddress = listOfAddress
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> GetAddressesModel {
        var message: String = ""
        var isSuccessful: Bool = false
        var listOfAddress: [AddressModelV2] = []
        
        if dictionary.isKindOfClass(NSDictionary) {
            if let tempVar = dictionary["message"] as? String {
                message = tempVar
            }
            
            if let tempVar = dictionary["isSuccessful"] as? Bool {
                isSuccessful = tempVar
            }
            
            if let value: AnyObject = dictionary["data"] {
                
                for subValue in value as! NSArray {
                    let model: AddressModelV2 = AddressModelV2.parseAddressFromDictionary(subValue as! NSDictionary)
                    listOfAddress.append(model)
                }
            }
        }
        
        return GetAddressesModel(message: message, isSuccessful: isSuccessful, listOfAddress: listOfAddress)
    }
}