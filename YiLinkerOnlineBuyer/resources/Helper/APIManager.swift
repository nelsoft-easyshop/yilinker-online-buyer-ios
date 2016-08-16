//
//  APIManager.swift
//  EasyshopPractise
//
//  Created by Alvin John Tandoc on 7/22/15.
//  Copyright (c) 2015 easyshop-esmobile. All rights reserved.
//

struct APIEnvironment {
    
    static var development = false
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
    
    static let V1 = "v1"
    static let V2 = "v2"
    static let V3 = "v3"
    static let V4 = "v4"
    
    static func generateV3URL(url: String) -> String {
        return "\(APIAtlas.V3)/\(SessionManager.selectedCountryCode())/\(SessionManager.selectedLanguageCode())/\(url)"
    }
    
    static func generateV4URL(url: String) -> String {
        return "\(APIAtlas.V4)/\(SessionManager.selectedCountryCode())/\(SessionManager.selectedLanguageCode())/\(url)"
    }
    
    static func COD() -> String {
        if SessionManager.isLoggedIn() {
            return APIAtlas.generateV4URL("auth/payment/doPaymentCod")
        } else {
            SessionManager.loadCookies()
            return APIAtlas.generateV4URL("payment/doPaymentCod")
        }
    }
    
    static func pesoPay() -> String {
        if SessionManager.isLoggedIn() {
            return APIAtlas.generateV4URL("auth/payment/doPesoPay")
        } else {
            SessionManager.loadCookies()
            return APIAtlas.generateV4URL("payment/doPesoPay")
        }
    }
    
    static func overView() -> String {
        if SessionManager.isLoggedIn() {
            return APIAtlas.generateV4URL("auth/payment/checkoutOverview")
        } else {
            SessionManager.loadCookies()
            return APIAtlas.generateV4URL("payment/checkoutOverview")
        }
    }
    
    static func cart() -> String {
        if SessionManager.isLoggedIn() {
            return APIAtlas.generateV4URL("auth/cart/getCart")
        } else {
            SessionManager.loadCookies()
            return APIAtlas.generateV4URL("cart/getCart")
        }
    }
    
    static func updateCart() -> String {
        if SessionManager.isLoggedIn() {
            return APIAtlas.generateV4URL("auth/cart/updateCartItem")
        } else {
            SessionManager.loadCookies()
            return APIAtlas.generateV4URL("cart/updateCartItem")
        }
    }
    
    static func updateCheckout() -> String {
        if SessionManager.isLoggedIn() {
            return APIAtlas.generateV4URL("auth/cart/cartToCheckout")
        } else {
            SessionManager.loadCookies()
            return APIAtlas.generateV4URL("cart/cartToCheckout")
        }
    }
    
    
    static func voucher() -> String {
        if SessionManager.isLoggedIn() {
            return APIAtlas.generateV4URL("auth/cart/applyVoucher")
        } else {
            SessionManager.loadCookies()
            return APIAtlas.generateV4URL("cart/applyVoucher")
        }
    }
    
    static func mobileFeedBack() -> String {
        if SessionManager.isLoggedIn() {
            return APIAtlas.generateV4URL("auth/mobile-feedback/add")
        } else {
            SessionManager.loadCookies()
            return APIAtlas.generateV4URL("mobile-feedback/add")
        }
    }
    
//    static func homeUrl(version: String, languageCode: String) -> String {
//        return APIAtlas.generateV3URL("home/getData")
//    }
//    
    static let appItunesURL = "https://itunes.apple.com/ph/app/yilinker-buyer/id1048641709?mt=8"
    static let appLookupUrl = "http://itunes.apple.com/lookup?bundleId=com.easyshop.YiLinkerOnlineBuyer"
    
