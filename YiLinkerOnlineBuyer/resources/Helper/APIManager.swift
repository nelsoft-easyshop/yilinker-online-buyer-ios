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
            return "http://online.api.easydeal.ph/api/v1"
        } else  {
            return "http://www.yilinker.com/api/v1"
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
    
    static let refreshTokenUrl = "login"
    static let loginUrl = "login"
    static let registerUrl = "user/register"
    static let getUserInfoUrl = "auth/user/getUser"
    static let homeUrl = "home/getData"
    static let cartUrl = "auth/cart/getCart"
    static let wishlistUrl = "auth/cart/getCart"
    static let updateWishlistUrl = "auth/cart/updateCartItem"
    static let addWishlistToCartUrl = "auth/wishlistToCart"
    static let updateCartUrl = "auth/cart/updateCartItem"
    static let getSellerUrl = "v1/get-seller"
    static let buyerSellerFeedbacks = "feedback/getUserFeedbacks"
    static let productDetails = "product/getProductDetail"
    static let productReviews = "product/getProductReviews"
    static let productSellerDetails = "v1/get-product"
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
    
    //Transactions
    static let transactionLogs = "auth/getTransactionList?access_token="
    static let transactionDetails = "auth/getTransaction?access_token="
    static let transactionLeaveSellerFeedback = "auth/feedback/addUserFeedback"
    static let transactionProductDetails = "auth/getOrderProductDetail?access_token="
    static let transactionCancellation = "auth/cancellation/reasons"
    static let postTransactionCancellation = "auth/transaction/cancel"
    static let getReasons = "auth/dispute/get-seller-reasons?access_token="
    static let transactionDeliveryStatus = "auth/getTransactionDeliveryOverview?access_token="
    static let getDeliveryLogs = "auth/getTransactionDeliveryLogs"
    
    //Resolution Center
    static let getResolutionCenterCases = "/api/v1/auth/dispute/get-case"
    static let getResolutionCenterCaseDetails = "/api/v1/auth/dispute/get-case-detail"
    static let postResolutionCenterAddCase = "/api/v1/auth/dispute/add-case"
    
    //Seller Category
    static let sellerCategory = "category/getCustomCategories?sellerId="
    
    static let facebookUrl = "facebook/auth"
    static let googleUrl = "google/auth"
    
    static let verificationGetCodeUrl = "auth/sms/getCode"
    
    //Guest Register
    static let guestUserRegisterUrl = "registerGuestUser"
    
    //Voucher Url
    static let voucherUrl = APIAtlas.voucher()
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