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
    
    //MARK: - 
    //MARK: - Set First Name
    class func setFirstName(firstName: String) {
        NSUserDefaults.standardUserDefaults().setObject(firstName, forKey: "firstName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: - 
    //MARK: - Set Last Name
    class func setLastName(lastName: String) {
        NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "lastName")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: -
    //MARK: - Set Email Address
    class func setEmailAddress(lastName: String) {
        NSUserDefaults.standardUserDefaults().setObject(lastName, forKey: "emailAddress")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //MARK: -
    //MARK: - Email Address
    class func emailAddress() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("emailAddress") as? String {
            result = val as! String
        }
        return result
    }
    
    //MARK: - 
    //MARK: - First Name
    class func firstName() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("firstName") as? String {
            result = val as! String
        }
        return result
    }
    
    //MARK: -
    //MARK: - Last Name
    class func lastName() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("lastName") as? String {
            result = val as! String
        }
        return result
    }
    
    class func userId() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("userId") as? String {
            result = val as! String
        }
        return result
    }
    
    //MARK: - 
    //MARK: - Mobile Number
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
    
    class func logoutWithTarget(viewController: UIViewController) {
        var hud: MBProgressHUD = MBProgressHUD(view: viewController.view)
        hud.removeFromSuperViewOnHide = true
        hud.dimBackground = false
        viewController.view.addSubview(hud)
        hud.show(true)
        
        var URL: String = "\(APIAtlas.ACTION_GCM_DELETE_V2)?access_token=\(SessionManager.accessToken())"
        
        WebServiceManager.fireLogoutUserWithUrl(URL, registrationId: SessionManager.gcmToken(), deviceType: "1", access_token: SessionManager.accessToken(), actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            hud.hide(true)
            if successful || requestErrorType == .ResponseError {
                self.logoutUserWithHomeRedirection(viewController)
            } else {
                if requestErrorType == .AccessTokenExpired {
                    self.logoutUserWithHomeRedirection(viewController)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: viewController.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: viewController.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: viewController.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: viewController.view)
                }
            }
        })
    }
    
    class func logoutUserWithHomeRedirection(viewController: UIViewController) {
        let registrationToken = SessionManager.gcmToken()
        SessionManager.logout()
        SessionManager.setGcmToken(registrationToken)
        FBSDKLoginManager().logOut()
        GPPSignIn.sharedInstance().signOut()
        viewController.dismissViewControllerAnimated(false, completion: nil)
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToHomeView()
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


     class func setIsDeviceTokenRegistered(isDeviceRegistered: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(isDeviceRegistered, forKey: "isDeviceRegistered")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    class func isDeviceRegistered() -> Bool {
        var userDefaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
        
        if (userDefaults.objectForKey("isDeviceRegistered") != nil) {
            return true
        }
        
        return false
    }
    
}
