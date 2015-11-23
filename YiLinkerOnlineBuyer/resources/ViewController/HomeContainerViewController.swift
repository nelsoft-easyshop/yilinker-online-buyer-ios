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

class HomeContainerViewController: UIViewController, UITabBarControllerDelegate, EmptyViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    var dimView: UIView?
    
    let viewControllerIndex = 0
    var searchViewContoller: SearchViewController?
    var circularMenuViewController: CircularMenuViewController?
    var wishlisViewController: WishlistViewController?
    var cartViewController: CartViewController?
    
    var viewControllers = [UIViewController]()
    
    var selectedChildViewController: UIViewController?
    var contentViewFrame: CGRect?
    
    var hotItemsCollectionViewController: HomePageCollectionViewController?
    var featuredCollectionViewController: HomePageCollectionViewController?
    var newItemsCollectionViewController: HomePageCollectionViewController?
    var sellersCollectionViewController: HomePageCollectionViewController?
    
    var curentCollectionViewController: Int = 0
    
    var emptyView: EmptyView?
    var hud: MBProgressHUD?
    var profileModel: ProfileUserDetailsModel = ProfileUserDetailsModel()
    var customTabBarController: CustomTabBarController?
    
    
    //MARK: - Life Cycle
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        contentViewFrame = contentView.bounds
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set customTabbar
        self.view.layoutIfNeeded()
        self.contentViewFrame = self.view.frame
        self.customTabBarController = self.tabBarController as? CustomTabBarController
        self.customTabBarController?.isValidToSwitchToMenuTabBarItems = false
        self.circularDraweView()
        self.tabBarController!.delegate = self
        self.addSuHeaderScrollView()
        if Reachability.isConnectedToNetwork() {
            self.fireGetHomePageData()
        } else {
            self.addEmptyView()
        }
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRegistration:",
            name: appDelegate.registrationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNewMessage:",
            name: appDelegate.messageKey, object: nil)
        self.initDimView()
    }
    
    func onRegistration(notification: NSNotification){
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
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title,
            message: message, preferredStyle: .Alert)
        let dismissAction = UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil)
        alert.addAction(dismissAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func onNewMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        var count = SessionManager.getUnReadMessagesCount() + 1
                        SessionManager.setUnReadMessagesCount(count)
                    }
                }
            }
        }
    }
    
    func fireCreateRegistration(registrationID : String) {
        
        self.showHUD()
        
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = [
            "registrationId": "\(registrationID)",
            "access_token"  : SessionManager.accessToken(),
            "deviceType"    : "1"
            ]   as Dictionary<String, String>
        
        let url = APIAtlas.baseUrl + APIAtlas.ACTION_GCM_CREATE
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            //SVProgressHUD.dismiss()
            self.hud?.hide(true)
            //self.showSuccessMessage()
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
                //SVProgressHUD.dismiss()
                self.hud?.hide(true)
        })
    }
    
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
            
            if SessionManager.accessToken() != "" {
                var buttonImages: [String] = ["fab_following", "fab_messaging", "fab_promo", "fab_category", self.profileModel.profileImageUrl]
                var buttonTitles: [String] = [FABStrings.followedSeller, FABStrings.messaging, FABStrings.todaysPromo, FABStrings.categories, FABStrings.logout]
                
                var buttonRightText: [String] = ["", SessionManager.unreadMessageCount(), "", "", "\(self.profileModel.firstName) \(self.profileModel.lastName) \n\(self.profileModel.address.streetAddress) \(self.profileModel.address.subdivision)"]
                
                animatedViewController?.buttonImages = buttonImages
                animatedViewController?.buttonTitles = buttonTitles
                animatedViewController?.buttonRightText = buttonRightText
            } else {
                var buttonImages: [String] = ["fab_register", "fab_signin", "fab_promo", "fab_category"]
                var buttonTitles: [String] = ["REGISTER", FABStrings.signIn, FABStrings.todaysPromo, FABStrings.categories]
                var buttonRightText: [String] = ["", "", "", ""]
                
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
    
    //MARK: - Select View Controller with Index
    //This function is for executing child view logic code
    func setSelectedViewControllerWithIndex(index: Int) {
        if self.viewControllers.count != 0 {
            let viewController: UIViewController = viewControllers[index]
            setSelectedViewController(viewController)
        }
    }
    
    //MARK: - Selected View Controller
    //Func for view conteinment
    func setSelectedViewController(viewController: UIViewController) {
        if !(selectedChildViewController == viewController) {
            if self.isViewLoaded() {
                selectedChildViewController?.willMoveToParentViewController(self)
                selectedChildViewController?.view.removeFromSuperview()
                selectedChildViewController?.removeFromParentViewController()
            }
        }
        self.view.layoutIfNeeded()
        self.addChildViewController(viewController)
        viewController.view.frame = contentViewFrame!
        contentView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedChildViewController = viewController
    }
    
    //MARK: - Init View Controllers
    func initViewControllers() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        hotItemsCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("HomePageCollectionViewController") as? HomePageCollectionViewController
        featuredCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("HomePageCollectionViewController") as? HomePageCollectionViewController
        newItemsCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("HomePageCollectionViewController") as? HomePageCollectionViewController
        sellersCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("HomePageCollectionViewController") as? HomePageCollectionViewController
    
        viewControllers.append(hotItemsCollectionViewController!)
        viewControllers.append(featuredCollectionViewController!)
        viewControllers.append(newItemsCollectionViewController!)
        viewControllers.append(sellersCollectionViewController!)
    }
    
    //MARK: - Add Sub Header ScrollView
    //Function for adding rounded buttons in the navigation bar
    func addSuHeaderScrollView() {
        let scrollView: UIScrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        let titles: [String] = [HomeStrings.featured, HomeStrings.hotItems, HomeStrings.newItem, HomeStrings.seller]
        var xPosition: CGFloat = 10
        var counter = 0
        for title in titles {
            let button: UIButton = UIButton(frame: CGRectMake(xPosition, 5, 90, 30))
            button.setTitle(title, forState: UIControlState.Normal)
            button.titleLabel!.font =  UIFont(name: "HelveticaNeue", size: 10)
            button.layer.cornerRadius = 15
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.whiteColor().CGColor
            button.tag = counter
            button.addTarget(self, action: "clickSubCategories:", forControlEvents: .TouchUpInside)
            scrollView.addSubview(button)
            xPosition = xPosition + button.frame.size.width + 30
            scrollView.contentSize = CGSizeMake(xPosition, 0)
            
            if title == "FEATURED" {
                button.backgroundColor = UIColor.whiteColor()
                button.setTitleColor(HexaColor.colorWithHexa(0x5A1F75), forState: UIControlState.Normal)
            }
            counter++
        }
        scrollView.showsHorizontalScrollIndicator = false
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, UIBarButtonItem(customView: scrollView)]
    }
    
    //MARK: - Click Sub Categories
    @IBAction func clickSubCategories(sender: UIButton) {
        let scrollView: UIScrollView = sender.superview as! UIScrollView
        let subViewsCount: Int = scrollView.subviews.count
        
        for button in scrollView.subviews  {
            if (button.isKindOfClass(UIButton)) {
                let tempButton: UIButton = button as! UIButton
                if tempButton.tag == sender.tag {
                    tempButton.backgroundColor = UIColor.whiteColor()
                    tempButton.setTitleColor(HexaColor.colorWithHexa(0x5A1F75), forState: UIControlState.Normal)
                    if tempButton.tag != 0 {
                        curentCollectionViewController = tempButton.tag
                    } else {
                        curentCollectionViewController = tempButton.tag
                    }
                    setSelectedViewControllerWithIndex(curentCollectionViewController)
                } else {
                    tempButton.backgroundColor = UIColor.clearColor()
                    tempButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                }
            }
            
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
    func fireGetHomePageData() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.GET(APIAtlas.homeUrl, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.populateHomePageWithDictionary(responseObject as! NSDictionary)
                self.hud?.hide(true)
                //get user info
                if SessionManager.isLoggedIn() {
                    self.fireGetUserInfo()
                } else {
                    SessionManager.saveCookies()
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                self.addEmptyView()
        })

    }
    
    //MARK: - Populate Home Page With Dictionary
    //Function for populating dictionary to the collectionview
    func populateHomePageWithDictionary(dictionary: NSDictionary) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        featuredCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("HomePageCollectionViewController") as? HomePageCollectionViewController
        
        let dataDictionary: NSDictionary = dictionary["data"] as! NSDictionary
        
        var featuredDictionary: NSDictionary = dataDictionary["featured"] as! NSDictionary
        var featuredLayouts: [String] = [Constants.HomePage.layoutOneKey, Constants.HomePage.layoutTwoKey, Constants.HomePage.layoutThreeKey, Constants.HomePage.layoutFourKey, Constants.HomePage.layoutFiveKey, Constants.HomePage.layoutSixKey]
        
        featuredCollectionViewController?.dictionary = featuredDictionary
        featuredCollectionViewController?.layouts = featuredLayouts
        
        hotItemsCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("HomePageCollectionViewController") as? HomePageCollectionViewController
        let hotItemsDictionary: NSDictionary = dataDictionary["hotItems"] as! NSDictionary
        var hotItemLayouts: [String] = [Constants.HomePage.layoutTwoKey, Constants.HomePage.layoutSevenKey]
        
        let categories: NSArray = hotItemsDictionary["categories"] as! NSArray
        
        for (index, category) in enumerate(categories) {
            let categoryDictionary: NSDictionary = category as! NSDictionary
            let layoutId: Int = categoryDictionary["categoryId"] as! Int
            var layout: String = ""
            if index == 0 {
                layout = Constants.HomePage.layoutFiveKeyWithFooter
            } else {
                layout = Constants.HomePage.layoutFiveKey2
            }
            
            hotItemLayouts.append(layout)
        }
        
        hotItemLayouts.append(Constants.HomePage.layoutTwoKey)
        hotItemsCollectionViewController?.dictionary = hotItemsDictionary
        hotItemsCollectionViewController?.layouts = hotItemLayouts
        
        
        newItemsCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("HomePageCollectionViewController") as? HomePageCollectionViewController
        let newItemsDictionary: NSDictionary = dataDictionary["newItems"] as! NSDictionary
        var newItemslayout: [String] = [Constants.HomePage.layoutEightKey, Constants.HomePage.layoutSixKey]
        newItemsCollectionViewController?.dictionary = newItemsDictionary
        newItemsCollectionViewController?.layouts = newItemslayout
        
        sellersCollectionViewController = storyBoard.instantiateViewControllerWithIdentifier("HomePageCollectionViewController") as? HomePageCollectionViewController
        let sellerDictionary: NSDictionary = dataDictionary["sellers"] as! NSDictionary
        let sellerLayouts: [String] = [Constants.HomePage.layoutNineKey, Constants.HomePage.layoutTenKey]
        sellersCollectionViewController?.dictionary = sellerDictionary
        sellersCollectionViewController?.layouts = sellerLayouts
        
        viewControllers.append(featuredCollectionViewController!)
        viewControllers.append(hotItemsCollectionViewController!)
        viewControllers.append(newItemsCollectionViewController!)
        viewControllers.append(sellersCollectionViewController!)
        
        setSelectedViewControllerWithIndex(self.curentCollectionViewController)
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
            self.updateTabBarBadge()
            
            /*if !SessionManager.isMobileVerified() && !SessionManager.isEmailVerified() {
                self.fireGetCode()
            }*/
            
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
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        self.showHUD()
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
            
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: HomeStrings.somethingWentWrong, title: HomeStrings.error)
                
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
    
    
    
    //MARK: - Dim View
    func initDimView() {
        dimView = UIView(frame: self.view.bounds)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.parentViewController!.view.addSubview(dimView!)
        //self.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
    }
    
    // MARK: - Did Tap Reload
    func didTapReload() {
        self.fireGetHomePageData()
        self.emptyView?.hidden = true
    }
    
    //MARK: - Verification
   /* func displayCodeDialog() {
        var verifyNumberModal = VerifyMobileNumberViewController(nibName: "VerifyMobileNumberViewController", bundle: nil)
        verifyNumberModal.delegate = self
        verifyNumberModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        verifyNumberModal.providesPresentationContextTransitionStyle = true
        verifyNumberModal.definesPresentationContext = true
        verifyNumberModal.view.backgroundColor = UIColor.clearColor()
        verifyNumberModal.view.frame.origin.y = 0
        self.parentViewController!.presentViewController(verifyNumberModal, animated: true, completion: nil)
        self.tabBarController?.tabBar.userInteractionEnabled = false
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }*/
    
    
    // MARK: - GET CODE
    /*func fireGetCode() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        self.showHUD()
        manager.POST(APIAtlas.verificationGetCodeUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            self.displayCodeDialog()
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                self.hud?.hide(true)
        })
    }
    
    //MARK: - Verification Delegate
    func closeVerifyMobileNumberViewController() {
        self.hideDimView()
        SessionManager.logout()
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToHomeView()
    }
    
    func verifyMobileNumberAction(isSuccessful: Bool) {
        self.hideDimView()
        if !isSuccessful {
            self.fireGetCode()
        }
    }
    
    func requestNewCodeAction() {
        self.hideDimView()
        self.fireGetCode()
    }
    
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            self.tabBarController?.tabBar.userInteractionEnabled = true
            }, completion: { finished in
                
        })
    }*/
}