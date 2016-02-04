//
//  Enums.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

enum LoginType {
    case FacebookLogin
    case GoogleLogin
    case DirectLogin
}

enum PaymentType {
    case COD
    case CreditCard
}

enum CancellationType {
    case GetReason
    case PostReason
}

enum CustomizeShoppingType {
    case Categories
    case Seller
    case Promos
    case Others
}

enum AddressRefreshType {
    case Edit
    case Delete
    case Create
    case SetDefault
    case Get
}

enum SellerRefreshType {
    case Follow
    case Unfollow
    case Get
    case Feedback
}

enum TransactionRefreshType {
    case All
    case OnGoing
    case Pending
    case ForFeedback
    case Support
}

enum TransactionDetailsType {
    case Details
    case Seller
    case Contacts
}

enum CheckoutRefreshType {
    case COD
    case Credit
    case OverView
    case Voucher
    case SetAddress
}

enum TargetType {
    case TodaysPromo
    case CategoryViewMoreItems
    case Category
    case ProductPage
    case Seller
    case SellerList
}

enum AddressPickerType {
    case Province
    case City
    case Barangay
}

enum RequestErrorType {
    case NoInternetConnection
    case RequestTimeOut
    case PageNotFound
    case AccessTokenExpired
    case ResponseError
    case UnRecognizeError
    case NoError
    case Cancel
}

enum LanguageType {
    case English
    case Chinese
}

enum ModalState {
    case SessionExpired
    case WrongCode
    case DismissModal
}