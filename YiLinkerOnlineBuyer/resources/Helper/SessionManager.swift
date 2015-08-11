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
    
    class func isLoggedIn() -> Bool {
        if self.accessToken() != "" {
            return true
        } else {
            return false
        }
    }
}
