//
//  VoucherModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class VoucherModel: NSObject {
    var isSuccessful: Bool = false
    var less: String = ""
    var originalPrice: String = ""
    var voucherPrice: String = ""
    var message: String = ""
    
    override init() {
        
    }
    
    init(isSuccessful: Bool, less: String, originalPrice: String, voucherPrice: String, message: String) {
        self.isSuccessful = isSuccessful
        self.originalPrice = originalPrice
        self.voucherPrice = voucherPrice
        self.message = message
        self.less = less
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> VoucherModel {
        var isSuccessful: Bool = false
        var less: String = ""
        var originalPrice: String = ""
        var voucherPrice: String = ""
        var message: String = ""
        
        if let temp = dictionary["isSuccessful"] as? Bool {
            isSuccessful = temp
        }
        
        if let dataDictionary = dictionary["data"] as? NSDictionary {
            if let temp = dataDictionary["less"] as? String {
                less = temp
            } else if let temp = dataDictionary["less"] as? NSNumber {
                less = "\(temp)"
            }
            
            if let temp = dataDictionary["origPrice"] as? String {
                originalPrice = temp
            } else if let temp = dataDictionary["origPrice"] as? NSNumber {
                originalPrice = "\(temp)"
            }
            
            if let temp = dataDictionary["voucherPrice"] as? String {
                voucherPrice = temp
            } else if let temp = dataDictionary["voucherPrice"] as? NSNumber {
                voucherPrice = "\(temp)"
            }
        }
        
        if let temp = dictionary["message"] as? String {
            message = temp
        }
        
        return VoucherModel(isSuccessful: isSuccessful, less: less, originalPrice: originalPrice, voucherPrice: voucherPrice, message: message)
    }
}
