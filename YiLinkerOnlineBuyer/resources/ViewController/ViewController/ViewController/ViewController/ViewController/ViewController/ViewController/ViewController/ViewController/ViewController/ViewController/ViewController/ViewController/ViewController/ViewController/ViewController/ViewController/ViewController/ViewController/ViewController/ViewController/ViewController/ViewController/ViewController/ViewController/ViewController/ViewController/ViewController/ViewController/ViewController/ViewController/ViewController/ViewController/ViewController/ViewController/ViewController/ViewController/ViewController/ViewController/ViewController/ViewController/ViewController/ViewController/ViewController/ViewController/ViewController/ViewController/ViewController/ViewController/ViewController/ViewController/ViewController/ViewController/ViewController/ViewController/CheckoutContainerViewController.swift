//
//  CheckoutContainerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CheckoutContainerViewController: UIViewController, PaymentWebViewViewControllerDelegate, RegisterModalViewControllerDelegate {
    
    var summaryViewController: SummaryViewController?
    var paymentViewController: PaymentViewController?
    var overViewViewController: OverViewViewController?
    
    var viewControllers = [UIViewController]()
    var selectedChildViewController: UIViewController?
    
    var contentViewFrame: CGRect?
    var selectedIndex: Int = 0
    var totalPrice: String = ""
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    
    @IBOutlet weak var firstCircleLabel: DynamicRoundedLabel!
    @IBOutlet weak var secondCircleLabel: DynamicRoundedLabel!
    @IBOutlet weak var thirdCircleLabel: DynamicRoundedLabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    var hud: MBProgressHUD?
    var isValidGuestUser: Bool = false

    var carItems: [CartProductDetailsModel] = []
    
    var guestEmail: String = ""
    var guestFirstName: String = ""
    var guestLastName: String = ""
    
    var alertHasShown: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleView()
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.initViewController()
        self.setSelectedViewControllerWithIndex(self.selectedIndex)
        self.backButton()
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }

    func titleView() {
        self.navigationController!.navigationBar.topItem!.title = "Checkout"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function is for executing child view logic code
    func setSelectedViewControllerWithIndex(index: Int) {
        if index == 0 {
            self.firsCircle()
            self.continueButton("Save and Continue")
            let viewController: UIViewController = viewControllers[index]
            setSelectedViewController(viewController)
        } else if index == 1 {
            if SessionManager.isLoggedIn() || self.isValidGuestUser {
                self.isValidGuestUser = false
                self.secondCircle()
                self.continueButton("Save and Go to Payment")
                let viewController: UIViewController = viewControllers[index]
                setSelectedViewController(viewController)
            } else {
                self.selectedIndex--
                if self.summaryViewController!.guestCheckoutTableViewCell.firstNameTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "First name is required.", title: "Incomplete Information")
                } else if self.summaryViewController!.guestCheckoutTableViewCell.lastNameTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Last name is required.", title: "Incomplete Information")
                } else if self.summaryViewController!.guestCheckoutTableViewCell.mobileNumberTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Mobile Number is required.", title: "Incomplete Information")
                } else if self.summaryViewController!.guestCheckoutTableViewCell.emailTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Email Address is required.", title: "Incomplete Information")
                } else if !self.summaryViewController!.guestCheckoutTableViewCell.emailTextField.text!.isValidEmail() {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Invalid email address.", title: "Incomplete Information")
                } else {
                    self.guestEmail = self.summaryViewController!.guestCheckoutTableViewCell.emailTextField.text
                    self.guestFirstName = self.summaryViewController!.guestCheckoutTableViewCell.firstNameTextField.text
                    self.guestLastName = self.summaryViewController!.guestCheckoutTableViewCell.lastNameTextField.text
                    self.summaryViewController!.fireGuestUser()
                }

            }
        } else if index == 2 {
            
        } else if index == 3 {
     
        }
    }
    
    func firsCircle() {
        for imageView in self.firstCircleLabel.subviews {
            imageView.removeFromSuperview()
        }
        
        self.firstCircleLabel.backgroundColor = Constants.Colors.appTheme
        self.secondCircleLabel.backgroundColor = UIColor.clearColor()
        self.thirdCircleLabel.backgroundColor = UIColor.clearColor()
        
        self.firstCircleLabel.text = "1"
        self.secondCircleLabel.text = ""
        self.thirdCircleLabel.text = ""
        
        self.summaryLabel.textColor = UIColor.whiteColor()
        self.paymentLabel.textColor = UIColor.lightGrayColor()
        self.overViewLabel.textColor = UIColor.lightGrayColor()
    }
    
    func secondCircle() {
        self.firstCircleLabel.backgroundColor = Constants.Colors.appTheme
        
        let checkImageView: UIImageView = UIImageView(frame: CGRectMake(3, 4, 20, 20))
        checkImageView.image = UIImage(named: "check-white")
        checkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.firstCircleLabel.addSubview(checkImageView)
        self.firstCircleLabel.text = ""
        
        self.secondCircleLabel.backgroundColor = UIColor.clearColor()
        self.secondCircleLabel.textColor = Constants.Colors.appTheme
        
        self.thirdCircleLabel.backgroundColor = UIColor.clearColor()
        
        self.secondCircleLabel.text = "2"
        self.thirdCircleLabel.text = ""
        
        self.summaryLabel.textColor = UIColor.lightGrayColor()
        self.paymentLabel.textColor = UIColor.whiteColor()
        self.overViewLabel.textColor = UIColor.lightGrayColor()
    }
    
    func thirdCircle() {
        self.firstCircleLabel.backgroundColor = Constants.Colors.appTheme
        
        let checkImageView: UIImageView = UIImageView(frame: CGRectMake(3, 4, 20, 20))
        checkImageView.image = UIImage(named: "check-white")
        checkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let checkImageView2: UIImageView = UIImageView(frame: CGRectMake(3, 4, 20, 20))
        checkImageView2.image = UIImage(named: "check-white")
        checkImageView2.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.firstCircleLabel.addSubview(checkImageView)
        self.firstCircleLabel.text = ""
        
        self.secondCircleLabel.backgroundColor = UIColor.clearColor()
        
        self.thirdCircleLabel.backgroundColor = UIColor.clearColor()
        
        self.secondCircleLabel.text = ""
        self.secondCircleLabel.addSubview(checkImageView2)
        self.secondCircleLabel.backgroundColor = Constants.Colors.appTheme
        
        self.thirdCircleLabel.text = "3"
        self.thirdCircleLabel.textColor = Constants.Colors.appTheme
        
        self.summaryLabel.textColor = UIColor.lightGrayColor()
        self.paymentLabel.textColor = UIColor.whiteColor()
        self.overViewLabel.textColor = UIColor.lightGrayColor()
    }
    
    override func viewDidLayoutSubviews() {
        self.contentViewFrame = contentView.bounds
        
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
        viewController.view.frame = self.contentViewFrame!
        contentView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedChildViewController = viewController
    }
    
    func initViewController() {
        summaryViewController = SummaryViewController(nibName: "SummaryViewController", bundle: nil)
        paymentViewController = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
        overViewViewController = OverViewViewController(nibName: "OverViewViewController", bundle: nil)
        summaryViewController!.totalPrice = self.totalPrice
        summaryViewController!.cartItems = self.carItems
        
        self.viewControllers.append(summaryViewController!)
        self.viewControllers.append(paymentViewController!)
        self.viewControllers.append(overViewViewController!)
    }
    
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        if self.selectedIndex != 0 {
            self.selectedIndex--
            self.setSelectedViewControllerWithIndex(self.selectedIndex)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func saveAndContinue(sender: AnyObject) {
        var limit: Int = self.viewControllers.count
        
        if selectedIndex < limit {
            self.selectedIndex++
        }
        
        if self.selectedIndex == 1 {
            if summaryViewController!.isValidToSelectPayment {
                self.setSelectedViewControllerWithIndex(self.selectedIndex)
            } else {
                self.selectedIndex--
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Server Error", title: "Something went wrong")
            }
        } else if self.selectedIndex == 2 {
            if self.paymentViewController!.paymentType == PaymentType.COD {
                self.fireCOD()
            } else {
                self.firePesoPay()
            }
        } else if self.selectedIndex == 3 {
            if SessionManager.isLoggedIn() {
                self.redirectToHomeView()
            } else {
                if !alertHasShown {
                    self.showRegisterAlert()
                } else {
                    self.redirectToHomeView()
                }
            }
            
        } else {
            self.redirectToHomeView()
        }

    }
    
    func redirectToHomeView() {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToHomeView()
    }
    
    func fireCOD() {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        manager.POST(APIAtlas.cashOnDeliveryUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
                let paymentSuccessModel: PaymentSuccessModel = PaymentSuccessModel.parseDataWithDictionary(responseObject as! NSDictionary)
                if paymentSuccessModel.isSuccessful {
                    self.redirectToSuccessPage(paymentSuccessModel)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: paymentSuccessModel.message, title: "Something went wrong")
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.fireRefreshToken(CheckoutRefreshType.COD)
                }
                self.selectedIndex--
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                self.hud?.hide(true)
        })
    }
    
    func firePesoPay() {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        manager.POST(APIAtlas.pesoPayUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            println(responseObject)
                let pesoPayModel: PesoPayModel = PesoPayModel.parseDataWithDictionary(responseObject as! NSDictionary)
                if pesoPayModel.isSuccessful {
                    self.redirectToPaymentWebViewWithUrl(pesoPayModel)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: pesoPayModel.message, title: "Something went wrong")
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken(CheckoutRefreshType.Credit)
                }
                self.selectedIndex--
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                self.hud?.hide(true)
        })
    }
    
    func continueButton(title: String) {
        if self.continueButton != nil {
            self.continueButton.setTitle(title, forState: UIControlState.Normal)
        }
    }
    
    func redirectToPaymentWebViewWithUrl(pesoPayModel: PesoPayModel) {
        let paymentWebViewController = PaymentWebViewViewController(nibName: "PaymentWebViewViewController", bundle: nil)
        paymentWebViewController.pesoPayModel = pesoPayModel
        paymentWebViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController(rootViewController: paymentWebViewController)
        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func paymentWebViewController(paymentDidCancel paymentWebViewController: PaymentWebViewViewController) {
        self.selectedIndex--
    }
    
    func paymentWebViewController(paymentDidSucceed paymentWebViewController: PaymentWebViewViewController, paymentSuccessModel: PaymentSuccessModel) {
        self.redirectToSuccessPage(paymentSuccessModel)
    }
    
    func redirectToSuccessPage(paymentSuccessModel: PaymentSuccessModel) {
        self.selectedIndex++
        self.overViewViewController?.paymentSuccessModel = paymentSuccessModel
        let viewController: UIViewController = viewControllers[2]
        setSelectedViewController(viewController)
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
        self.continueButton("Continue Shopping")
        self.thirdCircle()
    }
    
    func paymentWebViewController(paymentDidNotSucceed paymentWebViewController: PaymentWebViewViewController) {
        self.selectedIndex--
    }
    
    func fireRefreshToken(refreshType: CheckoutRefreshType) {
        self.showHUD()
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                if refreshType == CheckoutRefreshType.COD {
                    self.fireCOD()
                } else if refreshType == CheckoutRefreshType.Credit {
                    self.firePesoPay()
                }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let alertController = UIAlertController(title: "Something went wrong", message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                self.hud?.hide(true)
        })
    }
    
    func showRegisterAlert() {
        self.view.layoutIfNeeded()
        
        let dimView: UIView = UIView(frame: self.view.frame)
        dimView.backgroundColor = UIColor.blackColor()
        dimView.alpha = 0.0
        dimView.tag = 100
        self.view.addSubview(dimView)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            dimView.alpha = 0.5
            }, completion: nil)
        
        let registerModelViewController: RegisterModalViewController = RegisterModalViewController(nibName:"RegisterModalViewController", bundle: nil)
        registerModelViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        registerModelViewController.providesPresentationContextTransitionStyle = true
        registerModelViewController.definesPresentationContext = true
        registerModelViewController.view.backgroundColor = UIColor.clearColor()
        registerModelViewController.delegate = self
        self.presentViewController(registerModelViewController, animated: true, completion: nil)
    }
    
    func registerModalViewController(didExit view: RegisterModalViewController) {
        for dimView in self.view.subviews {
            if dimView.tag == 100 {
                let dimView2: UIView = dimView as! UIView
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    dimView2.alpha = 0.0
                    }, completion: { (Bool) -> Void in
                        dimView2.removeFromSuperview()
                        self.alertHasShown = true
                })
            }
        }
    }
    
    func registerModalViewController(didSave view: RegisterModalViewController, password: String) {
        self.fireRegister(password)
    }
    
    func fireRegister(password: String) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        
        let parameters: NSDictionary = ["email": self.guestEmail,"password": password, "firstName": "", "lastName": ""]
        
        manager.POST(APIAtlas.registerUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let registerModel: RegisterModel = RegisterModel.parseDataFromDictionary(responseObject as! NSDictionary)
            if registerModel.isSuccessful {
                self.fireLogin(self.guestEmail, password: password)
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: registerModel.message, title: "Error")
                self.hud?.hide(true)
            }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if !Reachability.isConnectedToNetwork() {
                    UIAlertController.displayNoInternetConnectionError(self)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                self.hud?.hide(true)
        })
    }
    
    func fireLogin(email: String, password: String) {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["email": email,"password": password, "client_id": Constants.Credentials.clientID, "client_secret": Constants.Credentials.clientSecret, "grant_type": Constants.Credentials.grantBuyer]
        self.showHUD()
        manager.POST(APIAtlas.loginUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.showSuccessMessage()
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Mismatch username and password", title: "Login Failed")
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                self.hud?.hide(true)
        })
    }
    
    func showSuccessMessage() {
        let alertController = UIAlertController(title: "Success", message: "Successfully login.", preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
}