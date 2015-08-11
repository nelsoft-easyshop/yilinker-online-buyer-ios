//
//  LoginAndLogoutContentViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//


class LoginAndRegisterContentViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var signInButton: DynamicRoundedButton!
    @IBOutlet weak var registerButton: DynamicRoundedButton!
    @IBOutlet weak var closeButton: DynamicRoundedButton!
    
    var viewControllers = [UIViewController]()
    var selectedChildViewController: UIViewController?
    var contentViewFrame: CGRect?
    
    var loginViewController: LoginViewController?
    var registerViewController: RegisterViewController?
    
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewControllers()
        self.setSelectedViewControllerWithIndex(0)

        if IphoneType.isIphone4() {
            self.logoHeightConstraint.constant = 50
            self.logoWidthConstraint.constant = 50
        }
        

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.contentViewFrame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)
    }
    
    func initViewControllers() {
        self.loginViewController  = self.storyboard!.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController
        self.registerViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RegisterViewController") as? RegisterViewController
        
        loginViewController?.parentView = self.view
        
        self.viewControllers.append(self.loginViewController!)
        self.viewControllers.append(self.registerViewController!)
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
    
    @IBAction func signIn(sender: AnyObject) {
        self.setSelectedViewControllerWithIndex(0)
       
        self.signInButton.backgroundColor = Constants.Colors.appTheme
        self.signInButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        self.registerButton.backgroundColor = UIColor.whiteColor()
        self.registerButton.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
    }
    
    @IBAction func register(sender: AnyObject) {
        self.setSelectedViewControllerWithIndex(1)
        
        self.signInButton.backgroundColor = UIColor.whiteColor()
        self.signInButton.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
        
        self.registerButton.backgroundColor = Constants.Colors.appTheme
        self.registerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
    }

    @IBAction func close(sender: AnyObject) {
       self.dismissViewControllerAnimated(true, completion: nil)
    }
}
