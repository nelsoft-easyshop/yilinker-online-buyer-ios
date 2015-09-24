//
//  Constansts.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/7/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

struct Constants {
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
        
        static let noInternet: String = StringHelper.localizedStringWithKey("NO_INTERNET_LOCALIZE_KEY")
        static let noInternetErrorMessage: String = StringHelper.localizedStringWithKey("NO_INTERNET_ERROR_MESSAGE_LOCALIZE_KEY")
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
        static let clientID = "1_167rxzqvid8g8swggwokcoswococscocc8ck44wo0g88owgkcc"
        static let clientSecret = "317eq8nohry84ooc0o8woo8000c0k844c4cggws84g80scwwog"
        static let grantRefreshToken = "refresh_token"
        static let grantBuyer = "http://yilinker-online.com/grant/buyer"
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
