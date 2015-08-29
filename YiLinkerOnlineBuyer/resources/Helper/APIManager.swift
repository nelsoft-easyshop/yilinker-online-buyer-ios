//
//  APIManager.swift
//  EasyshopPractise
//
//  Created by Alvin John Tandoc on 7/22/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

struct APIEnvironment {
    
    static var development = true
    static var staging = false
    static var production = false
    
    static func baseUrl() -> String {
        if development {
            return "http://online.api.easydeal.ph/api/v1"
        } else if staging {
            return ""
        } else  {
            return ""
        }
    }
}

struct APIAtlas {
    
    static let loginUrl = "login"
    static let registerUrl = "user/register"
    static let getUserInfoUrl = "auth/user/getUser"
    static let homeUrl = "home/getData"
    static let cartUrl = "v1/cart"
    static let wishlistUrl = "v1/cart"
    static let getSellerUrl = "v1/get-seller"
    static let productReviewUrl = "v1/product-review"
    static let productPageUrl = "v1/get-product"
    static let updateWishlistUrl = ""
    static let searchUrl = ""
    static let refreshTokenUrl = ""
    static let updateCartUrl = ""
    static let editProfileUrl = ""
    static let baseUrl = APIEnvironment.baseUrl()
    
    /* MESSAGING CONSTANTS */
    static let ACTION_SEND_MESSAGE          = "/message/sendMessage"
    static let ACTION_GET_CONVERSATION_HEAD = "/message/getConversationHead"
    static let ACTION_GET_CONTACTS          = "/message/getContacts"
    static let ACTION_GET_CONVERSATION_MESSAGES = "/message/getConversationMessages"
    static let ACTION_SET_AS_READ           = "/message/setConversationAsRead"
    static let ACTION_IMAGE_ATTACH          = "/message/imageAttach"
    static let ACTION_GCM_CREATE            = "/auth/device/addRegistrationId"
    static let ACTION_GCM_DELETE            = "/auth/device/deleteRegistrationId"
    static let ACTION_GCM_UPDATE            = "/device/auth/updateRegistrationId"
    static let uploadFileType = "jpeg"
}

class APIManager: AFHTTPSessionManager {
    
    class var sharedInstance: APIManager {
        struct Static {
            static var instance: APIManager?
            static var token: dispatch_once_t = 0
        }
        
        dispatch_once(&Static.token) {
            let url: NSURL! = NSURL(string: APIAtlas.baseUrl)
            Static.instance = APIManager(baseURL: url)
            Static.instance?.securityPolicy.allowInvalidCertificates = true
        }
        
        return Static.instance!
    }
}