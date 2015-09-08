//
//  PesoPayModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 9/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class PesoPayModel: NSObject {
    var isSuccessful: Bool = false
    var paymentUrl: NSURL = NSURL(string: "")!
    var successUrl: NSURL = NSURL(string: "")!
    var cancelUrl: NSURL = NSURL(string: "")!
    var failUrl: NSURL = NSURL(string: "")!
    var message: String = ""
    
    override init() {
        
    }
    
    init(isSuccessful: Bool, paymentUrl: NSURL, successUrl: NSURL, cancelUrl: NSURL, failUrl: NSURL, message: String) {
        self.isSuccessful = isSuccessful
        self.paymentUrl = paymentUrl
        self.successUrl = successUrl
        self.cancelUrl = cancelUrl
        self.failUrl = failUrl
        self.message = message
    }
    
    
    class func parseDataWithDictionary(dictionary: NSDictionary) -> PesoPayModel {
        
        var isSuccessful: Bool = false
        var paymentUrl: String = ""
        var paymentUrl2: NSURL = NSURL(string: "")!
        var successUrl: NSURL = NSURL(string: "")!
        var cancelUrl: NSURL = NSURL(string: "")!
        var failUrl: NSURL = NSURL(string: "")!
        var message: String = ""
        
        var dataDictionary: NSDictionary = NSDictionary()
        
        if let val: AnyObject = dictionary["isSuccessful"] {
            if let tempVal = val as? Bool {
                isSuccessful = tempVal
            }
        }
        
        if let val: AnyObject = dictionary["message"] {
            if let tempVal = val as? String {
                message = tempVal
            }
        }
        
        var mainUrl: String = ""
        
        if let val: AnyObject = dictionary["data"] {
            if let tempVal = val as? NSDictionary {
                dataDictionary = tempVal
            }
        }
        
        if let val: AnyObject = dataDictionary["paymentUrl"] {
            if let tempVal = val as? String {
                paymentUrl = tempVal
                paymentUrl2 = NSURL(string: tempVal)!
            }
        }
        
        
        let url: NSURL = NSURL(string: paymentUrl)!
        let dictionary: NSDictionary = url.getKeyVals()!
        successUrl = NSURL(string: dictionary["successUrl"] as! String)!
        cancelUrl = NSURL(string: dictionary["cancelUrl"] as! String)!
        failUrl = NSURL(string: dictionary["failUrl"] as! String)!
        
        return PesoPayModel(isSuccessful: isSuccessful, paymentUrl: paymentUrl2, successUrl: successUrl, cancelUrl: cancelUrl, failUrl: failUrl, message: message)
    }
    
}
