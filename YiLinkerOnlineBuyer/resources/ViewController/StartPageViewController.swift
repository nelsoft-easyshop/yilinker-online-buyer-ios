//
//  StartPageViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct StartPageStrings {
    static let or: String = StringHelper.localizedStringWithKey("OR_LOCALIZE_KEY")
    static let getStarted: String = StringHelper.localizedStringWithKey("GET_STARTED_LOCALIZE_KEY")
}

class StartPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var companyLogoImageView: UIImageView!
    @IBOutlet weak var getStartedButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orLabel: UILabel!
    
    var pageViewController: UIPageViewController?
    var pageTitles: NSArray?
    var pageImages: NSArray?
    
    @IBOutlet weak var signInButton: DynamicRoundedButton!
    var timer = NSTimer()

    @IBOutlet weak var pageControlVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if IphoneType.isIphone4() {
            self.pageControlVerticalConstraint.constant = 10
        }
        
        self.pageTitles = ["SHOES IN ONE PLACE", "CAMERA IN ONE PLACE", "SHOES IN ONE PLACE", "CAMERA IN ONE PLACE"]
        self.pageImages = ["shoes", "camera", "shoes", "camera"]
    
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        
        self.pageViewController?.dataSource = self
        self.pageViewController?.delegate = self
        
        let startingViewController = viewControllerAtIndex(0)
        var viewControllers: NSArray = NSArray(object: startingViewController!)
        
        self.pageViewController!.setViewControllers(viewControllers as! [AnyObject],
            direction: .Forward,
            animated: true,
            completion: nil)
        
        
        self.pageViewController?.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        self.pageViewController?.didMoveToParentViewController(self)
        
        self.pageControl.pageIndicatorTintColor = UIColor.lightGrayColor()
        self.pageControl.currentPageIndicatorTintColor = UIColor.blackColor()
        self.pageControl.backgroundColor = UIColor.clearColor()
        self.pageControl.numberOfPages = self.pageImages!.count
        
        self.pageControl.layer.zPosition = 100
        self.companyLogoImageView.layer.zPosition = 100
        self.orLabel.layer.zPosition = 100
        
        self.view.bringSubviewToFront(self.getStartedButton)
        self.view.bringSubviewToFront(self.signInButton)
        
        for view in self.pageViewController!.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.delegate = self
            }
        }
        self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("scrollPage"), userInfo: nil, repeats: false)
        
        self.getStartedButton.setTitle(StartPageStrings.getStarted, forState: UIControlState.Normal)
        self.orLabel.text = StartPageStrings.or
        self.signInButton.setTitle(FABStrings.signIn, forState: UIControlState.Normal)
    }
    
    func scrollPage() {
        var index = 0
        if self.pageControl.currentPage != (self.pageImages!.count - 1) {
            index = self.pageControl.currentPage + 1
            self.pageControl.currentPage = index
        } else {
            self.pageControl.currentPage = 0
        }
        self.titleLabel.text = self.pageTitles?.objectAtIndex(index) as? String
        let viewControllers: NSArray = NSArray(object: self.viewControllerAtIndex(index)!)
        self.pageViewController!.setViewControllers(viewControllers as! [AnyObject],
            direction: .Forward,
            animated: true,
            completion: nil)
    }
    
    func pageViewController(pageViewController: UIPageViewController,
        viewControllerAfterViewController viewController: UIViewController) ->
        UIViewController? {
            var index = (viewController as! StarterContentPageViewController).pageIndex
            if (index == NSNotFound) {
                return nil
            }

            index++
            if (index == pageTitles!.count ){
                return nil
            }
            return viewControllerAtIndex(index)
    }
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! StarterContentPageViewController).pageIndex
        if ((index == 0) || (index == NSNotFound)) {
            return nil
        }
        
        index--
        
        return viewControllerAtIndex(index)
    }
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return self.pageTitles!.count
    }
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
    //MARK: Instance methods
    func viewControllerAtIndex(index:Int) -> StarterContentPageViewController? {
        if ((pageTitles!.count == 0) || (index >= pageTitles!.count)) {
            return nil
        }
        let pageContentVC =
        storyboard?.instantiateViewControllerWithIdentifier(
            "StarterContentPageViewController") as! StarterContentPageViewController
        //set the properties for the controller.
        pageContentVC.imageFile = self.pageImages?.objectAtIndex(index) as! String
        pageContentVC.pageIndex = index
        return pageContentVC
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        
        if completed {
            let contentViewController: StarterContentPageViewController = self.pageViewController?.viewControllers.last as! StarterContentPageViewController
            self.pageControl.currentPage = contentViewController.pageIndex
            self.titleLabel.text = self.pageTitles?.objectAtIndex(contentViewController.pageIndex) as? String
            let delay = 2.5 * Double(NSEC_PER_SEC)
            let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(time, dispatch_get_main_queue()) {
                self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("scrollPage"), userInfo: nil, repeats: false)
            }
        }
    }
    
    func scrollViewDidEndScrollingAnimation(scrollView: UIScrollView) {
        let delay = 2.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("scrollPage"), userInfo: nil, repeats: false)
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.timer.invalidate()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.timer.invalidate()
    }
    
    func touchesEnd() {
        let delay = 1.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("scrollPage"), userInfo: nil, repeats: false)
        }
    }
    
    @IBAction func getStarted(sender: AnyObject) {
        let homeStoryBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        let tabController: UITabBarController = homeStoryBoard.instantiateViewControllerWithIdentifier("TabBarController") as! UITabBarController
        var modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.CrossDissolve
        tabController.modalTransitionStyle = modalStyle
        self.presentViewController(tabController, animated: true, completion: nil)
    }
    
    
    @IBAction func signIn(sender: AnyObject) {
        var loginContainerView: LoginAndRegisterContentViewController
        if IphoneType.isIphone5() || IphoneType.isIphone4() {
            loginContainerView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController5") as! LoginAndRegisterContentViewController
        } else {
            loginContainerView = self.storyboard!.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController") as! LoginAndRegisterContentViewController
        }
        
        self.presentViewController(loginContainerView, animated: true, completion: nil)
    }
    
    
}
