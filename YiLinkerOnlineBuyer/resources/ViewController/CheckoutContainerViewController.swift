//
//  CheckoutContainerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct CheckoutStrings {
    static let summary: String = StringHelper.localizedStringWithKey("SUMMARY_LOCALIZE_KEY")
    static let payment: String = StringHelper.localizedStringWithKey("PAYMENT_LOCALIZE_KEY")
    static let overView: String = StringHelper.localizedStringWithKey("OVERVIEW_LOCALIZE_KEY")
    
    static let orderSummary: String = StringHelper.localizedStringWithKey("ORDER_SUMMARY_LOCALIZE_KEY")
    static let delivery: String = StringHelper.localizedStringWithKey("DELIVERY_LOCALIZE_KEY")
    static let total: String = StringHelper.localizedStringWithKey("TOTAL_LOCALIZE_KEY")
    static let free: String = StringHelper.localizedStringWithKey("FREE_LOCALIZE_KEY")
    
    static let shipTo: String = StringHelper.localizedStringWithKey("SHIP_TO_LOCALIZE_KEY")
    static let defaultAddress: String = StringHelper.localizedStringWithKey("DEFAULT_ADDRESS_LOCALIZE_KEY")
    static let changeAddress: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_LOCALIZE_KEY")
    
    static let saveAndContinue: String = StringHelper.localizedStringWithKey("SAVE_AND_CONTINUE_LOCALIZE_KEY")
    static let saveAndGoToPayment: String = StringHelper.localizedStringWithKey("SAVE_AND_GO_TO_PAYMENT_LOCALIZE_KEY")
    static let continueShopping: String = StringHelper.localizedStringWithKey("CONTINUE_SHOPPING_LOCALIZE_KEY")
}

struct AddressStrings {
    static let firstName: String = StringHelper.localizedStringWithKey("FIRST_NAME_LOCALIZE_KEY")
    static let lastName: String = StringHelper.localizedStringWithKey("LAST_NAME_LOCALIZE_KEY")
    
    static let mobileNumber: String = StringHelper.localizedStringWithKey("MOBILE_NUMBER_LOCALIZE_KEY")
    static let emailAddress: String = StringHelper.localizedStringWithKey("EMAIL_ADDRESS_LOCALIZE_KEY")
    static let unitNo: String = StringHelper.localizedStringWithKey("UNIT_NO_LOCALIZE_KEY")
    static let buildingName: String = StringHelper.localizedStringWithKey("BUILDING_NAME_LOCALIZE_KEY")
    static let streetNo: String = StringHelper.localizedStringWithKey("STREET_NO_LOCALIZE_KEY")
    static let streetName: String = StringHelper.localizedStringWithKey("STREET_NAME_LOCALIZE_KEY")

    static let subdivision: String = StringHelper.localizedStringWithKey("SUBDIVISION_LOCALIZE_KEY")
    static let province: String = StringHelper.localizedStringWithKey("PROVINCE_LOCALIZE_KEY")
    static let city: String = StringHelper.localizedStringWithKey("CITY_LOCALIZE_KEY")
    
    static let barangay: String = StringHelper.localizedStringWithKey("BARANGAY_LOCALIZE_KEY")
    static let zipCode: String = StringHelper.localizedStringWithKey("ZIP_CODE_LOCALIZE_KEY")
    static let additionalInfo: String = StringHelper.localizedStringWithKey("ADDITIONAL_INFO_LOCALIZE_KEY")
    
    static let newAddress: String = StringHelper.localizedStringWithKey("NEW_ADDRESS_LOCALIZE_KEY")
    static let editAddress: String = StringHelper.localizedStringWithKey("EDIT_ADDRESS_LOCALIZE_KEY")
    static let addAddress: String = StringHelper.localizedStringWithKey("ADD_ADDRESS_LOCALIZE_KEY")
    static let changeAddress: String = StringHelper.localizedStringWithKey("CHANGE_ADDRESS_LOCALIZE_KEY")
    static let addressTitle: String = StringHelper.localizedStringWithKey("ADDRESS_TITLE_ADDRESS_LOCALIZE_KEY")
    
    static let incompleteInformation: String = StringHelper.localizedStringWithKey("INCOMPLETE_INFORMATION_LOCALIZE_KEY")
    static let mobileNumberIsRequired: String = StringHelper.localizedStringWithKey("MOBILE_NUMBER_REQUIRED_LOCALIZE_KEY")
    
    static let streetTitleRequired: String = StringHelper.localizedStringWithKey("STREET_TITLE_REQUIRED_LOCALIZE_KEY")
    static let unitNoRequired: String = StringHelper.localizedStringWithKey("UNIT_NO_REQUIRED_LOCALIZE_KEY")
    
    static let addressTitleRequired: String = StringHelper.localizedStringWithKey("ADDRESS_TITLE_REQUIRED_LOCALIZE_KEY")
    
