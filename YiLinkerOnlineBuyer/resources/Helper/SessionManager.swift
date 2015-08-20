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
}
