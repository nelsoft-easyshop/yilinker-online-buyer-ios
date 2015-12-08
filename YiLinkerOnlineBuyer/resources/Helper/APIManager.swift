//
//  APIManager.swift
//  EasyshopPractise
//
//  Created by Alvin John Tandoc on 7/22/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

struct APIEnvironment {
    
    static var development = false
    static var staging = true
    static var production = false
    
    static func baseUrl() -> String {
        if development {
            return "http://online.api.easydeal.ph/api"
        } else if staging {
            return "http://online.api.easydeal.ph/api"
        } else  {
            return "https://www.yilinker.com/api"
        }
    }
}

struct APIAtlas {
    
    static func COD() -> String {
        if SessionManager.isLoggedIn() {
            return "v1/auth/payment/doPaymentCod"
        } else {
            SessionManager.loadCookies()
            return "v1/payment/doPaymentCod"
        }
    }
    
    static func pesoPay() -> String {
        if SessionManager.isLoggedIn() {
            return "v1/auth/payment/doPesoPay"
        } else {
            SessionManager.loadCookies()
            return "v1/payment/doPesoPay"
        }
    }
    
    static func overView() -> String {
        if SessionManager.isLoggedIn() {
            return "v1/auth/payment/checkoutOverview"
        } else {
            SessionManager.loadCookies()
            return "v1/payment/checkoutOverview"
        }
    }
    
    static func cart() -> String {
        if SessionManager.isLoggedIn() {
            return "v1/auth/cart/getCart"
        } else {
            SessionManager.loadCookies()
            return "v1/cart/getCart"
        }
    }
    
    static func updateCart() -> String {
        if SessionManager.isLoggedIn() {
            return "v1/auth/cart/updateCartItem"
        } else {
            SessionManager.loadCookies()
            return "v1/cart/updateCartItem"
        }
    }
    
    static func updateCheckout() -> String {
        if SessionManager.isLoggedIn() {
            return "v1/auth/cart/cartToCheckout"
        } else {
            SessionManager.loadCookies()
            return "v1/cart/cartToCheckout"
        }
    }
    
    
    static func voucher() -> String {
        if SessionManager.isLoggedIn() {
            return "v1/auth/cart/applyVoucher"
        } else {
            SessionManager.loadCookies()
            return "v1/cart/applyVoucher"
        }
    }
    
    static let refreshTokenUrl = "v1/login"
    static let loginUrl = "v1/login"
    static let registerUrl = "v1/user/register"
    static let getUserInfoUrl = "v1/auth/user/getUser"
    static let homeUrl = "v2/home/getData"
    static let cartUrl = "v1/auth/cart/getCart"
    static let wishlistUrl = "v1/auth/cart/getCart"
    static let updateWishlistUrl = "v1/auth/cart/updateCartItem"
    static let addWishlistToCartUrl = "auth/wishlistToCart"
    static let updateCartUrl = "v1/auth/cart/updateCartItem"
    static let getSellerUrl = "v1/get-seller"
    static let buyerSellerFeedbacks = "v1/feedback/getUserFeedbacks"
    static let productDetails = "v1/product/getProductDetail"
    static let productReviews = "v1/product/getProductReviews"
    static let productSellerDetails = "v1/get-product"
    static let getSellerInfoLoggedIn = "v1/auth/user/getStoreInfo"
    static let getSellerInfo = "v1/user/getStoreInfo"
    static let followSeller = "v1/auth/followSeller"
    static let unfollowSeller = "v1/auth/unfollowSeller"
    static let sellerReview = "v1/seller/getReviews"
    static let searchUrl = "v1/product/getSearchKeywords"
    static let profileUrl = "v1/auth/user/getUser"
    static let editProfileUrl = "v1/auth/user/editProfile"
    static let addressesUrl = "v1/auth/address/getUserAddresses"
    static let deleteAddressUrl = "v1/auth/address/deleteUserAddress"
    static let setDefaultAddressUrl = "v1/auth/address/setDefaultAddress"
    static let provinceUrl = "v1/location/getAllProvinces"
    static let citiesUrl = "v1/location/getChildCities"
    static let barangay = "v1/location/getBarangaysByCity"
    static let addAddressUrl = "v1/auth/address/addNewAddress"
    static let updateCheckoutUrl = "v1/auth/cart/cartToCheckout"
    static let updateGuestCheckout = "v1/cart/cartToCheckout"
    static let editAddress = "v1/auth/address/editUserAddress"
    static let setCheckoutAddressUrl = "v1/auth/user/setAddress"
    static let cashOnDeliveryUrl = APIAtlas.COD()
    static let pesoPayUrl = APIAtlas.pesoPay()
    static let overViewUrl = APIAtlas.overView()
    static let activityLogs = "v1/auth/user/activityLog?access_token="
    static let getCategories = "v1/product/getCategories?parentId="
    static let productList = "v1/product/getProductList"
    static let guestUserUrl = "v1/guestUser"
    static let updateMobileNumber = "v1/auth/user/changeContactNumber"
    static let smsVerification = "v1/auth/sms/verify"
    static let changePassword = "v1/auth/user/changePassword"
    static let getFollowedSellers = "v1/auth/getFollowedSellers"
    static let postEmailNotif = "v1/auth/email/subscription"
    static let postSMSNotif = "v1/auth/sms/subscription"
    static let deactivate = "v1/auth/account/disable"
    static let todaysPromo = "v1/product/getPromoProducts"
    static let cartImage = "v1/assets/images/uploads/products/"
    static let searchBuyer = "v1/product/getProductList?query="
    static let searchSeller = "v1/store/search?queryString="
    static let baseUrl = APIEnvironment.baseUrl()
    
