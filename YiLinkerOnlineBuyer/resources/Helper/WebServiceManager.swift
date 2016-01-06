//
//  WebServiceManager.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/5/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class WebServiceManager: NSObject {
    
    //Login dictionary keys
    static let emailKey = "email"
    static let passwordKey = "password"
    static let clientIdKey = "client_id"
    static let clientSecretKey = "client_secret"
    static let grantTypeKey = "grant_type"
    static let registrationIdKey = "registrationId"
    static let accessTokenKey = "access_token"
    static let tokenKey = "token"
    
    //Refresh Token
    static let refreshTokenKey = "refresh_token"
    
    //MARK: - Fire Login Request With URL
    class func fireLoginRequestWithUrl(url: String, emailAddress: String, password: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.emailKey: emailAddress, self.passwordKey: password, self.clientIdKey: Constants.Credentials.clientID(), self.clientSecretKey: Constants.Credentials.clientSecret(), self.grantTypeKey: Constants.Credentials.grantBuyer]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire RefreshTokenWithUrl
    class func fireRefreshTokenWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.clientIdKey: Constants.Credentials.clientID(), self.clientSecretKey: Constants.Credentials.clientSecret(), self.grantTypeKey: Constants.Credentials.grantRefreshToken, self.refreshTokenKey:  SessionManager.refreshToken()]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get Home Page Data With Url
    class func fireGetHomePageDataWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: []) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get User Info With Url
    class func fireGetUserInfoWithUrl(url: String, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Post Request With Url
    //This function is for removing repeated codes in handler
    private static func firePostRequestWithUrl(url: String, parameters: AnyObject, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            manager.GET(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        //No internet connection
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
    
    //MARK: - Get Request With Url
    //This function is for removing repeated codes in handler
    private static func fireGetRequestWithUrl(url: String, parameters: AnyObject, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            manager.GET(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        //No internet connection
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
}