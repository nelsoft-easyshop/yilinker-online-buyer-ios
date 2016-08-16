//
//  ViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit


class HomeContainerViewController: UIViewController, UITabBarControllerDelegate, EmptyViewDelegate, CarouselCollectionViewCellDataSource, CarouselCollectionViewCellDelegate, HalfPagerCollectionViewCellDelegate, HalfPagerCollectionViewCellDataSource, FlashSaleCollectionViewCellDelegate, LayoutHeaderCollectionViewCellDelegate, SellerCarouselCollectionViewCellDataSource, SellerCarouselCollectionViewCellDelegate, LayoutNineCollectionViewCellDelegate, DailyLoginCollectionViewCellDataSource, DailyLoginCollectionViewCellDelegate, FABViewControllerDelegate, OverseasCollectionViewCellDelegate, OverseasCollectionViewCellDataSource, LayoutTwelveCollectionViewCellDelegate {
    
    let featured: String = StringHelper.localizedStringWithKey("FEATURED_LOCALIZE_KEY")
    let hotItems: String = StringHelper.localizedStringWithKey("HOT_ITEMS_LOCALIZE_KEY")
    let newItem: String = StringHelper.localizedStringWithKey("NEW_ITEMS_LOCALIZE_KEY")
    let seller: String = StringHelper.localizedStringWithKey("SELLERS_LOCALIZE_KEY")
    
    let wishlistError: String = StringHelper.localizedStringWithKey("WISHLIST_ERROR_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("SOMETHING_WENT_WRONG_LOCALIZE_KEY")
    let home: String = StringHelper.localizedStringWithKey("HOME_LOCALIZE_KEY")
    let backToTop: String = StringHelper.localizedStringWithKey("BACK_TO_TOP_LOCALIZE_KEY")
    let off: String = StringHelper.localizedStringWithKey("OFF_LOCALIZE_KEY")
    
    var searchViewContoller: SearchViewController?
    var wishlisViewController: WishlistViewController?
    var cartViewController: CartViewController?
    
    var scrollYPosition: CGFloat = 0.0
    
    var emptyView: EmptyView?
    var searchBarView: SearchBarView?
    var yiHud: YiHUD?
    var profileModel: ProfileUserDetailsModel = ProfileUserDetailsModel()
    var customTabBarController: CustomTabBarController?
    
    var layouts: [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var backToTopButton: UIButton!
    @IBOutlet weak var topBarView: UIView!
    
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
    let twelveLayout = "LayoutTwelveCollectionViewCell"
    let thirteenLayout = "LayoutThirteenCollectionViewCell"
    let fourteenLayout = "LayoutFourteenCollectionViewCell"
    
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
    
    var oldPushNotifData: String = ""
    
    //Search
    var searchType = SearchType.Product
    let manager = APIManager.sharedInstance
    
    var searchTask: NSURLSessionDataTask?
    var suggestions: [SearchSuggestionModel] = []
    
    var refferalCode: String = ""
    
    //MARK: - Life Cycle
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        self.setupSearchBar()
        self.setupBackToTopButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
//        self.setupSearchBar()
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
        
        self.title = self.home
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
        self.registerCellWithNibName(OverseasCollectionViewCell.nibNameAndIdentifier())
        self.registerCellWithNibName(self.twelveLayout)
        self.registerCellWithNibName(self.thirteenLayout)
        self.registerCellWithNibName(self.fourteenLayout)
        self.fireGetHomePageData(true)
        
        self.changeDashBoardToCategory()
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onRegistration:",
            name: appDelegate.registrationKey, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onNewMessage:",
            name: appDelegate.messageKey, object: nil)
        
        self.view.layoutIfNeeded()
        //set customTabbar
        self.customTabBarController = self.tabBarController as? CustomTabBarController
        self.customTabBarController?.isValidToSwitchToMenuTabBarItems = false
        self.circularDraweView("circular-drawer")
        self.tabBarController!.delegate = self
        
        self.backToTopButton.layer.cornerRadius = 15
        self.addPullToRefresh()
        
        let languageType: LanguageType = LanguageHelper.currentLanguge()
        
        if languageType == .Chinese {
            println("Device language is chinese!")
        } else {
            println("Device language is english!")
        }
        
        if !self.isJsonStringEmpty() {
            self.populateHomePageWithDictionary(self.coreDataJsonString())
        }
        
        self.collectionView.contentInset = UIEdgeInsetsMake(-20, 0, 0, 0);
        self.automaticallyAdjustsScrollViewInsets = true
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
    
    //MARK: - Add Pull To Refresh
    func setupSearchBar() {
        self.searchBarView = SearchBarView.initSearchBar()
        self.searchBarView?.showSearchBarToView(self.topBarView, mainView: self.view)
        self.searchBarView?.delegate = self
        self.searchBarView?.setProfileImage(SessionManager.profileImageStringUrl())
        self.view.layoutIfNeeded()
        self.searchBarView?.frame.size.width = UIScreen.mainScreen().bounds.width
    }
    
    //MARK: -
    //MARK: - Back To Top Button
    func setupBackToTopButton() {
        self.backToTopButton.layer.cornerRadius = 15
        self.backToTopButton.alpha = 0
        self.backToTopButton.backgroundColor = Constants.Colors.appTheme
        self.backToTopButton.layer.shadowColor = UIColor.darkGrayColor().CGColor
        self.backToTopButton.layer.shadowOffset = CGSizeMake(0, 5)
        self.backToTopButton.layer.shadowRadius = 5
        self.backToTopButton.layer.shadowOpacity = 1.0
        self.backToTopButton.setTitle(self.backToTop, forState: UIControlState.Normal)
    }
    
    //MARK: -
    //MARK: - Close Keyboard
    func closeKeyboard() {
        self.view.endEditing(true)
    }
    
    //MARK: -
    //MARK: - collectionViewLayout()
    func collectionViewLayout() {
        self.collectionView.collectionViewLayout = UICollectionViewLayout()
        
        let homePageCollectionViewLayout: HomePageCollectionViewLayout2 = HomePageCollectionViewLayout2()
        homePageCollectionViewLayout.homePageModel = self.homePageModel
        homePageCollectionViewLayout.layouts = self.layouts
        
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.collectionView.collectionViewLayout = homePageCollectionViewLayout
        //decoration view
        self.registerDecorationView(self.sectionBackgroundNibName)
    }
    
    //MARK: -
    //MARK: - Register Header Collection View
    func registerHeaderCollectionView(nibName: String) {
        var layoutHeaderCollectionViewNib: UINib = UINib(nibName: nibName, bundle: nil)
        collectionView!.registerNib(layoutHeaderCollectionViewNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: nibName)
    }
    
    //MARK: -
    //MARK: - Register Decoration View
    func registerDecorationView(nibName: String) {
        var decorationViewNib: UINib = UINib(nibName: nibName, bundle: nil)
        self.collectionView?.collectionViewLayout.registerNib(decorationViewNib, forDecorationViewOfKind: nibName)
    }
    
    //MARK: -
    //MARK: - Register Cell
    func registerCellWithNibName(nibName: String) {
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: nibName)
    }
    
    //MARK: -
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
    
    //MARK: -
    //MARK: - Show Alert
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
    func onNewMessage(notification : NSNotification){
        if let info = notification.userInfo as? Dictionary<String, AnyObject> {
            if let data = info["data"] as? String{
                if let data2 = data.dataUsingEncoding(NSUTF8StringEncoding){
                    if let json = NSJSONSerialization.JSONObjectWithData(data2, options: .MutableContainers, error: nil) as? [String:AnyObject] {
                        if let id = json["recipientUid"] as? Int {
                            if "\(id)" == SessionManager.userId() && self.oldPushNotifData != data {
                                var count = SessionManager.getUnReadMessagesCount() + 1
                                SessionManager.setUnReadMessagesCount(count)
                                self.circularDraweView("circular-drawer")
                            }
                        }
                    }
                }
                self.oldPushNotifData = data
            }
        }
        
    }
    
    //MARK: Fire Create Registration
    //For GCM Registration
    func fireCreateRegistration(registrationID : String) {
        self.showHUD()
        //        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "registrationId": "\(registrationID)",
            "access_token"  : SessionManager.accessToken(),
            "deviceType"    : "1"
            ]   as Dictionary<String, String>
        
        let url = APIAtlas.baseUrl + APIAtlas.ACTION_GCM_CREATE
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.yiHud?.hide()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                println(task.response?.description)
                