    static let refreshTokenUrl = APIAtlas.generateV4URL("login")
    static let loginUrl = APIAtlas.generateV4URL("login")
    static let registerUrl = APIAtlas.generateV4URL("user/register")
    static let getUserInfoUrl = APIAtlas.generateV4URL("auth/user/getUser")
    static let homeUrl = APIAtlas.generateV4URL("home/getData")
    static let cartUrl = APIAtlas.generateV4URL("auth/cart/getCart")
    static let wishlistUrl = APIAtlas.generateV4URL("auth/cart/getCart")
    static let updateWishlistUrl = APIAtlas.generateV4URL("auth/cart/updateCartItem")
    static let addWishlistToCartUrl = APIAtlas.generateV4URL("auth/wishlistToCart")
    static let updateCartUrl = APIAtlas.generateV4URL("auth/cart/updateCartItem")
    static let getSellerUrl = APIAtlas.generateV4URL("get-seller")
    static let buyerSellerFeedbacks = APIAtlas.generateV4URL("feedback/getUserFeedbacks")
    static let productDetails = APIAtlas.generateV4URL("product/getProductDetail")
    static let productReviews = APIAtlas.generateV4URL("product/getProductReviews")
    static let productSellerDetails = APIAtlas.generateV4URL("get-product")
    static let getSellerInfoLoggedIn = APIAtlas.generateV4URL("auth/user/getStoreInfo")
    static let getSellerInfo = APIAtlas.generateV4URL("user/getStoreInfo")
    static let followSeller = APIAtlas.generateV4URL("auth/followSeller")
    static let unfollowSeller = APIAtlas.generateV4URL("auth/unfollowSeller")
    static let sellerReview = APIAtlas.generateV4URL("seller/getReviews")
    static let searchUrl = APIAtlas.generateV4URL("product/getSearchKeywords")
    static let profileUrl = APIAtlas.generateV4URL("auth/user/getUser")
    static let editProfileUrl = APIAtlas.generateV4URL("auth/user/editProfile")
    static let addressesUrl = APIAtlas.generateV4URL("auth/address/getUserAddresses")
    static let deleteAddressUrl = APIAtlas.generateV4URL("auth/address/deleteUserAddress")
    static let setDefaultAddressUrl = APIAtlas.generateV4URL("auth/address/setDefaultAddress")
    static let provinceUrl = APIAtlas.generateV4URL("location/getAllProvinces")
    static let citiesUrl = APIAtlas.generateV4URL("location/getChildCities")
    static let barangay = APIAtlas.generateV4URL("location/getBarangaysByCity")
    static let addAddressUrl = APIAtlas.generateV4URL("auth/address/addNewAddress")
    static let updateCheckoutUrl = APIAtlas.generateV4URL("auth/cart/cartToCheckout")
    static let updateGuestCheckout = APIAtlas.generateV4URL("cart/cartToCheckout")
    static let editAddress = APIAtlas.generateV4URL("auth/address/editUserAddress")
    static let setCheckoutAddressUrl = APIAtlas.generateV4URL("auth/user/setAddress")

    static let cashOnDeliveryUrl = APIAtlas.COD()
    static let pesoPayUrl = APIAtlas.pesoPay()
    static let overViewUrl = APIAtlas.overView()
    static let activityLogs = APIAtlas.generateV4URL("auth/user/activityLog?access_token=")
    static let getCategories = APIAtlas.generateV4URL("product/getCategories?parentId=")
    static let productList = APIAtlas.generateV4URL("product/getProductList")
    static let guestUserUrl = APIAtlas.generateV4URL("guestUser")
    static let updateMobileNumber = APIAtlas.generateV4URL("auth/user/changeContactNumber")
    static let smsVerification = APIAtlas.generateV4URL("auth/sms/verify")
    static let changePassword = APIAtlas.generateV4URL("auth/user/changePassword")
    static let getFollowedSellers = APIAtlas.generateV4URL("auth/getFollowedSellers")
    static let postEmailNotif = APIAtlas.generateV4URL("auth/email/subscription")
    static let postSMSNotif = APIAtlas.generateV4URL("auth/sms/subscription")
    static let deactivate = APIAtlas.generateV4URL("auth/account/disable")
    static let todaysPromo = APIAtlas.generateV4URL("product/getPromoProducts")
    static let cartImage = APIAtlas.generateV4URL("assets/images/uploads/products/")
    static let searchBuyer = APIAtlas.generateV4URL("product/getProductList?query=")
    static let searchSeller = APIAtlas.generateV4URL("store/search?queryString=")
    static let baseUrl = APIEnvironment.baseUrl()
    
    //=== Used on Dennis Code ===
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
    //=== Used on Dennis Code ===
    
