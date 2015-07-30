//
//  StartPageViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class StartPageViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var companyLogoImageView: UIImageView!
    @IBOutlet weak var getStartedButton: UIButton!
    
    var pageViewController: UIPageViewController?
    var pageTitles: NSArray?
    var pageImages: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageTitles = ["Over 200 Tips and Tricks", "Discover Hidden Features", "Bookmark Favorite Tip", "Free Regular Update"]
        self.pageImages = ["page1", "page2", "page3", "page4"]
    
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController
        
        self.pageViewController?.dataSource = self
        
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
        
        let pageControll: UIPageControl = UIPageControl.appearance()
        pageControll.pageIndicatorTintColor = UIColor.lightGrayColor()
        pageControll.currentPageIndicatorTintColor = UIColor.blackColor()
        pageControll.backgroundColor = UIColor.clearColor()
        
        self.companyLogoImageView.layer.zPosition = 100
        self.getStartedButton.layer.zPosition = 100
        
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
        pageContentVC.titleText = self.pageTitles?.objectAtIndex(index) as! String
        
        pageContentVC.imageFile = self.pageImages?.objectAtIndex(index) as! String
        pageContentVC.pageIndex = index
        return pageContentVC
    }
    

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