    static let streetNumberRequired: String = StringHelper.localizedStringWithKey("STREET_NUMBER_REQUIRED_LOCALIZE_KEY")
    static let streetNameRequired: String = StringHelper.localizedStringWithKey("STREET_NAME_REQUIRED_LOCALIZE_KEY")
    static let zipCodeRequired: String = StringHelper.localizedStringWithKey("ZIP_CODE_REQUIRED_LOCALIZE_KEY")
}

class CheckoutContainerViewController: UIViewController, PaymentWebViewViewControllerDelegate, RegisterModalViewControllerDelegate, ChangeMobileNumberViewControllerDelegate, VerifyMobileNumberViewControllerDelegate, VerifyMobileNumberStatusViewControllerDelegate {
    
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
    
    var guestRegisterModel: RegisterModel = RegisterModel()
    
    var dimView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleView()
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.initViewController()
        self.setSelectedViewControllerWithIndex(self.selectedIndex)
        self.backButton()
        
        self.summaryLabel.text = CheckoutStrings.summary
        self.paymentLabel.text = CheckoutStrings.payment
        self.overViewLabel.text = CheckoutStrings.overView
        
        self.continueButton.setTitle(CheckoutStrings.saveAndContinue, forState: UIControlState.Normal)
        
        self.initDimView()
        
