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
    var registerViewController: RegisterViewController?
    var loginViewController: LoginViewController?
    var messagingViewController: MessagingViewController?
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
            setSelectedViewController(viewController)
        }
        
        if index == 0 {
            
        } else if index == 1 {
            
        } else if index == 2 {
            
        } else if index == 3 {
            
        } else if index == 4 {
            
        } else if index == 5 {
            
        } else if index == 6 {
            var titleLabel = UILabel(frame: CGRectZero)
            titleLabel.text = "Category Page"
            titleLabel.textColor = .whiteColor()
            titleLabel.sizeToFit()
            self.navigationItem.titleView = titleLabel
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
            self.messagingViewController = MessagingViewController(nibName: "MessagingViewController", bundle: nil)
            self.customizeShoppingViewController = CustomizeShoppingViewController(nibName: "CustomizeShoppingViewController", bundle: nil)
            self.resultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            self.categoriesViewController = CategoriesViewController(nibName: "CategoriesViewController", bundle: nil)
            self.profileViewController = ProfileViewController(nibName: "ProfileViewController", bundle: nil)
            
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
            
            self.registerViewController = storyBoard.instantiateViewControllerWithIdentifier("RegisterViewController") as? RegisterViewController
            
            self.loginViewController =  storyBoard.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
            
            self.messagingViewController = MessagingViewController(nibName: "MessagingViewController", bundle: nil)
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
