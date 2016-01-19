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

    //Register dictionary keys
    static let firstNameKey = "firstName"
    static let lastNameKey = "lastName"
    static let contactNumberKey = "contactNumber"
    
    //Guest Register dictionary keys
    static let plainPasswordFirstKey = "user_guest[plainPassword][first]"
    static let plainPasswordSecondKey = "user_guest[plainPassword][second]"
    static let referralCodeKey = "user_guest[referralCode]"

    //Messaging dictionary keys
    static let pageKey = "page"
    static let limitKey = "limit"
    static let keywordKey = "keyword"
    static let messageKey = "message"
    static let recipientIdKey = "recipientId"
    static let isImageKey = "isImage"
    static let deviceTypeKey = "deviceType"
    
    static private var postTask: NSURLSessionDataTask?

    //Checkout
    static let addressIdKey = "address_id"
    static let voucherCodeKey = "voucherCode"
    
    //Seller
    static let sellerIdKey = "sellerId"
    static let userIdKey = "userId"
    
    //MARK: -
    //MARK: - Fire Login Request With URL
    class func fireLoginRequestWithUrl(url: String, emailAddress: String, password: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.emailKey: emailAddress, self.passwordKey: password, self.clientIdKey: Constants.Credentials.clientID(), self.clientSecretKey: Constants.Credentials.clientSecret(), self.grantTypeKey: Constants.Credentials.grantBuyer]
        
        let sessionDataTask: NSURLSessionDataTask = self.firePostRequestSessionDataTaskWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
        
        return sessionDataTask
    }
    
    //MARK: -
    //MARK: - Fire RefreshTokenWithUrl
    class func fireRefreshTokenWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.clientIdKey: Constants.Credentials.clientID(), self.clientSecretKey: Constants.Credentials.clientSecret(), self.grantTypeKey: Constants.Credentials.grantRefreshToken, self.refreshTokenKey:  SessionManager.refreshToken()]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Get Home Page Data With Url
    class func fireGetHomePageDataWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: []) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Get User Info With Url
    class func fireGetUserInfoWithUrl(url: String, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: accessToken]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire COD With Url
    class func fireCODWithUrl(url: String, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: accessToken]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Peso Pay With Url
    class func firePesoPayWithUrl(url: String, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: accessToken]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Set Checkout Address With Url
    class func fireSetCheckoutAddressWithUrl(url: String, accessToken: String, addressId: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: accessToken, self.addressIdKey: addressId]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get Conversation list With Url
    class func fireGetConversationListWithUrl(url: String, page: String, limit: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [pageKey: page, limitKey: limit]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get Conversation thread list With Url
    class func fireGetConversationThreadListWithUrl(url: String, page: String, limit: String, userId: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [pageKey: page, limitKey: limit, userIdKey: userId]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get Contacts lis With Url
    class func fireGetContactListWithUrl(url: String, keyword: String, page: String, limit: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [pageKey: page, limitKey: limit, keywordKey: keyword]
        let manager = APIManager.sharedInstance
        if (self.postTask != nil) {
            self.postTask?.cancel()
            manager.operationQueue.cancelAllOperations()
            self.postTask = nil
        }
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get Contacts list With Url
    class func fireSendMessageWithUrl(url: String, isImage: Bool, recipientId: String, message: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        if !isImage {
            let parameters: NSDictionary = [isImageKey: "0", messageKey: message, recipientIdKey: recipientId]
            self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
                actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
            }
        } else {
            let parameters: NSDictionary = [isImageKey: "1", messageKey: message, recipientIdKey: recipientId]
            self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
                actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
            }
        }
    }
    
    //MARK: - Fire set conversation as read
    class func fireSetConversationAsReadWithUrl(url: String, userId: String, access_token: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [userIdKey: userId]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get Contacts lis With Url
    class func fireAttachImageWithUrl(url: String, image: UIImage, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithImage(url, parameters: [], image: image) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Logout User
    class func fireLogoutUserWithUrl(url: String, registrationId: String, deviceType: String, access_token: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [registrationIdKey: registrationId, deviceTypeKey: deviceType]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Voucher With Url
    class func fireVoucherWithUrl(url: String, accessToken: String, voucherCode: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        
        var parameters: NSDictionary = NSDictionary()
        
        if accessToken != "" {
            parameters = [self.accessTokenKey: accessToken, self.voucherCodeKey: voucherCode]
        } else {
            parameters = [self.voucherCodeKey: voucherCode]
        }
        self.fireGetRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Post Request With Url
    //This function is for removing repeated codes in handler
    private static func firePostRequestWithUrl(url: String, parameters: AnyObject, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            self.postTask = manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task   : NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
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
    
    
    //MARK: -
    //MARK: - Post Request With Url * Session Data Task
    //This function is for removing repeated codes in handler
    private static func firePostRequestSessionDataTaskWithUrl(url: String, parameters: AnyObject, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager = APIManager.sharedInstance
        var sessionDataTask: NSURLSessionDataTask = NSURLSessionDataTask()
        if Reachability.isConnectedToNetwork() {
           sessionDataTask = manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task : NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        if Reachability.isConnectedToNetwork() {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .Cancel)
                        } else {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                        }
                    }
            })!
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
        
        return sessionDataTask
    }
    
    //MARK: -
    //MARK: - Get Request With Url * Session Data Task
    //This function is for removing repeated codes in handler
    private static func fireGetRequestSessionDataTaskWithUrl(url: String, parameters: AnyObject, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager = APIManager.sharedInstance
        var sessionDataTask: NSURLSessionDataTask = NSURLSessionDataTask()
        if Reachability.isConnectedToNetwork() {
            sessionDataTask = manager.GET(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task : NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else {
                            //Unrecognized error, this is a rare case.
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        if Reachability.isConnectedToNetwork() {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .Cancel)
                        } else {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                        }
                    }
            })!
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
        
        return sessionDataTask
    }
    
    //MARK: - Post Request With Image
    //This function is for removing repeated codes in handler
    private static func firePostRequestWithImage(url: String, parameters: AnyObject, image: UIImage, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            
            self.postTask = manager.POST(url, parameters: parameters,
                constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                    formData.appendPartWithFileData(UIImageJPEGRepresentation(image, 1.0), name: "image", fileName: "yilinker", mimeType: "image/JPEG")
                }, success: { (task, responseObject) -> Void in
                    actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) -> Void in
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
    
    //MARK: -
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
                        if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            //Page not found
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            //Request Timeout
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else if task.statusCode == Constants.WebServiceStatusCode.expiredAccessToken {
                            //The accessToken is already expired
                            actionHandler(successful: false, responseObject: [], requestErrorType: .AccessTokenExpired)
                        } else if error.userInfo != nil {
                            //Request is successful but encounter error in server
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
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
    
    //MARK: -
    //MARK: - Fire Register Request With URL
    class func fireRegisterRequestWithUrl(url: String, emailAddress: String, mobileNumber: String, password: String, firstName: String, lastName: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.emailKey: emailAddress, self.passwordKey: password, self.firstNameKey: firstName, self.lastNameKey: lastName, self.contactNumberKey: mobileNumber]
        
        if Reachability.isConnectedToNetwork() {
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
    
    //MARK: -
    //MARK: - Fire Guest Register Request With URL
    class func fireGuestRegisterRequestWithUrl(url: String, password: String, referralCode: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.plainPasswordFirstKey: password, self.plainPasswordSecondKey: password, self.referralCodeKey: referralCode]
        
        if Reachability.isConnectedToNetwork() {
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    if let task = task.response as? NSHTTPURLResponse {
                        if error.userInfo != nil {
                            actionHandler(successful: false, responseObject: error.userInfo!, requestErrorType: .ResponseError)
                        } else if task.statusCode == Constants.WebServiceStatusCode.pageNotFound {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .PageNotFound)
                        } else if task.statusCode == Constants.WebServiceStatusCode.requestTimeOut {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .RequestTimeOut)
                        } else {
                            actionHandler(successful: false, responseObject: [], requestErrorType: .UnRecognizeError)
                        }
                    } else {
                        actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
                    }
            })
        } else {
            actionHandler(successful: false, responseObject: [], requestErrorType: .NoInternetConnection)
        }
    }
 
    //MARK: -
    //MARK: - Fire Seller With Url
    class func fireSellerWithUrl(url: String, accessToken: String, sellerId: Int, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = NSDictionary()
        
        if SessionManager.isLoggedIn() {
            parameters = [self.userIdKey: sellerId, self.accessTokenKey: accessToken]
        } else {
            parameters = [self.userIdKey: sellerId]
        }
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Seller Feedback With Url
    class func fireSellerFeedbackWithUrl(url: String, sellerId: Int, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.sellerIdKey: sellerId]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - 
    //MARK: - Fire Follow Seller With Url
    class func fireFollowSellerWithUrl(url: String, sellerId: Int, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.sellerIdKey: sellerId, self.accessTokenKey: accessToken]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire UnFollow Seller With Url
    class func fireUnFollowSellerWithUrl(url: String, sellerId: Int, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.sellerIdKey: sellerId, self.accessTokenKey: accessToken]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
}