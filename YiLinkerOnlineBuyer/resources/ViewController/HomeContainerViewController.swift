//
//  ViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HomeContainerViewController: UIViewController, UITabBarControllerDelegate, EmptyViewDelegate {
    
    @IBOutlet weak var contentView: UIView!
    
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
        
        /*
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRegistration:",
            name: appDelegate.registrationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "receivedMessage:",
            name: appDelegate.messageKey, object: nil)
        */
    }
    
    /*
    
    func onRegistration(notification: NSNotification){
        if let info = notification.userInfo as? Dictionary<String,String> {
            if let error = info["error"] {
                showAlert("Error registering with GCM", message: error)
            } else if let registrationToken = info["registrationToken"] {
                let message = "Check the xcode debug console for the registration token for the server to send notifications to your device"
                self.fireCreateRegistration(registrationToken)
                showAlert("Registration Successful!", message: message)
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
    
    func receivedMessage(notification : NSNotification){
        //action here to open messaging
    }

    */
    
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
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        contentViewFrame = contentView.bounds
       
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers![4] as! UIViewController {
            return true
        } else if viewController == tabBarController.viewControllers![3] as! UIViewController {
            if SessionManager.isLoggedIn() {
                return true
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Please log in to view your Wishlist.", title: "Error")
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
                var buttonImages: [String] = ["fab_help", "fab_following", "fab_messaging", "fab_customize", "fab_promo", "fab_category", self.profileModel.profileImageUrl]
                var buttonTitles: [String] = ["HELP", "FOLLOWED SELLER", "MESSAGING", "CUSTOMIZE SHOPPING", "TODAY'S PROMO", "CATEGORIES", "LOGOUT"]
                var buttonRightText: [String] = ["", "", "You have 1 unread message", "", "", "", "\(self.profileModel.firstName) \(self.profileModel.lastName) \n\(self.profileModel.address.streetAddress) \(self.profileModel.address.subdivision)"]
                
                animatedViewController?.buttonImages = buttonImages
                animatedViewController?.buttonTitles = buttonTitles
                animatedViewController?.buttonRightText = buttonRightText
            } else {
                var buttonImages: [String] = ["fab_help", "fab_register", "fab_signin", "fab_messaging","fab_customize", "fab_promo", "fab_category"]
                var buttonTitles: [String] = ["HELP", "REGISTER", "SIGN IN", "MESSAGING", "CUSTOMIZE SHOPPING", "TODAYS PROMO", "CATEGORIES"]
                var buttonRightText: [String] = ["", "", "Must be Sign in", "Must be Sign in", "", "", ""]
                
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
    
    // This function is for executing child view logic code
    func setSelectedViewControllerWithIndex(index: Int) {
        if self.viewControllers.count != 0 {
            let viewController: UIViewController = viewControllers[index]
            setSelectedViewController(viewController)
        }
    }
    
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
    
    func addSuHeaderScrollView() {
        let scrollView: UIScrollView = UIScrollView(frame: CGRectMake(0, 0, self.view.frame.size.width, 40))
        let titles: [String] = ["FEATURED", "HOT ITEMS", "NEW ITEMS", "SELLER"]
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
    
    func circularDraweView() {
        let unselectedImage: UIImage = UIImage(named: "circular-drawer")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let item2: UITabBarItem = self.tabBarController?.tabBar.items![2] as! UITabBarItem
        item2.selectedImage = unselectedImage
        item2.image = unselectedImage
        item2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
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
            if layoutId == 1 {
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
    
    func didTapReload() {
        self.fireGetHomePageData()
        self.emptyView?.hidden = true
    }
    
    func fireGetUserInfo() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        self.showHUD()
        manager.POST(APIAtlas.getUserInfoUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let dictionary: NSDictionary = responseObject as! NSDictionary
            self.profileModel = ProfileUserDetailsModel.parseDataWithDictionary(dictionary["data"]!)
            //Insert Data to Session Manager
            SessionManager.setFullAddress("\(self.profileModel.address.barangay) \(self.profileModel.address.unitNumber) \(self.profileModel.address.subdivision) \(self.profileModel.address.streetNumber) \(self.profileModel.address.streetAddress) \(self.profileModel.address.streetName) \(self.profileModel.address.buildingName)")
            SessionManager.setUserFullName(self.profileModel.fullName)
            SessionManager.setAddressId(self.profileModel.address.userAddressId)
            SessionManager.setCartCount(self.profileModel.cartCount)
            SessionManager.setWishlistCount(self.profileModel.wishlistCount)
            self.updateTabBarBadge()
                
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                self.hud?.hide(true)
        })
    }
    
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
    
    func fireRefreshToken() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        self.showHUD()
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
            
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                
                self.hud?.hide(true)
        })

    }
    
    //Show HUD
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
}