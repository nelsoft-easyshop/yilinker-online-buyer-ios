//
//  ViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct HomeStrings {
    static let featured: String = StringHelper.localizedStringWithKey("FEATURED_LOCALIZE_KEY")
    static let hotItems: String = StringHelper.localizedStringWithKey("HOT_ITEMS_LOCALIZE_KEY")
    static let newItem: String = StringHelper.localizedStringWithKey("NEW_ITEMS_LOCALIZE_KEY")
    static let seller: String = StringHelper.localizedStringWithKey("SELLERS_LOCALIZE_KEY")
    
    static let wishlistError: String = StringHelper.localizedStringWithKey("WISHLIST_ERROR_LOCALIZE_KEY")
    static let error: String = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
    static let somethingWentWrong: String = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
}

struct FABStrings {
    static let signIn: String = StringHelper.localizedStringWithKey("SIGNIN_LOCALIZE_KEY")
    static let help: String = StringHelper.localizedStringWithKey("HELP_LOCALIZE_KEY")
    static let register: String = StringHelper.localizedStringWithKey("REGISTER_LOCALIZE_KEY")
    static let messaging: String = StringHelper.localizedStringWithKey("MESSAGING_LOCALIZE_KEY")
    static let customizeShopping: String = StringHelper.localizedStringWithKey("CUSTOMIZE_SHOPPING_LOCALIZE_KEY")
    static let todaysPromo: String = StringHelper.localizedStringWithKey("TODAYS_PROMO_LOCALIZE_KEY")
    static let categories: String = StringHelper.localizedStringWithKey("CATEGORIES_LOCALIZE_KEY")
    static let mustBeSignIn: String = StringHelper.localizedStringWithKey("MUST_BE_SIGNIN_LOCALIZE_KEY")
    static let followedSeller: String = StringHelper.localizedStringWithKey("FOLLOWED_SELLER_LOCALIZE_KEY")
    static let logout: String = StringHelper.localizedStringWithKey("LOGOUT_LOCALIZE_KEY")
    static let profile: String = StringHelper.localizedStringWithKey("PROFILE_LOCALIZE_KEY")
}

class HomeContainerViewController: UIViewController, UITabBarControllerDelegate, EmptyViewDelegate, CarouselCollectionViewCellDataSource, CarouselCollectionViewCellDelegate, HalfPagerCollectionViewCellDelegate, HalfPagerCollectionViewCellDataSource, FlashSaleCollectionViewCellDelegate, LayoutHeaderCollectionViewCellDelegate, SellerCarouselCollectionViewCellDataSource, SellerCarouselCollectionViewCellDelegate, LayoutNineCollectionViewCellDelegate, DailyLoginCollectionViewCellDataSource, DailyLoginCollectionViewCellDelegate {
    
    var searchViewContoller: SearchViewController?
    var circularMenuViewController: CircularMenuViewController?
    var wishlisViewController: WishlistViewController?
    var cartViewController: CartViewController?
    
    var emptyView: EmptyView?
    var hud: MBProgressHUD?
    var profileModel: ProfileUserDetailsModel = ProfileUserDetailsModel()
    var customTabBarController: CustomTabBarController?
    
    var layouts: [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backToTopButton: UIButton!
    
    var images: [String] = ["http://www.nognoginthecity.com/wp-content/uploads/2014/11/20141023_BRA_NA_Penshoppe-CB-women_NA_penshoppe-1.jpg", "http://www.manilaonsale.com/wp-content/uploads/2013/03/Penshoppe-Sale-March-2013.jpg", "http://www.manilaonsale.com/wp-content/uploads/2013/07/Penshoppe-Mid-Year-Clearance-Sale-July-2013.jpg", "http://cdn.soccerbible.com/media/8733/adidas-hunt-pack-supplied-img4.jpg", "http://demandware.edgesuite.net/sits_pod14-adidas/dw/image/v2/aagl_prd/on/demandware.static/-/Sites-adidas-AME-Library/default/dw2ec04560/brand/images/2015/06/adidas-originals-fw15-xeno-zx-flux-fc-double_70190.jpg?sw=470&sh=264&sm=fit&cx=10&cy=0&cw=450&ch=254&sfrm=jpg"]
    
    let placeHolder: String = "dummy-placeholder"
    
    let carouselCellNibName = "CarouselCollectionViewCell"
    let dailyLoginNibName = "DailyLoginCollectionViewCell"
    let halfPagerCellNibName = "HalfPagerCollectionViewCell"
    let flashSaleNibName = "FlashSaleCollectionViewCell"
    let verticalImageNibName = "VerticalImageCollectionViewCell"
    let halfVerticalNibName = "HalfVerticalImageCollectionViewCell"
    let sectionBackgroundNibName = "SectionBackground"
    let sectionHeaderNibName = "LayoutHeaderCollectionViewCell"
    let fullImageCellNib = "FullImageCollectionViewCell"
    let sellerNibName = "SellerCollectionViewCell"
    let sellerCarouselNibName = "SellerCarouselCollectionViewCell"
    let layoutNineNibName = "LayoutNineCollectionViewCell"
    let twoColumnGridCell = "TwoColumnGridCollectionViewCell"
    
    var remainingTime: Int = 0
    
    var firstHourString: String = ""
    var secondHourString: String = ""
    
    var firstMinString: String = ""
    var secondMinString: String = ""
    
    var firstSecondsString: String = ""
    var secondSecondsString: String = ""
    
    var homePageModel: HomePageModel = HomePageModel()
    
    var timer: NSTimer = NSTimer()
    var oneHourIntervalTimer: NSTimer = NSTimer()
    var updateUsingOneHourInterval: Bool = false
    
    //MARK: - Life Cycle
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if self.view.window != nil && self.remainingTime == -1 {
            Delay.delayWithDuration(1.0, completionHandler: { (success) -> Void in
                self.timer.invalidate()
                self.oneHourIntervalTimer.invalidate()
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.changeRootToHomeView()
            })
        }
    }
    
    deinit {
        // perform the deinitialization
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //header
        self.registerHeaderCollectionView(self.sectionHeaderNibName)
        self.registerCellWithNibName(self.carouselCellNibName)
        self.registerCellWithNibName(self.dailyLoginNibName)
        self.registerCellWithNibName(self.halfPagerCellNibName)
        self.registerCellWithNibName(self.flashSaleNibName)
        self.registerCellWithNibName(self.verticalImageNibName)
        self.registerCellWithNibName(self.halfVerticalNibName)
        self.registerCellWithNibName(self.fullImageCellNib)
        self.registerCellWithNibName(self.sellerNibName)
        self.registerCellWithNibName(self.sellerCarouselNibName)
        self.registerCellWithNibName(self.layoutNineNibName)
        self.registerCellWithNibName(self.twoColumnGridCell)
        
        if Reachability.isConnectedToNetwork() {
            self.fireGetHomePageData(true)
        } else {
            self.addEmptyView()
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRegistration:",
            name: appDelegate.registrationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNewMessage:",
            name: appDelegate.messageKey, object: nil)
        
        self.view.layoutIfNeeded()
        //set customTabbar
        self.customTabBarController = self.tabBarController as? CustomTabBarController
        self.customTabBarController?.isValidToSwitchToMenuTabBarItems = false
        self.circularDraweView()
        self.tabBarController!.delegate = self
        
        self.backToTopButton.layer.cornerRadius = 15
        self.setupBackToTopButton()
        
        self.addPullToRefresh()
    }
    
    //MARK: - Add Pull To Refresh
    func addPullToRefresh() {
        let options = PullToRefreshOption()
        options.backgroundColor = UIColor.clearColor()
        options.indicatorColor = UIColor.darkGrayColor()
        
        self.collectionView.addPullToRefresh(options: options, refreshCompletion: { [weak self] in
            // some code
            Delay.delayWithDuration(1.0, completionHandler: { (success) -> Void in
                self!.timer.invalidate()
                self!.oneHourIntervalTimer.invalidate()
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.changeRootToHomeView()
            })
            })
    }
    