                println(error.description)
                if (Reachability.isConnectedToNetwork()) {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.fireRefreshToken()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.somethingWentWrong, title: self.error)
                    }
                }
                self.yiHud?.hide()
        })
    }
    
    //MARK: - Add Empty View
    //Show this view if theres no internet connection
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.view.layoutIfNeeded()
        self.emptyView?.frame = self.view.frame
        self.emptyView!.delegate = self
        self.view.addSubview(self.emptyView!)
        
        self.collectionView.hidden = true
    }

    //MARK: -
    //MARK: - Change DashBoard to Category
    func changeDashBoardToCategory() {
        var viewControllers: [UINavigationController] = self.tabBarController!.viewControllers as! [UINavigationController]
        
        let categories = StringHelper.localizedStringWithKey("WEBVIEW_CATEGORIES")
        let webViewController: WebViewController = WebViewController(nibName: "WebViewController", bundle: nil) as WebViewController
        webViewController.webviewSource = WebviewSource.Category
        webViewController.title = categories
        webViewController.isFromFab = true
        webViewController.isBackButtonVisible = false
        let navigationController2: UINavigationController = UINavigationController(rootViewController: webViewController) as UINavigationController
        navigationController2.navigationBar.barTintColor = Constants.Colors.appTheme
        navigationController2.navigationBar.tintColor = UIColor.whiteColor()
        viewControllers[1] = navigationController2
        self.tabBarController!.viewControllers = viewControllers
        
        
        let unselectedImage: UIImage = UIImage(named: "dashboard-category")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let item1: UITabBarItem = self.tabBarController?.tabBar.items![1] as! UITabBarItem
        item1.selectedImage = unselectedImage
        item1.image = unselectedImage
    }
    
    //MARK: - Circular Drawer View
    //Function for changin tabBar item to circle
    func circularDraweView(imageName: String) {
        let unselectedImage: UIImage = UIImage(named: imageName)!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let item2: UITabBarItem = self.tabBarController?.tabBar.items![2] as! UITabBarItem
        item2.selectedImage = unselectedImage
        item2.image = unselectedImage
        item2.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        if SessionManager.getUnReadMessagesCount() > 0 {
            item2.badgeValue = "\(SessionManager.getUnReadMessagesCount())"
        }
    }
    
    //MARK: - Fire Get Home Page Data
    //Request for getting json data for populating homepage
    func fireGetHomePageData(showHuD: Bool) {
        /*if showHuD {
            self.showHUD()
        }*/
        
        WebServiceManager.fireGetHomePageDataWithUrl(APIAtlas.homeUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.populateHomePageWithDictionary(responseObject as! NSDictionary)
                self.yiHud?.hide()
                
                self.addOrUpdateHomeDataToCoreDataWithDataString(StringHelper.convertDictionaryToJsonString(responseObject as! NSDictionary) as String)
                
                self.collectionView.hidden = false
                //get user info
                if SessionManager.isLoggedIn() {
                    self.fireGetUserInfo()
                } else {
                    SessionManager.saveCookies()
                }
            } else {
                //self.yiHud?.hide()
                
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    self.addEmptyView()
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                    self.addEmptyView()
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    //Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                    if self.isJsonStringEmpty() {
                        self.addEmptyView()
                    } else {
                        //show cached data
                        //self.showNoDataBanner()
                        //self.populateHomePageWithDictionary(self.coreDataJsonString())
                    }
                    
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    if self.isJsonStringEmpty() {
                        self.addEmptyView()
                    } else {
                        //show cached data
//                        self.showNoDataBanner()
//                        self.populateHomePageWithDictionary(self.coreDataJsonString())
                    }
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
//                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                    println(Constants.Localized.error)
                    self.addEmptyView()
                }
            }
        })
    }
    
    //MARK: -
    //MARK: - Show No Data Banner
    func showNoDataBanner() {
        let kNoInternetViewHeight: CGFloat = 26
        let noInternetView: UIView = XibHelper.puffViewWithNibName("NoInternetConnectionView", index: 0)
        noInternetView.frame = CGRectMake(0, 20, self.view.frame.size.width, kNoInternetViewHeight)
        noInternetView.layer.zPosition = 100
        noInternetView.alpha = 0
        self.view.addSubview(noInternetView)
        
        UIView.animateWithDuration(2.0, delay: 1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            noInternetView.alpha = 1
        }), completion: {
            (value: Bool) in
            Delay.delayWithDuration(0.3, completionHandler: { (success) -> Void in
                UIView.animateWithDuration(2.0, delay: 1.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
                    noInternetView.alpha = 0
                }), completion: {
                    (value: Bool) in
                    noInternetView.removeFromSuperview()
                })
            })
        })
    }
    
    //MARK: -
    //MARK: - Add or Update Home Data to Core Data With Data String
    func addOrUpdateHomeDataToCoreDataWithDataString(jsonString: String) {
        var homeEntities: [HomeEntity] = HomeEntity.findAll() as! [HomeEntity]
        
        if homeEntities.count == 0 {
            let homeEntity: HomeEntity = HomeEntity.createEntity() as! HomeEntity
            homeEntity.json = jsonString
            homeEntities.append(homeEntity)
            NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
            println("new record added to homeEntity")
        } else {
            let homeEntity: HomeEntity = homeEntities.first!
            homeEntity.json = jsonString
            homeEntities.append(homeEntity)
            NSManagedObjectContext.defaultContext().saveToPersistentStoreAndWait()
            println("updated record in homeEntity")
        }
    }
    
    //MARK: -
    //MARK: - isJsonStringEmpty
    func isJsonStringEmpty() -> Bool {
        var homeEntities: [HomeEntity] = HomeEntity.findAll() as! [HomeEntity]
        
        if homeEntities.count == 0 {
            return true
        } else {
            return false
        }
    }
    
    //MARK: -
    //MARK: -  Core Data Json String
    func coreDataJsonString() -> NSDictionary {
        let homeEntities: [HomeEntity] = HomeEntity.findAll() as! [HomeEntity]
        return StringHelper.convertStringToDictionary(homeEntities.first!.json)
    }
    
    //MARK: -
    //MARK: - Populate Home PageWith  Dictionary
    func populateHomePageWithDictionary(dictionary: NSDictionary) {
        let yPosition: CGFloat = self.scrollYPosition
        self.collectionView.hidden = false
        self.homePageModel = HomePageModel.parseDataFromDictionary(dictionary)
        self.layouts.removeAll(keepCapacity: true)
        for (index, model) in enumerate(self.homePageModel.data) {

            if model.isKindOfClass(LayoutOneModel) {
                self.layouts.append("1")
                self.loadImageInSectionOne(model as! LayoutOneModel)
            } else if model.isKindOfClass(LayoutTwoModel) {
                self.layouts.append("2")
            } else if model.isKindOfClass(LayoutThreeModel) {
                self.layouts.append("3")
            } else if model.isKindOfClass(LayoutFourModel) { // Flash Sale
                let layoutFourModel: LayoutFourModel = self.homePageModel.data[index] as! LayoutFourModel
                // MARK: TODO
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
            } else if model.isKindOfClass(LayoutElevenModel) {
                self.layouts.append("11")
            } else if model.isKindOfClass(LayoutTwelveModel) {
                self.layouts.append("12")
                self.layouts.append("13")
            } else if model.isKindOfClass(LayoutThirteenModel) {
//                self.layouts.append("13")
            } else if model.isKindOfClass(LayoutFourteenModel) {
                self.layouts.append("14")
            }
        }
        
//        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData()
            self.collectionViewLayout()
            self.collectionView.setContentOffset(CGPointMake(0, yPosition), animated: false)
//        })
    }
    
    //MARK: - 
    //MARK: - Load Image in Section One
    func loadImageInSectionOne(layoutOneModel: LayoutOneModel) {
        for imageData in layoutOneModel.data {
            self.loadImage(imageData.image)
        }
    }
    
    //MARK: -
    //MARK: - Fire Get User Info
    func fireGetUserInfo() {
        self.showHUD()
        WebServiceManager.fireGetUserInfoWithUrl(APIAtlas.getUserInfoUrl, accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            if successful {
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
                
                SessionManager.setLang(self.profileModel.address.latitude)
                SessionManager.setLong(self.profileModel.address.longitude)
                println(self.profileModel.firstName)
                SessionManager.setFirstName(self.profileModel.firstName)
                SessionManager.setLastName(self.profileModel.lastName)
                SessionManager.setMobileNumber(self.profileModel.contactNumber)
                SessionManager.setEmailAddress(self.profileModel.email)
                SessionManager.setReferrerCode(self.profileModel.referrerCode)
                
//                println("first name: \(self.profileModel.firstName)")
//                println("last name: \(self.profileModel.lastName)")
//                println("contact number: \(self.profileModel.contactNumber)")
                
                //Update tab bar icons badges
                self.updateTabBarBadge()
            } else {
                self.yiHud?.hide()
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    
                    if errorModel.message == "The access token provided is invalid." {
                        UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                            self.logout()
                        })
                    } else {
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    }
                    
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
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
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
        }
    }
    
    //MARK: -
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
    
    //MARK: -
    //MARK: - Fire Refresh Token
    func fireRefreshToken() {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireGetUserInfo()
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    self.logout()
                })
            }
        })
    }
    
    //MARK: -
    //MARK: logout
    func logout() {
        SessionManager.logout()
        FBSDKLoginManager().logOut()
        GPPSignIn.sharedInstance().signOut()
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.startPage()
    }
    
    //MARK: -
    //MARK: - Show HUD
    func showHUD() {
        self.yiHud = YiHUD.initHud()
        self.yiHud!.showHUDToView(self.view)
        self.yiHud!.showHUDToView(self.view)
        self.yiHud!.showHUDToView(self.view)
        self.yiHud!.showHUDToView(self.view)
    }
    
    //MARK: -
    //MARK: - Did Tap Reload
    func didTapReload() {
        self.emptyView?.removeFromSuperview()
        self.fireGetHomePageData(true)
    }
    
    //MARK: -
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
        case 11:
            return 1
        case 12:
            return 1
        case 13:
            return 4
        case 14:
            return 4//self.homePageModel.data[section].data.count
        default:
            return 0
        }
    }
    
    //MARK: -
    //MARK: -
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
        } else if self.layouts[indexPath.section] == "11" {
            return self.overseasCollectionViewCell(indexPath)
        } else if self.layouts[indexPath.section] == "12" {
            if indexPath.row == 0 {
                return self.layoutTwelveCollectionViewCellWithIndexPath(indexPath)
            } else {
                return self.layoutThirteenCollectionViewCellWithIndexPath(indexPath)
            }
        } else if self.layouts[indexPath.section] == "13" {
            return self.layoutThirteenCollectionViewCellWithIndexPath(indexPath)
        } else if self.layouts[indexPath.section] == "14" {
            return self.layoutFourteenCollectionViewCellWithIndexPath(indexPath)
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
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutTwelveModel) {
            let layoutTwelveModel: LayoutTwelveModel = self.homePageModel.data[indexPath.section] as! LayoutTwelveModel
            if layoutTwelveModel.isViewMoreAvailable {
                headerView.target = layoutTwelveModel.viewMoreTarget.targetUrl
                headerView.targetType = layoutTwelveModel.viewMoreTarget.targetType
                headerView.viewMoreButton.hidden = false
            } else {
                headerView.viewMoreButton.hidden = true
            }
            
            headerView.sectionTitle = layoutTwelveModel.sectionTitle
            headerView.titleLabel.text = layoutTwelveModel.sectionTitle
            headerView.updateTitleLine()
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutThirteenModel) {
            let layoutThirteenModel: LayoutThirteenModel = self.homePageModel.data[indexPath.section] as! LayoutThirteenModel
            if layoutThirteenModel.isViewMoreAvailable {
                headerView.target = layoutThirteenModel.viewMoreTarget.targetUrl
                headerView.targetType = layoutThirteenModel.viewMoreTarget.targetType
                headerView.viewMoreButton.hidden = false
            } else {
                headerView.viewMoreButton.hidden = true
            }

            headerView.sectionTitle = layoutThirteenModel.sectionTitle
            headerView.titleLabel.text = layoutThirteenModel.sectionTitle
            headerView.updateTitleLine()
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutFourteenModel) {
            let layoutFourteenModel: LayoutFourteenModel = self.homePageModel.data[indexPath.section] as! LayoutFourteenModel
            if layoutFourteenModel.isViewMoreAvailable {
                headerView.target = layoutFourteenModel.viewMoreTarget.targetUrl
                headerView.targetType = layoutFourteenModel.viewMoreTarget.targetType
                headerView.viewMoreButton.hidden = false
            } else {
                headerView.viewMoreButton.hidden = true
            }

            headerView.sectionTitle = layoutFourteenModel.sectionTitle
            headerView.titleLabel.text = layoutFourteenModel.sectionTitle
            headerView.updateTitleLine()
        }
        
        return headerView
    }
    
    //MARK: -
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
        } else if cell.isKindOfClass(LayoutThirteenCollectionViewCell) {
            let layoutThirteen: LayoutThirteenCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! LayoutThirteenCollectionViewCell
            self.didClickItemWithTarget(layoutThirteen.target, targetType: layoutThirteen.targetType)
        } else if cell.isKindOfClass(LayoutFourteenCollectionViewCell) {
            let layoutFourteen: LayoutFourteenCollectionViewCell = collectionView.cellForItemAtIndexPath(indexPath) as! LayoutFourteenCollectionViewCell
            self.didClickItemWithTarget(layoutFourteen.target, targetType: layoutFourteen.targetType)
        }
        
        // MARK: - TODO
        // MARK: put a delegate here for the new layouts
    }
    
    //MARK: -
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
    
    //MARK: -
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
    
    //MARK: -
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
        
        fullImageCell.itemProductImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutThreeModel.data[indexPath.row].image), placeholderImage: UIImage(named: "dummy-placeholder"), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
            if let imageView = fullImageCell.itemProductImageView {
                if downloadedImage != nil {
                    imageView.fadeInImageWithImage(downloadedImage)
                }
            }
        })
        
        fullImageCell.target = layoutThreeModel.data[indexPath.row].target.targetUrl
        fullImageCell.targetType = layoutThreeModel.data[indexPath.row].target.targetType
        fullImageCell.layer.cornerRadius = 5
        fullImageCell.clipsToBounds = true
        
        return fullImageCell
    }
    
    func itemWidthHalfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell) -> CGFloat {
        let rightInset: Int = 15
        self.view.layoutIfNeeded()
        
        /*if IphoneType.isIphone6() || IphoneType.isIphone6Plus() {
        println((self.view.frame.size.width / 2) - 8)
        return (self.view.frame.size.width / 2) - 8
        } else {
        return (self.view.frame.size.width / 2) - 8
        }*/
        
        return SectionHeight.sectionThreeCellWidth()
    }
    
    //MARK: -
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
    
    //MARK: -
    //MARK: - Flash Collection View Delegate
    func flashSaleCollectionViewCell(didTapProductImageView productImageView: ProductImageView) {
        self.didClickItemWithTarget(productImageView.target, targetType: productImageView.targetType)
    }
    
    //MARK: -
    //MARK: - Seconds To Hours Minutes Seconds
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    //MARK: -
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
            Delay.delayWithDuration(1.0, completionHandler: { (success) -> Void in
                self.timer.invalidate()
                if self.view.window != nil && self.remainingTime == -1 {
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.changeRootToHomeView()
                }
            })
        }
    }
    
    //MARK: -
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
            flashSaleCell.productOneImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutFourModel.data[0].image), placeholderImage: UIImage(named: "dummy-placeholder"))
            flashSaleCell.productOneDiscountLabel.text = "\(layoutFourModel.data[0].discountPercentage)% \(self.off)"
            flashSaleCell.productOneImageView.target = layoutFourModel.data[0].target.targetUrl
            flashSaleCell.productOneImageView.targetType = layoutFourModel.data[0].target.targetType
        }
        
        if layoutFourModel.data.count >= 2 {
            flashSaleCell.productTwoImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutFourModel.data[1].image), placeholderImage: UIImage(named: "dummy-placeholder"))
            flashSaleCell.productTwoImageView.target = layoutFourModel.data[1].target.targetUrl
            flashSaleCell.productTwoImageView.targetType = layoutFourModel.data[1].target.targetType
            flashSaleCell.productTwoDiscountLabel.text = "\(layoutFourModel.data[1].discountPercentage)% \(self.off)"
        }
        
        if layoutFourModel.data.count >= 3 {
            flashSaleCell.productThreeImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutFourModel.data[2].image), placeholderImage: UIImage(named: "dummy-placeholder"))
            flashSaleCell.productThreeImageView.target = layoutFourModel.data[2].target.targetUrl
            flashSaleCell.productThreeImageView.targetType = layoutFourModel.data[2].target.targetType
            flashSaleCell.productThreeDiscountLabel.text = "\(layoutFourModel.data[2].discountPercentage)% \(self.off)"
        }
        
        return flashSaleCell
    }
    
    //MARK: -
    //MARK: - Grid Layout
    func twoColumnGridCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> TwoColumnGridCollectionViewCell {
        let twoColumnGridCollectionViewCell: TwoColumnGridCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("TwoColumnGridCollectionViewCell", forIndexPath: indexPath) as! TwoColumnGridCollectionViewCell
        
        let layoutTenModel: LayoutTenModel = self.homePageModel.data[indexPath.section] as! LayoutTenModel
        
        twoColumnGridCollectionViewCell.target = layoutTenModel.data[indexPath.row].target.targetUrl
        twoColumnGridCollectionViewCell.targetType = layoutTenModel.data[indexPath.row].target.targetType
        
        twoColumnGridCollectionViewCell.productItemImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutTenModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
            if let imageView = twoColumnGridCollectionViewCell.productItemImageView {
                if downloadedImage != nil {
                    imageView.fadeInImageWithImage(downloadedImage)
                }
            }
        })
        
        twoColumnGridCollectionViewCell.productNameLabel.text = layoutTenModel.data[indexPath.row].name
        twoColumnGridCollectionViewCell.discountedPriceLabel.text = layoutTenModel.data[indexPath.row].discountedPrice.addPesoSign()
        twoColumnGridCollectionViewCell.discountPercentageLabel.text = layoutTenModel.data[indexPath.row].discountPercentage.formatToPercentage()
        twoColumnGridCollectionViewCell.originalPriceLabel.text = layoutTenModel.data[indexPath.row].originalPrice.addPesoSign()
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
    
    //MARK: -
    //MARK: - Layout Nine Collection View Cell With IndexPath
    func layoutNineCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> LayoutNineCollectionViewCell {
        let layoutNineModel: LayoutNineModel = self.homePageModel.data[indexPath.section] as! LayoutNineModel
        
        let layoutNineCollectionViewCell: LayoutNineCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.layoutNineNibName, forIndexPath: indexPath) as! LayoutNineCollectionViewCell
        layoutNineCollectionViewCell.delegate = self
        
        if layoutNineModel.data.count >= 5 {
            layoutNineCollectionViewCell.productOneNameLabel.text = layoutNineModel.data[0].name
            layoutNineCollectionViewCell.productImageViewOne.title = layoutNineModel.data[0].name
            layoutNineCollectionViewCell.productImageViewOne.target = layoutNineModel.data[0].target.targetUrl
            layoutNineCollectionViewCell.productImageViewOne.targetType = layoutNineModel.data[0].target.targetType
            layoutNineCollectionViewCell.productImageViewOne.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutNineModel.data[0].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = layoutNineCollectionViewCell.productImageViewOne {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
            
            layoutNineCollectionViewCell.productTwoNameLabel.text = layoutNineModel.data[1].name
            layoutNineCollectionViewCell.productImageViewTwo.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutNineModel.data[1].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = layoutNineCollectionViewCell.productImageViewTwo {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
            
            layoutNineCollectionViewCell.productImageViewTwo.target = layoutNineModel.data[1].target.targetUrl
            layoutNineCollectionViewCell.productImageViewTwo.targetType = layoutNineModel.data[1].target.targetType
            layoutNineCollectionViewCell.productImageViewTwo.title = layoutNineModel.data[1].name
            
            layoutNineCollectionViewCell.productThreeNameLabel.text = layoutNineModel.data[2].name
            layoutNineCollectionViewCell.productImageViewThree.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutNineModel.data[2].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = layoutNineCollectionViewCell.productImageViewThree {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
            
            layoutNineCollectionViewCell.productImageViewThree.target = layoutNineModel.data[2].target.targetUrl
            layoutNineCollectionViewCell.productImageViewThree.targetType = layoutNineModel.data[2].target.targetType
            layoutNineCollectionViewCell.productImageViewThree.title = layoutNineModel.data[2].name
            
            layoutNineCollectionViewCell.productFourNameLabel.text = layoutNineModel.data[3].name
            layoutNineCollectionViewCell.productImageViewFour.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutNineModel.data[3].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = layoutNineCollectionViewCell.productImageViewFour {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
            layoutNineCollectionViewCell.productImageViewFour.target = layoutNineModel.data[3].target.targetUrl
            layoutNineCollectionViewCell.productImageViewFour.targetType = layoutNineModel.data[3].target.targetType
            layoutNineCollectionViewCell.productImageViewFour.title = layoutNineModel.data[3].name
            
            
            layoutNineCollectionViewCell.productFiveNameLabel.text = layoutNineModel.data[4].name
            layoutNineCollectionViewCell.productImageViewFive.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutNineModel.data[4].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = layoutNineCollectionViewCell.productImageViewFive {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
            
            layoutNineCollectionViewCell.productImageViewFive.target = layoutNineModel.data[4].target.targetUrl
            layoutNineCollectionViewCell.productImageViewFive.targetType = layoutNineModel.data[4].target.targetType
            layoutNineCollectionViewCell.productImageViewFive.title = layoutNineModel.data[4].name
        }
        
        return layoutNineCollectionViewCell
    }
    
    //MARK: -
    //MARK: - Layout Nine Collection View Cell Delegate
    func layoutNineCollectionViewCellDidClickProductImage(productImage: ProductImageView) {
        self.didClickItemWithTarget(productImage.target, targetType: productImage.targetType, sectionTitle: productImage.title)
    }
    
    //MARK: -
    //MARK: - Twelve Layout
    func layoutTwelveCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> LayoutTwelveCollectionViewCell {
        let layoutTwelveCVC: LayoutTwelveCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("LayoutTwelveCollectionViewCell", forIndexPath: indexPath) as! LayoutTwelveCollectionViewCell
        
        layoutTwelveCVC.delegate = self
        
        let model: LayoutTwelveModel = self.homePageModel.data[indexPath.section] as! LayoutTwelveModel
            
        if model.data.count > 0 {
            layoutTwelveCVC.leftImageView.target = model.data[0].target.targetUrl
            layoutTwelveCVC.leftImageView.targetType = model.data[0].target.targetType
            layoutTwelveCVC.leftImageView.title = model.data[0].name
            layoutTwelveCVC.leftImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(model.data[0].image), placeholderImage: UIImage(named: self.placeHolder), completed: {
                (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = layoutTwelveCVC.leftImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
        }
        
        
        if model.data.count > 1 {
            layoutTwelveCVC.rightUpperImageView.target = model.data[1].target.targetUrl
            layoutTwelveCVC.rightUpperImageView.targetType = model.data[1].target.targetType
            layoutTwelveCVC.rightUpperImageView.title = model.data[1].name
            layoutTwelveCVC.rightUpperImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(model.data[1].image), placeholderImage: UIImage(named: self.placeHolder), completed: {
                (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = layoutTwelveCVC.rightUpperImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
        }
        
        
        if model.data.count > 2 {
            layoutTwelveCVC.rightLowerImageView.target = model.data[2].target.targetUrl
            layoutTwelveCVC.rightLowerImageView.targetType = model.data[2].target.targetType
            layoutTwelveCVC.rightLowerImageView.title = model.data[2].name
            layoutTwelveCVC.rightLowerImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(model.data[2].image), placeholderImage: UIImage(named: self.placeHolder), completed: {
                (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = layoutTwelveCVC.rightLowerImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
        }
        
        return layoutTwelveCVC
    }
    
    //MARK: -
    //MARK: - Thirteen Layout
    func layoutThirteenCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> LayoutThirteenCollectionViewCell {
        let layoutThirteenCVC: LayoutThirteenCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("LayoutThirteenCollectionViewCell", forIndexPath: indexPath) as! LayoutThirteenCollectionViewCell
        
        let model: LayoutThirteenModel = self.homePageModel.data[indexPath.section] as! LayoutThirteenModel

        layoutThirteenCVC.target = model.data[indexPath.row].target.targetUrl
        layoutThirteenCVC.targetType = model.data[indexPath.row].target.targetType

        layoutThirteenCVC.productImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(model.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder), completed: {
            (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
            if let imageView = layoutThirteenCVC.productImageView {
                if downloadedImage != nil {
                    imageView.fadeInImageWithImage(downloadedImage)
                }
            }
        })
        
        layoutThirteenCVC.nameLabel.text = model.data[indexPath.row].name
        layoutThirteenCVC.priceLabel.text = model.data[indexPath.row].originalPrice.formatToPeso()
        layoutThirteenCVC.discountLabel.attributedText = formatToAttributedDiscountString(model.data[indexPath.row].discountedPrice.formatToPeso(), discountPercentText: model.data[indexPath.row].discountPercentage + "%")
        
        return layoutThirteenCVC
    }
    
    //MARK: -
    //MARK: - Thirteen Layout
    func layoutFourteenCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> LayoutFourteenCollectionViewCell {
        let layoutFourteenCVC: LayoutFourteenCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("LayoutFourteenCollectionViewCell", forIndexPath: indexPath) as! LayoutFourteenCollectionViewCell
        
        let model: LayoutFourteenModel = self.homePageModel.data[indexPath.section] as! LayoutFourteenModel
        
        layoutFourteenCVC.target = model.data[indexPath.row].target.targetUrl
        layoutFourteenCVC.targetType = model.data[indexPath.row].target.targetType
        
        layoutFourteenCVC.productImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(model.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder), completed: {
            (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
            if let imageView = layoutFourteenCVC.productImageView {
                if downloadedImage != nil {
                    imageView.fadeInImageWithImage(downloadedImage)
                }
            }
        })
        
        layoutFourteenCVC.nameLabel.text = model.data[indexPath.row].name
        layoutFourteenCVC.priceLabel.text = model.data[indexPath.row].originalPrice.formatToPeso()
        //layoutFourteenCVC.discountLabel.attributedText = formatToAttributedDiscountString(model.data[indexPath.row].discountedPrice.formatToPeso(), discountPercentText: model.data[indexPath.row].discountPercentage + "%")
        
        if model.data[indexPath.row].discountPercentage == "0.0" || model.data[indexPath.row].discountPercentage == "0" {
            layoutFourteenCVC.discountLabel.hidden = true
        } else {
            layoutFourteenCVC.discountLabel.attributedText = formatToAttributedDiscountString(model.data[indexPath.row].discountedPrice.formatToPeso(), discountPercentText: model.data[indexPath.row].discountPercentage + "%")
            layoutFourteenCVC.discountLabel.hidden = false
            
        }

        return layoutFourteenCVC
    }
    
    //MARK: -
    //MARK: - Vertical Image Collection View Cell With IndexPath
    func verticalImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> VerticalImageCollectionViewCell {
        let verticalImageCollectionViewCell: VerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.verticalImageNibName
            , forIndexPath: indexPath) as! VerticalImageCollectionViewCell
        if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutFiveModel) {
            let layoutFiveModel: LayoutFiveModel = self.homePageModel.data[indexPath.section] as! LayoutFiveModel
            if indexPath.row < layoutFiveModel.data.count {
                verticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutFiveModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                    if let imageView = verticalImageCollectionViewCell.productItemImageView {
                        if downloadedImage != nil {
                            imageView.fadeInImageWithImage(downloadedImage)
                        }
                    }
                })
                
                verticalImageCollectionViewCell.productNameLabel.text = layoutFiveModel.data[indexPath.row].name
                verticalImageCollectionViewCell.discountedPriceLabel.text = layoutFiveModel.data[indexPath.row].discountedPrice.addPesoSign()
                verticalImageCollectionViewCell.discountPercentageLabel.text = layoutFiveModel.data[indexPath.row].discountPercentage.formatToPercentage()
                
                verticalImageCollectionViewCell.target = layoutFiveModel.data[indexPath.row].target.targetUrl
                verticalImageCollectionViewCell.targetType = layoutFiveModel.data[indexPath.row].target.targetType
                
                verticalImageCollectionViewCell.originalPriceLabel.text = layoutFiveModel.data[indexPath.row].originalPrice.addPesoSign()
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
                verticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutSevenModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                    if let imageView = verticalImageCollectionViewCell.productItemImageView {
                        if downloadedImage != nil {
                            imageView.fadeInImageWithImage(downloadedImage)
                        }
                    }
                })
                
                verticalImageCollectionViewCell.productNameLabel.text = layoutSevenModel.data[indexPath.row].name
                verticalImageCollectionViewCell.discountedPriceLabel.text = layoutSevenModel.data[indexPath.row].discountedPrice.addPesoSign()
                verticalImageCollectionViewCell.discountPercentageLabel.text = layoutSevenModel.data[indexPath.row].discountPercentage.formatToPercentage()
                
                verticalImageCollectionViewCell.target = layoutSevenModel.data[indexPath.row].target.targetUrl
                verticalImageCollectionViewCell.targetType = layoutSevenModel.data[indexPath.row].target.targetType
                
                verticalImageCollectionViewCell.originalPriceLabel.text = layoutSevenModel.data[indexPath.row].originalPrice.addPesoSign()
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
    
    //MARK: -
    //MARK: - Half Vertical Image Collection View Cell With IndexPath
    func halfVerticalImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> HalfVerticalImageCollectionViewCell {
        let halfVerticalImageCollectionViewCell: HalfVerticalImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.halfVerticalNibName, forIndexPath: indexPath) as! HalfVerticalImageCollectionViewCell
        
        if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutFiveModel) {
            let layoutFiveModel: LayoutFiveModel = self.homePageModel.data[indexPath.section] as! LayoutFiveModel
            
            if indexPath.row < layoutFiveModel.data.count {
                halfVerticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutFiveModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                    if let imageView = halfVerticalImageCollectionViewCell.productItemImageView {
                        if downloadedImage != nil {
                            imageView.fadeInImageWithImage(downloadedImage)
                        }
                    }
                })
                
                halfVerticalImageCollectionViewCell.productNameLabel.text = layoutFiveModel.data[indexPath.row].name
                halfVerticalImageCollectionViewCell.discountedPriceLabel.text = layoutFiveModel.data[indexPath.row].discountedPrice.addPesoSign()
                halfVerticalImageCollectionViewCell.discountPercentageLabel.text = layoutFiveModel.data[indexPath.row].discountPercentage.formatToPercentage()
                
                halfVerticalImageCollectionViewCell.target = layoutFiveModel.data[indexPath.row].target.targetUrl
                halfVerticalImageCollectionViewCell.targetType = layoutFiveModel.data[indexPath.row].target.targetType
                
                halfVerticalImageCollectionViewCell.originalPriceLabel.text = layoutFiveModel.data[indexPath.row].originalPrice.addPesoSign()
                
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
                halfVerticalImageCollectionViewCell.productItemImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutSevenModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                    if let imageView = halfVerticalImageCollectionViewCell.productItemImageView {
                        if downloadedImage != nil {
                            imageView.fadeInImageWithImage(downloadedImage)
                        }
                    }
                })
                
                halfVerticalImageCollectionViewCell.productNameLabel.text = layoutSevenModel.data[indexPath.row].name
                halfVerticalImageCollectionViewCell.discountedPriceLabel.text = layoutSevenModel.data[indexPath.row].discountedPrice.addPesoSign()
                halfVerticalImageCollectionViewCell.discountPercentageLabel.text = layoutSevenModel.data[indexPath.row].discountPercentage.formatToPercentage()
                
                halfVerticalImageCollectionViewCell.target = layoutSevenModel.data[indexPath.row].target.targetUrl
                halfVerticalImageCollectionViewCell.targetType = layoutSevenModel.data[indexPath.row].target.targetType
                
                halfVerticalImageCollectionViewCell.originalPriceLabel.text = layoutSevenModel.data[indexPath.row].originalPrice.addPesoSign()
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
    
    //MARK: -
    //MARK: - Header View Delegate
    func layoutHeaderCollectionViewCellDidSelectViewMore(layoutHeaderCollectionViewCell: LayoutHeaderCollectionViewCell) {
        self.didClickItemWithTarget(layoutHeaderCollectionViewCell.target, targetType: layoutHeaderCollectionViewCell.targetType, sectionTitle: layoutHeaderCollectionViewCell.sectionTitle)
    }
    
    //MARK: -
    //MARK: - Full Image Collection View Cell
    func fullImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath, fullImageCollectionView: UICollectionView) -> FullImageCollectionViewCell {
        let fullImageCollectionViewCell: FullImageCollectionViewCell = fullImageCollectionView.dequeueReusableCellWithReuseIdentifier(self.fullImageCellNib, forIndexPath: indexPath) as! FullImageCollectionViewCell
        
        if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutOneModel) {
            let layoutOneModel: LayoutOneModel = self.homePageModel.data[indexPath.section] as! LayoutOneModel
            
            fullImageCollectionViewCell.target = layoutOneModel.data[indexPath.row].target.targetUrl
            fullImageCollectionViewCell.targetType = layoutOneModel.data[indexPath.row].target.targetType
            
            fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutOneModel.data[indexPath.row].image), placeholderImage: UIImage(named: placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = fullImageCollectionViewCell.itemProductImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
            
        } else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutSixModel) {
            let layoutSixModel: LayoutSixModel = self.homePageModel.data[indexPath.section] as! LayoutSixModel
            
            fullImageCollectionViewCell.target = layoutSixModel.data[indexPath.row].target.targetUrl
            fullImageCollectionViewCell.targetType = layoutSixModel.data[indexPath.row].target.targetType
            
            fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutSixModel.data[indexPath.row].image), placeholderImage: UIImage(named: placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = fullImageCollectionViewCell.itemProductImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
            
        }  else if self.homePageModel.data[indexPath.section].isKindOfClass(LayoutTwoModel) {
            let layoutTwoModel: LayoutTwoModel = self.homePageModel.data[indexPath.section] as! LayoutTwoModel
            
            fullImageCollectionViewCell.target = layoutTwoModel.data[indexPath.row].target.targetUrl
            fullImageCollectionViewCell.targetType = layoutTwoModel.data[indexPath.row].target.targetType
            
            fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutTwoModel.data[indexPath.row].image), placeholderImage: UIImage(named: placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = fullImageCollectionViewCell.itemProductImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
        }
        
        return fullImageCollectionViewCell
    }
    
    //MARK: -
    //MARK: - Daily Login With Index Path
    func dailyLoginWithWIndexpath(indexPath: NSIndexPath) -> DailyLoginCollectionViewCell {
        let layoutTwoModel: LayoutTwoModel = self.homePageModel.data[indexPath.section] as! LayoutTwoModel
        
        let dailyLoginCell: DailyLoginCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.dailyLoginNibName, forIndexPath: indexPath) as! DailyLoginCollectionViewCell
        
        dailyLoginCell.delegate = self
        dailyLoginCell.dataSource = self
        dailyLoginCell.collectionView.reloadData()
        
        return dailyLoginCell
    }
    
    //MARK: -
    //MARK: - Half Pager With IndexPath
    func halfPagerWithIndexPath(indexPath: NSIndexPath) -> HalfPagerCollectionViewCell {
        let halfPager: HalfPagerCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.halfPagerCellNibName, forIndexPath: indexPath) as! HalfPagerCollectionViewCell
        halfPager.delegate = self
        halfPager.dataSource = self
        return halfPager
    }
    
    //MARK: -
    //MARK: - Seller Collection View Cell With Index Path
    func sellerCollectionViewCellWithIndexPath(indexPath: NSIndexPath) -> SellerCollectionViewCell {
        let sellerCollectionView: SellerCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier(self.sellerNibName, forIndexPath: indexPath) as! SellerCollectionViewCell
        
        return sellerCollectionView
    }
    
    //MARK: -
    //MARK: - Seller Carousel
    func sellerCarouselWithIndexPath(indexPath: NSIndexPath) -> SellerCarouselCollectionViewCell {
        let sellerCarosuel: SellerCarouselCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(self.sellerCarouselNibName, forIndexPath: indexPath) as! SellerCarouselCollectionViewCell
        
        sellerCarosuel.delegate = self
        sellerCarosuel.dataSource = self
        return sellerCarosuel
    }
    
    //MARK: - 
    //MARK: - Overseas Collection View Cell
    func overseasCollectionViewCell(indexPath: NSIndexPath) -> OverseasCollectionViewCell {
        let overseasCollectionViewCell: OverseasCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(OverseasCollectionViewCell.nibNameAndIdentifier(), forIndexPath: indexPath) as! OverseasCollectionViewCell
        
        overseasCollectionViewCell.delegate = self
        overseasCollectionViewCell.dataSource = self
        
        return overseasCollectionViewCell
    }
    
    //MARK: -
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
        sellerCollectionView.sellerProfileImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutEightModel.data[indexPath.row].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
            if let imageView = sellerCollectionView.sellerProfileImageView {
                if downloadedImage != nil {
                    imageView.fadeInImageWithImage(downloadedImage)
                }
            }
        })
        
        if layoutEightModel.data[indexPath.row].data.count >= 1 {
            sellerCollectionView.productOneImageView.target = layoutEightModel.data[indexPath.row].data[0].target.targetUrl
            sellerCollectionView.productOneImageView.targetType = layoutEightModel.data[indexPath.row].data[0].target.targetType
            sellerCollectionView.productOneImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutEightModel.data[indexPath.row].data[0].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = sellerCollectionView.productOneImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
            
        }
        
        if layoutEightModel.data[indexPath.row].data.count >= 2 {
            sellerCollectionView.productTwoImageView.target = layoutEightModel.data[indexPath.row].data[1].target.targetUrl
            sellerCollectionView.productTwoImageView.targetType = layoutEightModel.data[indexPath.row].data[1].target.targetType
            sellerCollectionView.productTwoImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutEightModel.data[indexPath.row].data[1].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = sellerCollectionView.productTwoImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
        }
        
        if layoutEightModel.data[indexPath.row].data.count >= 3 {
            sellerCollectionView.productThreeImageView.target = layoutEightModel.data[indexPath.row].data[2].target.targetUrl
            sellerCollectionView.productThreeImageView.targetType = layoutEightModel.data[indexPath.row].data[2].target.targetType
            sellerCollectionView.productThreeImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutEightModel.data[indexPath.row].data[2].image), placeholderImage: UIImage(named: self.placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = sellerCollectionView.productThreeImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
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
    
    //MARK: -
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
    
    //MARK: -
    //MARK: - Add Gesture To Seller Product
    func addGestureToSellerProduct(productImageView: ProductImageView) {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapItem:")
        productImageView.userInteractionEnabled = true
        productImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    //MARK: -
    //MARK: - Did Tap Item
    func didTapItem(tap: UITapGestureRecognizer) {
        let itemImageView: ProductImageView = tap.view as! ProductImageView
        self.didClickItemWithTarget(itemImageView.target, targetType: itemImageView.targetType)
    }
    
    //MARK: -
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
                    self.tabBarController!.view.makeToast(Constants.Localized.targetNotAvailable, duration: 1.5, position: CSToastPositionTop, style: CSToastManager.sharedStyle())
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
        } else if targetType == "countryProductList" {
            //code here...
//            Toast.displayToastWithMessage("country prod list action here", view: self.navigationController!.view)
            let resultViewController: ResultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            resultViewController.pageTitle = sectionTitle
            resultViewController.passModel(SearchSuggestionModel(suggestion: "", imageURL: "", searchUrl: target))
            self.navigationController!.pushViewController(resultViewController, animated: true)
        }
    }
    
    //MARK: -
    //MARK: - Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.scrollYPosition = scrollView.contentOffset.y
        let indexes: [NSIndexPath] = self.collectionView.indexPathsForVisibleItems() as! [NSIndexPath]
        var isShowBackToTop: Bool = true
        self.closeKeyboard()
        
        if self.searchBarView != nil {
            self.searchBarView!.hideSearchTypePicker()
            self.searchBarView!.hideAutoComplete()
        }
        
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
    
    //MARK: -
    //MARK: - Show Back To Top
    func showBackToTop() {
        UIView.animateWithDuration(0.8, animations: {
            self.backToTopButton.alpha = 1
            }, completion: {
                (value: Bool) in
        })
    }
    
    //MARK: -
    //MARK: - Show Back To Top
    func hideBackToTop() {
        UIView.animateWithDuration(0.8, animations: {
            self.backToTopButton.alpha = 0
            }, completion: {
                (value: Bool) in
        })
    }
    
    //MARK: -
    //MARK: - Back To Top
    @IBAction func backToTop(sender: AnyObject) {
        self.collectionView.setContentOffset(CGPointZero, animated: true)
    }
    
    //MARK: -
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
        
    }
    
    //MARK: -
    //MARK: - Daily Login Data Source
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, numberOfItemsInSection section: Int) -> Int {
        if self.collectionView.indexPathForCell(dailyLoginCollectionViewCell) != nil {
            let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(dailyLoginCollectionViewCell)!
            let layoutTwoModel: LayoutTwoModel = self.homePageModel.data[parentIndexPath.section] as! LayoutTwoModel
            
            return layoutTwoModel.data.count
        } else {
            return 0
        }
    }
    
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell {
        
        let fullImageCollectionViewCell: FullImageCollectionViewCell = dailyLoginCollectionViewCell.collectionView.dequeueReusableCellWithReuseIdentifier(self.fullImageCellNib, forIndexPath: indexPath) as! FullImageCollectionViewCell
        
        let parentIndexPath: NSIndexPath = self.collectionView.indexPathForCell(dailyLoginCollectionViewCell)!
        let layoutTwoModel: LayoutTwoModel = self.homePageModel.data[parentIndexPath.section] as! LayoutTwoModel
        
        fullImageCollectionViewCell.target = layoutTwoModel.data[indexPath.row].target.targetUrl
        fullImageCollectionViewCell.targetType = layoutTwoModel.data[indexPath.row].target.targetType
        
        fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutTwoModel.data[indexPath.row].image), placeholderImage: UIImage(named: placeHolder), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
            if let imageView = fullImageCollectionViewCell.itemProductImageView {
                if downloadedImage != nil {
                    imageView.fadeInImageWithImage(downloadedImage)
                }
            }
        })
        
        return fullImageCollectionViewCell
    }
    
    func itemWidthInDailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell) -> CGFloat {
        dailyLoginCollectionViewCell.layoutIfNeeded()
        return dailyLoginCollectionViewCell.collectionView.frame.size.width
    }
    
    func redirectToLoginRegister(isLogin: Bool) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "StartPageStoryBoard", bundle: nil)
        let loginRegisterViewController: LoginAndRegisterTableViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterTableViewController") as! LoginAndRegisterTableViewController
        loginRegisterViewController.isLogin = isLogin
        loginRegisterViewController.refferalCode = self.refferalCode
        self.customTabBarController!.presentViewController(loginRegisterViewController, animated: true, completion: nil)
    }
    
    //MARK: -
    //MARK: - Show Fab
    func showFAB() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "FAB", bundle: nil)
        var fabViewController: FABViewController?
        fabViewController  = storyBoard.instantiateViewControllerWithIdentifier("FABViewController") as? FABViewController
        fabViewController!.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        fabViewController!.providesPresentationContextTransitionStyle = true
        fabViewController!.definesPresentationContext = true
        fabViewController!.view.backgroundColor = UIColor.clearColor()
        fabViewController!.delegate = self
        
        let signIn: String = StringHelper.localizedStringWithKey("SIGNIN_LOCALIZE_KEY")
        let help: String = StringHelper.localizedStringWithKey("HELP_LOCALIZE_KEY")
        let register: String = StringHelper.localizedStringWithKey("REGISTER_LOCALIZE_KEY")
        let messaging: String = StringHelper.localizedStringWithKey("MESSAGING_LOCALIZE_KEY")
        let customizeShopping: String = StringHelper.localizedStringWithKey("CUSTOMIZE_SHOPPING_LOCALIZE_KEY")
        let todaysPromo: String = StringHelper.localizedStringWithKey("TODAYS_PROMO_LOCALIZE_KEY")
        let categories: String = StringHelper.localizedStringWithKey("CATEGORIES_LOCALIZE_KEY")
        let mustBeSignIn: String = StringHelper.localizedStringWithKey("MUST_BE_SIGNIN_LOCALIZE_KEY")
        let followedSeller: String = StringHelper.localizedStringWithKey("FOLLOWED_SELLER_LOCALIZE_KEY")
        let logout: String = StringHelper.localizedStringWithKey("LOGOUT_LOCALIZE_KEY")
        let profile: String = StringHelper.localizedStringWithKey("PROFILE_LOCALIZE_KEY")
        
        if SessionManager.isLoggedIn() {
            fabViewController!.addtextAndIconsWithLeftText("", rightText: "", icon: "close-white", isProfile: false)
            fabViewController!.addtextAndIconsWithLeftText(followedSeller, rightText: "", icon: "fab_following", isProfile: false)
            fabViewController!.addtextAndIconsWithLeftText(messaging, rightText: "\(SessionManager.getUnReadMessagesCount()) unread message(s)", icon: "fab_messaging", isProfile: false)
            fabViewController!.addtextAndIconsWithLeftText(categories, rightText: "", icon: "fab_promo", isProfile: false)
            fabViewController!.addtextAndIconsWithLeftText(help, rightText: "", icon: "fab_help", isProfile: false)
            fabViewController!.addtextAndIconsWithLeftText(profile, rightText: "\(SessionManager.userFullName()) \n \(SessionManager.city()) \(SessionManager.province())", icon: SessionManager.profileImageStringUrl(), isProfile: true)
            self.tabBarController!.presentViewController(fabViewController!, animated: false) { () -> Void in
                
            }
        } else {
            self.circularDraweView("circular-drawer")
            fabViewController!.addtextAndIconsWithLeftText("", rightText: "", icon: "close-white", isProfile: false)
            fabViewController!.addtextAndIconsWithLeftText(register, rightText: "", icon: "fab_register", isProfile: false)
            fabViewController!.addtextAndIconsWithLeftText(signIn, rightText: "", icon: "fab_signin", isProfile: false)
            fabViewController!.addtextAndIconsWithLeftText(categories, rightText: "", icon: "fab_category", isProfile: false)
            fabViewController!.addtextAndIconsWithLeftText(help, rightText: "", icon: "fab_help", isProfile: false)
            
            self.tabBarController!.presentViewController(fabViewController!, animated: false) { () -> Void in
                
            }
        }
    }
}

