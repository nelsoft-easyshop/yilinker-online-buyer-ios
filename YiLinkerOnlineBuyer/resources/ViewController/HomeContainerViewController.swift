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

class HomeContainerViewController: UIViewController, UITabBarControllerDelegate, EmptyViewDelegate, CarouselCollectionViewCellDataSource, CarouselCollectionViewCellDelegate, DailyLoginCollectionViewCellDelegate, HalfPagerCollectionViewCellDelegate, HalfPagerCollectionViewCellDataSource, FlashSaleCollectionViewCellDelegate, LayoutHeaderCollectionViewCellDelegate {
    var searchViewContoller: SearchViewController?
    var circularMenuViewController: CircularMenuViewController?
    var wishlisViewController: WishlistViewController?
    var cartViewController: CartViewController?
    
    var emptyView: EmptyView?
    var hud: MBProgressHUD?
    var profileModel: ProfileUserDetailsModel = ProfileUserDetailsModel()
    var customTabBarController: CustomTabBarController?
    
    var layouts: [String] = ["1", "2", "3", "4", "5", "1", "5", "5"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: [String] = ["http://www.nognoginthecity.com/wp-content/uploads/2014/11/20141023_BRA_NA_Penshoppe-CB-women_NA_penshoppe-1.jpg", "http://www.manilaonsale.com/wp-content/uploads/2013/03/Penshoppe-Sale-March-2013.jpg", "http://www.manilaonsale.com/wp-content/uploads/2013/07/Penshoppe-Mid-Year-Clearance-Sale-July-2013.jpg", "http://cdn.soccerbible.com/media/8733/adidas-hunt-pack-supplied-img4.jpg", "http://demandware.edgesuite.net/sits_pod14-adidas/dw/image/v2/aagl_prd/on/demandware.static/-/Sites-adidas-AME-Library/default/dw2ec04560/brand/images/2015/06/adidas-originals-fw15-xeno-zx-flux-fc-double_70190.jpg?sw=470&sh=264&sm=fit&cx=10&cy=0&cw=450&ch=254&sfrm=jpg"]
    
    let carouselCellNibName = "CarouselCollectionViewCell"
    let dailyLoginNibName = "DailyLoginCollectionViewCell"
    let halfPagerCellNibName = "HalfPagerCollectionViewCell"
    let flashSaleNibName = "FlashSaleCollectionViewCell"
    let verticalImageNibName = "VerticalImageCollectionViewCell"
    let halfVerticalNibName = "HalfVerticalImageCollectionViewCell"
    let sectionBackgroundNibName = "SectionBackground"
    let sectionHeaderNibName = "LayoutHeaderCollectionViewCell"
    
    var timeRemaining: Int = 20000
    
    var firstHourString: String = ""
    var secondHourString: String = ""
    
    var firstMinString: String = ""
    var secondMinString: String = ""
    
    var firstSecondsString: String = ""
    var secondSecondsString: String = ""
    
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
        
        //set customTabbar
        self.view.layoutIfNeeded()
        self.customTabBarController = self.tabBarController as? CustomTabBarController
        self.customTabBarController?.isValidToSwitchToMenuTabBarItems = false
        self.circularDraweView()
        self.tabBarController!.delegate = self
        
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
        
        self.collectionViewLayout()
        
        var timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateTime", userInfo: nil, repeats: true)
        //decoration view
        self.registerDecorationView(self.sectionBackgroundNibName)
    }
    
    //MARK: - collectionViewLayout()
    func collectionViewLayout() {
        let homePageCollectionViewLayout: HomePageCollectionViewLayout2 = HomePageCollectionViewLayout2()
        homePageCollectionViewLayout.layouts = self.layouts
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = homePageCollectionViewLayout
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
            let dailyLoginCell: DailyLoginCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.dailyLoginNibName, forIndexPath: indexPath) as! DailyLoginCollectionViewCell
            dailyLoginCell.productImageView.sd_setImageWithURL(NSURL(string: self.images[4]), placeholderImage: UIImage(named: "dummy-placeholder"))
            dailyLoginCell.delegate = self
            
