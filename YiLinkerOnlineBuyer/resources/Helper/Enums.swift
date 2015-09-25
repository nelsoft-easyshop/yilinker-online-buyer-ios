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

enum CheckoutRefreshType {
    case COD
    case Credit
    case OverView
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