//MARK: - 
//MARK: - FABView Controller Delegate
extension HomeContainerViewController: FABViewControllerDelegate {
    //MARK: -
    //MARK: - FAB View Controller Delegate
    func fabViewController(viewController: FABViewController, didSelectIndex index: Int) {
        self.redirectToHiddenWithIndex(index)
    }
    
    //not a delegate function of fab
    func redirectToHiddenWithIndex(index: Int) {
        if SessionManager.isLoggedIn() {
            if index != -1 {
                let navigationController: UINavigationController = self.customTabBarController!.viewControllers![2] as! UINavigationController
                let hiddenViewController: HiddenViewController = navigationController.viewControllers[0] as! HiddenViewController
                hiddenViewController.selectViewControllerAtIndex(index)
                self.customTabBarController!.selectedIndex = 2
            }
        } else {
            if index == 0 {
                Delay.delayWithDuration(0.5, completionHandler: { (success) -> Void in
                    self.redirectToLoginRegister(false)
                })
            } else if index == 1 {
                Delay.delayWithDuration(0.5, completionHandler: { (success) -> Void in
                    self.redirectToLoginRegister(true)
                })
            } else {
                if index != -1 {
                    let navigationController: UINavigationController = self.customTabBarController!.viewControllers![2] as! UINavigationController
                    let hiddenViewController: HiddenViewController = navigationController.viewControllers[0] as! HiddenViewController
                    hiddenViewController.selectViewControllerAtIndex(index)
                    self.customTabBarController!.selectedIndex = 2
                }
            }
        }
    }
}

