//
//  SellerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SellerTableHeaderViewDelegate, ProductsTableViewCellDelegate, ViewFeedBackViewControllerDelegate, EmptyViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sellerModel: SellerModel?
    var sellerModel2: SellerModel?
    var followSellerModel: FollowedSellerModel?
    var productReviewModel: ProductReviewsModel?
    var productReviews: [ProductReviewsModel] = [ProductReviewsModel]()
    
    let sellerTableHeaderView: SellerTableHeaderView = SellerTableHeaderView.loadFromNibNamed("SellerTableHeaderView", bundle: nil) as! SellerTableHeaderView
    var is_successful: Bool = false
    
    var hud: MBProgressHUD?
    
    var sellerId: Int = 0
    var sellerContactNumber: String = ""
    var sellerName: String = ""
    
    var dimView: UIView = UIView()
    
    //Localized strings
    let follow: String = StringHelper.localizedStringWithKey("FOLLOW_LOCALIZE_KEY")
    let following: String = StringHelper.localizedStringWithKey("UNFOLLOW_LOCALIZE_KEY")
    let viewFeedback: String = StringHelper.localizedStringWithKey("VIEW_FEEDBACK_LOCALIZE_KEY")
    let vendorTitle: String = StringHelper.localizedStringWithKey("VENDOR_PAGE_TITLE_LOCALIZE_KEY")
    let aboutSeller: String = StringHelper.localizedStringWithKey("ABOUT_SELLER_LOCALIZE_KEY")
    let productsTitle: String = StringHelper.localizedStringWithKey("PRODUCTS_SELLER_LOCALIZE_KEY")
    let moreSellersProduct: String = StringHelper.localizedStringWithKey("MORE_SELLERS_PRODUCT_LOCALIZE_KEY")
    let productRatings: String = StringHelper.localizedStringWithKey("PRODUCT_RATINGS_AND_FEEDBACK_LOCALIZE_KEY")

    var selectedContact : W_Contact?
    var emptyView : EmptyView?
    var conversations = [W_Conversation]()
    var contentViewFrame: CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentViewFrame = self.view.frame
        
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.backButton()
        self.tableView.estimatedRowHeight = 112.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.registerNib()
      
        self.titleView()
        self.fireSeller()
        self.fireSellerFeedback()
        self.getConversationsFromEndpoint("1", limit: "30")
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    func populateData() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clearColor()
        self.headerView()
        self.tableView.reloadData()
    }
    
    func titleView() {
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, 100, 50))
        label.text = vendorTitle
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = label
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func headerView() {
        
        sellerTableHeaderView.delegate = self
        
        sellerTableHeaderView.coverPhotoImageView.sd_setImageWithURL(self.sellerModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder"))
        if SessionManager.isLoggedIn() {
            self.sellerTableHeaderView.followButton.enabled = true
        } else {
             self.sellerTableHeaderView.followButton.enabled = false
        }
        
        if self.is_successful {
            self.sellerTableHeaderView.followButton.layer.borderColor = Constants.Colors.grayLine.CGColor
            self.sellerTableHeaderView.followButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.sellerTableHeaderView.followButton.backgroundColor = UIColor.clearColor()
            self.sellerTableHeaderView.followButton.setTitle(following, forState: UIControlState.Normal)
        } else if !(self.is_successful){
            self.sellerTableHeaderView.followButton.backgroundColor = Constants.Colors.appTheme
            self.sellerTableHeaderView.followButton.borderColor = UIColor.clearColor()
            self.sellerTableHeaderView.followButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.sellerTableHeaderView.followButton.setTitle(follow, forState: UIControlState.Normal)
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
    }
    
    func registerNib() {
        let sellerNib: UINib = UINib(nibName: Constants.Seller.aboutSellerTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(sellerNib, forCellReuseIdentifier: Constants.Seller.aboutSellerTableViewCellNibNameAndIdentifier)
        
        let productsNib: UINib = UINib(nibName: Constants.Seller.productsTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(productsNib, forCellReuseIdentifier: Constants.Seller.productsTableViewCellNibNameAndIdentifier)
        
        let generalRatingNib: UINib = UINib(nibName: Constants.Seller.generalRatingTableViewCellNibNameAndIndentifier, bundle: nil)
        self.tableView.registerNib(generalRatingNib, forCellReuseIdentifier: Constants.Seller.generalRatingTableViewCellNibNameAndIndentifier)
        
        let reviewNib: UINib = UINib(nibName: Constants.Seller.reviewNibName, bundle: nil)
        self.tableView.registerNib(reviewNib, forCellReuseIdentifier: Constants.Seller.reviewIdentifier)
        
        let seeMoreNib: UINib = UINib(nibName: Constants.Seller.seeMoreTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(seeMoreNib, forCellReuseIdentifier: Constants.Seller.seeMoreTableViewCellNibNameAndIdentifier)
    }
    
    func fireSeller() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        println(sellerId)
        let parameters: NSDictionary = ["userId" : sellerId];
        manager.POST(APIAtlas.getSellerInfo, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject["isSuccessful"])
                if responseObject["isSuccessful"] as! Bool {
                    self.sellerModel = SellerModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
                    self.populateData()
                    self.is_successful == self.sellerModel?.is_allowed
                    self.hud?.hide(true)
                } else {
                    self.showAlert(title: "Error", message: responseObject["message"] as! String)
                    self.hud?.hide(true)
                }
          
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    self.hud?.hide(true)
                } else if task.statusCode == 401 {
                    self.requestRefreshToken(SellerRefreshType.Get)
                } else {
                    self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                    self.hud?.hide(true)
                    self.is_successful == self.sellerModel?.is_allowed
                }
                /*
                if error.userInfo != nil {
                    println(error.userInfo)
                    
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        if jsonResult["message"] != nil {
                            self.showAlert(title: jsonResult["message"] as! String, message: nil)
                            self.hud?.hide(true)

                        } else {
                            self.showAlert(title: "Something went wrong", message: nil)
                            self.hud?.hide(true)
                            self.is_successful == self.sellerModel?.is_allowed
                        }
                    }
                } else  {
                    self.showAlert(title: "Error", message: "Something went wrong.")
                    self.hud?.hide(true)
                    self.is_successful == self.sellerModel?.is_allowed
                }
                */
        })
        self.tableView.reloadData()
    }
    
    func fireSellerFeedback() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        println(sellerId)
        let parameters: NSDictionary = ["sellerId" : sellerId];
        manager.POST("\(APIAtlas.buyerSellerFeedbacks)?access_token=\(SessionManager.accessToken())", parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject["isSuccessful"])
            if responseObject["isSuccessful"] as! Bool {
                self.sellerModel2 = SellerModel.parseSellerReviewsDataFromDictionary(responseObject as! NSDictionary)
                
                self.hud?.hide(true)
            } else {
                self.showAlert(title: "Error", message: responseObject["message"] as! String)
                self.hud?.hide(true)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    self.hud?.hide(true)
                } else if task.statusCode == 401 {
                    self.requestRefreshToken(SellerRefreshType.Feedback)
                } else {
                    self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                    self.hud?.hide(true)
                }
                /*
                if error.userInfo != nil {
                    println(error.userInfo)
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        if jsonResult["message"] != nil {
                            self.showAlert(title: jsonResult["message"] as! String, message: nil)
                            self.hud?.hide(true)
                            
                        } else {
                            self.showAlert(title: "Something went wrong", message: nil)
                            self.hud?.hide(true)
                        }
                    }
                } else  {
                    self.showAlert(title: "Error", message: "Something went wrong.")
                    self.hud?.hide(true)
                }
            */
        })
        self.tableView.reloadData()
    }
    
    func fireFollowSeller() {
        
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["sellerId" : sellerId, "access_token" : SessionManager.accessToken()];
        manager.POST(APIAtlas.followSeller, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(responseObject as! NSDictionary)
            //self.populateData()
            self.is_successful = true
            self.sellerTableHeaderView.followButton.tag = 1
            println("result after ff: \(self.is_successful)")
            println("button after ff: \(self.sellerTableHeaderView.followButton.selected)")
            println(self.followSellerModel?.message)
            
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(error.userInfo as! Dictionary<String, AnyObject>)
                    println(self.followSellerModel?.message)
                    self.is_successful = true
                    self.sellerTableHeaderView.followButton.tag = 1
                    println("result after ff error block: \(self.is_successful)")
                    println("button after ff error block: \(self.sellerTableHeaderView.followButton.highlighted)")

                } else if task.statusCode == 401 {
                    self.requestRefreshToken(SellerRefreshType.Follow)
                } else {
                    self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                    self.is_successful = false
                    self.sellerTableHeaderView.followButton.tag = 2
                }

                /*
                //let dictionary: NSDictionary =(data, options: nil, error: nil)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 400 {
                    let data = error.userInfo as! Dictionary<String, AnyObject>
                    self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(error.userInfo as! Dictionary<String, AnyObject>)
                    println(self.followSellerModel?.message)
                    self.is_successful = true
                    self.sellerTableHeaderView.followButton.tag = 1
                    println("result after ff error block: \(self.is_successful)")
                    println("button after ff error block: \(self.sellerTableHeaderView.followButton.highlighted)")
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    self.is_successful = false
                    self.sellerTableHeaderView.followButton.tag = 2
                }
                */
        })
       
    }
    
    func fireUnfollowSeller() {
        
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["sellerId" : sellerId, "access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.unfollowSeller, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(responseObject as! NSDictionary)
                //self.populateData()
                print(self.followSellerModel?.error_description)
                self.hud?.hide(true)
                self.is_successful = false
                self.sellerTableHeaderView.followButton.tag = 2
                println("result after uff: \(self.is_successful)")
                println("button after uff: \(self.sellerTableHeaderView.followButton.highlighted)")
                println(self.followSellerModel?.isSuccessful)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    let data = error.userInfo as! Dictionary<String, AnyObject>
                    self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(error.userInfo as! Dictionary<String, AnyObject>)
                    print(self.followSellerModel?.message)
                    self.is_successful = false
                    self.sellerTableHeaderView.followButton.tag = 2
                } else if task.statusCode == 401 {
                    self.requestRefreshToken(SellerRefreshType.Unfollow)
                } else {
                    self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                    self.is_successful = false
                    self.sellerTableHeaderView.followButton.tag = 2
                }
                /*
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 400 {
                    let data = error.userInfo as! Dictionary<String, AnyObject>
                    self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(error.userInfo as! Dictionary<String, AnyObject>)
                    print(self.followSellerModel?.message)
                    self.is_successful = false
                    self.sellerTableHeaderView.followButton.tag = 2
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    self.is_successful = false
                    self.sellerTableHeaderView.followButton.tag = 2
                }
                */
        })
    }
    
    func requestRefreshToken(type: SellerRefreshType) {
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if type == SellerRefreshType.Follow {
                self.fireFollowSeller()
            } else if type == SellerRefreshType.Unfollow {
                self.fireUnfollowSeller()
            } else if type == SellerRefreshType.Get {
                self.fireSeller()
            } else {
                self.fireSellerFeedback()
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let alertController = UIAlertController(title: Constants.Localized.someThingWentWrong, message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func didTapReload() {
        self.getConversationsFromEndpoint("1", limit: "30")
        self.emptyView?.hidden = true
    }
    
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
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.sellerModel2 != nil {
            return self.sellerModel2!.reviews.count + 3
        } else {
            return 1
        }
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let aboutSellerTableViewCell: AboutSellerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Seller.aboutSellerTableViewCellNibNameAndIdentifier) as! AboutSellerTableViewCell
//                aboutSellerTableViewCell.aboutLabel.text = self.sellerModel!.sellerAbout
            aboutSellerTableViewCell.aboutLabel.text = self.sellerModel?.store_description
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
            
            if self.sellerModel2 != nil {
               generalRatingTableViewCell.setRating(self.sellerModel2!.rating)
            } else {
                generalRatingTableViewCell.setRating(0)
            }
            
            return generalRatingTableViewCell
        } else {
            let index: Int = indexPath.section - 3
            let reviewCell: ReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Seller.reviewIdentifier) as! ReviewTableViewCell
            
            let reviewModel: ProductReviewsModel = self.sellerModel2!.reviews[index]
            
            reviewCell.displayPictureImageView.sd_setImageWithURL(NSURL(string: reviewModel.imageUrl)!, placeholderImage: UIImage(named: "dummy-placeholder"))
//            reviewCell.messageLabel.text = reviewModel.message
//            reviewCell.nameLabel.text = reviewModel.name
            reviewCell.messageLabel.text = reviewModel.review
            reviewCell.nameLabel.text = reviewModel.fullName
            println("rating \(self.sellerModel2!.rating)")
            reviewCell.setRating(reviewModel.ratingSellerReview)
            return reviewCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section >= 3 {
            return 0
        } else {
            return 10
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
    
    //MARK: Seller Header View Delegate
    func sellerTableHeaderViewDidViewFeedBack() {
        println("view feedback")
        self.showView()
        var attributeModal = ViewFeedBackViewController(nibName: "ViewFeedBackViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.sellerId = self.sellerId
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.screenWidth = self.view.frame.width
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
    }
    
    func sellerTableHeaderViewDidFollow() {
        //println("follow")
        
        sellerTableHeaderView.delegate = self
        println("result: \(self.is_successful)")
        println("button: \(self.sellerTableHeaderView.followButton.selected)")
        if self.is_successful {
            self.sellerTableHeaderView.followButton.tag = 1
        } else {
            self.sellerTableHeaderView.followButton.tag = 2
        }
        if self.sellerTableHeaderView.followButton.tag == 1 {
            self.sellerTableHeaderView.followButton.tag = 2
            self.sellerTableHeaderView.followButton.backgroundColor = Constants.Colors.appTheme
            self.sellerTableHeaderView.followButton.borderColor = UIColor.clearColor()
            self.sellerTableHeaderView.followButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
             self.sellerTableHeaderView.followButton.setTitle(follow, forState: UIControlState.Normal)
            fireUnfollowSeller()
        } else {
            self.sellerTableHeaderView.followButton.tag = 1
            self.sellerTableHeaderView.followButton.layer.borderColor = Constants.Colors.grayLine.CGColor
            self.sellerTableHeaderView.followButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            self.sellerTableHeaderView.followButton.backgroundColor = UIColor.clearColor()

            self.sellerTableHeaderView.followButton.setTitle(following, forState: UIControlState.Normal)
            fireFollowSeller()
        }
        
    }
    
    func sellerTableHeaderViewDidMessage() {
        println("message")
        //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Send message to seller \(self.sellerName).", title: "Message Seller")
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        let messagingViewController: MessageThreadVC = (storyBoard.instantiateViewControllerWithIdentifier("MessageThreadVC") as? MessageThreadVC)!
        for var i = 0; i < self.conversations.count; i++ {
            println("\(self.sellerId) \(self.conversations[i].sender)")
            if conversations[i].sender == "\(self.sellerId)" {
                self.selectedContact = conversations[i].contact
                println("--- \(conversations[i].contact)")
            } else {
                 println("\(conversations[i].contact)")
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
        self.navigationController?.pushViewController(messagingViewController, animated: true)
    }
    func getConversationsFromEndpoint(
        page : String,
        limit : String){
            
            self.showHUD()
            //SVProgressHUD.show()
            
            let manager: APIManager = APIManager.sharedInstance
            manager.requestSerializer = AFHTTPRequestSerializer()
            
            let parameters: NSDictionary = [
                "page"          : "\(page)",
                "limit"         : "\(limit)",
                "access_token"  : SessionManager.accessToken()
                ]   as Dictionary<String, String>
            
            /* uncomment + "a" to test retry sending */
            let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONVERSATION_HEAD //+ "a"
            manager.POST(url, parameters: parameters, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.conversations = W_Conversation.parseConversations(responseObject as! NSDictionary)
                println(responseObject)
                self.hud?.hide(true)
                //SVProgressHUD.dismiss()
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    
                    println("REACHABILITY \(Reachability.isConnectedToNetwork())")
                    if (Reachability.isConnectedToNetwork()){
                        let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                        
                        if task.statusCode == 401 {
                            if (SessionManager.isLoggedIn()){
                                self.fireRefreshToken()
                            }
                        } else {
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                        }
                        
                        self.conversations = Array<W_Conversation>()
                        
                        self.hud?.hide(true)
                        //SVProgressHUD.dismiss()
                        
                        self.addEmptyView()
                        
                    } else {
                        self.addEmptyView()
                    }
            })
            
    }
    
    func addEmptyView() {
        println(self.emptyView)
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.contentViewFrame!
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    func sellerTableHeaderViewDidCall() {
        println("call")
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:\(self.sellerContactNumber)" )!) {
            println("can call")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Calling number action \(self.sellerContactNumber).", title: "Call Seller")
        } else {
            println("cant make a call")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Cannot make a call to \(self.sellerContactNumber).", title: "Call Seller")
        }

    }
    
    func fireRefreshToken() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SVProgressHUD.dismiss()
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
        })
        
    }
    
    func productstableViewCellDidTapMoreProductWithTarget(target: String) {
        println("Target: \(target)")
        self.redirectToResultView("target")
    }
    
    func productstableViewCellDidTapProductWithTarget(target: String, type: String) {
        self.redirectToProductpageWithProductID("1")
    }
    
    func redirectToProductpageWithProductID(productID: String) {
        let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
    
    func redirectToResultView(target: String) {
        /*let resultViewController: ResultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
        self.navigationController!.pushViewController(resultViewController, animated: true)
        */
        let sellerCategoryViewController: SellerCategoryViewController = SellerCategoryViewController(nibName: "SellerCategoryViewController", bundle: nil)
        sellerCategoryViewController.sellerId = self.sellerId
        self.navigationController!.pushViewController(sellerCategoryViewController, animated: true)
    }
    
    //MARK: Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
  
    //MARK: Show and hide dim view
    
    func showView(){
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = false
            self.dimView.alpha = 0.5
            self.dimView.layer.zPosition = 2
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.93)
        })
    }
    
    func dismissDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = true
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
        })
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

}
