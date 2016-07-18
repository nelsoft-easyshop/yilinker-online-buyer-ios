//
//  Constansts.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/7/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

struct Constants {
    
    struct WebServiceStatusCode {
        static let pageNotFound: Int = 404
        static let expiredAccessToken: Int = 401
        static let requestTimeOut: Int = 408
    }
    
    struct Localized {
        static let ok: String = StringHelper.localizedStringWithKey("OK_BUTTON_LOCALIZE_KEY")
        static let someThingWentWrong: String = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
        static let error: String = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        static let failed: String = StringHelper.localizedStringWithKey("FAILED_LOCALIZE_KEY")
        static let done: String = StringHelper.localizedStringWithKey("TOOLBAR_DONE_LOCALIZE_KEY")
        static let success: String = StringHelper.localizedStringWithKey("SUCCESS_LOGIN_LOCALIZE_KEY")
        static let serverError: String = StringHelper.localizedStringWithKey("SERVER_ERROR_LOCALIZE_KEY")
        static let next: String = StringHelper.localizedStringWithKey("NEXT_LOCALIZE_KEY")
        static let previous: String = StringHelper.localizedStringWithKey("PREVIOUS_LOCALIZE_KEY")
        static let information: String = StringHelper.localizedStringWithKey("INFORMATION_LOCALIZE_KEY")
        static let noInternet: String = StringHelper.localizedStringWithKey("NO_INTERNET_LOCALIZE_KEY")
        static let noInternetErrorMessage: String = StringHelper.localizedStringWithKey("NO_INTERNET_ERROR_MESSAGE_LOCALIZE_KEY")
        static let targetNotAvailable: String = StringHelper.localizedStringWithKey("TARGET_NOT_AVAILABLE")
        static let pageNotFound: String = StringHelper.localizedStringWithKey("PAGE_NOT_FOUND_LOCALIZE_KEY")
        static let hi: String = StringHelper.localizedStringWithKey("HI_LOCALIZE_KEY")
    }
    
    struct HomePage {
        static let layoutOneKey = "layout1"
        static let layoutTwoKey = "layout2"
        static let layoutThreeKey = "layout3"
        static let layoutFourKey = "layout4"
        static let layoutFiveKey = "layout5"
        static let layoutSixKey = "layout6"
        static let layoutSevenKey = "layout7"
        static let layoutEightKey = "layout8"
        static let layoutNineKey = "layout9"
        static let layoutTenKey = "layout10"
        static let layoutFiveKeyWithFooter = "layout5-footer"
        static let layoutFiveKey2 = "layout5-2"
        static let layoutTwelveKey = "layout12"
        static let layoutThirteenKey = "layout13"
        static let layoutFourteenKey = "layout14"
    }
    
    struct Colors {
        static let appTheme: UIColor = HexaColor.colorWithHexa(0x5A1F75)
        static let productDetails: UIColor = HexaColor.colorWithHexa(0xd52371)
        static let productPrice: UIColor = HexaColor.colorWithHexa(0x75348a)
        static let productReviewGreen: UIColor = HexaColor.colorWithHexa(0xb3b233)
        static let grayLine: UIColor = HexaColor.colorWithHexa(0x606060)
        static let backgroundGray: UIColor = HexaColor.colorWithHexa(0xE7E7E7)
        static let selectedGreenColor: UIColor = HexaColor.colorWithHexa(0x44A491)
        static let selectedCellColor: UIColor = HexaColor.colorWithHexa(0xE1E1E1)
        static let successfulVerification: UIColor = HexaColor.colorWithHexa(0x75348A)
        static let errorVerification: UIColor = HexaColor.colorWithHexa(0x666666)
        static let grayText: UIColor = HexaColor.colorWithHexa(0x666666)
        static let offlineColor = HexaColor.colorWithHexa(0xda202d)
        static let onlineColor = HexaColor.colorWithHexa(0x54b6a7)
        static let statusBarBackgroundColor = HexaColor.colorWithHexa(0x602077)
        static let alphaAppThemeColor = HexaColor.colorWithHexa(0xD7D2E3)
    }
    
