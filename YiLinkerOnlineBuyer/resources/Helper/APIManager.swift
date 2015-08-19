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
            return "http://demo9190076.mockable.io/"
        } else if staging {
            return ""
        } else  {
            return ""
        }
    }
}

struct APIAtlas {
    
    static let loginUrl = "v1/login"
    static let registerUrl = "v1/register"
    static let homeUrl = "v1/home"
    static let cartUrl = "v1/cart"
    static let wishlistUrl = "v1/cart"
    static let getSellerUrl = "v1/get-seller"
    static let productReviewUrl = "v1/product-review"
    static let productPageUrl = "v1/get-product"
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
        }
        
        return Static.instance!
    }
}