        if !SessionManager.isMobileVerified() && SessionManager.isLoggedIn() {
            self.changeMobileNumberAction()
        }
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
            self.continueButton(CheckoutStrings.saveAndContinue)
            let viewController: UIViewController = viewControllers[index]
            setSelectedViewController(viewController)
        } else if index == 1 {
            if SessionManager.isLoggedIn() || self.isValidGuestUser {
                self.isValidGuestUser = false
                self.secondCircle()
                self.continueButton(CheckoutStrings.saveAndGoToPayment)
                let viewController: UIViewController = viewControllers[index]
                setSelectedViewController(viewController)
            } else {
                self.selectedIndex--
                if self.summaryViewController!.guestCheckoutTableViewCell.firstNameTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.firstNameRequired, title: AddressStrings.incompleteInformation)
                } else if self.summaryViewController!.guestCheckoutTableViewCell.lastNameTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.lastNameRequired, title: AddressStrings.incompleteInformation)
                } else if self.summaryViewController!.guestCheckoutTableViewCell.mobileNumberTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AddressStrings.mobileNumberIsRequired, title: AddressStrings.incompleteInformation)
                } else if self.summaryViewController!.guestCheckoutTableViewCell.emailTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.emailRequired, title: AddressStrings.incompleteInformation)
                } else if !self.summaryViewController!.guestCheckoutTableViewCell.emailTextField.text!.isValidEmail() {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.invalidEmail, title: AddressStrings.incompleteInformation)
                } else {
                    self.guestEmail = self.summaryViewController!.guestCheckoutTableViewCell.emailTextField.text
                    self.guestFirstName = self.summaryViewController!.guestCheckoutTableViewCell.firstNameTextField.text
                    self.guestLastName = self.summaryViewController!.guestCheckoutTableViewCell.lastNameTextField.text
                    
                    guestRegisterModel = RegisterModel(firstName: self.summaryViewController!.guestCheckoutTableViewCell.firstNameTextField.text,
                        lastName: self.summaryViewController!.guestCheckoutTableViewCell.lastNameTextField.text,
                        emailAddress: self.summaryViewController!.guestCheckoutTableViewCell.emailTextField.text,
                        mobileNumber: self.summaryViewController!.guestCheckoutTableViewCell.mobileNumberTextField.text)
                    
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
        
        self.secondCircleLabel.backgroundColor = Constants.Colors.appTheme
        self.secondCircleLabel.textColor = UIColor.whiteColor()
        
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
        self.thirdCircleLabel.textColor = UIColor.whiteColor()
        self.thirdCircleLabel.backgroundColor = Constants.Colors.appTheme
        
        self.summaryLabel.textColor = UIColor.lightGrayColor()
        self.paymentLabel.textColor = UIColor.lightGrayColor()
        self.overViewLabel.textColor = UIColor.whiteColor()
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
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.serverError, title: Constants.Localized.someThingWentWrong)
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: paymentSuccessModel.message, title: Constants.Localized.someThingWentWrong)
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.fireRefreshToken(CheckoutRefreshType.COD)
                }
                self.selectedIndex--
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
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
        self.continueButton(CheckoutStrings.continueShopping)
        self.thirdCircle()
    }
    
    func paymentWebViewController(paymentDidNotSucceed paymentWebViewController: PaymentWebViewViewController) {
        self.selectedIndex--
    }
    
    func fireRefreshToken(refreshType: CheckoutRefreshType) {
        self.showHUD()
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                if refreshType == CheckoutRefreshType.COD {
                    self.fireCOD()
                } else if refreshType == CheckoutRefreshType.Credit {
                    self.firePesoPay()
                }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let alertController = UIAlertController(title: Constants.Localized.someThingWentWrong, message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
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
        self.navigationController!.view.addSubview(dimView)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
            dimView.alpha = 0.5
            }, completion: nil)
        
        let registerModelViewController: RegisterModalViewController = RegisterModalViewController(nibName:"RegisterModalViewController", bundle: nil)
        registerModelViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        registerModelViewController.providesPresentationContextTransitionStyle = true
        registerModelViewController.definesPresentationContext = true
        registerModelViewController.view.backgroundColor = UIColor.clearColor()
        registerModelViewController.delegate = self
        self.navigationController!.presentViewController(registerModelViewController, animated: true, completion: nil)
    }
    
    func registerModalViewController(didExit view: RegisterModalViewController, isShowRegister: Bool) {
        for dimView in self.navigationController!.view.subviews {
            if dimView.tag == 100 {
                let dimView2: UIView = dimView as! UIView
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    dimView2.alpha = 0.0
                    }, completion: { (Bool) -> Void in
                        dimView2.removeFromSuperview()
                        self.alertHasShown = true
                        
                        if isShowRegister {
                            self.redirectToRegister()
                        }
                })
            }
        }
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
        let alertController = UIAlertController(title: Constants.Localized.success, message: LoginStrings.successMessage, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }

    
    func redirectToRegister() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "StartPageStoryBoard", bundle: nil)
        let registerViewController: LoginAndRegisterContentViewController?
        if IphoneType.isIphone5() {
            registerViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController5") as? LoginAndRegisterContentViewController
        } else if IphoneType.isIphone4() {
            registerViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController4") as? LoginAndRegisterContentViewController
        } else {
            registerViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterContentViewController") as? LoginAndRegisterContentViewController
        }
        registerViewController?.registerModel = self.guestRegisterModel
        self.navigationController?.presentViewController(registerViewController!, animated: true, completion: nil)
    }
    
    //MARK: - Dim View
    func initDimView() {
        dimView = UIView(frame: self.view.bounds)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController!.view.addSubview(dimView!)
        //self.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
    }
    
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            }, completion: { finished in
                
        })
    }
    
    func changeMobileNumberAction(){
        var changeNumberModal = ChangeMobileNumberViewController(nibName: "ChangeMobileNumberViewController", bundle: nil)
        changeNumberModal.delegate = self
        changeNumberModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        changeNumberModal.providesPresentationContextTransitionStyle = true
        changeNumberModal.definesPresentationContext = true
        changeNumberModal.view.backgroundColor = UIColor.clearColor()
        changeNumberModal.view.frame.origin.y = 0
        changeNumberModal.mobileNumber = SessionManager.mobileNumber()
        changeNumberModal.isFromCheckout = true
        
        self.navigationController!.presentViewController(changeNumberModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    // MARK: - ChangeMobileNumberViewControllerDelegate
    func closeChangeNumbderViewController(){
        hideDimView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func submitChangeNumberViewController(){
        var verifyNumberModal = VerifyMobileNumberViewController(nibName: "VerifyMobileNumberViewController", bundle: nil)
        verifyNumberModal.delegate = self
        verifyNumberModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        verifyNumberModal.providesPresentationContextTransitionStyle = true
        verifyNumberModal.definesPresentationContext = true
        verifyNumberModal.view.backgroundColor = UIColor.clearColor()
        verifyNumberModal.view.frame.origin.y = 0
        self.navigationController!.presentViewController(verifyNumberModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    // MARK: - VerifyMobileNumberViewControllerDelegate
    func closeVerifyMobileNumberViewController() {
        hideDimView()
        self.changeMobileNumberAction()
    }
    
    func verifyMobileNumberAction(isSuccessful: Bool) {
        var verifyStatusModal = VerifyMobileNumberStatusViewController(nibName: "VerifyMobileNumberStatusViewController", bundle: nil)
        verifyStatusModal.delegate = self
        verifyStatusModal.isSuccessful = isSuccessful
        verifyStatusModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        verifyStatusModal.providesPresentationContextTransitionStyle = true
        verifyStatusModal.definesPresentationContext = true
        verifyStatusModal.view.backgroundColor = UIColor.clearColor()
        verifyStatusModal.view.frame.origin.y = 0
        self.navigationController!.presentViewController(verifyStatusModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    func requestNewCodeAction() {
        changeMobileNumberAction()
    }
    
    // MARK: - VerifyMobileNumberStatusViewControllerDelegate
    func closeVerifyMobileNumberStatusViewController() {
        hideDimView()
        self.changeMobileNumberAction()
    }
    
    func continueVerifyMobileNumberAction(isSuccessful: Bool) {
        hideDimView()
        if isSuccessful {
            self.summaryViewController?.fireSetCheckoutAddress("\(SessionManager.addressId())")
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func requestNewVerificationCodeAction() {
        changeMobileNumberAction()
    }
}
