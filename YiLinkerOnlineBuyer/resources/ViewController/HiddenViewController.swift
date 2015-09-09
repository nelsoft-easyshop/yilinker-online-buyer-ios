//
//  HiddenViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HiddenViewController: UIViewController {

    var helpViewController: HelpViewController?
    var registerViewController: LoginAndRegisterContentViewController?
    var loginViewController: LoginAndRegisterContentViewController?
    var messagingViewController: ConversationVC?
    var customizeShoppingViewController: CustomizeShoppingViewController?
    var resultViewController: ResultViewController?
    var categoriesViewController: CategoriesViewController?
    
    var followedSellerViewController: FollowedSellerViewController?
    var profileViewController: ProfileViewController?
    
    var viewControllers = [UIViewController]()
    var contentViewFrame: CGRect?
    
    var selectedChildViewController: UIViewController?
    
    @IBOutlet weak var contentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentViewFrame = contentView.bounds
    }
    
    override func viewDidLayoutSubviews() {
        self.contentViewFrame = contentView.bounds
    }
    
    // This function is for executing child view logic code
    func setSelectedViewControllerWithIndex(index: Int) {
        if self.viewControllers.count != 0 {
            let viewController: UIViewController = viewControllers[index]
            if !SessionManager.isLoggedIn() && index == 3 {
                
            } else {
                setSelectedViewController(viewController)
            }
        }
        
        if index == 0 {
            
        } else if index == 1 {
            if SessionManager.isLoggedIn() {
                var titleLabel = UILabel(frame: CGRectZero)
                titleLabel.font = UIFont(name: "Panton-Regular", size: 20)
                titleLabel.text = "Followed Sellers"
                titleLabel.textColor = .whiteColor()
                titleLabel.sizeToFit()
                self.navigationItem.titleView = titleLabel
            } else {
                self.registerViewController?.defaultViewControllerIndex = 1
                self.registerViewController?.closeButton.hidden = true
            }
        } else if index == 2 {
            self.loginViewController?.defaultViewControllerIndex = 0
            self.loginViewController?.closeButton.hidden = true
        } else if index == 3 {
            
        } else if index == 4 {
            if !SessionManager.isLoggedIn() {
                var titleLabel = UILabel(frame: CGRectZero)
                titleLabel.font = UIFont(name: "Panton-Regular", size: 20)
                titleLabel.text = "Customize Shopping"
                titleLabel.textColor = .whiteColor()
                titleLabel.sizeToFit()
                self.navigationItem.titleView = titleLabel
            }
        } else if index == 5 {
            if !SessionManager.isLoggedIn() {
                var titleLabel = UILabel(frame: CGRectZero)
                titleLabel.text = "Customize Shopping"
                titleLabel.font = UIFont(name: "Panton-Regular", size: 20)
                titleLabel.textColor = .whiteColor()
                titleLabel.sizeToFit()
                self.navigationItem.titleView = titleLabel
            } else if SessionManager.isLoggedIn() {
                var titleLabel = UILabel(frame: CGRectZero)
                titleLabel.font = UIFont(name: "Panton-Regular", size: 20)
                titleLabel.text = "Category Page"
                titleLabel.textColor = .whiteColor()
                titleLabel.sizeToFit()
                self.navigationItem.titleView = titleLabel
            }
        } else if index == 6 {
            if !SessionManager.isLoggedIn() {
                var titleLabel = UILabel(frame: CGRectZero)
                titleLabel.font = UIFont(name: "Panton-Regular", size: 20)
                titleLabel.text = "Category Page"
                titleLabel.textColor = .whiteColor()
                titleLabel.sizeToFit()
                self.navigationItem.titleView = titleLabel
            }
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
    
    
    func initViews() {
        if SessionManager.isLoggedIn() {
            self.helpViewController = HelpViewController(nibName: "HelpViewController", bundle: nil)
            self.followedSellerViewController = FollowedSellerViewController(nibName: "FollowedSellerViewController", bundle: nil)

            let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
            self.messagingViewController = storyBoard.instantiateViewControllerWithIdentifier("ConversationVC") as? ConversationVC
            self.customizeShoppingViewController = CustomizeShoppingViewController(nibName: "CustomizeShoppingViewController", bundle: nil)
            self.resultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            self.categoriesViewController = CategoriesViewController(nibName: "CategoriesViewController", bundle: nil)
            self.profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            //ConversationVC
            
            self.viewControllers.append(self.helpViewController!)
            self.viewControllers.append(self.followedSellerViewController!)
            self.viewControllers.append(self.messagingViewController!)
            self.viewControllers.append(self.customizeShoppingViewController!)
            self.viewControllers.append(self.resultViewController!)
            self.viewControllers.append(self.categoriesViewController!)
            self.viewControllers.append(self.profileViewController!)
        } else {
            self.helpViewController = HelpViewController(nibName: "HelpViewController", bundle: nil)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "StartPageStoryBoard", bundle: nil)
            
            if IphoneType.isIphone5() {
                self.registerViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController5") as? LoginAndRegisterContentViewController
                
                self.loginViewController =  storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController5") as? LoginAndRegisterContentViewController
            } else if IphoneType.isIphone4() {
                self.registerViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController4") as? LoginAndRegisterContentViewController
                
                self.loginViewController =  storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController4") as? LoginAndRegisterContentViewController
            } else {
                self.registerViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController") as? LoginAndRegisterContentViewController
                
                self.loginViewController =  storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController") as? LoginAndRegisterContentViewController

            }
            
            
            let storyBoard1: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
            self.messagingViewController = storyBoard1.instantiateViewControllerWithIdentifier("ConversationVC") as? ConversationVC
            self.customizeShoppingViewController = CustomizeShoppingViewController(nibName: "CustomizeShoppingViewController", bundle: nil)
            self.resultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            self.categoriesViewController = CategoriesViewController(nibName: "CategoriesViewController", bundle: nil)
            
            self.viewControllers.append(self.helpViewController!)
            self.viewControllers.append(self.registerViewController!)
            self.viewControllers.append(self.loginViewController!)
            self.viewControllers.append(self.messagingViewController!)
            self.viewControllers.append(self.customizeShoppingViewController!)
            self.viewControllers.append(self.resultViewController!)
            self.viewControllers.append(self.categoriesViewController!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectViewControllerAtIndex(index: Int) {
        if self.viewControllers.count == 0 {
            self.initViews()
        }
        self.setSelectedViewControllerWithIndex(index)
    }
    
}
