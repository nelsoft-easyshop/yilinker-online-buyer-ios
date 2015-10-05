//
//  ProductViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct ProductStrings {
    static let freeShipping = StringHelper.localizedStringWithKey("FREE_SHIPPING_LOCALIZE_KEY")
    static let sevenDayReturn = StringHelper.localizedStringWithKey("SEVEN_DAY_RETURN_LOCALIZE_KEY")
    static let details = StringHelper.localizedStringWithKey("DETAILS_LOCALIZE_KEY")
    static let quantity = StringHelper.localizedStringWithKey("QUANTITY_LOCALIZE_KEY")
    static let description = StringHelper.localizedStringWithKey("DESCRIPTION_LOCALIZE_KEY")
    static let seeMore = StringHelper.localizedStringWithKey("SEE_MORE_LOCALIZE_KEY")
    static let ratingFeedback = StringHelper.localizedStringWithKey("RATING_FEEDBACK_LOCALIZE_KEY")
    static let seller = StringHelper.localizedStringWithKey("SELLER_LOCALIZE_KEY")

    static let addToCart = StringHelper.localizedStringWithKey("ADD_TO_CART_LOCALIZE_KEY")
    static let buytItNow = StringHelper.localizedStringWithKey("BUY_IT_NOW_LOCALIZE_KEY")
    
    static let cancel = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
    static let done = StringHelper.localizedStringWithKey("DONE_LOCALIZE_KEY")
    static let enterQuantity = StringHelper.localizedStringWithKey("ENTER_QUANTITY_LOCALIZE_KEY")
    static let availableStocks = StringHelper.localizedStringWithKey("AVAILABLE_STOCKS_LOCALIZE_KEY")
    static let select = StringHelper.localizedStringWithKey("SELECT_LOCALIZE_KEY")
    
    static let reviewRatingFeedback = StringHelper.localizedStringWithKey("REVIEW_RATING_FEEDBACK_LOCALIZE_KEY")
    static let peopleRate = StringHelper.localizedStringWithKey("PEOPLE_RATE_LOCALIZE_KEY")
    
    static let alertWishlist = StringHelper.localizedStringWithKey("ALERT_ADDED_TO_WISHLIST_LOCALIZE_KEY")
    static let alertCart = StringHelper.localizedStringWithKey("ALERT_ADDED_TO_CART_LOCALIZE_KEY")
    static let alertLogin = StringHelper.localizedStringWithKey("ALERT_PLEASE_LOGIN_LOCALIZE_KEY")
    static let alertComplete = StringHelper.localizedStringWithKey("ALERT_PLEASE_COMPLETE_LOCALIZE_KEY")
    static let alertWentWrong = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    static let alertOk = StringHelper.localizedStringWithKey("OK_BUTTON_LOCALIZE_KEY")
    static let alertError = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
    static let alertFailed = StringHelper.localizedStringWithKey("FAILED_LOCALIZE_KEY")
    static let alertNoReviews = StringHelper.localizedStringWithKey("NO_REVIEWS_LOCALIZE_KEY")
    static let cannotMessage = StringHelper.localizedStringWithKey("VENDOR_PAGE_CANNOT_MESSAGE_LOCALIZE_KEY")
}

protocol ProductViewControllerDelegate {
    func pressedDimViewFromProductPage(controller: ProductViewController)
}

