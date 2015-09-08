//
//  SessionManager.swift
//  EasyshopPractise
//
//  Created by Alvin John Tandoc on 7/22/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

class SessionManager {
    
    static let sharedInstance = SessionManager()

    var loginType: LoginType = LoginType.GoogleLogin
    
    class func setAccessToken(accessToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "accessToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setRefreshToken(refreshToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(refreshToken, forKey: "refreshToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setProfileImage(profileImageUrlString: String) {
        NSUserDefaults.standardUserDefaults().setObject(profileImageUrlString, forKey: "profileImageUrlString")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setUserFullName(userFullName: String) {
        NSUserDefaults.standardUserDefaults().setObject(userFullName, forKey: "userFullName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setFullAddress(userAddress: String) {
        NSUserDefaults.standardUserDefaults().setObject(userAddress, forKey: "userAddress")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setAddressId(addressId: Int) {
        NSUserDefaults.standardUserDefaults().setObject("\(addressId)", forKey: "addressId")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func addressId() -> Int {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("addressId") as? String {
            result = val as! String
        }
        return result.toInt()!
    }
    
    class func userFullName() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userFullName") as? String {
            result = val as! String
        }
        
        return result
    }
    
    class func userFullAddress() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userAddress") as? String {
            result = val as! String
        }
        
        return result
    }
    
    class func profileImageStringUrl() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("profileImageUrlString") as? String {
            result = val as! String
        }
        
        return result
    }
    
    class func accessToken() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as? String
        
        if returnValue == nil {
            returnValue = ""
        }
        
        return returnValue!
    }
    
    class func refreshToken() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("refreshToken") as? String
        
        if returnValue == nil {
            returnValue = ""
        }
        
        return returnValue!
    }
    
    class func logout() {
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "accessToken")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "refreshToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func isLoggedIn() -> Bool {
        if self.accessToken() != "" {
            return true
        } else {
            return false
        }
    }
    
    class func parseTokensFromResponseObject(dictionary: NSDictionary) {
        if dictionary.isKindOfClass(NSDictionary) {
            var accessToken: String = ""
            var refreshToken: String = ""
            
            if let val: AnyObject = dictionary["access_token"] {
                if let tempAccessToken = dictionary["access_token"] as? String {
                    accessToken = tempAccessToken
                }
            }
            
            if let val: AnyObject = dictionary["refresh_token"] {
                if let tempRefreshAccessToken = dictionary["refresh_token"] as? String {
                    refreshToken = tempRefreshAccessToken
                }
            }
            
            self.setAccessToken(accessToken)
            self.setRefreshToken(refreshToken)
            self.setProfileImage("http://besthqimages.mobi/wp-content/uploads/default-profile-picture-png-pictures-2.png")  
        }
    }
    
    class func setPaymentType(paymentType: PaymentType) {
        if paymentType == PaymentType.COD {
            NSUserDefaults.standardUserDefaults().setObject("cod", forKey: "paymentType")
        } else {
            NSUserDefaults.standardUserDefaults().setObject("creditcard", forKey: "paymentType")
        }
        
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func paymentType() -> PaymentType {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("paymentType") as? String {
            result = val as! String
        } else {
            self.setPaymentType(PaymentType.COD)
        }
        
        if result == "cod" {
            return PaymentType.COD
        } else {
            return PaymentType.CreditCard
        }
    }
    
    class func setRememberPaymentType(value: Bool) {
        var string: String = ""
        if value {
            string = "1"
        } else {
            string = "0"
        }
        
        NSUserDefaults.standardUserDefaults().setObject(string, forKey: "setRememberPaymentType")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func rememberPaymentType() -> Bool {
        var result: String = ""
        var returnValue: Bool = false
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("setRememberPaymentType") as? String {
            result = val as! String
        } else {
            self.setRememberPaymentType(true)
            returnValue = true
        }
    
        if result == "1" {
            returnValue = true
        } else {
            returnValue = false
        }
        return returnValue
    }
}
