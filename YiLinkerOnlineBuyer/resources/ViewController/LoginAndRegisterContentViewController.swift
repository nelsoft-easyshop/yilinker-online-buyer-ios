//
//  LoginAndLogoutContentViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//


class LoginAndRegisterContentViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    var viewControllers = [UIViewController]()
    var selectedChildViewController: UIViewController?
    var contentViewFrame: CGRect?
    
    var loginViewController: LoginViewController?
    var registerViewController: RegisterViewController?
    
    var isFromDrawer: Bool = false
    
    @IBOutlet weak var logoWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var verticalSpaceConstraint: NSLayoutConstraint!
    
    var registerModel: RegisterModel = RegisterModel()
    
    var defaultViewControllerIndex: Int = 0
    
    var isFromTab: Bool = false
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.registerViewController != nil {
            self.setSelectedViewControllerWithIndex(self.defaultViewControllerIndex)
            if self.defaultViewControllerIndex == 0 {
                self.signIn(self.signInButton)
            } else if self.defaultViewControllerIndex == 1 {
                self.register(self.registerButton)
            }
        }
        
        self.signInButton.layer.borderColor = Constants.Colors.appTheme.CGColor
        
        self.signInButton.layer.borderWidth = 1
       
        self.registerButton.layer.borderColor = Constants.Colors.appTheme.CGColor
        self.registerButton.layer.borderWidth = 1
        self.closeButton.layer.borderWidth = 1
        
        self.closeButton.layer.cornerRadius = self.closeButton.frame.size.width / 2
        
        self.closeButton.layer.borderColor = Constants.Colors.backgroundGray.CGColor
        self.closeButton.layer.borderWidth = 1
        
        self.signInButton.setTitle(FABStrings.signIn, forState: UIControlState.Normal)
        self.registerButton.setTitle(FABStrings.register, forState: UIControlState.Normal)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.contentViewFrame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)
        self.initViewControllers()
        
        if !self.isFromTab && IphoneType.isIphone5() {
            self.verticalSpaceConstraint.constant = 25
        } else if IphoneType.isIphone5() {
            self.verticalSpaceConstraint.constant = 10
        }
        
        self.setSelectedViewControllerWithIndex(self.defaultViewControllerIndex)
        
        self.roundSignInAndRegisterButton()
    }
    
    //MARK: - Round Sign In And Register Button
    func roundSignInAndRegisterButton() {
        if IphoneType.isIphone6() || IphoneType.isIphone6Plus() {
            self.signInButton.layer.cornerRadius = 20
            self.registerButton.layer.cornerRadius = 20
        } else {
            self.signInButton.layer.cornerRadius = 15
            self.registerButton.layer.cornerRadius = 15
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