//MARK: -
//MARK: - QRCode Scanner View Controller Delegate
extension HomeContainerViewController: QRCodeScannerViewControllerDelegate {
    func qrCodeScannerViewController(qrCodeScannerViewController: QRCodeScannerViewController, code: String) {
        if code.contains("referralCode") {
            var qrCode: String = ""
            if let range = code.rangeOfString("=", options: NSStringCompareOptions.BackwardsSearch) {
                qrCode = code.substringFromIndex(range.endIndex)
                println(qrCode)
                if !SessionManager.isLoggedIn() {
                    self.refferalCode = qrCode
                    self.redirectToLoginRegister(false)
                } else if SessionManager.referrerCode().isEmpty {
                    var editViewController = EditProfileTableViewController(nibName: "EditProfileTableViewController", bundle: nil)
                    editViewController.isFromQRScanner = true
                    self.profileModel.referrerCode = qrCode
                    editViewController.passModel(self.profileModel)
                    self.navigationController?.pushViewController(editViewController, animated:true)
                } else {
                    Toast.displayToastWithMessage(StringHelper.localizedStringWithKey("HAVE_REFERRER_LOCALIZE_KEY"), duration: 1.5, view: self.view)
                }
            }
        } else if code.contains("store") {
            var slug: String = ""
            if let range = code.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch) {
                slug = code.substringFromIndex(range.endIndex)
                println(slug)
                
                let sellerViewController: SellerViewController = SellerViewController(nibName: "SellerViewController", bundle: nil)
                sellerViewController.slug = slug
                self.navigationController!.pushViewController(sellerViewController, animated: true)
            }
        } else if code.contains("item") {
            var slug: String = ""
            if let range = code.rangeOfString("/", options: NSStringCompareOptions.BackwardsSearch) {
                slug = code.substringFromIndex(range.endIndex)
                println(slug)
                
                let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
                productViewController.tabController = self.tabBarController as! CustomTabBarController
                productViewController.productId = slug
                self.navigationController!.pushViewController(productViewController, animated: true)

            }
        } else if code.contains("register") {
            self.redirectToLoginRegister(false)
        } else if code.contains("login") {
            self.redirectToLoginRegister(true)
        }else {
            UIApplication.sharedApplication().openURL(StringHelper.convertStringToUrl(code))
        }
    }
}

