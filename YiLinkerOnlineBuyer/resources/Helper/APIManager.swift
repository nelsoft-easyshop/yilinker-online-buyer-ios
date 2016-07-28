//
//  APIManager.swift
//  EasyshopPractise
//
//  Created by Alvin John Tandoc on 7/22/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

struct APIEnvironment {
    
    static var development = true
    static var sprint = false
    static var staging = false
    static var production = true
    
    static func baseUrl() -> String {
        if development {
            return "http://dev.online.api.easydeal.ph/api"
        } else if sprint {
            return "http://sprint.online.api.easydeal.ph/api"
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
            return "auth/payment/doPaymentCod"
        } else {
            SessionManager.loadCookies()
            return "payment/doPaymentCod"
        }
    }
    
    static func pesoPay() -> String {
        if SessionManager.isLoggedIn() {
            return "auth/payment/doPesoPay"
        } else {
            SessionManager.loadCookies()
            return "payment/doPesoPay"
        }
    }
    
    static func overView() -> String {
        if SessionManager.isLoggedIn() {
            return "auth/payment/checkoutOverview"
        } else {
            SessionManager.loadCookies()
            return "payment/checkoutOverview"
        }
    }
    
    static func cart() -> String {
        if SessionManager.isLoggedIn() {
            return "auth/cart/getCart"
        } else {
            SessionManager.loadCookies()
            return "cart/getCart"
        }
    }
    
    static func updateCart() -> String {
        if SessionManager.isLoggedIn() {
            return "auth/cart/updateCartItem"
        } else {
            SessionManager.loadCookies()
            return "cart/updateCartItem"
        }
    }
    
    static func updateCheckout() -> String {
        if SessionManager.isLoggedIn() {
            return "auth/cart/cartToCheckout"
        } else {
            SessionManager.loadCookies()
            return "cart/cartToCheckout"
        }
    }
    
    
    static func voucher() -> String {
        if SessionManager.isLoggedIn() {
            return "auth/cart/applyVoucher"
        } else {
            SessionManager.loadCookies()
            return "cart/applyVoucher"
        }
    }
    
    static func mobileFeedBack() -> String {
        if SessionManager.isLoggedIn() {
            return "auth/mobile-feedback/add"
        } else {
            SessionManager.loadCookies()
            return "mobile-feedback/add"
        }
    }
    
    static func homeUrl(version: String, languageCode: String) -> String {
        return "home/getData"
    }
    
    static let V1 = "v1"
    static let V2 = "v2"
    static let V3 = "v3"
    static let V4 = "v4"
    
    static let appItunesURL = "https://itunes.apple.com/ph/app/yilinker-buyer/id1048641709?mt=8"
    static let appLookupUrl = "http://itunes.apple.com/lookup?bundleId=com.easyshop.YiLinkerOnlineBuyer"
    static let refreshTokenUrl = "login"
    static let loginUrl = "login"
    static let registerUrl = "user/register"
    static let getUserInfoUrl = "auth/user/getUser"
    static let homeUrl = "v4/home/getData"
    static let cartUrl = "auth/cart/getCart"
    static let wishlistUrl = "auth/cart/getCart"
    static let updateWishlistUrl = "auth/cart/updateCartItem"
    static let addWishlistToCartUrl = "auth/wishlistToCart"
    static let updateCartUrl = "auth/cart/updateCartItem"
    static let getSellerUrl = "get-seller"
    static let buyerSellerFeedbacks = "feedback/getUserFeedbacks"
    static let productDetails = "product/getProductDetail"
    static let productReviews = "product/getProductReviews"
    static let productSellerDetails = "get-product"
    static let getSellerInfoLoggedIn = "auth/user/getStoreInfo"
    static let getSellerInfo = "user/getStoreInfo"
    static let followSeller = "auth/followSeller"
    static let unfollowSeller = "auth/unfollowSeller"
    static let sellerReview = "seller/getReviews"
    static let searchUrl = "product/getSearchKeywords"
    static let profileUrl = "auth/user/getUser"
    static let editProfileUrl = "auth/user/editProfile"
    static let addressesUrl = "auth/address/getUserAddresses"
    static let deleteAddressUrl = "auth/address/deleteUserAddress"
    static let setDefaultAddressUrl = "auth/address/setDefaultAddress"
    static let provinceUrl = "location/getAllProvinces"
    static let citiesUrl = "location/getChildCities"
    static let barangay = "location/getBarangaysByCity"
    static let addAddressUrl = "auth/address/addNewAddress"
    static let updateCheckoutUrl = "auth/cart/cartToCheckout"
    static let updateGuestCheckout = "cart/cartToCheckout"
    static let editAddress = "auth/address/editUserAddress"
    static let setCheckoutAddressUrl = "auth/user/setAddress"