    //MARK: - Back To Top Button
    func setupBackToTopButton() {
        self.backToTopButton.layer.cornerRadius = 15
        self.backToTopButton.alpha = 0
        self.backToTopButton.backgroundColor = Constants.Colors.appTheme
        self.backToTopButton.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.backToTopButton.layer.shadowOffset = CGSizeMake(0, 5)
        self.backToTopButton.layer.shadowRadius = 5
        self.backToTopButton.layer.shadowOpacity = 1.0
    }
    
    //MARK: - collectionViewLayout()
    func collectionViewLayout() {
        let homePageCollectionViewLayout: HomePageCollectionViewLayout2 = HomePageCollectionViewLayout2()
        homePageCollectionViewLayout.homePageModel = self.homePageModel
        homePageCollectionViewLayout.layouts = self.layouts
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = homePageCollectionViewLayout
        //decoration view
        self.registerDecorationView(self.sectionBackgroundNibName)
    }
    
    //MARK: - Register Header Collection View
    func registerHeaderCollectionView(nibName: String) {
        var layoutHeaderCollectionViewNib: UINib = UINib(nibName: nibName, bundle: nil)
        collectionView!.registerNib(layoutHeaderCollectionViewNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: nibName)
    }
    
    //MARK: - Register Decoration View
    func registerDecorationView(nibName: String) {
        var decorationViewNib: UINib = UINib(nibName: nibName, bundle: nil)
        self.collectionView?.collectionViewLayout.registerNib(decorationViewNib, forDecorationViewOfKind: nibName)
    }
    
