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
    
    class func setGcmToken(accessToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "gcmToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setAccessToken(accessToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "accessToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setRefreshToken(refreshToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(refreshToken, forKey: "refreshToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setUserId(userId: String) {
        NSUserDefaults.standardUserDefaults().setObject(userId, forKey: "userId")
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
    
    class func setWishlistCount(wishlistCount: Int) {
        NSUserDefaults.standardUserDefaults().setObject("\(wishlistCount)", forKey: "wishlistCount")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setCartCount(cartCount: Int) {
        NSUserDefaults.standardUserDefaults().setObject("\(cartCount)", forKey: "cartCount")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setDeviceToken(deviceToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(deviceToken, forKey: "deviceToken")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setMobileNumber(mobileNumber: String) {
        NSUserDefaults.standardUserDefaults().setObject(mobileNumber, forKey: "mobileNumber")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func userId() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String {
            result = val as! String
        }
        return result
    }
    
    class func mobileNumber() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("mobileNumber") as? String {
            result = val as! String
        }
        return result
    }
    
    class func cartCount() -> Int {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("cartCount") as? String {
            result = val as! String
        }
        return result.toInt()!
    }
    
    class func wishlistCount() -> Int {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("wishlistCount") as? String {
            result = val as! String
        }
        return result.toInt()!
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
    
    class func gcmToken() -> String {
        var result : String = ""
        
        if let val : AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("gcmToken") as? String {
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
    
    class func deviceToken() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("deviceToken") as? String
        
        if returnValue == nil {
            returnValue = ""
        }
        
        return returnValue!
    }
    
    class func logout() {
        let appDomain = NSBundle.mainBundle().bundleIdentifier!
        
        NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "accessToken")
        NSUserDefaults.standardUserDefaults().setObject("", forKey: "refreshToken")
        NSUserDefaults.standardUserDefaults().setObject("0", forKey: "messageCount")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func isLoggedIn() -> Bool {
        if self.accessToken() != "" {
            return true
        } else {
            return false
        }
    }
    
    class func setIsEmailVerified(isEmailVerified: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(isEmailVerified, forKey: "isEmailVerified")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func isEmailVerified() -> Bool {
//        var result: Bool = false
//        if let val: AnyObject = NSUserDefaults.standardUserDefaults().boolForKey("isEmailVerified"){
//            result = val as! Bool
//        }
//        return result
        return NSUserDefaults.standardUserDefaults().boolForKey("isEmailVerified")
    }
    
    class func setIsMobileVerified(isMobileVerified: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(isMobileVerified, forKey: "isMobileVerified")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func isMobileVerified() -> Bool {
//        var result: Bool = false
//        if let val: AnyObject = NSUserDefaults.standardUserDefaults().boolForKey("isMobileVerified"){
//            result = val as! Bool
//        }
//        return result
        return NSUserDefaults.standardUserDefaults().boolForKey("isMobileVerified")
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
    
    class func saveCookies() {
        var cookiesData: NSData = NSKeyedArchiver.archivedDataWithRootObject(NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies!)
        var defaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(cookiesData, forKey: "sessionCookies")
        defaults.synchronize()
    }
    
    class func loadCookies() {
        var cookiesData: NSData = NSUserDefaults.standardUserDefaults().objectForKey("sessionCookies") as! NSData
        var cookies: [NSHTTPCookie] = NSKeyedUnarchiver.unarchiveObjectWithData(cookiesData) as! [NSHTTPCookie]
        var cookieStorage: NSHTTPCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in cookies {
            cookieStorage.setCookie(cookie)
        }
    }
    
    class func getUnReadMessagesCount() -> Int{
        var messageCount: Int = 0
        
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("messageCount") as? String {
            let result = val as! String
            if result != "" {
                messageCount = result.toInt()!
            } else {
                messageCount = 0
            }
        } else {
            messageCount = 0
        }
        
        return messageCount
    }
    
    class func setUnReadMessagesCount(messageCount: Int) {
        NSUserDefaults.standardUserDefaults().setObject("\(messageCount)", forKey: "messageCount")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func unreadMessageCount() -> String {
        return "You have \(self.getUnReadMessagesCount()) unread messages"
    }
    
    class func longitude() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("long") as? String
        
        if returnValue == nil || returnValue == "" {
            returnValue = "0"
        }
        
        return returnValue!
    }
    
    class func latitude() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("lat") as? String
        
        if returnValue == nil || returnValue == "" {
            returnValue = "0"
        }
        
        return returnValue!
    }
    
    class func setLong(long: String) {
        NSUserDefaults.standardUserDefaults().setObject("\(long)", forKey: "long")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func setLang(lang: String) {
        NSUserDefaults.standardUserDefaults().setObject("\(lang)", forKey: "lat")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func city() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("city") as? String
        
        if returnValue == nil || returnValue == "" {
            returnValue = ""
        }
        
        return returnValue!
    }
    
    class func setCity(city: String) {
        NSUserDefaults.standardUserDefaults().setObject("\(city)", forKey: "city")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func province() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("province") as? String
        
        if returnValue == nil || returnValue == "" {
            returnValue = ""
        }
        
        return returnValue!
    }
    
    class func setProvince(province: String) {
        NSUserDefaults.standardUserDefaults().setObject("\(province)", forKey: "province")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    
}