//MARK: -
//MARK: - Search Bar View Delegate
extension HomeContainerViewController: SearchBarViewDelegate {
    
    func searchBarView(searchBarView: SearchBarView, didTapScanQRCode button: UIButton) {
        var qrCodeScannerViewController = QRCodeScannerViewController(nibName: "QRCodeScannerViewController", bundle: nil)
        qrCodeScannerViewController.delegate = self
        self.presentViewController(qrCodeScannerViewController, animated: true, completion: nil)
    }
    
    func searchBarView(searchBarView: SearchBarView, didTapProfile button: UIButton) {
        if SessionManager.isLoggedIn() {
            var profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            profileViewController.isFromSearchBar = true
            self.navigationController?.pushViewController(profileViewController, animated: true)
        } else {
            self.redirectToLoginRegister(true)
        }
    }
    
    func searchBarView(searchBarView: SearchBarView, didTextChanged textField: UITextField) {
        if self.searchType == .Product {
            self.fireSearch(textField.text, searchBarView: searchBarView)
        }
    }
    
    func searchBarView(searchBarView: SearchBarView, didSeacrhTypeChanged searchType: SearchType) {
        self.searchType = searchType
    }
    
    func searchBarView(searchBarView: SearchBarView, didTapSearch textField: UITextField) {
        if count(textField.text) < 3 {
            Toast.displayToastWithMessage(StringHelper.localizedStringWithKey("KEYWORD_SHORT_LOCALIZE_KEY"), duration: 1.5, view: self.view)
        } else {
            if (self.searchTask != nil) {
                self.searchTask?.cancel()
                searchTask = nil
            }
            
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            textField.resignFirstResponder()
            let newString = textField.text.stringByReplacingOccurrencesOfString(" ", withString: "+")
            
            var resultController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            
            if self.searchType == .Product {
                resultController.isSellerSearch = false
                resultController.passModel(SearchSuggestionModel(suggestion: textField.text, imageURL: "", searchUrl: "\(APIAtlas.searchBuyer)\(newString)"))
            } else {
                resultController.isSellerSearch = true
                resultController.passModel(SearchSuggestionModel(suggestion: textField.text, imageURL: "", searchUrl: "\(APIAtlas.searchSeller)\(newString)"))
            }
            
            resultController.profileModel = self.profileModel
            
            resultController.searchType = self.searchType
            
            self.navigationController?.pushViewController(resultController, animated:true);
        }
    }
    
