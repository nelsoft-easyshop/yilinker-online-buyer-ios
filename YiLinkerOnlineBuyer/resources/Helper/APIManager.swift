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
    static let refreshTokenUrl = "login"
    static let registerUrl = "user/register"
    static let getUserInfoUrl = "auth/user/getUser"
    static let homeUrl = "home/getData"
    static let cartUrl = "auth/cart/getCart"
    static let wishlistUrl = "auth/cart/getCart"
    static let updateWishlistUrl = "auth/cart/updateCartItem"
    static let getSellerUrl = "v1/get-seller"
    static let productReviewUrl = "v1/product-review"
    static let productPageUrl = "v1/get-product"
    static let getSellerInfo = "user/getStoreInfo"
    static let followSeller = "auth/followSeller"
    static let unfollowSeller = "auth/unfollowSeller"
    static let baseUrl = APIEnvironment.baseUrl()
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
            Static.instance?.responseSerializer = JSONResponseSerializer()
        }
        
        return Static.instance!
    }

}