//
//  SessionManager.swift
//  EasyshopPractise
//
//  Created by Alvin John Tandoc on 7/22/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

class SessionManager {
    
    static let sharedInstance = SessionManager()
    
    var accessToken: String = ""
    var refreshToken: String = ""
    var loginType: LoginType = LoginType.GoogleLogin
    
    var profileImageUrlString: String = ""
    
    func setAccessToken(accessToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "accessToken")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.accessToken = accessToken
    }
    
    func setRefreshToken(refreshToken: String) {
        NSUserDefaults.standardUserDefaults().setObject(accessToken, forKey: "refreshToken")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.refreshToken = refreshToken
    }
    
    func setProfileImage(profileImageUrlString: String) {
        NSUserDefaults.standardUserDefaults().setObject(profileImageUrlString, forKey: "profileImageUrlString")
        NSUserDefaults.standardUserDefaults().synchronize()
        self.profileImageUrlString = profileImageUrlString
    }
    
    class func currentAccessToken() -> String {
        var returnValue : String?
        
        returnValue = NSUserDefaults.standardUserDefaults().objectForKey("accessToken") as? String
        
        if returnValue == nil {
            returnValue = ""
        }
        
        return returnValue!
    }
}
