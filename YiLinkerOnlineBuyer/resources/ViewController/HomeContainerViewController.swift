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

class HomeContainerViewController: UIViewController, UITabBarControllerDelegate, EmptyViewDelegate, CarouselCollectionViewCellDataSource, CarouselCollectionViewCellDelegate, DailyLoginCollectionViewCellDelegate, HalfPagerCollectionViewCellDelegate, HalfPagerCollectionViewCellDataSource, FlashSaleCollectionViewCellDelegate, LayoutHeaderCollectionViewCellDelegate, SellerCarouselCollectionViewCellDataSource, SellerCarouselCollectionViewCellDelegate, LayoutNineCollectionViewCellDelegate, LayoutNineCollectionViewCellDataSource {
    
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
    
    var remainingTime: Int = 20000
    
    var firstHourString: String = ""
    var secondHourString: String = ""
    
    var firstMinString: String = ""
    var secondMinString: String = ""
    
    var firstSecondsString: String = ""
    var secondSecondsString: String = ""
    
    var homePageModel: HomePageModel = HomePageModel()
    
    //MARK: - Life Cycle
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
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
        
        /*if Reachability.isConnectedToNetwork() {
        self.fireGetHomePageData()
        } else {
        self.addEmptyView()
        }*/
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRegistration:",
            name: appDelegate.registrationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNewMessage:",
            name: appDelegate.messageKey, object: nil)
        
        let dictionary: NSDictionary = ParseLocalJSON.fileName("dummyHomePage") as NSDictionary
        self.homePageModel = HomePageModel.parseDataFromDictionary(dictionary)
        
        for (index, model) in enumerate(self.homePageModel.data) {
            if model.isKindOfClass(LayoutOneModel) {
                self.layouts.append("1")
            } else if model.isKindOfClass(LayoutTwoModel) {
                self.layouts.append("2")
            } else if model.isKindOfClass(LayoutThreeModel) {
                self.layouts.append("3")
            } else if model.isKindOfClass(LayoutFourModel) {
                self.layouts.append("4")
                let layoutFourModel: LayoutFourModel = self.homePageModel.data[index] as! LayoutFourModel
              
                if layoutFourModel.remainingTime.toInt() != 0 || layoutFourModel.remainingTime.toInt() != nil {
                    self.remainingTime = layoutFourModel.remainingTime.toInt()!
                    var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
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
        
        self.collectionViewLayout()
        
        self.view.layoutIfNeeded()
        //set customTabbar
        self.customTabBarController = self.tabBarController as? CustomTabBarController
        self.customTabBarController?.isValidToSwitchToMenuTabBarItems = false
        self.circularDraweView()
        self.tabBarController!.delegate = self
    }
    
    //MARK: - collectionViewLayout()
    func collectionViewLayout() {
        let homePageCollectionViewLayout: HomePageCollectionViewLayout2 = HomePageCollectionViewLayout2()
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
    
    // MARK: - Did Tap Reload
    func didTapReload() {
        self.fireGetHomePageData()
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
            return 1
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
           return self.twoColumnGridCollectionViewCellWithIndexPath(indexPath)
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
            println(towColumnCell.target)
            println(towColumnCell.targetType)
        }
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
        
        println("Target: \(fullImageCell.target)")
        println("Target: \(fullImageCell.targetType)")
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
    
    //MARK: - Daily Login Delegate
    func dailyLoginCollectionViewCellDidTapCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell) {
        println("target: \(dailyLoginCollectionViewCell.target)")
        println("targetType: \(dailyLoginCollectionViewCell.targetType)")
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
        
        var numberOfPages: Float = Float(layoutThreeModel.data.count) /  2.0
        
        if fmod(numberOfPages, 1.0) != 0.0 {
            numberOfPages = numberOfPages + 1
        }
        
        return Int(numberOfPages)
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
            return (self.view.frame.size.width / 2) - CGFloat(rightInset)
        } else {
            return (self.view.frame.size.width / 2) - CGFloat(rightInset)
        }
    }
    
    //MARK: - Half Pager Delegate
    func halfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Did select item \(indexPath.row)")
    }
    
    func halfPagerCollectionViewCellDidEndDecelerating(halfPagerCollectionViewCell: HalfPagerCollectionViewCell) {
        halfPagerCollectionViewCell.layoutIfNeeded()
        let pageWidth: CGFloat = halfPagerCollectionViewCell.collectionView.frame.size.width
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
        println(productImageView.target)
        println(productImageView.targetType)
    }
    
    //MARK: - Seconds To Hours Minutes Seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: - Update Time
    func updateTime() {
        self.remainingTime--
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
        
        if let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 3) {
            self.collectionView.reloadItemsAtIndexPaths([indexPath])
        }
    }
    
    //MARK: - Flash Sale Collection View Cell With IndexPath
    func flashSaleCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> FlashSaleCollectionViewCell {
        let layoutFourModel: LayoutFourModel = self.homePageModel.data[indexPath.section] as! LayoutFourModel
        
        let flashSaleCell: FlashSaleCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.flashSaleNibName, forIndexPath: indexPath) as! FlashSaleCollectionViewCell
        flashSaleCell.delegate = self
        
        flashSaleCell.hourFirstDigit.text = self.firstHourString
        flashSaleCell.hourSecondDigit.text = self.secondHourString
        
        flashSaleCell.minuteFirstDigit.text = self.firstMinString
        flashSaleCell.minuteSecondDigit.text = self.secondMinString
        
        flashSaleCell.secondFirstDigit.text = self.firstSecondsString
        flashSaleCell.secondSecondDigit.text = self.secondSecondsString
        
        flashSaleCell.productOneImageView.sd_setImageWithURL(NSURL(string: layoutFourModel.data[0].image), placeholderImage: UIImage(named: "dummy-placeholder"))
        flashSaleCell.productTwoImageView.sd_setImageWithURL(NSURL(string: layoutFourModel.data[1].image), placeholderImage: UIImage(named: "dummy-placeholder"))
        flashSaleCell.productThreeImageView.sd_setImageWithURL(NSURL(string: layoutFourModel.data[2].image), placeholderImage: UIImage(named: "dummy-placeholder"))
        
        flashSaleCell.productOneImageView.target = layoutFourModel.data[0].target.targetUrl
        flashSaleCell.productOneImageView.targetType = layoutFourModel.data[0].target.targetType
        
        flashSaleCell.productTwoImageView.target = layoutFourModel.data[1].target.targetUrl
        flashSaleCell.productTwoImageView.targetType = layoutFourModel.data[1].target.targetType
        
        flashSaleCell.productThreeImageView.target = layoutFourModel.data[2].target.targetUrl
        flashSaleCell.productThreeImageView.targetType = layoutFourModel.data[2].target.targetType
        
        flashSaleCell.productOneDiscountLabel.text = "\(layoutFourModel.data[0].discountPercentage)%"
        flashSaleCell.productTwoDiscountLabel.text = "\(layoutFourModel.data[1].discountPercentage)%"
        flashSaleCell.productThreeDiscountLabel.text = "\(layoutFourModel.data[2].discountPercentage)%"
        
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
        twoColumnGridCollectionViewCell.discountedPriceLabel.text = layoutTenModel.data[indexPath.row].discountedPrice
        twoColumnGridCollectionViewCell.discountPercentageLabel.text = layoutTenModel.data[indexPath.row].discountPercentage
        
        return twoColumnGridCollectionViewCell
    }
    
    //MARK: - Layout Nine Collection View Cell With IndexPath
    func layoutNineCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> LayoutNineCollectionViewCell {
        let layoutNineModel: LayoutNineModel = self.homePageModel.data[indexPath.section] as! LayoutNineModel
        
        let layoutNineCollectionViewCell: LayoutNineCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.layoutNineNibName, forIndexPath: indexPath) as! LayoutNineCollectionViewCell
        layoutNineCollectionViewCell.delegate = self
        layoutNineCollectionViewCell.dataSource = self
        
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
        
        return layoutNineCollectionViewCell
    }
    
    //MARK: - Layout Nine Collection View Cell Datasource
    func layoutNineCollectionViewCell(layoutNineCollectionViewCell: LayoutNineCollectionViewCell, numberOfItemsInSection section: Int) -> Int {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(layoutNineCollectionViewCell)!
        let layoutNineModel: LayoutNineModel = self.homePageModel.data[parentIndexPath.section] as! LayoutNineModel
        
        return layoutNineModel.data.count - 5
    }
    
    func layoutNineCollectionViewCell(layoutNineCollectionViewCell: LayoutNineCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell {
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(layoutNineCollectionViewCell)!
        let layoutNineModel: LayoutNineModel = self.homePageModel.data[parentIndexPath.section] as! LayoutNineModel
        
        let fullImageCell: FullImageCollectionViewCell = layoutNineCollectionViewCell.collectionView.dequeueReusableCellWithReuseIdentifier(layoutNineCollectionViewCell.fullImageCellNib, forIndexPath: indexPath) as! FullImageCollectionViewCell
        fullImageCell.itemProductImageView.sd_setImageWithURL(NSURL(string: layoutNineModel.data[indexPath.row + 5].image), placeholderImage: UIImage(named: "dummy-placeholder"))
        fullImageCell.target = layoutNineModel.data[indexPath.row + 5].target.targetUrl
        fullImageCell.targetType = layoutNineModel.data[indexPath.row + 5].target.targetType
        
        fullImageCell.layer.cornerRadius = 5
        fullImageCell.clipsToBounds = true
        return fullImageCell
    }
    
    func layoutNineCollectionViewCell(layoutNineCollectionViewCell: LayoutNineCollectionViewCell) -> CGFloat {
        layoutNineCollectionViewCell.layoutIfNeeded()
        return layoutNineCollectionViewCell.collectionView.frame.size.width
    }
    
    //MARK: - Layout Nine Collection View Cell Delegate
    func layoutNineCollectionViewCellDidClickProductImage(productImage: ProductImageView) {
        println(productImage.target)
        println(productImage.targetType)
    }
    
    func layoutNineCollectionViewCell(layoutNineCollectionViewCell: LayoutNineCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let fullImageCell: FullImageCollectionViewCell = layoutNineCollectionViewCell.collectionView.cellForItemAtIndexPath(indexPath) as! FullImageCollectionViewCell
        println(fullImageCell.target)
    }
    
    func layoutNineCollectionViewCellDidEndDecelerating(layoutNineCollectionViewCell: LayoutNineCollectionViewCell) {
        layoutNineCollectionViewCell.layoutIfNeeded()
        let pageWidth: CGFloat = layoutNineCollectionViewCell.collectionView.frame.size.width
        let currentPage: CGFloat = layoutNineCollectionViewCell.collectionView.contentOffset.x / pageWidth
        
        if 0.0 != fmodf(Float(currentPage), 1.0) {
            layoutNineCollectionViewCell.pageControl.currentPage = Int(currentPage) + 1
        } else {
            layoutNineCollectionViewCell.pageControl.currentPage = Int(currentPage)
        }
    }
    
    //MARK: - Vertical Image Collection View Cell With IndexPath
    func verticalImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> VerticalImageCollectionViewCell {
        let verticalImageCollectionViewCell: VerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.verticalImageNibName
            , forIndexPath: indexPath) as! VerticalImageCollectionViewCell

        if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutFiveModel) {
            let layoutFiveModel: LayoutFiveModel = self.homePageModel.data[indexPath.section] as! LayoutFiveModel
            verticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(NSURL(string: layoutFiveModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
            
            verticalImageCollectionViewCell.productNameLabel.text = layoutFiveModel.data[indexPath.row].name
            verticalImageCollectionViewCell.discountedPriceLabel.text = layoutFiveModel.data[indexPath.row].discountedPrice.formatToPeso()
            verticalImageCollectionViewCell.discountPercentageLabel.text = layoutFiveModel.data[indexPath.row].discountPercentage.formatToPercentage()
            
            verticalImageCollectionViewCell.target = layoutFiveModel.data[indexPath.row].target.targetUrl
            verticalImageCollectionViewCell.targetType = layoutFiveModel.data[indexPath.row].target.targetType
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutSevenModel) {
            let layoutSevenModel: LayoutSevenModel = self.homePageModel.data[indexPath.section] as! LayoutSevenModel
            verticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(NSURL(string: layoutSevenModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
            
            verticalImageCollectionViewCell.productNameLabel.text = layoutSevenModel.data[indexPath.row].name
            verticalImageCollectionViewCell.discountedPriceLabel.text = layoutSevenModel.data[indexPath.row].discountedPrice.formatToPeso()
            verticalImageCollectionViewCell.discountPercentageLabel.text = layoutSevenModel.data[indexPath.row].discountPercentage.formatToPercentage()
            
            verticalImageCollectionViewCell.target = layoutSevenModel.data[indexPath.row].target.targetUrl
            verticalImageCollectionViewCell.targetType = layoutSevenModel.data[indexPath.row].target.targetType
        }
        
        return verticalImageCollectionViewCell
    }
    
    //MARK: - Half Vertical Image Collection View Cell With IndexPath
    func halfVerticalImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> HalfVerticalImageCollectionViewCell {
        let halfVerticalImageCollectionViewCell: HalfVerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.halfVerticalNibName, forIndexPath: indexPath) as! HalfVerticalImageCollectionViewCell
        
        if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutFiveModel) {
            let layoutFiveModel: LayoutFiveModel = self.homePageModel.data[indexPath.section] as! LayoutFiveModel
            halfVerticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(NSURL(string: layoutFiveModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
            
            halfVerticalImageCollectionViewCell.productNameLabel.text = layoutFiveModel.data[indexPath.row].name
            halfVerticalImageCollectionViewCell.discountedPriceLabel.text = layoutFiveModel.data[indexPath.row].discountedPrice.formatToPeso()
            halfVerticalImageCollectionViewCell.discountPercentageLabel.text = layoutFiveModel.data[indexPath.row].discountPercentage.formatToPercentage()
            
            halfVerticalImageCollectionViewCell.target = layoutFiveModel.data[indexPath.row].target.targetUrl
            halfVerticalImageCollectionViewCell.targetType = layoutFiveModel.data[indexPath.row].target.targetType
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutSevenModel) {
            let layoutSevenModel: LayoutSevenModel = self.homePageModel.data[indexPath.section] as! LayoutSevenModel
            halfVerticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(NSURL(string: layoutSevenModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
            
            halfVerticalImageCollectionViewCell.productNameLabel.text = layoutSevenModel.data[indexPath.row].name
            halfVerticalImageCollectionViewCell.discountedPriceLabel.text = layoutSevenModel.data[indexPath.row].discountedPrice.formatToPeso()
            halfVerticalImageCollectionViewCell.discountPercentageLabel.text = layoutSevenModel.data[indexPath.row].discountPercentage.formatToPercentage()
            
            halfVerticalImageCollectionViewCell.target = layoutSevenModel.data[indexPath.row].target.targetUrl
            halfVerticalImageCollectionViewCell.targetType = layoutSevenModel.data[indexPath.row].target.targetType
        }

        return halfVerticalImageCollectionViewCell
    }
    
    //MARK: - Header View Delegate
    func layoutHeaderCollectionViewCellDidSelectViewMore(layoutHeaderCollectionViewCell: LayoutHeaderCollectionViewCell) {
        println(layoutHeaderCollectionViewCell.target)
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
        }
     
        return fullImageCollectionViewCell
    }
    
    //MARK: - Daily Login With Index Path
    func dailyLoginWithWIndexpath(indexPath: NSIndexPath) -> DailyLoginCollectionViewCell {
        let layoutTwoModel: LayoutTwoModel = self.homePageModel.data[indexPath.section] as! LayoutTwoModel
        
        let dailyLoginCell: DailyLoginCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.dailyLoginNibName, forIndexPath: indexPath) as! DailyLoginCollectionViewCell
        
        dailyLoginCell.productImageView.sd_setImageWithURL(NSURL(string: layoutTwoModel.data[0].image), placeholderImage: UIImage(named: self.placeHolder))
        dailyLoginCell.target = layoutTwoModel.data[0].target.targetUrl
        dailyLoginCell.targetType = layoutTwoModel.data[0].target.targetType
        dailyLoginCell.delegate = self
        
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
        
        sellerCollectionView.productOneImageView.target = layoutEightModel.data[indexPath.row].data[0].target.targetUrl
        sellerCollectionView.productTwoImageView.target = layoutEightModel.data[indexPath.row].data[1].target.targetUrl
        sellerCollectionView.productThreeImageView.target = layoutEightModel.data[indexPath.row].data[2].target.targetUrl
        
        sellerCollectionView.productOneImageView.targetType = layoutEightModel.data[indexPath.row].data[0].target.targetType
        sellerCollectionView.productTwoImageView.targetType = layoutEightModel.data[indexPath.row].data[1].target.targetType
        sellerCollectionView.productThreeImageView.targetType = layoutEightModel.data[indexPath.row].data[2].target.targetType
        
        sellerCollectionView.sellerProfileImageView.sd_setImageWithURL(NSURL(string: layoutEightModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder))
        
        sellerCollectionView.productOneImageView.sd_setImageWithURL(NSURL(string: layoutEightModel.data[indexPath.row].data[0].image), placeholderImage: UIImage(named: self.placeHolder))
        sellerCollectionView.productTwoImageView.sd_setImageWithURL(NSURL(string: layoutEightModel.data[indexPath.row].data[1].image), placeholderImage: UIImage(named: self.placeHolder))
        sellerCollectionView.productThreeImageView.sd_setImageWithURL(NSURL(string: layoutEightModel.data[indexPath.row].data[2].image), placeholderImage: UIImage(named: self.placeHolder))
        
        sellerCollectionView.target = layoutEightModel.data[indexPath.row].target.targetUrl
        sellerCollectionView.targetType = layoutEightModel.data[indexPath.row].target.targetType
        
        sellerCollectionView.sellerProfileImageView.userInteractionEnabled = false
        
        sellerCollectionView.sellerTitleLabel.text = layoutEightModel.data[indexPath.row].name
        sellerCollectionView.sellerSubTitleLabel.text = layoutEightModel.data[indexPath.row].specialty
        
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
        
        var numberOfPages: CGFloat = CGFloat(layoutEightModel.data.count) / 2.0
        
        if fmod(numberOfPages, 1.0) != 0.0 {
            numberOfPages = numberOfPages + 1
        }
        
        return Int(numberOfPages)
    }
    
    //MARK: - Seller Carousel Delegate
    func sellerCarouselCollectionViewCell(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let sellerCollectionViewCell: SellerCollectionViewCell = sellerCarouselCollectionViewCell.collectionView.cellForItemAtIndexPath(indexPath) as! SellerCollectionViewCell
        println(sellerCollectionViewCell.target)
    }
    
    func sellerCarouselCollectionViewCellDidEndDecelerating(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell) {
        sellerCarouselCollectionViewCell.layoutIfNeeded()
        let pageWidth: CGFloat = sellerCarouselCollectionViewCell.collectionView.frame.size.width
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
        println(itemImageView.target)
    }
}