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
    static let contactNoKey = "contactNo"
    
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
    
    // Followed Sellers keys
    // page
    // limit
    
    // Review Details keys
    static let productIdKey = "productId"
    
    // Seller Details keys
    // userIdKey
    
    // Update Wishlist keys
    // productId
    static let unitIdKey = "unitId"
    static let quantityKey = "quantity"
    // wishlist
    
    // Cart to Checkout
    static let cartKey = "cart"
    
    // Get Contacts
    // page
    // limit
    // keyword
    
    //Wishlist
    static let wishlistKey = "wishlist"
    // productId
    // unitId
    // quantity
    static let itemIdsKey = "itemIds[]"
    static let itemIdKey = "itemId"
    
    //Address
    static let provinceIdKey = "provinceId"
    static let cityIdIdKey = "cityId"
    
    //Guest User
    static let guestFirstNameKey = "user_guest[firstName]"
    static let guestLastNameKey = "user_guest[lastName]"
    static let guestEmailKey = "user_guest[email]"
    static let guestContactNumberKey = "user_guest[contactNumber]"
    static let guestTitleKey = "user_address[title]"
    static let guestStreetNameKey = "user_address[streetName]"
    static let guestZipCodeKey = "user_address[zipCode]"
    static let guestLocationKey = "user_address[location]"
    static let guestIsDefaultKey = "user_address[isDefault]"
    
    //OverView
    static let transactionIdKey = "transactionId"
    
    //Search
    static let queryStringKey = "queryString"
    //Settings
    static let isSubscribeKey = "isSubscribe"
    
    //Edit Profile
    static let profilePhotoKey = "profilePhoto"
    static let userDocumentKey = "userDocument"
    static let referrerCodeKey = "referralCode"
    
    //Verify Mobile Number
    static let codeKey = "code"
    
    //Change Password
    static let oldPasswordKey = "oldPassword"
    static let newPasswordKey = "newPassword"
    static let newPasswordConfirmKey = "newPasswordConfirm"
    
    //Unathenticated OTP
    static let areaCodeKey = "areaCode"
    static let typeKey = "type"
    static let storeTypeKey = "storeType"
    
    //Register
    static let verificationCodeKey = "verificationCode"
    static let referralCodeRegistrationKey = "referralCode"
    
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
    //MARK: - Fire Email Login Request With URL
    class func fireEmailLoginRequestWithUrl(url: String, emailAddress: String, password: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.emailKey: emailAddress, self.passwordKey: password, self.clientIdKey: Constants.Credentials.clientID(), self.clientSecretKey: Constants.Credentials.clientSecret(), self.grantTypeKey: Constants.Credentials.grantBuyer]
        
        let sessionDataTask: NSURLSessionDataTask = self.firePostRequestSessionDataTaskWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
        
        return sessionDataTask
    }
    
    //MARK: -
    //MARK: - Fire Contact Number Login Request With URL
    class func fireContactNumberLoginRequestWithUrl(url: String, contactNo: String, password: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager: APIManager = APIManager.sharedInstance
        
        //self.emailKey is used for contact number because the API is not yet configured to accept the 'contactNo' parameter
        let parameters: NSDictionary = [self.emailKey: contactNo, self.passwordKey: password, self.clientIdKey: Constants.Credentials.clientID(), self.clientSecretKey: Constants.Credentials.clientSecret(), self.grantTypeKey: Constants.Credentials.grantBuyer]
        
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
    
    //MARK: - Fire Get Contacts list With Url
    class func fireAttachImageWithUrl(url: String, image: UIImage, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithImage(url, parameters: [], image: image) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Logout User
    class func fireLogoutUserWithUrl(url: String, registrationId: String, deviceType: String, access_token: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.registrationIdKey: registrationId, self.deviceTypeKey: deviceType]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Set Notification Settings
    class func fireSetNotificationSettingsWithUrl(url: String, accessToken: String, isSubscribe: Bool, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let tempURL = "\(url)?access_token=\(accessToken)&\(isSubscribeKey)=\(isSubscribe)"
        self.firePostRequestWithUrl(tempURL, parameters: []) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Deactivate Account
    class func fireDeactivateWithUrl(url: String, accessToken: String, password: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: accessToken, self.passwordKey: password]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Update Profile
    class func fireUpdateProfileWithUrl(url: String, hasImage: Bool, accessToken: String, firstName: String, lastName: String, profilePhoto: NSData? = nil, userDocument: NSData? = nil, referrerPersonCode: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let tempUrl: String = url +  "?access_token=" + accessToken
        if hasImage {
            let parameters: NSDictionary = [firstNameKey: firstName, lastNameKey: lastName, referrerCodeKey: referrerPersonCode]
            self.firePostRequestWithImages(tempUrl, parameters: parameters, imageData: [profilePhoto, userDocument], imageKeys: [profilePhotoKey, userDocumentKey]) { (successful, responseObject, requestErrorType) -> Void in
                actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
            }
        } else {
            let parameters: NSDictionary = [firstNameKey: firstName, lastNameKey: lastName, referrerCodeKey: referrerPersonCode]
            self.firePostRequestWithUrl(tempUrl, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
                actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
            }
        }
    }
    
    //MARK: - Fire Change Password
    class func fireChangePassword(url: String, accessToken: String, oldPassword: String, newPassword: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: accessToken, self.oldPasswordKey: oldPassword, self.newPasswordKey: newPassword, self.newPasswordConfirmKey: newPassword]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Update Change Number
    class func fireChangeMobileNumber(url: String, accessToken: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get Mobile Verification Code
    class func fireGetMobileCode(url: String, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: accessToken]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get Mobile Verification Code
    class func fireVerifyVerificationCode(url: String, accessToken: String, code: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: accessToken, self.codeKey: code]
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
    
    //MARK: - Fire Get Wishlist data list With Url
    class func fireGetWishlistWithUrl(url: String, access_token: String, wishlist: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: access_token, self.wishlistKey: wishlist]
        self.fireGetRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Delete Wishlist Item
    class func fireDeleteWishlistItemWithUrl(url: String, access_token: String, productId: String, unitId: String, quantity: Int, wishlist: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: access_token, self.productIdKey: productId, self.unitIdKey: unitId, self.quantityKey: quantity, self.wishlistKey: wishlist]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Add Wishlist Item to Cart
    class func fireAddWishlistItemToCartWithUrl(url: String, access_token: String, itemIds: Int, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: access_token, self.itemIdsKey: itemIds]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Get Cart data list With Url
    class func fireGetCartWithUrl(url: String, access_token: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: access_token]
        self.fireGetRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Delete Cart Item
    class func fireDeleteCartItemWithUrl(url: String, access_token: String, productId: String, unitId: String, quantity: Int, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: access_token, self.productIdKey: productId, self.unitIdKey: unitId, self.quantityKey: quantity]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }

    //MARK: - Fire Update Cart Item
    class func fireUpdateCartItemWithUrl(url: String, access_token: String, productId: String, unitId: String, itemId: String, quantity: Int, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: access_token, self.productIdKey: productId, self.unitIdKey: unitId, self.itemIdKey: itemId, self.quantityKey: quantity]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Fire Checkout Cart Item
    class func fireCheckoutCartItemWithUrl(url: String, access_token: String, cart: [Int], actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.accessTokenKey: access_token, self.cartKey: cart]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Province
    class func fireProvince(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = NSDictionary()
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire City
    class func fireCityWithProvinceId(url: String, provinceId: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.provinceIdKey: provinceId]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Barangays
    class func fireBarangaysWithCityId(url: String, cityId: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let parameters: NSDictionary = [self.cityIdIdKey: cityId]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: -
    //MARK: - Fire Guest Checkout
    class func fireGuestCheckoutWithUrl(url: String, firstName: String, lastName: String, email: String, contactNumber: String, title: String, streetName: String, zipCode: String, location: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        
        let parameters: NSDictionary = ["user_guest[firstName]": firstName,
            self.guestLastNameKey: lastName,
            self.guestEmailKey: email,
            self.guestContactNumberKey: contactNumber,
            self.guestTitleKey: "Guest Address",
            self.guestStreetNameKey: streetName,
            self.guestZipCodeKey: zipCode,
            self.guestLocationKey: location,
            self.guestIsDefaultKey: true]
        SessionManager.loadCookies()
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    //MARK: - Search Product
    class func fireSearcProducthWithUrl(url: String, queryString:String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) -> NSURLSessionDataTask {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.queryStringKey: queryString]
        
        let sessionDataTask: NSURLSessionDataTask = self.fireGetRequestSessionDataTaskWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
        
        return sessionDataTask
    }
    
    //MARK: - Get Product/Seller List
    class func fireGetProductSellerListWithUrl(url: String,actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager.sharedInstance
        
        self.fireGetRequestWithUrl(url, parameters: []) { (successful, responseObject, requestErrorType) -> Void in
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
    
    private static func firePostRequestWithImages(url: String, parameters: AnyObject, imageData: [NSData?], imageKeys: [String], actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager = APIManager.sharedInstance
        if Reachability.isConnectedToNetwork() {
            
            self.postTask = manager.POST(url, parameters: parameters,
                constructingBodyWithBlock: { (formData: AFMultipartFormData!) -> Void in
                    for var i = 0; i < imageData.count; i++ {
                        if imageData[i] != nil {
                            formData.appendPartWithFileData(imageData[i]!, name: imageKeys[i], fileName: imageKeys[i], mimeType: "image/JPEG")
                        }
                        
                    }
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
    //MARK: - Fire Forgot Password Request With URL
    class func fireForgotPasswordrRequestWithUrl(url: String, verficationCode: String, newPassword: String, storeType: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.verificationCodeKey: verficationCode, self.newPasswordKey: newPassword, self.storeTypeKey: storeType]
        
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
    //MARK: - Fire Register Request With URL v2
    class func fireRegisterRequestWithUrl(url: String, contactNumber: String, password: String, areaCode: String, referralCode: String,  verificationCode: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.contactNumberKey: contactNumber, self.passwordKey: password, self.areaCodeKey: areaCode, self.referralCodeRegistrationKey: referralCode, self.verificationCodeKey: verificationCode]
        
        if Reachability.isConnectedToNetwork() {
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                actionHandler(successful: true, responseObject: responseObject, requestErrorType: .NoError)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    println(error)
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
    //MARK: - Fire Get Unauthenticated OTP (One Time Password) With URL
    //Parameters  "type":"register/forgot-password"
    class func fireUnauthenticatedOTPRequestWithUrl(url: String, contactNumber: String, areaCode: String, type: String, storeType: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = [self.contactNumberKey: contactNumber, self.areaCodeKey: areaCode, self.typeKey: type, self.storeTypeKey: storeType]
        
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
    //MARK: - Fire Over View With Url
    class func fireOverViewWith(url: String, accessToken: String, transactionId: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
       let parameters = [self.accessTokenKey: accessToken, self.transactionIdKey: transactionId]
        
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
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
    
    // MARK: - Followed Sellers
    // Get Followed Sellers
    class func fireFollwedSellersWithUrl(url: String, page: String, limit: String, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.pageKey: page, self.limitKey: limit, self.accessTokenKey: accessToken]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: - Product Details Calls
    // Get Product Details
    class func fireGetProductDetailsWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: []) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // Get Review Details
    class func fireGetReviewDetailsWithUrl(url: String, productId: String, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.productIdKey: productId]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // Get Seller Details
    class func fireGetSellerDetailsWithUrl(url: String, userId: Int, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.userIdKey: userId, self.accessTokenKey: accessToken]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // Update Wishlist
    class func fireUpdateWishlistWithUrl(url: String, productId: String, unitId: String, quantity: String, wishlist: String, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.productIdKey: productId, self.unitIdKey: unitId, self.quantityKey: quantity, self.wishlistKey: wishlist, self.accessTokenKey: accessToken]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // Add Item To Cart
    class func fireAddToCartWithUrl(url: String, productId: String, unitId: String, quantity: Int, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.productIdKey: productId, self.unitIdKey: unitId, self.quantityKey: quantity, self.accessTokenKey: accessToken]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // Cart To Checkout
    class func fireCartToCheckoutWithUrl(url: String, cart: [Int], accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.cartKey: cart, self.accessTokenKey: accessToken]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // Get Contact Details
    class func fireGetContacttDetailsWithUrl(url: String, page: String, limit: String, keyword: String, accessToken: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        var parameters: NSDictionary = [self.pageKey: page, self.limitKey: limit, self.keywordKey: keyword, self.accessTokenKey: accessToken]
        self.firePostRequestWithUrl(url, parameters: parameters) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: - Resolution Center Calls
    class func fireGetCasesWithUrl(url: String, parameter: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: parameter) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    class func fireGetTransactionIdsWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: []) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    class func fireGetReasonsWithUrl(url: String, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: []) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    class func fireSubmitDispute(url: String, parameter: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.firePostRequestWithUrl(url, parameters: parameter) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
    
    // MARK: -
    // MARK: - Activity Log
    class func fireGetActivityLogWithUrl(url: String, parameters: NSDictionary, actionHandler: (successful: Bool, responseObject: AnyObject, requestErrorType: RequestErrorType) -> Void) {
        self.fireGetRequestWithUrl(url, parameters: []) { (successful, responseObject, requestErrorType) -> Void in
            actionHandler(successful: successful, responseObject: responseObject, requestErrorType: requestErrorType)
        }
    }
}