            return dailyLoginCell
        } else if self.layouts[indexPath.section] == "3" {
            let halfPager: HalfPagerCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.halfPagerCellNibName, forIndexPath: indexPath) as! HalfPagerCollectionViewCell
            halfPager.delegate = self
            halfPager.dataSource = self
            
            return halfPager
        } else if self.layouts[indexPath.section] == "4" {
            return self.flashSaleCollectionViewCellWithIndexPath(indexPath)
        } else if self.layouts[indexPath.section] == "5" {
            if indexPath.row == 0 {
                return self.verticalImageCollectionViewCellWithIndexPath(indexPath)
            } else {
                return self.halfVerticalImageCollectionViewCellWithIndexPath(indexPath)
            }
        } else {
            return self.flashSaleCollectionViewCellWithIndexPath(indexPath)
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let headerView: LayoutHeaderCollectionViewCell = self.collectionView?.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: self.sectionHeaderNibName, forIndexPath: indexPath) as! LayoutHeaderCollectionViewCell
        headerView.delegate = self
        return headerView
    }
    
    //MARK: - Carousel Data Source
    func carouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func carouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell {
        let fullImageCollectionViewCell: FullImageCollectionViewCell = carouselCollectionViewCell.collectionView.dequeueReusableCellWithReuseIdentifier(carouselCollectionViewCell.fullImageCellNib, forIndexPath: indexPath) as! FullImageCollectionViewCell
        fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(NSURL(string: self.images[indexPath.row]), placeholderImage: UIImage(named: "dummy-placeholder"))
        return fullImageCollectionViewCell
    }
    
    func itemWidthInCarouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell) -> CGFloat {
        carouselCollectionViewCell.layoutIfNeeded()
        return carouselCollectionViewCell.collectionView.frame.size.width
    }
    
    //MARK: - Carousel Delegate
    func carouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println("Did select item \(indexPath.row)")
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
        println("daily login clicked!")
    }
    
    //MARK: - Half Pager Data Source
    func halfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func halfPagerCollectionViewCellnumberOfDotsInPageControl(halfPagerCollectionViewCell: HalfPagerCollectionViewCell) -> Int {
        var numberOfPages: CGFloat = CGFloat(self.images.count / 2)
        
        if fmod(numberOfPages, 1.0) == 0.0 {
            numberOfPages = numberOfPages + 1
        }
        
        return Int(numberOfPages)
    }
    
    func halfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell {
        let fullImageCell: FullImageCollectionViewCell = halfPagerCollectionViewCell.collectionView.dequeueReusableCellWithReuseIdentifier(halfPagerCollectionViewCell.fullImageCellNib, forIndexPath: indexPath) as! FullImageCollectionViewCell
        fullImageCell.itemProductImageView.sd_setImageWithURL(NSURL(string: self.images[indexPath.row]), placeholderImage: UIImage(named: "dummy-placeholder"))
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
    func flashSaleCollectionViewCell(didTapFlashSaleItemIndex index: Int) {
        println(index)
    }
    
    //MARK: - Seconds To Hours Minutes Seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: - Update Time
    func updateTime() {
        self.timeRemaining--
        let (hour, min, seconds): (Int, Int, Int) = self.secondsToHoursMinutesSeconds(self.timeRemaining)
        
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
        
        println(seconds)
        if seconds < 10 {
            firstSecondsString = "\(seconds)"
            secondSecondsString = "0"
        } else {
            firstSecondsString = "\(seconds)".stringCharacterAtIndex(1)
            secondSecondsString = "\(seconds)".stringCharacterAtIndex(0)
        }
        
        if let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 3) {
            self.collectionView.reloadItemsAtIndexPaths([indexPath])
            UIView.setAnimationsEnabled(false)
        }
    }
    
    //MARK: - Flash Sale Collection View Cell With IndexPath
    func flashSaleCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> FlashSaleCollectionViewCell {
        let flashSaleCell: FlashSaleCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.flashSaleNibName, forIndexPath: indexPath) as! FlashSaleCollectionViewCell
        flashSaleCell.delegate = self
        
        flashSaleCell.hourFirstDigit.text = self.firstHourString
        flashSaleCell.hourSecondDigit.text = self.secondHourString
        
        flashSaleCell.minuteFirstDigit.text = self.firstMinString
        flashSaleCell.minuteSecondDigit.text = self.secondMinString
        
        flashSaleCell.secondFirstDigit.text = self.firstSecondsString
        flashSaleCell.secondSecondDigit.text = self.secondSecondsString
        
        flashSaleCell.productOneImageView.sd_setImageWithURL(NSURL(string: self.images[0]), placeholderImage: UIImage(named: "dummy-placeholder"))
        flashSaleCell.productTwoImageView.sd_setImageWithURL(NSURL(string: self.images[1]), placeholderImage: UIImage(named: "dummy-placeholder"))
        flashSaleCell.productThreeImageView.sd_setImageWithURL(NSURL(string: self.images[2]), placeholderImage: UIImage(named: "dummy-placeholder"))
        
        return flashSaleCell
    }
    
    //MARK: - Vertical Image Collection View Cell With IndexPath
    func verticalImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> VerticalImageCollectionViewCell {
         let verticalImageCollectionViewCell: VerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.verticalImageNibName
            , forIndexPath: indexPath) as! VerticalImageCollectionViewCell
        
        return verticalImageCollectionViewCell
    }
    
    //MARK: - Half Vertical Image Collection View Cell With IndexPath
    func halfVerticalImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> HalfVerticalImageCollectionViewCell {
        let halfVerticalImageCollectionViewCell: HalfVerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.halfVerticalNibName, forIndexPath: indexPath) as! HalfVerticalImageCollectionViewCell
        
        return halfVerticalImageCollectionViewCell
    }
    
    //MARK: - Header View Delegate
    func layoutHeaderCollectionViewCellDidSelectViewMore(layoutHeaderCollectionViewCell: LayoutHeaderCollectionViewCell) {
        println("view more selected!!!")
    }
    
}