class ProductViewController: UIViewController, ProductImagesViewDelegate, ProductDescriptionViewDelegate, ProductReviewFooterViewDelegate, ProductSellerViewDelegate, ProductReviewViewControllerDelegate, ProductAttributeViewControllerDelegate, EmptyViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyItNowView: UIView!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var buttonSubContainer: UIView!
    @IBOutlet weak var buyItNowLabel: UILabel!
    
    var headerView: UIView!
    var footerView: UIView!
    
    var productImagesView: ProductImagesView!
    var productDetailsView: UIView!
    var productAttributeView: UIView!
    var productDescriptionView: ProductDescriptionView!
    var productReviewHeaderView: ProductReviewHeaderView!
    var productReviewFooterView: ProductReviewFooterView!
    var productSellerView: ProductSellerView!
    
    let manager = APIManager.sharedInstance
    var productDetailsModel: ProductDetailsModel!
    var attributes: [ProductAttributeModel] = []
    var combinations: [ProductAvailableAttributeCombinationModel] = []
    var productReviewModel: ProductReviewModel!
    var productSellerModel: ProductSellerModel!
    
    var selectedName: [String] = []
    var selectedValue: [String] = []
    var selectedId: [String] = []
    
    var newFrame: CGRect!
    var visibility = 0.0
    var lastContentOffset: CGFloat = 0.0
    
    // MARK: Request Checker
    
    var productRequest = false
    var reviewRequest = false
    var sellerRequest = false
    
    var productSuccess = false
    var reviewSuccess = false
    var sellerSuccess = false
    
    var delegate: ProductViewControllerDelegate?
    
    var emptyView: EmptyView?
    var hud: MBProgressHUD?
    var tabController = CustomTabBarController()
    
    var unitIdIndex: Int = 0
    var isExiting: Bool = true
    
    // Messaging
    var selectedContact : W_Contact?
    var contacts = [W_Contact()]
    // MARK: Parameters
    
    var unitId: String = "0"
    var productId: String = "0"
    var quantity: Int = 1
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "reviewIdentifier")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
        setBorderOf(view: addToCartButton, width: 1, color: .grayColor(), radius: 3)
        setBorderOf(view: buyItNowView, width: 1, color: .grayColor(), radius: 3)
        
        if Reachability.isConnectedToNetwork() {
            requestProductDetails()
            requestReviewDetails()
        } else {
            addEmptyView()
        }
        
        buyItNowView.addGestureRecognizer(tapGesture("buyItNowAction:"))
        
        addToCartButton.setTitle(ProductStrings.addToCart, forState: .Normal)
        buyItNowLabel.text = ProductStrings.buytItNow
    }
    
    override func viewWillAppear(animated: Bool) {
        isExiting = true
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.barTintColor = .whiteColor()
        self.navigationController?.navigationBar.tintColor = .grayColor()
        if self.productDetailsModel == nil {
            configureNavigationBar()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if self.tableView.contentOffset.y <= 140 {
            self.navigationController?.navigationBar.alpha = 0
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if isExiting {
            self.navigationController?.navigationBar.alpha = 1.0
            self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
            UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        }
        self.hud?.hide(true)
    }
    
    // MARK: - Table View Data Source and Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productReviewModel != nil && productReviewModel.reviews.count > 1 {
            return 2
        } else if productReviewModel != nil && productReviewModel.reviews.count < 2 {
            return productReviewModel.reviews.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("reviewIdentifier") as! ReviewTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.nameLabel.text = productReviewModel.reviews[indexPath.row].fullName
        cell.setDisplayPicture(productReviewModel.reviews[indexPath.row].profileImageUrl)
        cell.setRating(productReviewModel.reviews[indexPath.row].rating)
        cell.messageLabel.text = productReviewModel.reviews[indexPath.row].review
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y <= 140.0 { // hide
            if visibility >= 0.0 && visibility <= 1.0 {
                visibility -= Double(scrollView.contentOffset.y / 14) * 0.005
            }
        } else if self.lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y >= 140.0 { // show
            if  visibility <= 1.0 && visibility >= 0.0 {
                visibility += Double(scrollView.contentOffset.y / 14) * 0.005
            }
        }
        
        if visibility > 1.0 {
            visibility = 1.0
        } else if visibility < 0.0 {
            visibility = 0.0
        }
        
        // reached top or bottom
        
        if scrollView.contentOffset.y <= 0.0 {
            visibility = 0.0
        } else if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height {
            visibility = 1.0
        }
        
        self.navigationController?.navigationBar.alpha = CGFloat(visibility)
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // MARK: - Init Views
    
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.autoresizesSubviews = false
        }
        return self.headerView
    }
    
    func getFooterView() -> UIView {
        if self.footerView == nil {
            self.footerView = UIView(frame: CGRectZero)
            self.footerView.autoresizesSubviews = false
        }
        return self.footerView
    }
    
    func getProductImagesView() -> ProductImagesView {
        if self.productImagesView == nil {
            self.productImagesView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 0) as! ProductImagesView
            self.productImagesView.frame.size.width = self.view.frame.size.width
            self.productImagesView.frame.size.height = self.view.frame.size.height - 114
        }
        return self.productImagesView
    }
    
    func getProductDetailsView() -> UIView {
        if self.productDetailsView == nil {
            self.productDetailsView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 25))
            self.productDetailsView.backgroundColor = UIColor.whiteColor()
        }
        return self.productDetailsView
    }
    
    func getProductAttributeView() -> UIView {
        if self.productAttributeView == nil {
            self.productAttributeView = UIView(frame: CGRectMake(0, 41, self.view.frame.size.width, 50))
            self.productAttributeView.backgroundColor = .whiteColor()
            
            var titleLabel = UILabel(frame: CGRectMake(8, 0, self.productAttributeView.frame.size.width - 16, 40))
            titleLabel.text = ProductStrings.details
            titleLabel.font = UIFont.systemFontOfSize(16.0)
            titleLabel.textColor = UIColor.darkGrayColor()
            titleLabel.userInteractionEnabled = true
            
            var tap = UITapGestureRecognizer()
            tap.numberOfTapsRequired = 1
            tap.addTarget(self, action: "gotoAttributes:")
            titleLabel.addGestureRecognizer(tap)
            
            var arrowImageView = UIImageView(frame: CGRectMake(self.productAttributeView.frame.size.width - 20, 11.5, 9, 17))
            arrowImageView.image = UIImage(named: "right-gray")
            
            var separatorView = UIView(frame: CGRectMake(0, 41, self.view.frame.size.width, 1))
            separatorView.backgroundColor = .lightGrayColor()
            
            self.productAttributeView.addSubview(titleLabel)
            self.productAttributeView.addSubview(arrowImageView)
            self.productAttributeView.addSubview(separatorView)
        }
        return self.productAttributeView
    }
    
    func getProductDescriptionView() -> ProductDescriptionView {
        if self.productDescriptionView == nil {
            self.productDescriptionView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 1) as! ProductDescriptionView
            self.productDescriptionView.frame.size.width = self.view.frame.size.width
            
            self.productDescriptionView.descriptionTitleLabel.text = ProductStrings.description
            
            var seeMoreLabel = UILabel(frame: CGRectMake(0, 0, 90, 41))
            seeMoreLabel.text = ProductStrings.seeMore
            seeMoreLabel.textColor = .blueColor()
            seeMoreLabel.font = UIFont.systemFontOfSize(15.0)
            seeMoreLabel.textAlignment = .Center
            
            var seeMoreImageView = UIImageView(frame: CGRectMake(seeMoreLabel.frame.size.width, (seeMoreLabel.frame.size.height / 2) - 6, 8, 12))
            seeMoreImageView.image = UIImage(named: "seeMore")
            seeMoreLabel.addSubview(seeMoreImageView)
            
            seeMoreLabel.center.x = self.view.center.x - 5
            self.productDescriptionView.seeMoreView.addSubview(seeMoreLabel)
        }
        return self.productDescriptionView
    }
    
    func getProductReviewHeaderView() -> ProductReviewHeaderView {
        if self.productReviewHeaderView == nil {
            self.productReviewHeaderView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 2) as! ProductReviewHeaderView
            self.productReviewHeaderView.frame.size.width = self.view.frame.size.width
            self.productReviewHeaderView.reviewTitleLabel.text = ProductStrings.ratingFeedback
        }
        return self.productReviewHeaderView
    }
    
    func getProductReviewFooterView() -> ProductReviewFooterView {
        if self.productReviewFooterView == nil {
            self.productReviewFooterView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 3) as! ProductReviewFooterView
            self.productReviewFooterView.frame.size.width = self.view.frame.size.width
            
            var seeMoreLabel = UILabel(frame: self.productReviewFooterView.frame)
            seeMoreLabel.frame.size.width = 90
            seeMoreLabel.font = UIFont.systemFontOfSize(15.0)
            seeMoreLabel.textAlignment = .Center
            
            if self.productReviewModel != nil && self.productReviewModel.reviews.count != 0 {
                seeMoreLabel.text = ProductStrings.seeMore
                seeMoreLabel.textColor = .blueColor()
                
                var seeMoreImageView = UIImageView(frame: CGRectMake(seeMoreLabel.frame.size.width, (seeMoreLabel.frame.size.height / 2) - 6, 8, 12))
                seeMoreImageView.image = UIImage(named: "seeMore")
                seeMoreLabel.addSubview(seeMoreImageView)
            } else {
                seeMoreLabel.frame.size.width = self.productReviewFooterView.frame.size.width
                seeMoreLabel.text = ProductStrings.alertNoReviews
                seeMoreLabel.textColor = .grayColor()
            }
            
            seeMoreLabel.center.x = self.view.center.x - 5
            self.productReviewFooterView.addSubview(seeMoreLabel)
        }
        return self.productReviewFooterView
    }
    
    func getProductSellerView() -> ProductSellerView {
        if self.productSellerView == nil {
            self.productSellerView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 4) as! ProductSellerView
            self.productSellerView.frame.size.width = self.view.frame.size.width
            self.productSellerView.sellerLabel.text = ProductStrings.seller
        }
        return self.productSellerView
    }
    
    // MARK: - Requests
    
    func requestProductDetails() {
        self.showHUD()
        let id: String = "?productId=" + productId
        
        manager.GET(APIAtlas.productDetails + id, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject["isSuccessful"] as! Bool {
                self.productDetailsModel = ProductDetailsModel.parseDataWithDictionary(responseObject)
                self.productId = self.productDetailsModel.id
                self.unitId = self.productDetailsModel.productUnits[0].productUnitId
                
                self.getUnitIdIndexFrom()
                
                self.attributes = self.productDetailsModel.attributes
                self.requestSellerDetails()
                self.requestContactsFromEndpoint()
            } else {
                let alert = UIAlertController(title: ProductStrings.alertError,
                                            message: responseObject["message"] as? String,
                                     preferredStyle: UIAlertControllerStyle.Alert)
                let okButton = UIAlertAction(title: ProductStrings.alertOk,
                                             style: UIAlertActionStyle.Cancel) { (alert) -> Void in
                    self.barCloseAction()
                }
                alert.addAction(okButton)
                self.presentViewController(alert, animated: true, completion: nil)
                
                self.hud?.hide(true)
                self.addEmptyView()
            }
            
            self.productRequest = true
            self.productSuccess = true
            self.checkRequests()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("product failed")
                self.productRequest = true
                self.productSuccess = false
                self.checkRequests()
        })
    }
    
    func requestReviewDetails() {
        
        let params: NSDictionary = ["productId": productId]
        
        manager.POST(APIAtlas.productReviews, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.productReviewModel = ProductReviewModel.parseDataWithDictionary(responseObject)
            self.reviewRequest = true
            self.reviewSuccess = true
            self.checkRequests()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("review failed")
                self.reviewRequest = true
                self.reviewSuccess = false
                self.checkRequests()
        })
    }
    
    func requestSellerDetails() {
        
        let params = ["userId": self.productDetailsModel.sellerId]
        println(params)
        manager.POST(APIAtlas.getSellerInfo, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in

            if responseObject["isSuccessful"] as! Bool {
                self.productSellerModel = ProductSellerModel.parseDataWithDictionary(responseObject)
                self.sellerRequest = true
                self.sellerSuccess = true
                self.checkRequests()
            } else {
                self.showAlert(title: ProductStrings.alertError, message: responseObject["message"] as! String)
                self.hud?.hide(true)
                self.addEmptyView()
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("seller failed")
                println(error)
                self.sellerRequest = true
                self.sellerSuccess = false
                self.checkRequests()
        })
    }
    
    func requestUpdateWishlistItem() {
        
        self.showHUD()
        let manager = APIManager.sharedInstance
        let params = ["access_token": SessionManager.accessToken(),
            "productId": self.productId,
            "unitId": self.unitId,
            "quantity": "1",
            "wishlist": "true"]
        
        manager.POST(APIAtlas.updateWishlistUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject.isKindOfClass(NSDictionary) {
                
                if let tempVar = responseObject["isSuccessful"] as? Bool {
                    if tempVar {
                        var data: NSDictionary = responseObject["data"] as! NSDictionary
                        var items: NSArray = data["items"] as! NSArray
                        SessionManager.setWishlistCount(items.count)
                        self.showAlert(title: nil, message: ProductStrings.alertWishlist)
                        self.addBadge("wishlist")
                    } else {
                        if let tempVar = responseObject["message"] as? String {
                            self.showAlert(title: ProductStrings.alertError, message: tempVar)
                        }
                    }
                }
            }
            
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.requestRefreshToken("wishlist")
                } else {
                    println(error)
                    self.hud?.hide(true)
                }
        })
    }
    
    func requestAddCartItem(type: String) {
        self.showHUD()
        
        let params: NSDictionary = ["access_token": SessionManager.accessToken(),
            "productId": self.productDetailsModel.id,
            "unitId": self.unitId,
            "quantity": quantity]
        
        manager.POST(APIAtlas.updateCart(), parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject.isKindOfClass(NSDictionary) {
                
                if let tempVar = responseObject["isSuccessful"] as? Bool {
                    var data: NSDictionary = responseObject["data"] as! NSDictionary
                    
                    var items: NSArray = data["items"] as! NSArray
                    
                    if type == "buyitnow" {
                        var itemProductId: String = ""
                        var itemUnitId: String = ""
                        
                        for i in 0..<items.count {
                            let item: NSDictionary = items[i] as! NSDictionary
                            itemProductId = item["id"] as! String
                            
                            let productUnits: NSArray = item["productUnits"] as! NSArray
                            for i in 0..<productUnits.count {
                                let productUnit: NSDictionary = productUnits[i] as! NSDictionary
                                itemUnitId = productUnit["productUnitId"] as! String
                                
                                if self.productId == itemProductId && self.unitId == itemUnitId {
                                    var quantity: String = item["quantity"] as! String
                                    var price: Double = (productUnit["discountedPrice"] as! NSString).doubleValue
                                    var iQuantity: Double = (quantity as NSString).doubleValue
                                    self.requestCartToCheckout(item["itemId"] as! Int, totalAmount: (iQuantity * price))
                                    break
                                }
                                
                            } // loop for product unit
                        } // loop for items
                    } else {
                        self.showAlert(title: nil, message: ProductStrings.alertCart)
                        println(items.count)
                        SessionManager.setCartCount(data["total"] as! Int)
                        self.addBadge("cart")
                        self.hud?.hide(true)
                    }
                    
                } else {
                    self.showAlert(title: ProductStrings.alertError, message: responseObject["message"] as! String)
                    self.hud?.hide(true)
                }
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.requestRefreshToken("cart")
                } else {
                    println(error)
                    self.hud?.hide(true)
                }
        })
    }
    
    func requestCartToCheckout(id: Int, totalAmount: Double) {
        
        let item: [Int] = [id]
        let params: NSDictionary = ["access_token": SessionManager.accessToken(), "cart": item]
        
        manager.POST(APIAtlas.updateCheckout(), parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!)in
            
            var cartProductModel: [CartProductDetailsModel] = []
            
            if let value: AnyObject = responseObject["data"] {
                for subValue in responseObject["data"] as! NSArray {
                    let model: CartProductDetailsModel = CartProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)
                    cartProductModel.append(model)
                }
            }
            
            let checkout = CheckoutContainerViewController(nibName: "CheckoutContainerViewController", bundle: nil)
            checkout.carItems = cartProductModel
            checkout.totalPrice = String(stringInterpolationSegment: totalAmount)
            let navigationController: UINavigationController = UINavigationController(rootViewController: checkout)
            navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
            self.tabBarController?.presentViewController(navigationController, animated: true, completion: nil)
            
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong. . .", title: "Error")
                self.hud?.hide(true)
        })
    }
    
    func requestRefreshToken(type: String) {
        
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.hud?.hide(true)
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            if type == "cart" {
                self.requestAddCartItem("")
            } else if type == "wishlist" {
                self.requestUpdateWishlistItem()
            } else if type == "message" {
                self.requestContactsFromEndpoint()
            }else {
                println("else in product view refresh token")
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert(title: ProductStrings.alertWentWrong, message: nil)
                
        })
    }
    
    func requestContactsFromEndpoint(){
            if (Reachability.isConnectedToNetwork()) {
                self.showHUD()
                
                let manager: APIManager = APIManager.sharedInstance
                manager.requestSerializer = AFHTTPRequestSerializer()
                
                let parameters: NSDictionary = [
                    "page"          : "1",
                    "limit"         : "30",
                    "keyword"       : "",
                    "access_token"  : SessionManager.accessToken()
                    ]   as Dictionary<String, String>
                
                let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONTACTS
                
                manager.POST(url, parameters: parameters, success: {
                    (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                    self.contacts = W_Contact.parseContacts(responseObject as! NSDictionary)
                    self.hud?.hide(true)
                    }, failure: {
                        (task: NSURLSessionDataTask!, error: NSError!) in
                        let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                        
                        if task.statusCode == 401 {
                            if (SessionManager.isLoggedIn()){
                                self.requestRefreshToken("message")
                            }
                        } else {
                            if (SessionManager.isLoggedIn()){
                                self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                            }
                        }
                        
                        self.contacts = Array<W_Contact>()
                        self.hud?.hide(true)
                })
            }
    }
    
    // MARK: - Methods
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.alpha = 0
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.barTintColor = .whiteColor()
        self.navigationController?.navigationBar.tintColor = .grayColor()
        
        let close = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "barCloseAction")
        let wishlist = UIBarButtonItem(image: UIImage(named: "wishlist"), style: .Plain, target: self, action: "barWishlistAction")
        let rate = UIBarButtonItem(image: UIImage(named: "rating"), style: .Plain, target: self, action: "barRateAction")
        let message = UIBarButtonItem(image: UIImage(named: "msg"), style: .Plain, target: self, action: "barMessageAction")
        let share = UIBarButtonItem(image: UIImage(named: "share"), style: .Plain, target: self, action: "barShareAction")
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        
        self.navigationItem.setLeftBarButtonItem(close, animated: false)
        self.navigationItem.setRightBarButtonItems([share, negativeSpacer, message, negativeSpacer, rate, negativeSpacer, wishlist], animated: true)
    }
    
    func setUpViews() {
        self.setPosition(self.productDetailsView, from: self.productImagesView)
        self.setPosition(self.productAttributeView, from: self.productDetailsView)
        self.setPosition(self.productDescriptionView, from: self.productAttributeView)
        self.setPosition(self.productReviewHeaderView, from: self.productDescriptionView)
        self.setPosition(self.productSellerView, from: self.productReviewFooterView)
        
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.productReviewHeaderView.frame)
        self.headerView.frame = newFrame
        
        newFrame = self.footerView.frame
        newFrame.size.height = CGRectGetMaxY(self.productSellerView.frame)
        self.footerView.frame = newFrame
        
        self.tableView.tableFooterView = nil
        self.tableView.tableFooterView = self.footerView
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame) + 20
        view.frame = newFrame
    }
    
    func setBorderOf(#view: AnyObject, width: CGFloat, color: UIColor, radius: CGFloat) {
        view.layer.borderWidth = width
        view.layer.borderColor = color.CGColor
        view.layer.cornerRadius = radius
    }
    
    func loadViewsWithDetails() {
        
        self.tableView.hidden = false
        self.buttonsContainer.hidden = false
        
        self.getHeaderView().addSubview(self.getProductImagesView())
        self.getHeaderView().addSubview(self.getProductDetailsView())
        self.getHeaderView().addSubview(self.getProductAttributeView())
        self.getHeaderView().addSubview(self.getProductDescriptionView())
        self.getHeaderView().addSubview(self.getProductReviewHeaderView())
        
        self.getFooterView().addSubview(self.getProductReviewFooterView())
        self.getFooterView().addSubview(self.getProductSellerView())
        
        self.productImagesView.setDetails(self.productDetailsModel, unitId: unitIdIndex, width: self.view.frame.size.width)
        //        self.setDetails(productDetailsModel.details)
        self.setDetails([ProductStrings.freeShipping, ProductStrings.sevenDayReturn])
        
        self.setAttributes(self.productDetailsModel.attributes, productUnits: self.productDetailsModel.productUnits, unitId: self.unitId, quantity: 1)
        self.productDescriptionView.setDescription(productDetailsModel.shortDescription, full: productDetailsModel.fullDescription)
        
        
        if self.productReviewModel != nil {
            self.productReviewHeaderView.setRating(self.productReviewModel.ratingAverage)
        }
        
        self.tableView.reloadData()
        
        if self.productSellerModel != nil {
            if self.productSellerModel.images.count < 1 {
                self.productSellerView.collectionView.hidden = true
                self.productSellerView.frame.size.height = 123.0
            }
            self.productSellerView.setSellerDetails(self.productSellerModel)
        }
        
        setUpViews()
        
        self.productImagesView.delegate = self
        self.productDescriptionView.delegate = self
        self.productReviewFooterView.delegate = self
        self.productSellerView.delegate = self
        
        self.hud?.hide(true)
    }
    
    func setDetails(list: NSArray) {
        var topMargin: CGFloat = 0
        
        for i in 0..<list.count {
            
            topMargin = CGFloat(i * 25) + 10
            
            var label = UILabel(frame: CGRectMake(43, topMargin, self.productDetailsView.frame.size.width - 50, 25))
            label.text = list[i] as? String
            label.textColor = Constants.Colors.productDetails
            label.font = UIFont(name: label.font.fontName, size: 13)
            
            topMargin = CGFloat(i * 25) + 14
            
            var imageView = UIImageView(frame: CGRectMake(17, topMargin, 17, 17))
            imageView.image = UIImage(named: "check")
            
            self.productDetailsView.addSubview(imageView)
            self.productDetailsView.addSubview(label)
        }
        
        newFrame = self.productDetailsView.frame
        newFrame.size.height = CGFloat(self.productDetailsView.frame.size.height * CGFloat(list.count)) + 20
        self.productDetailsView.frame = newFrame
    }
    
    func setAttributes(attributes: [ProductAttributeModel], productUnits: [ProductUnitsModel], unitId: String, quantity: Int) {
        println("unit id >>> \(unitId)")
        
        for view in self.productAttributeView.subviews {
            if view is UILabel {
                let label: UILabel = view as! UILabel
                if label.text != ProductStrings.details {
                    view.removeFromSuperview()
                }
            }
        }
        
        selectedName = []
        selectedValue = []
        selectedId = []
        selectedName.append(ProductStrings.quantity)
        if quantity == 0 {
            selectedValue.append(String(self.quantity) + "x")
        } else {
            selectedValue.append(String(quantity) + "x")
        }
        
        self.getUnitIdIndexFrom()
        for i in 0..<attributes.count {
            for j in 0..<attributes[i].valueId.count {
                if productUnits[self.unitIdIndex].combination[i] == attributes[i].valueId[j] {
                    selectedName.append(attributes[i].attributeName)
                    selectedId.append(attributes[i].valueId[j])
                    selectedValue.append(attributes[i].valueName[j])
                }
            }
        }
        
        createAttributesLabel(selectedName.count, name: selectedName, value: selectedValue)
    }
    
    func createAttributesLabel(numberOfAttributes: Int, name: NSArray, value: NSArray) {
        var topMargin: CGFloat = 0
        var leftMargin: CGFloat = 0
        var reseter: Int = 0
        var counter: Int = 1
        var labelWidth = (self.view.frame.size.width / 3)
        
        for i in 0..<numberOfAttributes {
            if i % 3 == 0 && i != 0 {
                topMargin += 23
                reseter = 0
                counter += 1
            }
            
            leftMargin = CGFloat(reseter * Int(labelWidth))
            reseter += 1
            
            var attributesLabel = UILabel(frame: CGRectMake(leftMargin + 10, topMargin + 50, labelWidth - 12, 23))
            attributesLabel.font = UIFont.systemFontOfSize(14.0)
            attributesLabel.textColor = .grayColor()
            
            var attributedCategory = NSMutableAttributedString(string: "\(name[i]): ")
            var font = [NSFontAttributeName : UIFont.boldSystemFontOfSize(14.0)]
            var attributeItem = NSMutableAttributedString(string: value[i] as! String, attributes: font)
            attributedCategory.appendAttributedString(attributeItem)
            
            attributesLabel.attributedText = attributedCategory
            
            self.productAttributeView.addSubview(attributesLabel)
        }
        
        newFrame = self.productAttributeView.frame
        newFrame.size.height = CGFloat(counter * 23) + 60 //60 = height of header + 10 for bottom margin
        self.productAttributeView.frame = newFrame
        
        setUpViews()
    }
    
    func checkRequests() {
        
        if productRequest && reviewRequest && sellerRequest {
            if productSuccess {
                self.loadViewsWithDetails()
            } else {
                addEmptyView()
                self.hud?.hide(true)
            }
        }
        
    }
    
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.emptyView!.delegate = self
        self.emptyView!.frame = self.view.bounds
        self.view.addSubview(self.emptyView!)
    }
    
    func addWishlistBadge(items: Int) {
        let badgeValue = (self.tabController.tabBar.items![3] as! UITabBarItem).badgeValue?.toInt()
        (self.tabController.tabBar.items![3] as! UITabBarItem).badgeValue = String(items)
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func addBadge(type: String) {
        if type == "cart" {
            (self.tabController.tabBar.items![4] as! UITabBarItem).badgeValue = String(SessionManager.cartCount())
        } else if type == "wishlist" {
            (self.tabController.tabBar.items![3] as! UITabBarItem).badgeValue = String(SessionManager.wishlistCount())
        }
    }
    
    func getUnitIdIndexFrom() {
        
        for i in 0..<self.productDetailsModel.productUnits.count {
            if self.unitId == self.productDetailsModel.productUnits[i].productUnitId {
                self.unitIdIndex = i
                break
            }
        }
    }
    
    // MARK: - Product View Delegate
    
    func close(controller: ProductImagesView) {
        self.barCloseAction()
    }
    
    func wishlist(controller: ProductImagesView) {
        self.barWishlistAction()
    }
    
    func rate(controller: ProductImagesView) {
        self.barRateAction()
    }
    
    func message(controller: ProductImagesView) {
        self.barMessageAction()
    }
    
    func share(controller: ProductImagesView) {
        self.barShareAction()
    }
    
    func seeMoreAttribute(title: String) {
        
        var attributeModal = ProductAttributeViewController(nibName: "ProductAttributeViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.backgroundColor = UIColor.clearColor()
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        attributeModal.passModel(productDetailsModel: productDetailsModel, selectedValue: selectedValue, selectedId: selectedId, unitIdIndex: unitIdIndex, quantity: self.quantity, price: self.productImagesView.priceLabel.text!, imageIndex: self.productImagesView.pageControl.currentPage)
        attributeModal.setTitle = title
        attributeModal.tabController = self.tabController
        attributeModal.screenWidth = self.view.frame.width
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
            self.dimView.layer.zPosition = 2
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    // MARK: - Product Description Delegate
    
    func seeMoreDescription(controller: ProductDescriptionView) {
        isExiting = false
        let description = ProductDescriptionViewController(nibName: "ProductDescriptionViewController", bundle: nil)
        description.url = self.productDetailsModel.fullDescription
        description.title = self.productDetailsModel.title
        let root: UINavigationController = UINavigationController(rootViewController: description)
        self.tabBarController?.presentViewController(root, animated: true, completion: nil)
    }
    
    // MARK: - Product Attribute Delegate
    
    func dissmissAttributeViewController(controller: ProductAttributeViewController, type: String) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
            self.navigationController?.navigationBar.alpha = CGFloat(self.visibility)
            }, completion: { finished in
                if type == "cart" {
                    self.showAlert(title: nil, message: ProductStrings.alertCart)
                    self.loadViewsWithDetails()
                } else if type == "done" {
                    //                    self.showAlert(type)
                }
        })
        
    }
    
    func doneActionPassDetailsToProductView(controller: ProductAttributeViewController, unitId: String, quantity: Int, selectedId: NSArray) {
        self.unitId = unitId
        self.selectedId = selectedId as! [String]
        self.quantity = quantity
        self.setAttributes(self.productDetailsModel.attributes, productUnits: self.productDetailsModel.productUnits, unitId: unitId, quantity: quantity)
    }
    
    func gotoCheckoutFromAttributes(controller: ProductAttributeViewController) {
        self.buyItNowAction(UIGestureRecognizer())
    }
    
    // MARK: - Product Review Delegate
    
    func pressedCancelReview(controller: ProductReviewViewController) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
            self.navigationController?.navigationBar.alpha = CGFloat(self.visibility)
        })
    }
    
    func seeMoreReview(controller: ProductReviewFooterView) {
        self.barRateAction()
    }
    
    // MARK: - Product Seller Delegate
    
    func seeMoreSeller(controller: ProductSellerView) {
        let seller = SellerViewController(nibName: "SellerViewController", bundle: nil)
        seller.sellerId = self.productDetailsModel.sellerId
        self.navigationController?.pushViewController(seller, animated: true)
    }
    
    func gotoSellerProduct(controller: ProductSellerView, id: String) {
        let productView = ProductViewController(nibName: "ProductViewController", bundle: nil)
        productView.productId = id
        self.navigationController?.pushViewController(productView, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func addToCartAction(sender: AnyObject) {
        
        requestAddCartItem("cart")
        
    }
    
    func buyItNowAction(gesture: UIGestureRecognizer) {
        requestAddCartItem("buyitnow")
        
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tapGesture(action: Selector) -> UITapGestureRecognizer {
        var tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        
        return tap
    }
    
    func gotoAttributes(gesture: UIGestureRecognizer) {
        seeMoreAttribute("")
    }
    
    func didTapReload() {
        if Reachability.isConnectedToNetwork() {
            requestProductDetails()
            requestReviewDetails()
        } else {
            addEmptyView()
        }
        self.emptyView?.removeFromSuperview()
    }
    
    // MARK: - Navigation Bar Actions
    
    func barCloseAction() {
        self.navigationController?.popViewControllerAnimated(true)
//        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func barWishlistAction() {
        if SessionManager.isLoggedIn() {
            requestUpdateWishlistItem()
        } else {
            showAlert(title: ProductStrings.alertFailed, message: ProductStrings.alertLogin)
        }
    }
    
    func barRateAction() {
        if self.productReviewModel != nil && self.productReviewModel.reviews.count != 0 {
            var reviewModal = ProductReviewViewController(nibName: "ProductReviewViewController", bundle: nil)
            reviewModal.delegate = self
            reviewModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            reviewModal.providesPresentationContextTransitionStyle = true
            reviewModal.definesPresentationContext = true
            reviewModal.view.backgroundColor = UIColor.clearColor()
            reviewModal.view.frame.origin.y = reviewModal.view.frame.size.height
            reviewModal.passModel(self.productReviewModel)
            self.tabBarController?.presentViewController(reviewModal, animated: true, completion: nil)
            
            UIView.animateWithDuration(0.3, animations: {
                self.dimView.alpha = 0.5
                self.dimView.layer.zPosition = 2
                self.view.transform = CGAffineTransformMakeScale(0.92, 0.93)
                self.navigationController?.navigationBar.alpha = 0.0
            })
        }
//        else {
//            self.showAlert(title: ProductStrings.alertNoReviews, message: nil)
//        }
    }
    
    func barMessageAction() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        let messagingViewController: MessageThreadVC = (storyBoard.instantiateViewControllerWithIdentifier("MessageThreadVC") as? MessageThreadVC)!
        
        var canMessage: Bool = false
        for var i = 0; i < self.contacts.count; i++ {
            if "\(self.productDetailsModel.sellerId)" == contacts[i].userId {
                self.selectedContact = contacts[i]
                canMessage = true
            }
        }
        
        var isOnline = "-1"
        if (SessionManager.isLoggedIn()){
            isOnline = "1"
        } else {
            isOnline = "0"
        }
        messagingViewController.sender = W_Contact(fullName: SessionManager.userFullName() , userRegistrationIds: "", userIdleRegistrationIds: "", userId: SessionManager.accessToken(), profileImageUrl: SessionManager.profileImageStringUrl(), isOnline: isOnline)
        messagingViewController.recipient = selectedContact
        
        if canMessage {
            self.navigationController?.pushViewController(messagingViewController, animated: true)
        } else {
            self.showAlert(title: Constants.Localized.error, message: ProductStrings.cannotMessage)
            //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "You're allowed to message this seller. Please login first.", title: "Error")
        }
    }
    
    func barShareAction() {
        var sharingItems = [AnyObject]()
        sharingItems.append(NSURL(string: "http://online.api.easydeal.ph/item/" + self.productDetailsModel.slug)!)
        
        let shareViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(shareViewController, animated: true, completion: nil)
    }   
}