    struct Facebook {
        static let userNameKey = "name"
        static let userIDKey = "id"
        static let userEmail = "email"
        
        static let userPermissionEmailKey = "email"
        static let userPermissionPublicProfileKey = "public_profile"
        static let userPermissionFriendsKey = "user_friends"
    }
    

    struct Credentials {
        //development
        static func clientID() -> String {
            if APIEnvironment.development {
                return "1_9t2337riou0wsws84ckw8gkck8os8skw8cokoooc04gc0kssc"
            } else if APIEnvironment.sprint {
                return "1_4qzm05tv6uwwko4c4c8gs00sco0c40os08owg8sg0wswoo0w8o"
            } else if APIEnvironment.staging {
                return "1_167rxzqvid8g8swggwokcoswococscocc8ck44wo0g88owgkcc"
            } else {
                return "1_9t2337riou0wsws84ckw8gkck8os8skw8cokoooc04gc0kssc"
            }
        }
        
        static func clientSecret() -> String {
            if APIEnvironment.development {
                return "1vmep15il4cgw8gc0g8gokokk0wwkko0cg0go0s4c484kwswo4"
            } else if APIEnvironment.sprint {
                return "1vgsjw5b0u74kssco8cooock0oc8c0sscoksk0sgsc08s8k4gw"
            } else if APIEnvironment.staging {
                return "317eq8nohry84ooc0o8woo8000c0k844c4cggws84g80scwwog"
            } else {
                return "1vmep15il4cgw8gc0g8gokokk0wwkko0cg0go0s4c484kwswo4"
            }
        }
        
        //production
//        static let clientID = "1_9t2337riou0wsws84ckw8gkck8os8skw8cokoooc04gc0kssc"
//        static let clientSecret = "1vmep15il4cgw8gc0g8gokokk0wwkko0cg0go0s4c484kwswo4"
        static let grantRefreshToken = "refresh_token"
        static let grantBuyer = "http://yilinker-online.com/grant/buyer"
        static let gmailCredential = "231249450400-diffl4ab61n8qaum66bd4v8uuc0bqtq6.apps.googleusercontent.com"
    }

    struct Seller {
        static let aboutSellerTableViewCellNibNameAndIdentifier = "AboutSellerTableViewCell"
        static let productsTableViewCellNibNameAndIdentifier = "ProductsTableViewCell"
        static let generalRatingTableViewCellNibNameAndIndentifier = "GeneralRatingTableViewCell"
        static let reviewIdentifier = "reviewIdentifier"
        static let reviewNibName = "ReviewTableViewCell"
        static let seeMoreTableViewCellNibNameAndIdentifier = "SeeMoreTableViewCell"
    }
    
    struct Checkout {
        static let orderSummaryTableViewCellNibNameAndIdentifier = "OrderSummaryTableViewCell"
        static let shipToTableViewCellNibNameAndIdentifier = "ShipToTableViewCell"
        static let changeAddressCollectionViewCellNibNameAndIdentifier = "ChangeAddressCollectionViewCell"
        static let changeAddressFooterCollectionViewCellNibNameAndIdentifier = "ChangeAddressFooterCollectionViewCell"
        
        static let newAddressTableViewCellNibNameAndIdentifier = "NewAddressTableViewCell"
        static let paymentTableViewCellNibNameAndIdentifier = "PaymentTableViewCell"
        
        struct Payment {
            static let touchabelTagCOD: Int = 10
            static let touchabelTagCreditCard: Int = 11
        }
        
        struct OverView {
            static let successTableHeaderViewNibNameAndIdentifier = "SuccessTableHeaderView"
            static let plainTableViewCellNibNameAndIdentifier = "PlainTableViewCell"
            static let totalTableViewCellNibNameAndIdentifier = "TotalTableViewCell"
        }
    }
    
    struct CustomizeShopping {
        static let customizeShoppingNibNameAndIdentifier = "CustomizeShoppingCollectionViewCell"
        static let customizeSelectedNibNameAndIdentifier = "CustomizeSelectedCollectionViewCell"
        static let customizeShoppingTableViewCellNibNameAndIdentifier = "CustomizeShoppingTableViewCell"
    }
}
