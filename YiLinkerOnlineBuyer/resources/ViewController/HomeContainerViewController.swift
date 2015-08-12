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
    
    var homePageCollectionViewController: HomePageCollectionViewController?
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
    
    var featuredViewLoadData: Bool = false
    
    var emptyView: EmptyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.circularDraweView()
        self.tabBarController!.delegate = self
        self.addSuHeaderScrollView()
        if Reachability.isConnectedToNetwork() {
            self.fireGetHomePageData()
        } else {
            self.addEmptyView()
        }
    }
    
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.emptyView!.delegate = self
        self.view.addSubview(self.emptyView!)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        contentViewFrame = contentView.bounds
       
    }
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if self != viewController && viewController != tabBarController.viewControllers![2] as! UIViewController {
            return true
        } else {
            let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
            var animatedViewController: CircularMenuViewController?
            animatedViewController  = storyBoard.instantiateViewControllerWithIdentifier("CircularMenuViewController") as? CircularMenuViewController
            animatedViewController!.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            animatedViewController!.providesPresentationContextTransitionStyle = true
            animatedViewController!.definesPresentationContext = true
            animatedViewController!.view.backgroundColor = UIColor.clearColor()
            
            if SessionManager.accessToken() != "" {
                var buttonImages: [String] = ["help", "following", "message", "customize-shopping", "promo", "category", SessionManager.profileImageStringUrl()]
                var buttonTitles: [String] = ["HELP", "FOLLOWED SELLER", "MESSAGING", "CUSTOMIZE SHOPPING", "TODAY'S PROMO", "CATEGORIES", "LOGOUT"]
                var buttonRightText: [String] = ["", "", "You have 1 unread message", "", "", "", "Jessica Joe \nMetro Manila, City"]
                
                animatedViewController?.buttonImages = buttonImages
                animatedViewController?.buttonTitles = buttonTitles
                animatedViewController?.buttonRightText = buttonRightText
            } else {
                var buttonImages: [String] = ["help", "register", "sign_in", "message","customize-shopping", "promo", "category"]
                var buttonTitles: [String] = ["HELP", "REGISTER", "SIGN IN", "MESSAGING", "CUSTOMIZE SHOPPING", "TODAYS PROMO", "CATEGORIES"]
                var buttonRightText: [String] = ["", "", "Must be Sign in", "Must be Sign in", "", "", ""]
                
                animatedViewController?.buttonImages = buttonImages
                animatedViewController?.buttonTitles = buttonTitles
                animatedViewController?.buttonRightText = buttonRightText
            }
            
            self.tabBarController?.presentViewController(animatedViewController!, animated: false, completion: nil)
            
            return false
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
            let button: UIButton = UIButton(frame: CGRectMake(xPosition, 5, 80, 30))
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
        self.navigationController?.navigationBar.addSubview(scrollView)
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
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager = APIManager.sharedInstance
        manager.GET("http://demo5885209.mockable.io/api/v1/home/getItems", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.populateHomePageWithDictionary(responseObject as! NSDictionary)
            SVProgressHUD.dismiss()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
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
            let layoutId: String = categoryDictionary["layoutId"] as! String
            var layout: String = ""
            if layoutId == "1" {
                layout = Constants.HomePage.layoutFiveKey
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
        self.emptyView?.removeFromSuperview()
    }
}