    func searchBarView(searchBarView: SearchBarView, didChooseSuggestion suggestion: SearchSuggestionModel) {
        var resultController = ResultViewController(nibName: "ResultViewController", bundle: nil)
        resultController.isSellerSearch = false
        resultController.searchType = self.searchType
        resultController.passModel(suggestion)
        self.navigationController?.pushViewController(resultController, animated:true);
    }
    
    func searchBarView(didTapDailyLogin searchBarView: SearchBarView) {
        var url = APIEnvironment.baseUrl() + "/v3/" + SessionManager.selectedCountryCode() + "/" + SessionManager.selectedLanguageCode() + "/auth/" + APIAtlas.dailyLogin

        self.didClickItemWithTarget(url, targetType: "webView", sectionTitle: StringHelper.localizedStringWithKey("WEBVIEW_DAILY_LOGIN"))
    }
    
    //API Request
    //MARK: - API Request
    func fireSearch(queryString: String, searchBarView: SearchBarView){
        if Reachability.isConnectedToNetwork() {
            if (self.searchTask != nil) {
                self.searchTask?.cancel()
                self.searchTask = nil
                searchBarView.hideLoader()
            }
        }
        
        searchBarView.showLoader()
        self.searchTask = WebServiceManager.fireSearcProducthWithUrl(APIAtlas.searchUrl, queryString: queryString, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            searchBarView.hideLoader()
            if successful {
                if  let dictionary: NSDictionary = responseObject as? NSDictionary {
                    if let isSuccessful: Bool = dictionary["isSuccessful"] as? Bool{
                        if isSuccessful {
                            self.suggestions.removeAll(keepCapacity: false)
                            if let value: AnyObject = responseObject["data"] {
                                for subValue in value as! NSArray {
                                    let model: SearchSuggestionModel = SearchSuggestionModel.parseDataFromDictionary(subValue as! NSDictionary)
                                    
                                    self.suggestions.append(model)
                                }
                                searchBarView.passSearchSuggestions(self.suggestions)
                            }
                        }
                        else {
                            self.suggestions.removeAll(keepCapacity: false)
//                            self.suggestions.append(SearchSuggestionModel(suggestion: SearchBarView.noResultsString, imageURL: "", searchUrl: ""))
                            searchBarView.passSearchSuggestions(self.suggestions)
                        }
                    }
                } else {
                    UIAlertController.displaySomethingWentWrongError(self)
                }
            } else {
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
                } else if requestErrorType == .Cancel {
                } else {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                }
            }
        })
    }
    
    //MARK: -
    //MARK: - Load Image
    func loadImage(image: String) {
        let imageView: UIImageView = UIImageView(frame: CGRectZero)
        imageView.sd_setImageWithURL(StringHelper.convertStringToUrl(image))
    }
    
    func formatToAttributedDiscountString(discountedPriceText: String, discountPercentText: String) -> NSMutableAttributedString {
        
        let discountText = discountedPriceText + " - " + discountPercentText
        let discountAttributeString: NSMutableAttributedString =  NSMutableAttributedString(string: discountText)
        // text with middle line
        discountAttributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, count(discountedPriceText)))
        // text with italic font
        let boldFontAttribute = [NSFontAttributeName: UIFont.italicSystemFontOfSize(12.0)]
        discountAttributeString.addAttributes(boldFontAttribute, range: NSMakeRange(count(discountedPriceText) + 2, count(discountPercentText)))

        return discountAttributeString
    }
}