    static let cashOnDeliveryUrl = APIAtlas.COD()
    static let pesoPayUrl = APIAtlas.pesoPay()
    static let overViewUrl = APIAtlas.overView()
    static let activityLogs = "auth/user/activityLog?access_token="
    static let getCategories = "product/getCategories?parentId="
    static let productList = "product/getProductList"
    static let guestUserUrl = "guestUser"
    static let updateMobileNumber = "auth/user/changeContactNumber"
    static let smsVerification = "auth/sms/verify"
    static let changePassword = "auth/user/changePassword"
    static let getFollowedSellers = "auth/getFollowedSellers"
    static let postEmailNotif = "auth/email/subscription"
    static let postSMSNotif = "auth/sms/subscription"
    static let deactivate = "auth/account/disable"
    static let todaysPromo = "product/getPromoProducts"
    static let cartImage = "assets/images/uploads/products/"
    static let searchBuyer = "product/getProductList?query="
    static let searchSeller = "store/search?queryString="
    static let baseUrl = APIEnvironment.baseUrl()
    
    /* MESSAGING CONSTANTS */
    static let ACTION_SEND_MESSAGE          = "/v1/message/sendMessage"
    static let ACTION_GET_CONVERSATION_HEAD = "/v1/message/getConversationHead"
    static let ACTION_GET_CONTACTS          = "/v1/message/getContacts"
    static let ACTION_GET_CONVERSATION_MESSAGES = "/v1/message/getConversationMessages"
    static let ACTION_SET_AS_READ           = "/v1/message/setConversationAsRead"
    static let ACTION_IMAGE_ATTACH          = "/v1/message/imageAttach"
    static let ACTION_GCM_CREATE            = "/v1/auth/device/addRegistrationId"
    static let ACTION_GCM_DELETE            = "/v1/auth/device/deleteRegistrationId"
    static let ACTION_GCM_UPDATE            = "/v1/device/auth/updateRegistrationId"
    static let uploadFileType = "jpeg"
    
    /* MESSAGING CONSTANTS V2 */
    static let ACTION_SEND_MESSAGE_V2          = "message/sendMessage"
    static let ACTION_GET_CONVERSATION_HEAD_V2 = "message/getConversationHead"
    static let ACTION_GET_CONTACTS_V2          = "message/getContacts"
    static let ACTION_GET_CONVERSATION_MESSAGES_V2 = "message/getConversationMessages"
    static let ACTION_SET_AS_READ_V2           = "message/setConversationAsRead"
    static let ACTION_IMAGE_ATTACH_V2          = "message/imageAttach"
    static let ACTION_GCM_CREATE_V2            = "auth/device/addRegistrationId"
    static let ACTION_GCM_DELETE_V2            = "auth/device/deleteRegistrationId"
    static let ACTION_GCM_UPDATE_V2           = "device/auth/updateRegistrationId"
    static let uploadFileType_V2 = "jpeg"
    
    
    //Transactions
    static let transactionLogs = "auth/getTransactionList?access_token="
    static let transactionDetails = "auth/getTransaction?access_token="
    static let transactionLeaveSellerFeedback = "auth/feedback/addUserFeedback"
    static let transactionProductDetails = "auth/getOrderProductDetail?access_token="
    static let transactionCancellation = "auth/cancellation/reasons"
    static let postTransactionCancellation = "auth/transaction/cancel"
    static let getReasons = "auth/dispute/get-buyer-reasons?access_token="
    static let transactionDeliveryStatus = "auth/getTransactionDeliveryOverview?access_token="
    static let getDeliveryLogs = "auth/getTransactionDeliveryLogs"
    static let transactionLeaveProductFeedback = "auth/product/addProductReview"
    
    //Resolution Center
    static let getResolutionCenterCases = "auth/dispute/get-case"
    static let getResolutionCenterCaseDetails = "auth/dispute/get-case-detail"
    static let postResolutionCenterAddCase = "auth/dispute/add-case"
    
    //Seller Category
    static let sellerCategory = "category/getCustomCategories?sellerId="
    
    static let facebookUrl = "facebook/auth"
    static let googleUrl = "google/auth"
    
    static let verificationGetCodeUrl = "auth/sms/getCode"
    
    //Guest Register
    static let guestUserRegisterUrl = "registerGuestUser"
    
    //Voucher Url
    static let voucherUrl = APIAtlas.voucher()
    
    static let mergeFacebook = "socialmedia/merge"
    
    //Webview
    static let flashSale = "flash-sale"
    static let dailyLogin = "daily-login"
    static let category = "mobile-category"
    static let storeView = "mobile-stores"
    static let mobileProductList = "mobile-product-list"
    
    //MARK: - V2 APIs
    //Login
    static let loginUrlV2 = "login"
    
    //OTP
    static let unauthenticateOTP = "sms/send"
    
    //Register
    static let registerV2 = "user/register"
    
    //Sprint 1
    static let saveBasicInfoUrl = "auth/update-basic-info"
    static let authenticatedOTP = "auth/sms/send"
    static let verifyAuthenticatedOTPCodeUrl = "auth/token/validate"
    static let verifyUnAuthenticatedOTPCodeUrl = "token/validate"
    //Fogot Password
    static let forgotPasswordV2 = "user/resetPassword"
    
    //My Points
    static let getPointsTotal = "auth/user/getPoints"
    static let getPointsHistory = "auth/user/getPointHistory"
    
    //Push Notif
    static let registerDeviceUrl = "device/add-device-token"
    
    //Globalization
    static let getLanguages = "get-languages"
    
    //MARK: - Get Countries
    static let getCountriesUrl = "get-countries"
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