    /* MESSAGING CONSTANTS V2 */
    static let ACTION_SEND_MESSAGE_V2          = APIAtlas.generateV4URL("message/sendMessage")
    static let ACTION_GET_CONVERSATION_HEAD_V2 = APIAtlas.generateV4URL("message/getConversationHead")
    static let ACTION_GET_CONTACTS_V2          = APIAtlas.generateV4URL("message/getContacts")
    static let ACTION_GET_CONVERSATION_MESSAGES_V2 = APIAtlas.generateV4URL("message/getConversationMessages")
    static let ACTION_SET_AS_READ_V2           = APIAtlas.generateV4URL("message/setConversationAsRead")
    static let ACTION_IMAGE_ATTACH_V2          = APIAtlas.generateV4URL("message/imageAttach")
    static let ACTION_GCM_CREATE_V2            = APIAtlas.generateV4URL("auth/device/addRegistrationId")
    static let ACTION_GCM_DELETE_V2            = APIAtlas.generateV4URL("auth/device/deleteRegistrationId")
    static let ACTION_GCM_UPDATE_V2           = APIAtlas.generateV4URL("device/auth/updateRegistrationId")
    static let uploadFileType_V2 = "jpeg"
    
    
    //Transactions
    static let transactionLogs = APIAtlas.generateV4URL("auth/getTransactionList?access_token=")
    static let transactionDetails = APIAtlas.generateV4URL("auth/getTransaction?access_token=")
    static let transactionLeaveSellerFeedback = APIAtlas.generateV4URL("auth/feedback/addUserFeedback")
    static let transactionProductDetails = APIAtlas.generateV4URL("auth/getOrderProductDetail?access_token=")
    static let transactionCancellation = APIAtlas.generateV4URL("auth/cancellation/reasons")
    static let postTransactionCancellation = APIAtlas.generateV4URL("auth/transaction/cancel")
    static let getReasons = APIAtlas.generateV4URL("auth/dispute/get-buyer-reasons?access_token=")
    static let transactionDeliveryStatus = APIAtlas.generateV4URL("auth/getTransactionDeliveryOverview?access_token=")
    static let getDeliveryLogs = APIAtlas.generateV4URL("auth/getTransactionDeliveryLogs")
    static let transactionLeaveProductFeedback = APIAtlas.generateV4URL("auth/product/addProductReview")
    
    //Resolution Center
    static let getResolutionCenterCases = APIAtlas.generateV4URL("auth/dispute/get-case")
    static let getResolutionCenterCaseDetails = APIAtlas.generateV4URL("auth/dispute/get-case-detail")
    static let postResolutionCenterAddCase = APIAtlas.generateV4URL("auth/dispute/add-case")
    
    //Seller Category
    static let sellerCategory = APIAtlas.generateV4URL("category/getCustomCategories?sellerId=")
    
    static let facebookUrl = APIAtlas.generateV4URL("facebook/auth")
    static let googleUrl = APIAtlas.generateV4URL("google/auth")
    
    static let verificationGetCodeUrl = APIAtlas.generateV4URL("auth/sms/getCode")
    
    //Guest Register
    static let guestUserRegisterUrl = APIAtlas.generateV4URL("registerGuestUser")
    
    //Voucher Url
    static let voucherUrl = APIAtlas.voucher()
    
    static let mergeFacebook = APIAtlas.generateV4URL("socialmedia/merge")
    
    //Webview
    static let flashSale = "flash-sale"
    static let dailyLogin = "daily-login"
    static let category = "mobile-category"
    static let storeView = "mobile-stores"
    static let mobileProductList = "mobile-product-list"
    
    //MARK: - V2 APIs
    //Login
    static let loginUrlV2 = APIAtlas.generateV4URL("login")
    
    //OTP
    static let unauthenticateOTP = APIAtlas.generateV4URL("sms/send")
    
    //Register
    static let registerV2 = APIAtlas.generateV4URL("user/register")
    
    //Sprint 1
    static let saveBasicInfoUrl = APIAtlas.generateV4URL("auth/update-basic-info")
    static let authenticatedOTP = APIAtlas.generateV4URL("auth/sms/send")
    static let verifyAuthenticatedOTPCodeUrl = APIAtlas.generateV4URL("auth/token/validate")
    static let verifyUnAuthenticatedOTPCodeUrl = APIAtlas.generateV4URL("token/validate")
    //Fogot Password
    static let forgotPasswordV2 = APIAtlas.generateV4URL("user/resetPassword")
    
    //My Points
    static let getPointsTotal = APIAtlas.generateV4URL("auth/user/getPoints")
    static let getPointsHistory = APIAtlas.generateV4URL("auth/user/getPointHistory")
    
    //Push Notif
    static let registerDeviceUrl = APIAtlas.generateV4URL("device/add-device-token")
    
    //Globalization
    static let getLanguages = APIAtlas.generateV4URL("get-languages")
    
    //MARK: - Get Countries
    static let getCountriesUrl = APIAtlas.generateV4URL("get-countries")

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