    /* MESSAGING CONSTANTS */
    static let ACTION_SEND_MESSAGE          = "v1/message/sendMessage"
    static let ACTION_GET_CONVERSATION_HEAD = "v1/message/getConversationHead"
    static let ACTION_GET_CONTACTS          = "v1/message/getContacts"
    static let ACTION_GET_CONVERSATION_MESSAGES = "v1/message/getConversationMessages"
    static let ACTION_SET_AS_READ           = "v1/message/setConversationAsRead"
    static let ACTION_IMAGE_ATTACH          = "v1/message/imageAttach"
    static let ACTION_GCM_CREATE            = "v1/auth/device/addRegistrationId"
    static let ACTION_GCM_DELETE            = "v1/auth/device/deleteRegistrationId"
    static let ACTION_GCM_UPDATE            = "v1/device/auth/updateRegistrationId"
    static let uploadFileType = "jpeg"
    
    //Transactions
    static let transactionLogs = "v1/auth/getTransactionList?access_token="
    static let transactionDetails = "v1/auth/getTransaction?access_token="
    static let transactionLeaveSellerFeedback = "v1/auth/feedback/addUserFeedback"
    static let transactionProductDetails = "v1/auth/getOrderProductDetail?access_token="
    static let transactionCancellation = "v1/auth/cancellation/reasons"
    static let postTransactionCancellation = "v1/auth/transaction/cancel"
    static let getReasons = "v1/auth/dispute/get-buyer-reasons?access_token="
    static let transactionDeliveryStatus = "v1/auth/getTransactionDeliveryOverview?access_token="
    static let getDeliveryLogs = "v1/auth/getTransactionDeliveryLogs"
    
    //Resolution Center
    static let getResolutionCenterCases = "/api/v1/auth/dispute/get-case"
    static let getResolutionCenterCaseDetails = "/api/v1/auth/dispute/get-case-detail"
    static let postResolutionCenterAddCase = "/api/v1/auth/dispute/add-case"
    
    //Seller Category
    static let sellerCategory = "v1/category/getCustomCategories?sellerId="
    
    static let facebookUrl = "v1/facebook/auth"
    static let googleUrl = "v1/google/auth"
    
    static let verificationGetCodeUrl = "v1/auth/sms/getCode"
    
    //Guest Register
    static let guestUserRegisterUrl = "v1/registerGuestUser"
    
    //Voucher Url
    static let voucherUrl = APIAtlas.voucher()
    
    static let mergeFacebook = "v1/facebook/auth"
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
            
            Static.instance?.securityPolicy = AFSecurityPolicy(pinningMode: AFSSLPinningMode.Certificate)
            let certificatePath = NSBundle.mainBundle().pathForResource("yilinker_pinned_certificate", ofType: "cer")!
            let certificateData = NSData(contentsOfFile: certificatePath)!
            Static.instance?.securityPolicy.pinnedCertificates = [certificateData];
            Static.instance?.securityPolicy.validatesDomainName = true
            Static.instance?.securityPolicy.allowInvalidCertificates = true

            Static.instance?.responseSerializer = JSONResponseSerializer()
        }
        
        return Static.instance!
    }

}