//MARK: -
//MARK: - Tab Bar Delegate
extension HomeContainerViewController: UITabBarDelegate {
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if viewController == tabBarController.viewControllers![4] as! UIViewController {
            return true
        } else if viewController == tabBarController.viewControllers![3] as! UIViewController {
            if SessionManager.isLoggedIn() {
                return true
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.wishlistError, title: self.error)
                return false
            }
        } else if self != viewController && viewController != tabBarController.viewControllers![2] as! UIViewController {
            return true
        } else {
            self.circularDraweView("circular-drawer")
            self.showFAB()
            
            return false
        }
    }
}

//MARK: -
//MARK: - Overseas Collection View Cell Data Source
extension HomeContainerViewController: OverseasCollectionViewCellDataSource {
    func overseasCollectionViewCell(overseasCollectionViewCell: OverseasCollectionViewCell, numberOfItemsInSection section: Int) -> Int {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(overseasCollectionViewCell)!
        let layoutElevenModel: LayoutElevenModel  = self.homePageModel.data[indexPath.section] as! LayoutElevenModel
        return layoutElevenModel.data.count;
    }
    
    func overseasCollectionViewCell(overseasCollectionViewCell: OverseasCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell {

        let indexPath2: NSIndexPath = self.collectionView.indexPathForCell(overseasCollectionViewCell)!
        let layoutElevenModel: LayoutElevenModel  = self.homePageModel.data[indexPath2.section] as! LayoutElevenModel

        
        let fullImageCell: FullImageCollectionViewCell = overseasCollectionViewCell.collectionView.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
        
        fullImageCell.itemProductImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(layoutElevenModel.data[indexPath.row].image), placeholderImage: UIImage(named: "dummy-placeholder"), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
            if let imageView = fullImageCell.itemProductImageView {
                if downloadedImage != nil {
                    imageView.fadeInImageWithImage(downloadedImage)
                }
            }
        })
        
        fullImageCell.target = layoutElevenModel.data[indexPath.row].target.targetUrl
        fullImageCell.targetType = layoutElevenModel.data[indexPath.row].target.targetType
        
        return fullImageCell
    }
    
    func itemWidthInOverseasCollectionViewCell(overseasCollectionViewCell: OverseasCollectionViewCell) -> CGFloat {
        return 80
    }
}

//MARK: -
//MARK: - Overseas Collection View Cell Delegate
extension HomeContainerViewController: OverseasCollectionViewCellDelegate {
    func overseasCollectionViewCell(carouselCollectionViewCell: OverseasCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let fullImageCell: FullImageCollectionViewCell = carouselCollectionViewCell.collectionView.cellForItemAtIndexPath(indexPath) as! FullImageCollectionViewCell
        
        self.didClickItemWithTarget(fullImageCell.target, targetType: fullImageCell.targetType)
    }
}

extension HomeContainerViewController: LayoutTwelveCollectionViewCellDelegate {
    func layoutTwelveCollectionViewCellDidClickProductImage(productImage: ProductImageView) {
        self.didClickItemWithTarget(productImage.target, targetType: productImage.targetType, sectionTitle: productImage.title)
    }
}