    //MARK: - Register Cell
    func registerCellWithNibName(nibName: String) {
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: nibName)
    }
    
    //MARK: - On Registration
    //On Registration
    func onRegistration(notification: NSNotification) {
        if let info = notification.userInfo as? Dictionary<String,String> {
            if let error = info["error"] {
                showAlert("Error registering with GCM", message: error)
            } else if let registrationToken = info["registrationToken"] {
                let message = "Check the xcode debug console for the registration token for the server to send notifications to your device"
                self.fireCreateRegistration(registrationToken)
                println("Registration Successful! \(message)")
            }
        }
    }
    
    //MARK: Show Alert
    //For GCM Alert
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title,
            message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(dismissAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: On Message
    //For GCM Message
    func onNewMessage(notification : NSNotification) {
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding) {
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        var count = SessionManager.getUnReadMessagesCount() + 1
                        SessionManager.setUnReadMessagesCount(count)
                    }
                }
            }
        }
    }
    
    //MARK: Fire Create Registration
    //For GCM Registration
    func fireCreateRegistration(registrationID : String) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "registrationId": "\(registrationID)",
            "access_token"  : SessionManager.accessToken(),
            "deviceType"    : "1"
            ]   as Dictionary<String, String>
        
        let url = APIAtlas.baseUrl + APIAtlas.ACTION_GCM_CREATE
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                println(task.response?.description)
                
                println(error.description)
                if (Reachability.isConnectedToNetwork()) {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: HomeStrings.somethingWentWrong, title: HomeStrings.error)
                    }
                }
                self.hud?.hide(true)
        })
    }
    
    //MARK: - Add Empty View
    //Show this view if theres no internet connection
    func addEmptyView() {
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.view.layoutIfNeeded()
            self.emptyView?.frame = self.view.frame
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
        
        self.collectionView.hidden = true
    }
    
    //MARK: - Tab Bar Delegate
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers![4] as! UIViewController {
            return true
        } else if viewController == tabBarController.viewControllers![3] as! UIViewController {
            if SessionManager.isLoggedIn() {
                return true
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: HomeStrings.wishlistError, title: HomeStrings.error)
                return false
            }
        } else if self != viewController && viewController != tabBarController.viewControllers![2] as! UIViewController {
            return true
        } else if self.customTabBarController?.isValidToSwitchToMenuTabBarItems != true {
            let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
            var animatedViewController: CircularMenuViewController?
            animatedViewController  = storyBoard.instantiateViewControllerWithIdentifier("CircularMenuViewController") as? CircularMenuViewController
            animatedViewController!.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            animatedViewController!.providesPresentationContextTransitionStyle = true
            animatedViewController!.definesPresentationContext = true
            animatedViewController!.view.backgroundColor = UIColor.clearColor()
            
            if SessionManager.isLoggedIn() {
                var buttonImages: [String] = ["fab_following", "fab_messaging", "fab_category", "fab_help", SessionManager.profileImageStringUrl()]
                var buttonTitles: [String] = [FABStrings.followedSeller, FABStrings.messaging, FABStrings.categories, FABStrings.help, FABStrings.profile]
                
                var buttonRightText: [String] = ["", SessionManager.unreadMessageCount(), "", "", "\(SessionManager.userFullName()) \n \(SessionManager.city()) \(SessionManager.province())"]
                
                animatedViewController?.buttonImages = buttonImages
                animatedViewController?.buttonTitles = buttonTitles
                animatedViewController?.buttonRightText = buttonRightText
            } else {
                var buttonImages: [String] = ["fab_register", "fab_signin", "fab_category", "fab_help"]
                var buttonTitles: [String] = ["REGISTER", FABStrings.signIn, FABStrings.categories, FABStrings.help]
                var buttonRightText: [String] = ["", "", "", "", ""]
                
                animatedViewController?.buttonImages = buttonImages
                animatedViewController?.buttonTitles = buttonTitles
                animatedViewController?.buttonRightText = buttonRightText
            }
            animatedViewController?.customTabBarController = self.customTabBarController!
            self.tabBarController?.presentViewController(animatedViewController!, animated: false, completion: nil)
            return false
        } else {
            return true
        }
        
        
    }
    
    //MARK: - Circular Drawer View
    //Function for changin tabBar item to circle
    func circularDraweView() {
        let unselectedImage: UIImage = UIImage(named: "circular-drawer")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let item2: UITabBarItem = self.tabBarController?.tabBar.items![2] as! UITabBarItem
        item2.selectedImage = unselectedImage
        item2.image = unselectedImage
        item2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    //MARK: - Fire Get Home Page Data
    //Request for getting json data for populating homepage
    func fireGetHomePageData(showHuD: Bool) {
        if showHuD {
            self.showHUD()
        }
        
        WebServiceManager.fireGetHomePageDataWithUrl(APIAtlas.homeUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.populateHomePageWithDictionary(responseObject as! NSDictionary)
                self.hud?.hide(true)
                self.collectionView.hidden = false
                //get user info
                if SessionManager.isLoggedIn() {
                    self.fireGetUserInfo()
                } else {
                    SessionManager.saveCookies()
                }
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
        })
    }
    
    //MARK: - Populate Home PageWith  Dictionary
    func populateHomePageWithDictionary(dictionary: NSDictionary) {
        self.collectionView.hidden = false
        self.homePageModel = HomePageModel.parseDataFromDictionary(dictionary)
        self.layouts.removeAll(keepCapacity: true)
        for (index, model) in enumerate(self.homePageModel.data) {
            if model.isKindOfClass(LayoutOneModel) {
                self.layouts.append("1")
            } else if model.isKindOfClass(LayoutTwoModel) {
                self.layouts.append("2")
            } else if model.isKindOfClass(LayoutThreeModel) {
                self.layouts.append("3")
            } else if model.isKindOfClass(LayoutFourModel) {
                let layoutFourModel: LayoutFourModel = self.homePageModel.data[index] as! LayoutFourModel
                
                if layoutFourModel.remainingTime != 0 {
                    self.remainingTime = layoutFourModel.remainingTime
                    self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
                    self.layouts.append("4")
                } else {
                    self.homePageModel.data.removeAtIndex(index)
                }

            } else if model.isKindOfClass(LayoutFiveModel) {
                self.layouts.append("5")
            } else if model.isKindOfClass(LayoutSixModel) {
                self.layouts.append("6")
            } else if model.isKindOfClass(LayoutSevenModel) {
                self.layouts.append("7")
            } else if model.isKindOfClass(LayoutEightModel) {
                self.layouts.append("8")
            } else if model.isKindOfClass(LayoutNineModel) {
                self.layouts.append("9")
            } else if model.isKindOfClass(LayoutTenModel) {
                self.layouts.append("10")
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
            self.collectionViewLayout()
        })
    }
    
    //MARK: - Getting User Info
    func fireGetUserInfo() {
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        self.showHUD()
        manager.POST(APIAtlas.getUserInfoUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let dictionary: NSDictionary = responseObject as! NSDictionary
            self.profileModel = ProfileUserDetailsModel.parseDataWithDictionary(dictionary["data"]!)
            
            //Insert Data to Session Manager
            SessionManager.setFullAddress(self.profileModel.address.fullLocation)
            SessionManager.setUserFullName(self.profileModel.fullName)
            SessionManager.setAddressId(self.profileModel.address.userAddressId)
            SessionManager.setCartCount(self.profileModel.cartCount)
            SessionManager.setWishlistCount(self.profileModel.wishlistCount)
            SessionManager.setProfileImage(self.profileModel.profileImageUrl)
            
            SessionManager.setCity(self.profileModel.address.city)
            SessionManager.setProvince(self.profileModel.address.province)
            
            println(self.profileModel.address.latitude)
            println(self.profileModel.address.longitude)
            
            SessionManager.setLang(self.profileModel.address.latitude)
            SessionManager.setLong(self.profileModel.address.longitude)
            
            self.updateTabBarBadge()
            
            
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: HomeStrings.somethingWentWrong, title: HomeStrings.error)
                }
                
                self.hud?.hide(true)
        })
    }
    
    //MARK: - Update Tab Bar Badge
    func updateTabBarBadge() {
        if SessionManager.wishlistCount() != 0 {
            let badgeValue = (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue?.toInt()
            (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue = "\(SessionManager.wishlistCount())"
        } else {
            (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue = nil
        }
        
        if SessionManager.cartCount() != 0 {
            let badgeValue = (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue?.toInt()
            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = "\(SessionManager.cartCount())"
        } else {
            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = nil
        }
    }
    
    //MARK: - Fire Refresh Token
    func fireRefreshToken() {
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID(), "client_secret": Constants.Credentials.clientSecret(), "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        self.showHUD()
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.hud?.hide(true)
            self.fireGetUserInfo()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    FBSDKLoginManager().logOut()
                    GPPSignIn.sharedInstance().signOut()
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.startPage()
                })
                
                self.hud?.hide(true)
        })
        
    }
    
    //MARK: - Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.tabBarController!.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    // MARK: - Did Tap Reload
    func didTapReload() {
        self.fireGetHomePageData(true)
        self.emptyView?.hidden = true
    }
    
    //MARK: - UICollectionView Data Source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return self.layouts.count
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch (self.layouts[section].toInt()!) {
        case 1:
            return 1
        case 2:
            return 1
        case 3:
            return 1
        case 4:
            return 1
        case 5:
            return 3
        case 6:
            return 3
        case 7:
            return 3
        case 8:
            return 1
        case 9:
            return 1
        case 10:
            return self.homePageModel.data[section].data.count
        default:
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if self.layouts[indexPath.section] == "1" {
            let carouselCell: CarouselCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.carouselCellNibName, forIndexPath: indexPath) as! CarouselCollectionViewCell
            
            carouselCell.dataSource = self
            carouselCell.delegate = self
            
            return carouselCell
        } else if self.layouts[indexPath.section] == "2" {
            return self.dailyLoginWithWIndexpath(indexPath)
        } else if self.layouts[indexPath.section] == "3" {
            return self.halfPagerWithIndexPath(indexPath)
        } else if self.layouts[indexPath.section] == "4" {
            return self.flashSaleCollectionViewCellWithIndexPath(indexPath)
        } else if self.layouts[indexPath.section] == "5" {
            if indexPath.row == 0 {
                return self.verticalImageCollectionViewCellWithIndexPath(indexPath)
            } else {
                return self.halfVerticalImageCollectionViewCellWithIndexPath(indexPath)
            }
        } else if self.layouts[indexPath.section] == "6" {
            return self.fullImageCollectionViewCellWithIndexPath(indexPath, fullImageCollectionView: self.collectionView)
        } else if self.layouts[indexPath.section] == "7" {
            if indexPath.row == 0 || indexPath.row == 1 {
                return self.halfVerticalImageCollectionViewCellWithIndexPath(indexPath)
            } else {
                return self.verticalImageCollectionViewCellWithIndexPath(indexPath)
            }
        } else if self.layouts[indexPath.section] == "8" {
            return self.sellerCarouselWithIndexPath(indexPath)
        } else if self.layouts[indexPath.section] == "9" {
            return self.layoutNineCollectionViewCellWithIndexPath(indexPath)
        } else if self.layouts[indexPath.section] == "10" {
            return self.twoColumnGridCollectionViewCellWithIndexPath(indexPath)
        } else {
           return UICollectionViewCell()
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView: LayoutHeaderCollectionViewCell = self.collectionView?.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: self.sectionHeaderNibName, forIndexPath: indexPath) as! LayoutHeaderCollectionViewCell
        headerView.delegate = self
        
        if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutFiveModel) {
            let layoutFiveModel: LayoutFiveModel = self.homePageModel.data[indexPath.section] as! LayoutFiveModel
            if layoutFiveModel.isViewMoreAvailable {
                headerView.target = layoutFiveModel.viewMoreTarget.targetUrl
                headerView.targetType = layoutFiveModel.viewMoreTarget.targetType
                headerView.viewMoreButton.hidden = false
            } else {
                headerView.viewMoreButton.hidden = true
            }
            
            headerView.sectionTitle = layoutFiveModel.sectionTitle
            headerView.titleLabel.text = layoutFiveModel.sectionTitle
            headerView.updateTitleLine()
            headerView.backgroundColor = UIColor.whiteColor()
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutSevenModel) {
            let layoutSevenModel: LayoutSevenModel = self.homePageModel.data[indexPath.section] as! LayoutSevenModel
            if layoutSevenModel.isViewMoreAvailable {
                headerView.target = layoutSevenModel.viewMoreTarget.targetUrl
                headerView.targetType = layoutSevenModel.viewMoreTarget.targetType
                headerView.viewMoreButton.hidden = false
            } else {
                headerView.viewMoreButton.hidden = true
            }
            
            headerView.sectionTitle = layoutSevenModel.sectionTitle
            headerView.titleLabel.text = layoutSevenModel.sectionTitle
            headerView.updateTitleLine()
            headerView.backgroundColor = UIColor.whiteColor()
        }  else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutEightModel) {
            let layoutEightModel: LayoutEightModel = self.homePageModel.data[indexPath.section] as! LayoutEightModel
            if layoutEightModel.isViewMoreAvailable {
                headerView.target = layoutEightModel.viewMoreTarget.targetUrl
                headerView.targetType = layoutEightModel.viewMoreTarget.targetType
                headerView.viewMoreButton.hidden = false
            } else {
                headerView.viewMoreButton.hidden = true
            }
            
            headerView.sectionTitle = layoutEightModel.sectionTitle
            headerView.titleLabel.text = layoutEightModel.sectionTitle
            headerView.updateTitleLine()
            headerView.backgroundColor = UIColor.clearColor()
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutNineModel) {
            let layoutNineModel: LayoutNineModel = self.homePageModel.data[indexPath.section] as! LayoutNineModel
            if layoutNineModel.isViewMoreAvailable {
                headerView.target = layoutNineModel.viewMoreTarget.targetUrl
                headerView.targetType = layoutNineModel.viewMoreTarget.targetType
                headerView.viewMoreButton.hidden = false
            } else {
                headerView.viewMoreButton.hidden = true
            }
            
            headerView.sectionTitle = layoutNineModel.sectionTitle
            headerView.titleLabel.text = layoutNineModel.sectionTitle
            headerView.updateTitleLine()
            headerView.backgroundColor = UIColor.clearColor()
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutTenModel) {
            let layoutTenModel: LayoutTenModel = self.homePageModel.data[indexPath.section] as! LayoutTenModel
            if layoutTenModel.isViewMoreAvailable {
                headerView.target = layoutTenModel.viewMoreTarget.targetUrl
                headerView.targetType = layoutTenModel.viewMoreTarget.targetType
                headerView.viewMoreButton.hidden = false
            } else {
                headerView.viewMoreButton.hidden = true
            }
            
            headerView.sectionTitle = layoutTenModel.sectionTitle
            headerView.titleLabel.text = layoutTenModel.sectionTitle
            headerView.updateTitleLine()
            headerView.backgroundColor = UIColor.clearColor()
        }
        
        return headerView
    }
    
    //MARK: - CollectionViewDelegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell: AnyObject = collectionView.cellForItemAtIndexPath(indexPath)!
        
        if cell.isKindOfClass(TwoColumnGridCollectionViewCell) {
            let towColumnCell: TwoColumnGridCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! TwoColumnGridCollectionViewCell
            self.didClickItemWithTarget(towColumnCell.target, targetType: towColumnCell.targetType)
        } else if cell.isKindOfClass(FullImageCollectionViewCell) {
            let fullImageCell: FullImageCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! FullImageCollectionViewCell
            self.didClickItemWithTarget(fullImageCell.target, targetType: fullImageCell.targetType)
        } else if cell.isKindOfClass(HalfVerticalImageCollectionViewCell) {
            let halfVerticalCell: HalfVerticalImageCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! HalfVerticalImageCollectionViewCell
            self.didClickItemWithTarget(halfVerticalCell.target, targetType: halfVerticalCell.targetType)
        } else if cell.isKindOfClass(VerticalImageCollectionViewCell) {
            let verticalCell: VerticalImageCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! VerticalImageCollectionViewCell
            self.didClickItemWithTarget(verticalCell.target, targetType: verticalCell.targetType)
        }
        
        /*else if cell.isKindOfClass(FlashSaleCollectionViewCell) {
            let flashSaleCollectionViewCell: FlashSaleCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! FlashSaleCollectionViewCell
            self.didClickItemWithTarget(flashSaleCollectionViewCell.target, targetType: flashSaleCollectionViewCell.targetType)
        }*/
    }
    
    //MARK: - Carousel Data Source
    func carouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell, numberOfItemsInSection section: Int) -> Int {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(carouselCollectionViewCell)!
        let layoutOneModel: LayoutOneModel = self.homePageModel.data[parentIndexPath.section] as! LayoutOneModel
        
        return layoutOneModel.data.count
    }
    
    func carouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(carouselCollectionViewCell)!
        let layoutOneModel: LayoutOneModel = self.homePageModel.data[parentIndexPath.section] as! LayoutOneModel
        
        return self.fullImageCollectionViewCellWithIndexPath(indexPath, fullImageCollectionView: carouselCollectionViewCell.collectionView)
    }
    
    func itemWidthInCarouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell) -> CGFloat {
        carouselCollectionViewCell.layoutIfNeeded()
        return carouselCollectionViewCell.collectionView.frame.size.width
    }
    
    //MARK: - Carousel Delegate
    func carouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let fullImageCell: FullImageCollectionViewCell = carouselCollectionViewCell.collectionView.cellForItemAtIndexPath(indexPath) as! FullImageCollectionViewCell
        
        self.didClickItemWithTarget(fullImageCell.target, targetType: fullImageCell.targetType)
    }
    
    func carouselCollectionViewCellDidEndDecelerating(carouselCollectionViewCell: CarouselCollectionViewCell) {
        carouselCollectionViewCell.layoutIfNeeded()
        let pageWidth: CGFloat = carouselCollectionViewCell.collectionView.frame.size.width
        let currentPage: CGFloat = carouselCollectionViewCell.collectionView.contentOffset.x / pageWidth
        
        if 0.0 != fmodf(Float(currentPage), 1.0) {
            carouselCollectionViewCell.pageControl.currentPage = Int(currentPage) + 1
        }
        else {
            carouselCollectionViewCell.pageControl.currentPage = Int(currentPage)
        }
    }
    
    //MARK: - Half Pager Data Source
    func halfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell, numberOfItemsInSection section: Int) -> Int {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(halfPagerCollectionViewCell)!
        let layoutThreeModel: LayoutThreeModel = self.homePageModel.data[parentIndexPath.section] as! LayoutThreeModel
        
        return layoutThreeModel.data.count
    }
    
    func halfPagerCollectionViewCellnumberOfDotsInPageControl(halfPagerCollectionViewCell: HalfPagerCollectionViewCell) -> Int {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(halfPagerCollectionViewCell)!
        let layoutThreeModel: LayoutThreeModel = self.homePageModel.data[parentIndexPath.section] as! LayoutThreeModel
    
        return layoutThreeModel.data.count - 1
    }
    
    func halfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(halfPagerCollectionViewCell)!
        let layoutThreeModel: LayoutThreeModel = self.homePageModel.data[parentIndexPath.section] as! LayoutThreeModel
        
        let fullImageCell: FullImageCollectionViewCell = halfPagerCollectionViewCell.collectionView.dequeueReusableCellWithReuseIdentifier(halfPagerCollectionViewCell.fullImageCellNib, forIndexPath: indexPath) as! FullImageCollectionViewCell
        fullImageCell.itemProductImageView.sd_setImageWithURL(NSURL(string: layoutThreeModel.data[indexPath.row].image), placeholderImage: UIImage(named: "dummy-placeholder"))
        fullImageCell.target = layoutThreeModel.data[indexPath.row].target.targetUrl
        fullImageCell.targetType = layoutThreeModel.data[indexPath.row].target.targetType
        fullImageCell.layer.cornerRadius = 5
        fullImageCell.clipsToBounds = true
        
        return fullImageCell
    }
    
    func itemWidthHalfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell) -> CGFloat {
        let rightInset: Int = 15
        self.view.layoutIfNeeded()
        
            if IphoneType.isIphone6() || IphoneType.isIphone6Plus() {
                println((self.view.frame.size.width / 2) - 8)
                return (self.view.frame.size.width / 2) - 8
            } else {
                return (self.view.frame.size.width / 2) - 8
            }
    }
    
    //MARK: - Half Pager Delegate
    func halfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let fullImageCell: FullImageCollectionViewCell = halfPagerCollectionViewCell.collectionView.cellForItemAtIndexPath(indexPath) as! FullImageCollectionViewCell
        self.didClickItemWithTarget(fullImageCell.target, targetType: fullImageCell.targetType)
    }
    
    func halfPagerCollectionViewCellDidEndDecelerating(halfPagerCollectionViewCell: HalfPagerCollectionViewCell) {
        halfPagerCollectionViewCell.layoutIfNeeded()
        let pageWidth: CGFloat = (halfPagerCollectionViewCell.collectionView.frame.size.width - 8) / 2
        let currentPage: CGFloat = halfPagerCollectionViewCell.collectionView.contentOffset.x / pageWidth
        
        if 0.0 != fmodf(Float(currentPage), 1.0) {
            halfPagerCollectionViewCell.pageControl.currentPage = Int(currentPage) + 1
        }
        else {
            halfPagerCollectionViewCell.pageControl.currentPage = Int(currentPage)
        }
    }
    
    //MARK: - Flash Collection View Delegate
    func flashSaleCollectionViewCell(didTapProductImageView productImageView: ProductImageView) {
        self.didClickItemWithTarget(productImageView.target, targetType: productImageView.targetType)
    }
    
    //MARK: - Seconds To Hours Minutes Seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: - Update Time
    func updateTime() {
        if self.remainingTime > -1 {
            remainingTime--
        }
        
        if remainingTime >= 0 {
            let (hour, min, seconds): (Int, Int, Int) = self.secondsToHoursMinutesSeconds(self.remainingTime)
            
            var sampleDate: String = "\(hour) Hours, \(min) Minutes, \(seconds) Seconds"
            
            if hour < 10 {
                firstHourString = "\(hour)"
                secondHourString = "0"
            } else {
                firstHourString = "\(hour)".stringCharacterAtIndex(1)
                secondHourString = "\(hour)".stringCharacterAtIndex(0)
            }
            
            if min < 10 {
                firstMinString = "\(min)"
                secondMinString = "0"
            } else {
                firstMinString = "\(min)".stringCharacterAtIndex(1)
                secondMinString = "\(min)".stringCharacterAtIndex(0)
            }
            
            if seconds < 10 {
                firstSecondsString = "\(seconds)"
                secondSecondsString = "0"
            } else {
                firstSecondsString = "\(seconds)".stringCharacterAtIndex(1)
                secondSecondsString = "\(seconds)".stringCharacterAtIndex(0)
            }
            
            for (index, model) in enumerate(self.homePageModel.data) {
                if model.isKindOfClass(LayoutFourModel) {
                    if let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: index) {
                        self.collectionView.reloadItemsAtIndexPaths([indexPath])
                    }
                    
                    break
                }
            }

        } else {
            /*if self.updateUsingOneHourInterval {
                self.updateUsingOneHourInterval = false
                if self.remainingTime == -1 {
                    self.timer.invalidate()
                    self.oneHourIntervalTimer.invalidate()
                }
                
            } else {
                self.timer.invalidate()
                self.oneHourIntervalTimer.invalidate()
                self.updateUsingOneHourInterval = true
                
                if self.remainingTime == -1 {
                    //self.fireGetHomePageData(true)
                    
                    if self.view.window != nil {
                        Delay.delayWithDuration(1.0, completionHandler: { (success) -> Void in
                            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegate.changeRootToHomeView()
                        })
                    }
                }
            }*/
            
            Delay.delayWithDuration(1.0, completionHandler: { (success) -> Void in
                self.timer.invalidate()
                if self.view.window != nil && self.remainingTime == -1 {
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.changeRootToHomeView()
                }
            })
            
            
        }

    }
    
    //MARK: - Flash Sale Collection View Cell With IndexPath
    func flashSaleCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> FlashSaleCollectionViewCell {
        let layoutFourModel: LayoutFourModel = self.homePageModel.data[indexPath.section] as! LayoutFourModel
        
        let flashSaleCell: FlashSaleCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.flashSaleNibName, forIndexPath: indexPath) as! FlashSaleCollectionViewCell
        flashSaleCell.delegate = self
        
        flashSaleCell.target = layoutFourModel.target.targetUrl
        flashSaleCell.targetType = layoutFourModel.target.targetType
        
        flashSaleCell.hourFirstDigit.text = self.firstHourString
        flashSaleCell.hourSecondDigit.text = self.secondHourString
        
        flashSaleCell.minuteFirstDigit.text = self.firstMinString
        flashSaleCell.minuteSecondDigit.text = self.secondMinString
        
        flashSaleCell.secondFirstDigit.text = self.firstSecondsString
        flashSaleCell.secondSecondDigit.text = self.secondSecondsString
        
        if layoutFourModel.data.count >= 1 {
            flashSaleCell.productOneImageView.sd_setImageWithURL(NSURL(string: layoutFourModel.data[0].image), placeholderImage: UIImage(named: "dummy-placeholder"))
            flashSaleCell.productOneDiscountLabel.text = "\(layoutFourModel.data[0].discountPercentage)% OFF"
            flashSaleCell.productOneImageView.target = layoutFourModel.data[0].target.targetUrl
            flashSaleCell.productOneImageView.targetType = layoutFourModel.data[0].target.targetType
        }
        
        if layoutFourModel.data.count >= 2 {
            flashSaleCell.productTwoImageView.sd_setImageWithURL(NSURL(string: layoutFourModel.data[1].image), placeholderImage: UIImage(named: "dummy-placeholder"))
            flashSaleCell.productTwoImageView.target = layoutFourModel.data[1].target.targetUrl
            flashSaleCell.productTwoImageView.targetType = layoutFourModel.data[1].target.targetType
            flashSaleCell.productTwoDiscountLabel.text = "\(layoutFourModel.data[1].discountPercentage)% OFF"
        }
        
        if layoutFourModel.data.count >= 3 {
            flashSaleCell.productThreeImageView.sd_setImageWithURL(NSURL(string: layoutFourModel.data[2].image), placeholderImage: UIImage(named: "dummy-placeholder"))
            flashSaleCell.productThreeImageView.target = layoutFourModel.data[2].target.targetUrl
            flashSaleCell.productThreeImageView.targetType = layoutFourModel.data[2].target.targetType
            flashSaleCell.productThreeDiscountLabel.text = "\(layoutFourModel.data[2].discountPercentage) OFF%"
        }
        
        return flashSaleCell
    }
    
    //MARK: - Grid Layout
    func twoColumnGridCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> TwoColumnGridCollectionViewCell {
        let twoColumnGridCollectionViewCell: TwoColumnGridCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("TwoColumnGridCollectionViewCell", forIndexPath: indexPath) as! TwoColumnGridCollectionViewCell
        
        let layoutTenModel: LayoutTenModel = self.homePageModel.data[indexPath.section] as! LayoutTenModel
        
        twoColumnGridCollectionViewCell.target = layoutTenModel.data[indexPath.row].target.targetUrl
        twoColumnGridCollectionViewCell.targetType = layoutTenModel.data[indexPath.row].target.targetType
        
        twoColumnGridCollectionViewCell.productItemImageView.sd_setImageWithURL(NSURL(string: layoutTenModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
        twoColumnGridCollectionViewCell.productNameLabel.text = layoutTenModel.data[indexPath.row].name
        twoColumnGridCollectionViewCell.discountedPriceLabel.text = layoutTenModel.data[indexPath.row].discountedPrice.formatToTwoDecimal()
        twoColumnGridCollectionViewCell.discountPercentageLabel.text = layoutTenModel.data[indexPath.row].discountPercentage.formatToPercentage()
        twoColumnGridCollectionViewCell.originalPriceLabel.text = layoutTenModel.data[indexPath.row].originalPrice.formatToTwoDecimal()
        twoColumnGridCollectionViewCell.originalPriceLabel.drawDiscountLine(false)
        
        if layoutTenModel.data[indexPath.row].discountPercentage.toDouble() == 0 || layoutTenModel.data[indexPath.row].discountPercentage.toDouble() == nil {
            twoColumnGridCollectionViewCell.discountPercentageLabel.hidden = true
            twoColumnGridCollectionViewCell.originalPriceLabel.hidden = true
        } else {
            twoColumnGridCollectionViewCell.discountPercentageLabel.hidden = false
            twoColumnGridCollectionViewCell.originalPriceLabel.hidden = false
        }
        
        return twoColumnGridCollectionViewCell
    }
    
    //MARK: - Layout Nine Collection View Cell With IndexPath
    func layoutNineCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> LayoutNineCollectionViewCell {
        let layoutNineModel: LayoutNineModel = self.homePageModel.data[indexPath.section] as! LayoutNineModel
        
        let layoutNineCollectionViewCell: LayoutNineCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.layoutNineNibName, forIndexPath: indexPath) as! LayoutNineCollectionViewCell
        layoutNineCollectionViewCell.delegate = self
        
        if layoutNineModel.data.count >= 5 {
            layoutNineCollectionViewCell.productOneNameLabel.text = layoutNineModel.data[0].name
            layoutNineCollectionViewCell.productImageViewOne.sd_setImageWithURL(NSURL(string: layoutNineModel.data[0].image), placeholderImage: UIImage(named: self.placeHolder))
            layoutNineCollectionViewCell.productImageViewOne.target = layoutNineModel.data[0].target.targetUrl
            layoutNineCollectionViewCell.productImageViewOne.targetType = layoutNineModel.data[0].target.targetType
            
            layoutNineCollectionViewCell.productTwoNameLabel.text = layoutNineModel.data[1].name
            layoutNineCollectionViewCell.productImageViewTwo.sd_setImageWithURL(NSURL(string: layoutNineModel.data[1].image), placeholderImage: UIImage(named: self.placeHolder))
            layoutNineCollectionViewCell.productImageViewTwo.target = layoutNineModel.data[1].target.targetUrl
            layoutNineCollectionViewCell.productImageViewTwo.targetType = layoutNineModel.data[1].target.targetType
            
            layoutNineCollectionViewCell.productThreeNameLabel.text = layoutNineModel.data[2].name
            layoutNineCollectionViewCell.productImageViewThree.sd_setImageWithURL(NSURL(string: layoutNineModel.data[2].image), placeholderImage: UIImage(named: self.placeHolder))
            layoutNineCollectionViewCell.productImageViewThree.target = layoutNineModel.data[2].target.targetUrl
            layoutNineCollectionViewCell.productImageViewThree.targetType = layoutNineModel.data[2].target.targetType
            
            layoutNineCollectionViewCell.productFourNameLabel.text = layoutNineModel.data[3].name
            layoutNineCollectionViewCell.productImageViewFour.sd_setImageWithURL(NSURL(string: layoutNineModel.data[3].image), placeholderImage: UIImage(named: self.placeHolder))
            layoutNineCollectionViewCell.productImageViewFour.target = layoutNineModel.data[3].target.targetUrl
            layoutNineCollectionViewCell.productImageViewFour.targetType = layoutNineModel.data[3].target.targetType
            
            layoutNineCollectionViewCell.productFiveNameLabel.text = layoutNineModel.data[4].name
            layoutNineCollectionViewCell.productImageViewFive.sd_setImageWithURL(NSURL(string: layoutNineModel.data[4].image), placeholderImage: UIImage(named: self.placeHolder))
            layoutNineCollectionViewCell.productImageViewFive.target = layoutNineModel.data[4].target.targetUrl
            layoutNineCollectionViewCell.productImageViewFive.targetType = layoutNineModel.data[4].target.targetType
        }
        
        return layoutNineCollectionViewCell
    }
    
    //MARK: - Layout Nine Collection View Cell Delegate
    func layoutNineCollectionViewCellDidClickProductImage(productImage: ProductImageView) {
       self.didClickItemWithTarget(productImage.target, targetType: productImage.targetType)
    }
    
    //MARK: - Vertical Image Collection View Cell With IndexPath
    func verticalImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> VerticalImageCollectionViewCell {
        let verticalImageCollectionViewCell: VerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.verticalImageNibName
            , forIndexPath: indexPath) as! VerticalImageCollectionViewCell
        if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutFiveModel) {
            let layoutFiveModel: LayoutFiveModel = self.homePageModel.data[indexPath.section] as! LayoutFiveModel
            if indexPath.row < layoutFiveModel.data.count {
                verticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(NSURL(string: layoutFiveModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
                
                verticalImageCollectionViewCell.productNameLabel.text = layoutFiveModel.data[indexPath.row].name
                verticalImageCollectionViewCell.discountedPriceLabel.text = layoutFiveModel.data[indexPath.row].discountedPrice.formatToTwoDecimal()
                verticalImageCollectionViewCell.discountPercentageLabel.text = layoutFiveModel.data[indexPath.row].discountPercentage.formatToPercentage()
                
                verticalImageCollectionViewCell.target = layoutFiveModel.data[indexPath.row].target.targetUrl
                verticalImageCollectionViewCell.targetType = layoutFiveModel.data[indexPath.row].target.targetType
                
                verticalImageCollectionViewCell.originalPriceLabel.text = layoutFiveModel.data[indexPath.row].originalPrice.formatToTwoDecimal()
                verticalImageCollectionViewCell.originalPriceLabel.drawDiscountLine(false)
                
                if layoutFiveModel.data[indexPath.row].discountPercentage.toDouble() == 0 || layoutFiveModel.data[indexPath.row].discountPercentage.toDouble() == nil {
                    verticalImageCollectionViewCell.discountPercentageLabel.hidden = true
                    verticalImageCollectionViewCell.originalPriceLabel.hidden = true
                } else {
                    verticalImageCollectionViewCell.discountPercentageLabel.hidden = false
                    verticalImageCollectionViewCell.originalPriceLabel.hidden = false
                }
            }
            
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutSevenModel) {
            let layoutSevenModel: LayoutSevenModel = self.homePageModel.data[indexPath.section] as! LayoutSevenModel
            
            if indexPath.row < layoutSevenModel.data.count {
                verticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(NSURL(string: layoutSevenModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
                verticalImageCollectionViewCell.productNameLabel.text = layoutSevenModel.data[indexPath.row].name
                verticalImageCollectionViewCell.discountedPriceLabel.text = layoutSevenModel.data[indexPath.row].discountedPrice.formatToTwoDecimal()
                verticalImageCollectionViewCell.discountPercentageLabel.text = layoutSevenModel.data[indexPath.row].discountPercentage.formatToPercentage()
                
                verticalImageCollectionViewCell.target = layoutSevenModel.data[indexPath.row].target.targetUrl
                verticalImageCollectionViewCell.targetType = layoutSevenModel.data[indexPath.row].target.targetType
                
                verticalImageCollectionViewCell.originalPriceLabel.text = layoutSevenModel.data[indexPath.row].originalPrice.formatToTwoDecimal()
                verticalImageCollectionViewCell.originalPriceLabel.drawDiscountLine(false)
                
                if layoutSevenModel.data[indexPath.row].discountPercentage.toDouble() == 0 || layoutSevenModel.data[indexPath.row].discountPercentage.toDouble() == nil {
                    verticalImageCollectionViewCell.discountPercentageLabel.hidden = true
                    verticalImageCollectionViewCell.originalPriceLabel.hidden = true
                } else {
                    verticalImageCollectionViewCell.discountPercentageLabel.hidden = false
                    verticalImageCollectionViewCell.originalPriceLabel.hidden = false
                }
            }
        }
        
        return verticalImageCollectionViewCell
    }
    
    //MARK: - Half Vertical Image Collection View Cell With IndexPath
    func halfVerticalImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> HalfVerticalImageCollectionViewCell {
        let halfVerticalImageCollectionViewCell: HalfVerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.halfVerticalNibName, forIndexPath: indexPath) as! HalfVerticalImageCollectionViewCell
        
        if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutFiveModel) {
            let layoutFiveModel: LayoutFiveModel = self.homePageModel.data[indexPath.section] as! LayoutFiveModel
           
            if indexPath.row < layoutFiveModel.data.count {
                halfVerticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(NSURL(string: layoutFiveModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
                
                halfVerticalImageCollectionViewCell.productNameLabel.text = layoutFiveModel.data[indexPath.row].name
                halfVerticalImageCollectionViewCell.discountedPriceLabel.text = layoutFiveModel.data[indexPath.row].discountedPrice.formatToTwoDecimal()
                halfVerticalImageCollectionViewCell.discountPercentageLabel.text = layoutFiveModel.data[indexPath.row].discountPercentage.formatToPercentage()
                
                halfVerticalImageCollectionViewCell.target = layoutFiveModel.data[indexPath.row].target.targetUrl
                halfVerticalImageCollectionViewCell.targetType = layoutFiveModel.data[indexPath.row].target.targetType
                
                halfVerticalImageCollectionViewCell.originalPriceLabel.text = layoutFiveModel.data[indexPath.row].originalPrice.formatToTwoDecimal()
                halfVerticalImageCollectionViewCell.originalPriceLabel.drawDiscountLine(false)
                
                if layoutFiveModel.data[indexPath.row].discountPercentage.toDouble() == 0 || layoutFiveModel.data[indexPath.row].discountPercentage.toDouble() == nil {
                    halfVerticalImageCollectionViewCell.discountPercentageLabel.hidden = true
                    halfVerticalImageCollectionViewCell.originalPriceLabel.hidden = true
                } else {
                    halfVerticalImageCollectionViewCell.discountPercentageLabel.hidden = false
                    halfVerticalImageCollectionViewCell.originalPriceLabel.hidden = false
                }
            }
            
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutSevenModel) {
            let layoutSevenModel: LayoutSevenModel = self.homePageModel.data[indexPath.section] as! LayoutSevenModel

            if indexPath.row < layoutSevenModel.data.count {
                halfVerticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(NSURL(string: layoutSevenModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
                
                halfVerticalImageCollectionViewCell.productNameLabel.text = layoutSevenModel.data[indexPath.row].name
                halfVerticalImageCollectionViewCell.discountedPriceLabel.text = layoutSevenModel.data[indexPath.row].discountedPrice.formatToTwoDecimal()
                halfVerticalImageCollectionViewCell.discountPercentageLabel.text = layoutSevenModel.data[indexPath.row].discountPercentage.formatToPercentage()
                
                halfVerticalImageCollectionViewCell.target = layoutSevenModel.data[indexPath.row].target.targetUrl
                halfVerticalImageCollectionViewCell.targetType = layoutSevenModel.data[indexPath.row].target.targetType
                
                halfVerticalImageCollectionViewCell.originalPriceLabel.text = layoutSevenModel.data[indexPath.row].originalPrice.formatToTwoDecimal()
                halfVerticalImageCollectionViewCell.originalPriceLabel.drawDiscountLine(true)
                
                if layoutSevenModel.data[indexPath.row].discountPercentage.toDouble() == 0 || layoutSevenModel.data[indexPath.row].discountPercentage.toDouble() == nil {
                    halfVerticalImageCollectionViewCell.discountPercentageLabel.hidden = true
                    halfVerticalImageCollectionViewCell.originalPriceLabel.hidden = true
                } else {
                    halfVerticalImageCollectionViewCell.discountPercentageLabel.hidden = false
                    halfVerticalImageCollectionViewCell.originalPriceLabel.hidden = false
                }
            }
        }
        return halfVerticalImageCollectionViewCell
    }
    
    //MARK: - Header View Delegate
    func layoutHeaderCollectionViewCellDidSelectViewMore(layoutHeaderCollectionViewCell: LayoutHeaderCollectionViewCell) {
        self.didClickItemWithTarget(layoutHeaderCollectionViewCell.target, targetType: layoutHeaderCollectionViewCell.targetType, sectionTitle: layoutHeaderCollectionViewCell.sectionTitle)
    }
    
    //MARK: - Full Image Collection View Cell
    func fullImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath, fullImageCollectionView: UICollectionView) -> FullImageCollectionViewCell {
        let fullImageCollectionViewCell: FullImageCollectionViewCell = fullImageCollectionView.dequeueReusableCellWithReuseIdentifier(self.fullImageCellNib, forIndexPath: indexPath) as! FullImageCollectionViewCell
        
        if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutOneModel) {
            let layoutOneModel: LayoutOneModel = self.homePageModel.data[indexPath.section] as! LayoutOneModel
            
            fullImageCollectionViewCell.target = layoutOneModel.data[indexPath.row].target.targetUrl
            fullImageCollectionViewCell.targetType = layoutOneModel.data[indexPath.row].target.targetType
            fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(NSURL(string: layoutOneModel.data[indexPath.row].image), placeholderImage: UIImage(named: placeHolder))
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutSixModel) {
            let layoutSixModel: LayoutSixModel = self.homePageModel.data[indexPath.section] as! LayoutSixModel
            
            fullImageCollectionViewCell.target = layoutSixModel.data[indexPath.row].target.targetUrl
            fullImageCollectionViewCell.targetType = layoutSixModel.data[indexPath.row].target.targetType
            fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(NSURL(string: layoutSixModel.data[indexPath.row].image), placeholderImage: UIImage(named: placeHolder))
        }  else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutTwoModel) {
            let layoutTwoModel: LayoutTwoModel = self.homePageModel.data[indexPath.section] as! LayoutTwoModel
            
            fullImageCollectionViewCell.target = layoutTwoModel.data[indexPath.row].target.targetUrl
            fullImageCollectionViewCell.targetType = layoutTwoModel.data[indexPath.row].target.targetType
            fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(NSURL(string: layoutTwoModel.data[indexPath.row].image), placeholderImage: UIImage(named: placeHolder))
        }
     
        return fullImageCollectionViewCell
    }
    
    //MARK: - Daily Login With Index Path
    func dailyLoginWithWIndexpath(indexPath: NSIndexPath) -> DailyLoginCollectionViewCell {
        let layoutTwoModel: LayoutTwoModel = self.homePageModel.data[indexPath.section] as! LayoutTwoModel
        
        let dailyLoginCell: DailyLoginCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.dailyLoginNibName, forIndexPath: indexPath) as! DailyLoginCollectionViewCell
        
        /*dailyLoginCell.productImageView.sd_setImageWithURL(NSURL(string: layoutTwoModel.data[0].image), placeholderImage: UIImage(named: self.placeHolder))
        dailyLoginCell.target = layoutTwoModel.data[0].target.targetUrl
        dailyLoginCell.targetType = layoutTwoModel.data[0].target.targetType*/
        
        dailyLoginCell.delegate = self
        dailyLoginCell.dataSource = self
        dailyLoginCell.collectionView.reloadData()
        
        return dailyLoginCell
    }
    
    //MAMRK: - Half Pager With IndexPath
    func halfPagerWithIndexPath(indexPath: NSIndexPath) -> HalfPagerCollectionViewCell {
        let halfPager: HalfPagerCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.halfPagerCellNibName, forIndexPath: indexPath) as! HalfPagerCollectionViewCell
        halfPager.delegate = self
        halfPager.dataSource = self
        return halfPager
    }
    
    //MARK: - Seller Collection View Cell With Index Path
    func sellerCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> SellerCollectionViewCell {
        let sellerCollectionView: SellerCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.sellerNibName, forIndexPath: indexPath) as! SellerCollectionViewCell
        
        return sellerCollectionView
    }
    
    //MARK: - Seller Carousel
    func sellerCarouselWithIndexPath(indexPath: NSIndexPath) -> SellerCarouselCollectionViewCell {
        let sellerCarosuel: SellerCarouselCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.sellerCarouselNibName, forIndexPath: indexPath) as! SellerCarouselCollectionViewCell
        
        sellerCarosuel.delegate = self
        sellerCarosuel.dataSource = self
        return sellerCarosuel
    }
    
    //MARK: - Seller Carousel Data Source
    func sellerCarouselCollectionViewCell(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell, numberOfItemsInSection section: Int) -> Int {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(sellerCarouselCollectionViewCell)!
        let layoutEightModel: LayoutEightModel = self.homePageModel.data[parentIndexPath.section] as! LayoutEightModel
        return layoutEightModel.data.count
    }
    
    func sellerCarouselCollectionViewCell(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> SellerCollectionViewCell {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(sellerCarouselCollectionViewCell)!
        let layoutEightModel: LayoutEightModel = self.homePageModel.data[parentIndexPath.section] as! LayoutEightModel
        
        let sellerCollectionView: SellerCollectionViewCell = sellerCarouselCollectionViewCell.collectionView?.dequeueReusableCellWithReuseIdentifier(self.sellerNibName, forIndexPath: indexPath) as! SellerCollectionViewCell
        
        sellerCollectionView.target = layoutEightModel.data[indexPath.row].target.targetUrl
        sellerCollectionView.targetType = layoutEightModel.data[indexPath.row].target.targetType
        
        sellerCollectionView.sellerProfileImageView.userInteractionEnabled = false
        
        sellerCollectionView.sellerTitleLabel.text = layoutEightModel.data[indexPath.row].name
        sellerCollectionView.sellerSubTitleLabel.text = layoutEightModel.data[indexPath.row].specialty
        sellerCollectionView.sellerProfileImageView.sd_setImageWithURL(NSURL(string: layoutEightModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
        
        if layoutEightModel.data[indexPath.row].data.count >= 1 {
            sellerCollectionView.productOneImageView.target = layoutEightModel.data[indexPath.row].data[0].target.targetUrl
            sellerCollectionView.productOneImageView.targetType = layoutEightModel.data[indexPath.row].data[0].target.targetType
            sellerCollectionView.productOneImageView.sd_setImageWithURL(NSURL(string: layoutEightModel.data[indexPath.row].data[0].image), placeholderImage: UIImage(named: self.placeHolder))
            
        }
        
        if layoutEightModel.data[indexPath.row].data.count >= 2 {
            sellerCollectionView.productTwoImageView.target = layoutEightModel.data[indexPath.row].data[1].target.targetUrl
            sellerCollectionView.productTwoImageView.targetType = layoutEightModel.data[indexPath.row].data[1].target.targetType
            sellerCollectionView.productTwoImageView.sd_setImageWithURL(NSURL(string: layoutEightModel.data[indexPath.row].data[1].image), placeholderImage: UIImage(named: self.placeHolder))
        }
        
        if layoutEightModel.data[indexPath.row].data.count >= 3 {
            sellerCollectionView.productThreeImageView.target = layoutEightModel.data[indexPath.row].data[2].target.targetUrl
            sellerCollectionView.productThreeImageView.targetType = layoutEightModel.data[indexPath.row].data[2].target.targetType
            sellerCollectionView.productThreeImageView.sd_setImageWithURL(NSURL(string: layoutEightModel.data[indexPath.row].data[2].image), placeholderImage: UIImage(named: self.placeHolder))
        }
        
        self.addGestureToSellerProduct(sellerCollectionView.productOneImageView)
        self.addGestureToSellerProduct(sellerCollectionView.productTwoImageView)
        self.addGestureToSellerProduct(sellerCollectionView.productThreeImageView)
        
        return sellerCollectionView
    }
    
    func itemWidthInSellerCarouselCollectionViewCell(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell) -> CGFloat {
        sellerCarouselCollectionViewCell.layoutIfNeeded()
        
        return sellerCarouselCollectionViewCell.collectionView.frame.size.width / 2
    }
    
    func sellerCarouselCollectionViewCellnumberOfDotsInPageControl(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell) -> Int {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(sellerCarouselCollectionViewCell)!
        let layoutEightModel: LayoutEightModel = self.homePageModel.data[parentIndexPath.section] as! LayoutEightModel
        
        return layoutEightModel.data.count
    }
    
    //MARK: - Seller Carousel Delegate
    func sellerCarouselCollectionViewCell(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sellerCollectionViewCell: SellerCollectionViewCell = sellerCarouselCollectionViewCell.collectionView.cellForItemAtIndexPath(indexPath) as! SellerCollectionViewCell
         self.didClickItemWithTarget(sellerCollectionViewCell.target, targetType: sellerCollectionViewCell.targetType)
    }
    
    func sellerCarouselCollectionViewCellDidEndDecelerating(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell) {
        sellerCarouselCollectionViewCell.layoutIfNeeded()
        let pageWidth: CGFloat = sellerCarouselCollectionViewCell.collectionView.frame.size.width / 2
        let currentPage: CGFloat = sellerCarouselCollectionViewCell.collectionView.contentOffset.x / pageWidth
        
        if 0.0 != fmodf(Float(currentPage), 1.0) {
            sellerCarouselCollectionViewCell.pageControl.currentPage = Int(currentPage) + 1
        }
        else {
            sellerCarouselCollectionViewCell.pageControl.currentPage = Int(currentPage)
        }
    }
    
    //MARK: - Add Gesture To Seller Product
    func addGestureToSellerProduct(productImageView: ProductImageView) {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapItem:")
        productImageView.userInteractionEnabled = true
        productImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //MARK: - Did Tap Item
    func didTapItem(tap: UITapGestureRecognizer) {
        let itemImageView: ProductImageView = tap.view as! ProductImageView
        self.didClickItemWithTarget(itemImageView.target, targetType: itemImageView.targetType)
    }
    
    //MARK: - Did Click Item With Target
    func didClickItemWithTarget(target: String, targetType: String, sectionTitle: String = "") {
        if targetType == "seller" {
            let sellerViewController: SellerViewController = SellerViewController(nibName: "SellerViewController", bundle: nil)
            if target.toInt() != nil {
                sellerViewController.sellerId = target.toInt()!
            } else {
                let urlArray: [String] = target.componentsSeparatedByString("=")
                if urlArray[1].toInt() != nil {
                    sellerViewController.sellerId  = urlArray[1].toInt()!
                } else {
                    self.tabBarController!.view.makeToast(Constants.Localized.targetNotAvailable, duration: 1.5, position: CSToastPositionBottom, style: CSToastManager.sharedStyle())
                }
            }
            self.navigationController!.pushViewController(sellerViewController, animated: true)
        } else if targetType == "productList" {
            let resultViewController: ResultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            resultViewController.pageTitle = sectionTitle
            resultViewController.passModel(SearchSuggestionModel(suggestion: "", imageURL: "", searchUrl: target))
            self.navigationController!.pushViewController(resultViewController, animated: true)
        } else if targetType == "sellerList" {
            let resultViewController: ResultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            resultViewController.isSellerSearch = true
            resultViewController.pageTitle = sectionTitle
            resultViewController.passModel(SearchSuggestionModel(suggestion: "", imageURL: "", searchUrl: target))
            resultViewController.pageTitle = sectionTitle
            self.navigationController!.pushViewController(resultViewController, animated: true)
        } else if targetType == "product" {
            let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
            productViewController.tabController = self.tabBarController as! CustomTabBarController
            productViewController.productId = target
            self.navigationController?.pushViewController(productViewController, animated: true)
        } else if targetType == "webView" {
            let webViewController: WebViewController = WebViewController(nibName: "WebViewController", bundle: nil)
            webViewController.urlString = target
            self.navigationController!.pushViewController(webViewController, animated: true)
        } else {
            self.tabBarController!.view.makeToast(Constants.Localized.targetNotAvailable, duration: 1.5, position: CSToastPositionBottom, style: CSToastManager.sharedStyle())
        }
    }
    
    //MARK: - Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let indexes: [NSIndexPath] = self.collectionView.indexPathsForVisibleItems() as! [NSIndexPath]
        var isShowBackToTop: Bool = true
        for index in indexes {
            if index.section == 2 {
                isShowBackToTop = false
                break
            }
        }
        
        if scrollView.panGestureRecognizer.translationInView(scrollView.superview!).y > 0 {
            self.hideBackToTop()
        } else {
            if isShowBackToTop {
                self.showBackToTop()
            } else {
                self.hideBackToTop()
            }
        }
    }
    
    //MARK: - Show Back To Top
    func showBackToTop() {
        UIView.animateWithDuration(0.8, animations: {
                self.backToTopButton.alpha = 1
            }, completion: {
                (value: Bool) in
            })
    }
    
    //MARK: - Show Back To Top
    func hideBackToTop() {
        UIView.animateWithDuration(0.8, animations: {
            self.backToTopButton.alpha = 0
            }, completion: {
                (value: Bool) in
        })
    }

    
    //MARK: - Back To Top
    @IBAction func backToTop(sender: AnyObject) {
        self.collectionView.setContentOffset(CGPointZero, animated: true)
    }
    
    //MARK: - Update Data
    func updateData() {
        self.fireGetHomePageData(true)
    }
    
    //MARK: - 
    //MARK: - Daily Login Delegate
    func dailyLoginCollectionViewCellDidTapCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell) {
        
    }
    
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let fullImageCell: FullImageCollectionViewCell = dailyLoginCollectionViewCell.collectionView.cellForItemAtIndexPath(indexPath) as! FullImageCollectionViewCell
        self.didClickItemWithTarget(fullImageCell.target, targetType: fullImageCell.targetType)
    }
    
    func dailyLoginCollectionViewCellDidEndDecelerating(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell) {
//        dailyLoginCollectionViewCell.layoutIfNeeded()
//        let pageWidth: CGFloat = dailyLoginCollectionViewCell.collectionView.frame.size.width
//        let currentPage: CGFloat = dailyLoginCollectionViewCell.collectionView.contentOffset.x / pageWidth
//        
//        if 0.0 != fmodf(Float(currentPage), 1.0) {
//            dailyLoginCollectionViewCell.pageControl.currentPage = Int(currentPage) + 1
//        }
//        else {
//            dailyLoginCollectionViewCell.pageControl.currentPage = Int(currentPage)
//        }
    }
    
    //MARK: -
    //MARK: - Daily Login Data Source
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, numberOfItemsInSection section: Int) -> Int {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(dailyLoginCollectionViewCell)!
        let layoutTwoModel: LayoutTwoModel = self.homePageModel.data[parentIndexPath.section] as! LayoutTwoModel
        
        return layoutTwoModel.data.count
    }
    
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell {
        
        let fullImageCollectionViewCell: FullImageCollectionViewCell = dailyLoginCollectionViewCell.collectionView.dequeueReusableCellWithReuseIdentifier(self.fullImageCellNib, forIndexPath: indexPath) as! FullImageCollectionViewCell
        
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(dailyLoginCollectionViewCell)!
        let layoutTwoModel: LayoutTwoModel = self.homePageModel.data[parentIndexPath.section] as! LayoutTwoModel
        
        fullImageCollectionViewCell.target = layoutTwoModel.data[indexPath.row].target.targetUrl
        fullImageCollectionViewCell.targetType = layoutTwoModel.data[indexPath.row].target.targetType
        fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(NSURL(string: layoutTwoModel.data[indexPath.row].image), placeholderImage: UIImage(named: placeHolder))
        
        return fullImageCollectionViewCell
    }
    
    func itemWidthInDailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell) -> CGFloat {
        dailyLoginCollectionViewCell.layoutIfNeeded()
        return dailyLoginCollectionViewCell.collectionView.frame.size.width
    }
}
