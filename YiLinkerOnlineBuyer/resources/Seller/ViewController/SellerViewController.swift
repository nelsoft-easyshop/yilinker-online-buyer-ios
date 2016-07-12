//
//  SellerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SellerTableHeaderViewDelegate, ProductsTableViewCellDelegate, ViewFeedBackViewControllerDelegate, EmptyViewDelegate, UIScrollViewDelegate, FeedBackViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var sellerModel: SellerModel?
    var sellerModelFeedback: SellerModel?
    var followSellerModel: FollowedSellerModel?
    var productReviewModel: ProductReviewsModel?
    var productReviews: [ProductReviewsModel] = [ProductReviewsModel]()
    
    var yiHud: YiHUD?
    var dimView: UIView = UIView()
    
    var is_successful: Bool = false
    var sellerId: Int = 0
    var slug: String = ""
    var sellerContactNumber: String = ""
    var sellerName: String = ""
    var storeDescription: String = ""
    
    let sellerTableHeaderView: SellerTableHeaderView = SellerTableHeaderView.loadFromNibNamed("SellerTableHeaderView", bundle: nil) as! SellerTableHeaderView
    
    //Localized strings
    let follow: String = StringHelper.localizedStringWithKey("FOLLOW_LOCALIZE_KEY")
    let following: String = StringHelper.localizedStringWithKey("UNFOLLOW_LOCALIZE_KEY")
    let viewFeedback: String = StringHelper.localizedStringWithKey("VIEW_FEEDBACK_LOCALIZE_KEY")
    let vendorTitle: String = StringHelper.localizedStringWithKey("VENDOR_PAGE_TITLE_LOCALIZE_KEY")
    let aboutSeller: String = StringHelper.localizedStringWithKey("ABOUT_SELLER_LOCALIZE_KEY")
    let productsTitle: String = StringHelper.localizedStringWithKey("PRODUCTS_SELLER_LOCALIZE_KEY")
    let moreSellersProduct: String = StringHelper.localizedStringWithKey("MORE_SELLERS_PRODUCT_LOCALIZE_KEY")
    let productRatings: String = StringHelper.localizedStringWithKey("PRODUCT_RATINGS_AND_FEEDBACK_LOCALIZE_KEY")
    let cannotFollow: String = StringHelper.localizedStringWithKey("VENDOR_PAGE_CANNOT_FOLLOW_LOCALIZE_KEY")
    let cannotMessage: String = StringHelper.localizedStringWithKey("VENDOR_PAGE_CANNOT_MESSAGE_LOCALIZE_KEY")
    let cannotCall: String = StringHelper.localizedStringWithKey("VENDOR_PAGE_CANNOT_CALL_LOCALIZE_KEY")
    
    //Error messages
    let ok: String = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
    
    //Contacts
    var selectedContact : W_Contact?
    var emptyView : EmptyView?
    var conversations = [W_Conversation]()
    var contacts = [W_Contact()]
    var contentViewFrame: CGRect?
    var canMessage: Bool = false
    
    let kTableHeaderHeight: CGFloat = 300
    
    var sellerHeaderView: SellerTableHeaderView = SellerTableHeaderView()
    
    //MARK: -
    //MARK: - Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Get view frame
        self.contentViewFrame = self.view.frame
        
        //Adding dimView to the current view
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        //Customize navigation bar
        self.backButton()
        //Register nib classes
        self.registerNib()
        //Get seller/store info
        self.fireSeller()
        
        self.getContactsFromEndpoint("1", limit: "30", keyword: "")
        
        //Set footer view frame and row height
        self.tableView.estimatedRowHeight = 112.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    //MARK: -
    //MARK: Reload tableview
    func populateData() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clearColor()
        self.headerView()
        self.tableView.reloadData()
    }
    
    //MARK: -
    //MARK: Set title of navigation bar
    func titleView(vendorName: String) {
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, 100, 50))
        label.text = vendorName
        label.font = UIFont (name: "Panton-Regular", size: 20)
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        label.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = label
    }
    
    //MARK: -
    //MARK: Adding header view to tableview
    func headerView() {
        sellerTableHeaderView.delegate = self
        sellerTableHeaderView.coverPhotoImageView.sd_setImageWithURL(self.sellerModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder"))
        
        if self.is_successful {
            //self.sellerTableHeaderView.followButton.borderColor = UIColor.clearColor()
            self.sellerTableHeaderView.followButton.setTitle(following, forState: UIControlState.Normal)
        } else if !(self.is_successful){
            //self.sellerTableHeaderView.followButton.borderColor = UIColor.clearColor()
            self.sellerTableHeaderView.followButton.setTitle(follow, forState: UIControlState.Normal)
        }
        
        if self.sellerModel!.isAffiliated {
            sellerTableHeaderView.addressLabel.hidden = true
            sellerTableHeaderView.callButton.hidden = true
            sellerTableHeaderView.messageButton.hidden = true
        } else  {
            sellerTableHeaderView.addressLabel.hidden = false
            sellerTableHeaderView.callButton.hidden = false
            sellerTableHeaderView.messageButton.hidden = false
        }
        
        let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, sellerTableHeaderView.profileImageView.frame.width, sellerTableHeaderView.profileImageView.frame.height))
        imageView.sd_setImageWithURL(self.sellerModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder"))
        
        sellerTableHeaderView.viewFeedbackButton.setTitle(viewFeedback, forState: UIControlState.Normal)
        sellerTableHeaderView.profileImageView.addSubview(imageView)
        sellerTableHeaderView.sellernameLabel.text = sellerModel!.store_name
        sellerTableHeaderView.addressLabel.text = sellerModel!.store_address
        
        self.sellerName = self.sellerModel!.store_name
        self.sellerContactNumber = sellerModel!.contact_number
        
        self.tableView.tableHeaderView = sellerTableHeaderView
        self.tableView.reloadData()
        
        sellerHeaderView = self.tableView.tableHeaderView as! SellerTableHeaderView
        tableView.tableHeaderView = nil
        
        self.tableView.addSubview(sellerHeaderView)
        self.tableView.contentInset = UIEdgeInsets(top: kTableHeaderHeight, left: 0, bottom: 40, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -kTableHeaderHeight)
        self.sellerHeaderView.gradient()
    }
    
    //MARK: -
    //MARK: - Update Header View
    func updateHeaderView() {
        var headerRect: CGRect = CGRect(x: 0, y: -kTableHeaderHeight, width: self.tableView.bounds.width, height: kTableHeaderHeight)
        if tableView.contentOffset.y < -kTableHeaderHeight {
            headerRect.origin.y = tableView.contentOffset.y
            headerRect.size.height = -tableView.contentOffset.y
        }
        
        self.sellerHeaderView.frame = headerRect
        self.sellerHeaderView.gradient()
    }
    
    //MARK: -
    //MARK: Register nibs for tableview cells
    func registerNib() {
        let sellerNib: UINib = UINib(nibName: Constants.Seller.aboutSellerTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(sellerNib, forCellReuseIdentifier: Constants.Seller.aboutSellerTableViewCellNibNameAndIdentifier)
        
        let productsNib: UINib = UINib(nibName: Constants.Seller.productsTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(productsNib, forCellReuseIdentifier: Constants.Seller.productsTableViewCellNibNameAndIdentifier)
        
        let generalRatingNib: UINib = UINib(nibName: Constants.Seller.generalRatingTableViewCellNibNameAndIndentifier, bundle: nil)
        self.tableView.registerNib(generalRatingNib, forCellReuseIdentifier: Constants.Seller.generalRatingTableViewCellNibNameAndIndentifier)
        
        let reviewNib: UINib = UINib(nibName: Constants.Seller.reviewNibName, bundle: nil)
        self.tableView.registerNib(reviewNib, forCellReuseIdentifier: Constants.Seller.reviewNibName)
        
        let noReviewNib: UINib = UINib(nibName: "NoReviewTableViewCell", bundle: nil)
        self.tableView.registerNib(noReviewNib, forCellReuseIdentifier: "NoReviewTableViewCell")
        
        let seeMoreNib: UINib = UINib(nibName: Constants.Seller.seeMoreTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(seeMoreNib, forCellReuseIdentifier: Constants.Seller.seeMoreTableViewCellNibNameAndIdentifier)
    }
    
    //MARK: -
    //MARK: Get seller/store info
    func fireSeller() {
        var url: String = ""
        
        if SessionManager.isLoggedIn() {
            url = APIAtlas.getSellerInfoLoggedIn
        } else {
            url = APIAtlas.getSellerInfo
        }
        
        var params: String = ""
        if self.slug.isEmpty {
            params = "\(sellerId)"
        } else {
            params = self.slug
        }
        
        WebServiceManager.fireSellerWithUrl(url, accessToken: SessionManager.accessToken(), sellerId: params) {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            if successful {
                if responseObject["isSuccessful"] as! Bool {
                    self.sellerModel = SellerModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
                    self.is_successful = self.sellerModel!.is_allowed
                    self.yiHud?.hide()
                    self.titleView(self.sellerModel!.store_name)
                    self.storeDescription = self.sellerModel!.store_description
                    self.populateData()
                } else {
                    self.showAlert(title: "Error", message: responseObject["message"] as! String)
                }
                //Get seller ratings and feebback
                self.fireSellerFeedback()
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(SellerRefreshType.Get)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    //MARK: -
    //MARK: Get seller ratings and feedback
    func fireSellerFeedback() {
        var params: String = ""
        if self.slug.isEmpty {
            params = "\(sellerId)"
        } else {
            params = self.slug
        }
        
        WebServiceManager.fireSellerFeedbackWithUrl(APIAtlas.buyerSellerFeedbacks+"?sellerId=\(params)", sellerId: params) {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            println(responseObject)
            if successful {
                if responseObject["isSuccessful"] as! Bool {
                    let temp = SellerModel.parseSellerReviewsDataFromDictionary(responseObject as! NSDictionary)
                    self.sellerModel?.reviews = temp.reviews
                    self.sellerModel?.rating = temp.rating
                    self.tableView.reloadData()
                } else {
                    self.showAlert(title: Constants.Localized.error, message: responseObject["message"] as! String)
                }
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(SellerRefreshType.Feedback)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        }
    }
    
    //MARK: -
    //MARK: Follow seller
    func fireFollowSeller() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        var params: String = ""
        if self.slug.isEmpty {
            params = "\(sellerId)"
        } else {
            params = self.slug
        }
        
        WebServiceManager.fireFollowSellerWithUrl(APIAtlas.followSeller, sellerId: params, accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.yiHud?.hide()
            if successful {
                self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(responseObject as! NSDictionary)
                self.is_successful = true
                self.sellerTableHeaderView.followButton.tag = 1
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(SellerRefreshType.Follow)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
            
            if requestErrorType != .AccessTokenExpired {
                self.sellerTableHeaderView.followButton.tag = 2
            }
        }
    }
    
    //MARK: -
    //MARK: Unfollow seller
    func fireUnfollowSeller() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        WebServiceManager.fireUnFollowSellerWithUrl(APIAtlas.unfollowSeller, sellerId: self.sellerId, accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.yiHud?.hide()
            if successful {
                self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(responseObject as! NSDictionary)
                self.is_successful = false
                self.sellerTableHeaderView.followButton.tag = 2
                
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken(SellerRefreshType.Unfollow)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
            
            if requestErrorType != .AccessTokenExpired {
                self.sellerTableHeaderView.followButton.tag = 2
            }
        }
    }
    
    //MARK: -
    //MARK: Refresh token
    func requestRefreshToken(type: SellerRefreshType) {
        if SessionManager.isLoggedIn() {
            self.showHUD()
            WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
                (successful, responseObject, requestErrorType) -> Void in
                self.yiHud?.hide()
                
                if successful {
                    SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                    
                    if type == SellerRefreshType.Follow {
                        self.fireFollowSeller()
                    } else if type == SellerRefreshType.Unfollow {
                        self.fireUnfollowSeller()
                    } else if type == SellerRefreshType.Get {
                        self.fireSeller()
                    } else {
                        self.fireSellerFeedback()
                    }
                } else {
                    //Forcing user to logout.
                    UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                        SessionManager.logout()
                        FBSDKLoginManager().logOut()
                        GPPSignIn.sharedInstance().signOut()
                        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegate.startPage()
                    })
                }
            })
        }
        
    }
    
    func didTapReload() {
        self.emptyView?.hidden = true
    }
    
    //MARK: -
    //MARK: Customize navigation bar - adding back button
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    //MARK: -
    //MARK: Back
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    //MARK: UiTableView delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section != 3 {
            return 1
        } else {
            if self.sellerModelFeedback != nil {
                if self.sellerModelFeedback!.reviews.count > 3 {
                    return 4
                } else if self.sellerModelFeedback!.reviews.count == 0 {
                    return 1
                } else {
                    return self.sellerModelFeedback!.reviews.count
                }
            } else {
                return 0
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let aboutSellerTableViewCell: AboutSellerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Seller.aboutSellerTableViewCellNibNameAndIdentifier) as! AboutSellerTableViewCell
            //aboutSellerTableViewCell.aboutLabel.text = self.sellerModel!.sellerAbout
            aboutSellerTableViewCell.aboutLabel.text = self.storeDescription
            aboutSellerTableViewCell.aboutTitleLabel.text = aboutSeller
            
            return aboutSellerTableViewCell
        } else if indexPath.section == 1 {
            let productsTableViewCell: ProductsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Seller.productsTableViewCellNibNameAndIdentifier) as! ProductsTableViewCell
            productsTableViewCell.productModels = sellerModel!.products
            productsTableViewCell.productsLabel.text = productsTitle
            productsTableViewCell.moreSellersProduct.setTitle(moreSellersProduct, forState: UIControlState.Normal)
            productsTableViewCell.delegate = self
            
            return productsTableViewCell
        } else if indexPath.section == 2 {
            let generalRatingTableViewCell: GeneralRatingTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Seller.generalRatingTableViewCellNibNameAndIndentifier) as! GeneralRatingTableViewCell
            
            generalRatingTableViewCell.productRatingLabel.text = productRatings
            
            if self.sellerModel != nil {
                generalRatingTableViewCell.setRating(self.sellerModel!.rating)
            } else {
                generalRatingTableViewCell.setRating(0)
            }
            
            return generalRatingTableViewCell
        } else {
            if self.sellerModelFeedback!.reviews.count != 0 {
                if indexPath.row == 3 {
                    let noReviewCell: NoReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("NoReviewTableViewCell") as! NoReviewTableViewCell
                    noReviewCell.noReviewsLabel.text = "Tap to see more."
                    
                    return noReviewCell
                } else {
                    let reviewCell: ReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ReviewTableViewCell") as! ReviewTableViewCell
                    let reviewModel: ProductReviewsModel = self.sellerModelFeedback!.reviews[indexPath.row]
                    
                    reviewCell.displayPictureImageView.sd_setImageWithURL(NSURL(string: reviewModel.imageUrl)!, placeholderImage: UIImage(named: "dummy-placeholder"))
                    reviewCell.messageLabel.text = reviewModel.review
                    reviewCell.nameLabel.text = reviewModel.fullName
                    reviewCell.setRating(reviewModel.ratingSellerReview)
                    
                    return reviewCell
                }
            } else {
                let noReviewCell: NoReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("NoReviewTableViewCell") as! NoReviewTableViewCell
                noReviewCell.noReviewsLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_NO_REVIEWS_LOCALIZE_KEY")
                return noReviewCell
            }
        }
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView(frame: CGRectMake(0, 0, self.tableView.frame.size.width, 10))
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 3 && indexPath.row == 3 {
            self.sellerTableHeaderViewDidViewFeedBack()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 174
        } else if indexPath.section == 2 {
            return 41
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 174
        } else if indexPath.section == 2 {
            return 41
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK: -
    //MARK: Seller Header View Delegate
    //Show seller's ratings and feedback
    func sellerTableHeaderViewDidViewFeedBack() {
        if self.sellerModelFeedback != nil {
            if sellerModelFeedback?.reviews.count > 5 {
                self.showView()
                var feedBackViewController = FeedBackViewController(nibName: "FeedBackViewController", bundle: nil)
                feedBackViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
                feedBackViewController.providesPresentationContextTransitionStyle = true
                feedBackViewController.definesPresentationContext = true
                feedBackViewController.view.backgroundColor = UIColor.clearColor()
                feedBackViewController.delegate = self
                feedBackViewController.sellerModel = self.sellerModelFeedback!
                feedBackViewController.populateData()
                self.tabBarController?.presentViewController(feedBackViewController, animated: true, completion: nil)
            } else {
                var row = 0
                
                if self.sellerModelFeedback!.reviews.count - 1 >= 0 {
                    row = self.sellerModelFeedback!.reviews.count - 1
                }
                
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forItem: row, inSection: 3), atScrollPosition: .Bottom, animated: true)
            }
        } else {
            Toast.displayToastWithMessage("Fetching seller feedback", view: self.tableView)
        }
    }
    
    //MARK: -
    //MARK: - Follow/Unfollow seller
    func sellerTableHeaderViewDidFollow() {
        
        sellerTableHeaderView.delegate = self
        
        if SessionManager.isLoggedIn() {
            
            if self.is_successful {
                self.sellerTableHeaderView.followButton.tag = 1
            } else {
                self.sellerTableHeaderView.followButton.tag = 2
            }
            
            if self.sellerTableHeaderView.followButton.tag == 1 {
                self.sellerTableHeaderView.followButton.tag = 2
                //self.sellerTableHeaderView.followButton.borderColor = UIColor.clearColor()
                self.sellerTableHeaderView.followButton.setTitle(follow, forState: UIControlState.Normal)
                
                fireUnfollowSeller()
            } else {
                self.sellerTableHeaderView.followButton.tag = 1
                //self.sellerTableHeaderView.followButton.borderColor = UIColor.clearColor()
                self.sellerTableHeaderView.followButton.setTitle(following, forState: UIControlState.Normal)
                
                fireFollowSeller()
            }
        } else {
            self.showAlert(title: Constants.Localized.error, message: self.cannotFollow)
        }
    }
    
    //MARK: -
    //MARK: Message seller
    func sellerTableHeaderViewDidMessage() {
        
        for var i = 0; i < self.contacts.count; i++ {
            if "\(self.sellerId)" == contacts[i].userId {
                self.selectedContact = contacts[i]
            }
        }
        
        if !SessionManager.isLoggedIn() {
            self.showAlert(title: StringHelper.localizedStringWithKey("MESSAGING_TITLE"), message: ProductStrings.cannotMessage)
        } else {
            var isOnline: String = "0"
            if let temp = selectedContact?.isOnline {
                isOnline = temp
            }
            var viewController = MessagingThreadViewController(nibName: "MessagingThreadViewController", bundle: nil)
            if let temp = sellerModel {
                viewController.receiver = MessagingContactModel(userId: "\(self.sellerId)", slug: "", fullName: temp.name, profileImageUrl: temp.avatar.absoluteString!, profileThumbnailImageUrl: temp.avatar.absoluteString!, profileSmallImageUrl: temp.avatar.absoluteString!, profileMediumImageUrl: temp.avatar.absoluteString!, profileLargeImageUrl: temp.avatar.absoluteString!, isOnline: isOnline, hasUnreadMessage: "")
                self.navigationController?.pushViewController(viewController, animated:true)
            }
        }
        
//        
//        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
//        let messagingViewController: MessageThreadVC = (storyBoard.instantiateViewControllerWithIdentifier("MessageThreadVC") as? MessageThreadVC)!
//        
//        for var i = 0; i < self.contacts.count; i++ {
//            if "\(self.sellerId)" == contacts[i].userId {
//                self.selectedContact = contacts[i]
//                self.canMessage = true
//            }
//        }
//        
//        var isOnline = "-1"
//        if (SessionManager.isLoggedIn()){
//            isOnline = "1"
//        } else {
//            isOnline = "0"
//        }
//        
//        messagingViewController.sender = W_Contact(fullName: SessionManager.userFullName() , userRegistrationIds: "", userIdleRegistrationIds: "", userId: SessionManager.accessToken(), profileImageUrl: SessionManager.profileImageStringUrl(), isOnline: isOnline)
//        messagingViewController.recipient = selectedContact
//        
//        if self.canMessage {
//            self.navigationController?.pushViewController(messagingViewController, animated: true)
//        } else {
//            if SessionManager.isLoggedIn() {
//                self.showAlert(title: Constants.Localized.error, message: self.cannotMessage)
//            } else {
//                self.showAlert(title: Constants.Localized.error, message: StringHelper.localizedStringWithKey("VENDOR_PAGE_CANNOT_MESSAGE_LOGIN_LOCALIZE_KEY"))
//            }
//        }
        
    }
    
    //MARK: -
    //MARK: Call seller
    func sellerTableHeaderViewDidCall() {
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel://\(self.sellerContactNumber)" )!) {
            let url = NSURL(string: "tel://\(self.sellerContactNumber)")
            UIApplication.sharedApplication().openURL(url!)
        } else {
            self.showAlert(title: Constants.Localized.error, message: self.cannotCall + " \(self.sellerContactNumber)")
        }
        
    }
    
    //MARK: -
    //MARK: Get buyer's contacts
    func getContactsFromEndpoint(page : String, limit : String, keyword: String){
        
        if (Reachability.isConnectedToNetwork()) {
            
            WebServiceManager.fireGetContactListWithUrl("\(APIAtlas.ACTION_GET_CONTACTS_V2)?access_token=\(SessionManager.accessToken())", keyword: keyword, page: "\(page)", limit: "\(limit)", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                self.yiHud?.hide()
                if successful {
                    if responseObject["isSuccessful"] as! Bool {
                        self.contacts = W_Contact.parseContacts(responseObject as! NSDictionary)
                        self.yiHud?.hide()
                        self.tableView.reloadData()
                    } else {
                        self.showAlert(title: Constants.Localized.error, message: responseObject["message"] as! String)
                    }
                } else {
                    self.contacts = Array<W_Contact>()
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                        self.yiHud?.hide()
                    } else if requestErrorType == .AccessTokenExpired {
                        self.fireRefreshToken()
                    } else if requestErrorType == .PageNotFound {
                        //Page not found
                        Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                        self.yiHud?.hide()
                    } else if requestErrorType == .NoInternetConnection {
                        //No internet connection
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                        self.yiHud?.hide()
                    } else if requestErrorType == .RequestTimeOut {
                        //Request timeout
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                        self.yiHud?.hide()
                    } else if requestErrorType == .UnRecognizeError {
                        //Unhandled error
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                        self.yiHud?.hide()
                    }
                }
            })
        }
    }
    
    //MARK: -
    //MARK: Add empty view on the current view
    func addEmptyView() {
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.contentViewFrame!
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    //MARK: -
    //MARK: Refresh token
    func fireRefreshToken() {
        if SessionManager.isLoggedIn() {
            self.showHUD()
            WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
                (successful, responseObject, requestErrorType) -> Void in
                self.yiHud?.hide()
                
                if successful {
                    SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                    self.getContactsFromEndpoint("1", limit: "30", keyword: "")
                } else {
                    self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                }
            })
        }
        
    }
    
    func productstableViewCellDidTapMoreProductWithTarget(target: String) {
        self.redirectToResultView("target")
    }
    
    func productstableViewCellDidTapProductWithTarget(target: String, type: String, productId: String) {
        self.redirectToProductpageWithProductID(productId)
    }
    
    func redirectToProductpageWithProductID(productID: String) {
        let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        productViewController.tabController = self.tabBarController as! CustomTabBarController
        productViewController.productId = productID
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
    
    func redirectToResultView(target: String) {
        let sellerCategoryViewController: SellerCategoryViewController = SellerCategoryViewController(nibName: "SellerCategoryViewController", bundle: nil)
        sellerCategoryViewController.sellerId = self.sellerId
        self.navigationController!.pushViewController(sellerCategoryViewController, animated: true)
    }
    
    //MARK: -
    //MARK: Show HUD
    func showHUD() {
       self.yiHud = YiHUD.initHud()
       self.yiHud!.showHUDToView(self.view)
    }
    
    //MARK: -
    //MARK: Show and hide dim view
    func showView(){
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = false
            self.dimView.alpha = 0.5
            self.dimView.layer.zPosition = 2
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        })
    }
    
    func dismissDimView() {
        UIView.animateWithDuration(0.3, animations: {
            UIApplication.sharedApplication().statusBarStyle = .LightContent
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.dimView.hidden = true
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
        })
    }
    
    //MARK: -
    //MARK: Show alert dialog box
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: self.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: -
    //MARK: - Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.updateHeaderView()
    }
    
    //MARK: -
    //MARK: - FeedBack View Controller Delegate
    func feedBackViewControllerDidDismiss(feedBackViewController: FeedBackViewController) {
        self.dismissDimView()
    }
}