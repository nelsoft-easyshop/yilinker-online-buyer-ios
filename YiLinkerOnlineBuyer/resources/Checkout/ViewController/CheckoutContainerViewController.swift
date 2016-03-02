//
//  CheckoutContainerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//



/*
For getting the province, city and barangay. First request all the province and if the fireProvince request is successful
request for the city and if the request of city is successful reques the barangay. Because barangay and city has a parameter cityId and
province id.
*/

/*
*** self.selectedIndex is important because this is the index of which containerView will present.

*** self.setSelectedViewControllerWithIndex(self.selectedIndex) this function is for setting child view controller logic codes before presenting the view.

*** setSelectedViewController(viewController) this function is for changing the child views of the container. For short presenting the views.

Increment/Decrement selectedIndex ----->  setSelectedViewControllerWithIndex(self.selectedIndex) ------->  setSelectedViewController(viewController)

*** saveAndContinue func is always been called if the user tapped the button at the bottom of the screen.

if self.selectedIndex == 0
Show Summary View Controller

if  self.selectedIndex == 1
Show Payment View Controller

if self.selectedIndex == 2
Show Over View View Controller

if self.selectedIndex > 2
Redirect to Home Page


Checkout Process

1) Present the summary view controller and pass all the items in cart.

Check if the user is logged In, If the user is logged in, make a request for the checkout address. If theres no user address create address or select address.

If User is not logged In Show the guest checkout fields and validate if all required fields are filled up. If yes Fire the guest checkout action which includes cookies
in the request.

If user is not logged in request for address location (province, city, baranagay).

- Optional

Make a voucher code request and display the result to summary view controller

If all the required fields are filled up and checkout address or guest checkout request is successful, change the value of isValidToSelectPayment to true
If the isValidToSelectPayment is equal to true present the payment view controller, if false show an alert message with title can't proceed or incomplete details.

2) Present the Payment View Controller and select COD or PesoPay
- to set Payment Type SessionManager.setPaymentType(paymentType)
- to get payment Type SessionManager.paymentType(paymentType)

If paymentType is COD fire the cash on delivery request and that request will return a data needed by PaymentSuccessModel
If PaymentSuccessModel.isSuccessful is Equal to true redirect to success page.

If paymentType is equal to peso pay, fire the request firePesopay() on getting the url's (success, cancel, failed).
If pesoPayModel.isSuccessful is equal to true present the Payment web view controller.
Once the request url is equal to the successUrl request fireOverView with the transationId to get the over view of the items and redirect it to the success page.
If the peso pay urls is equal to failed or cancel peso pay view controller delegate will be trigered and will decrease the selected index and will dismiss the payment web view controller.

3) If Logged in redirect to home page.

If the user is not logged in. App Will show an alert to ask the guest user if he wants to register or continue shopping.
- We will get the previous information in checkout and use it to our register model.
- Redirect the user to register page. Disabled all the fields except for password and confirm password.
- Register the user and redirect to home page.
*/

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
    static let address: String = StringHelper.localizedStringWithKey("ADDRESS_LOCALIZE_KEY")

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
    static let addressIsRequired: String = StringHelper.localizedStringWithKey("ADDRESS_REQUIRED_LOCALIZE_KEY")
    static let streetTitleRequired: String = StringHelper.localizedStringWithKey("STREET_TITLE_REQUIRED_LOCALIZE_KEY")
    static let unitNoRequired: String = StringHelper.localizedStringWithKey("UNIT_NO_REQUIRED_LOCALIZE_KEY")
    
    static let addressTitleRequired: String = StringHelper.localizedStringWithKey("ADDRESS_TITLE_REQUIRED_LOCALIZE_KEY")
    
    static let streetNumberRequired: String = StringHelper.localizedStringWithKey("STREET_NUMBER_REQUIRED_LOCALIZE_KEY")
    static let streetNameRequired: String = StringHelper.localizedStringWithKey("STREET_NAME_REQUIRED_LOCALIZE_KEY")
    static let zipCodeRequired: String = StringHelper.localizedStringWithKey("ZIP_CODE_REQUIRED_LOCALIZE_KEY")
}

class CheckoutContainerViewController: UIViewController, PaymentWebViewViewControllerDelegate, ChangeMobileNumberViewControllerDelegate, VerifyMobileNumberViewControllerDelegate, VerifyMobileNumberStatusViewControllerDelegate, VerifyNumberViewControllerDelegate, SuccessModalViewControllerDelegate {
    
    //view controller fragments
    var summaryViewController: SummaryViewController?
    var paymentViewController: PaymentViewController?
    var overViewViewController: OverViewViewController?

    //view controller container
    var viewControllers = [UIViewController]()
    
    //active view controller fragment
    var selectedChildViewController: UIViewController?
    
    //content view frame
    var contentViewFrame: CGRect?
    
    //If this variable set to true, it means checkout address validation pass and will move on to the payment selection
    var isValidToSelectPayment: Bool = false
    
    //cart items to be displayed in summary view controller
    var carItems: [CartProductDetailsModel] = []
    
    var selectedIndex: Int = 0
    var totalPrice: String = ""
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    //header displays
    @IBOutlet weak var firstCircleLabel: DynamicRoundedLabel!
    @IBOutlet weak var secondCircleLabel: DynamicRoundedLabel!
    @IBOutlet weak var thirdCircleLabel: DynamicRoundedLabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    var yiHud: YiHUD?
    
    var dimView: UIView?
    
    @IBOutlet weak var saveAndContinueButtonHeightConstraint: NSLayoutConstraint!
    
    
    //Models for address
    var provinceModel: ProvinceModel = ProvinceModel()
    var cityModel: CityModel = CityModel()
    var barangayModel: BarangayModel = BarangayModel()
    
    var addressModel: AddressModelV2 = AddressModelV2()
    
    //for selected values in picker view
    var barangayRow: Int = 0
    var cityRow: Int = 0
    var provinceRow: Int = 0
    
    var selectedRow: Int = 0
    
    var showSuccess: Bool = false
    
    //VerifyNumberViewController for dismissing
    var tempVerifyNumberViewController: VerifyNumberViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleView()
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.setUpInitialViews()
        
        //TODO: Hide this function for now, because it will be move into the last part of the transaction.
        /*if !SessionManager.isMobileVerified() && SessionManager.isLoggedIn() {
            self.changeMobileNumberAction()
        }*/
        
        self.setSelectedViewControllerWithIndex(0, transition: UIViewAnimationOptions.TransitionNone)
    }
    
    //MARK: -
    //MARK: - Fire Province
    func fireProvinces() {
        self.showHUD()
        WebServiceManager.fireProvince(APIAtlas.provinceUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.provinceModel = ProvinceModel.parseDataWithDictionary(responseObject as! NSDictionary)
                
                self.addressModel.province = self.provinceModel.location[0]
                self.addressModel.provinceId = self.provinceModel.provinceId[0]
                
                self.provinceRow = 0
                self.cityRow = 0
                self.barangayRow = 0
                
                self.addressModel.province = self.provinceModel.location[0]
                self.addressModel.barangay = ""
                
                //clear text field of summary view controller
                self.summaryViewController!.clearCityAndBarangayTextField()
                //get all cities
                self.fireCitiesWithProvinceId("\(self.addressModel.provinceId)")
                //set text to default province value
                self.summaryViewController!.setProvinceTextFieldTextWithString(self.provinceModel.location[0])
            } else {
                self.yiHud?.hide()
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
                }
            }

        })
    }
    
    //MARK: -
    //MARK: - Fire Cities
    func fireCitiesWithProvinceId(provinceId: String) {
        self.showHUD()
        WebServiceManager.fireCityWithProvinceId(APIAtlas.citiesUrl, provinceId: provinceId, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.cityModel = CityModel.parseDataWithDictionary(responseObject as! NSDictionary)
                
                self.addressModel.city = self.cityModel.location[0]
                self.addressModel.cityId = self.cityModel.cityId[0]
                
                self.addressModel.barangay = ""
                
                self.cityRow = 0
                self.barangayRow = 0
                //set city text field to default
                self.summaryViewController!.setCityTextFieldTextWithString(self.cityModel.location[0])
                
                self.fireBarangaysWithCityId("\(self.addressModel.cityId)")
            } else {
                self.yiHud?.hide()
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
                }
            }
            
        })
    }
    
    //MARK: - 
    //MARK: - Fire Barangays With City Id
    func fireBarangaysWithCityId(cityId: String) {
        self.showHUD()
        WebServiceManager.fireBarangaysWithCityId(APIAtlas.barangay, cityId: cityId, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.barangayModel = BarangayModel.parseDataWithDictionary(responseObject)
                
                if self.barangayModel.barangayId.count != 0 {
                    self.addressModel.barangayId = self.barangayModel.barangayId[0]
                    self.addressModel.barangay = self.barangayModel.location[0]
                }
                
                //set city text field to default
                self.summaryViewController!.setBarangayTextFieldTextWithString(self.barangayModel.location[0])
                self.yiHud?.hide()
            } else {
                self.yiHud?.hide()
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
                }
            }
        })
    }
    
    
    //MARK: -
    //MARK: - Setup Initial Views
    func setUpInitialViews() {
        self.initViewController()
        
        self.backButton()
        
        self.summaryLabel.text = CheckoutStrings.summary
        self.paymentLabel.text = CheckoutStrings.payment
        self.overViewLabel.text = CheckoutStrings.overView
        
        self.initDimView()
    }
    
    override func viewDidLayoutSubviews() {
        self.contentViewFrame = contentView.bounds
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    //MARK: - Dim View
    func initDimView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        dimView = UIView(frame: screenSize)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController!.view.addSubview(dimView!)
        //self.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
    }
    
    //MARK: -
    //MARK: - Show HUD
    func showHUD() {
        if self.yiHud != nil {
           self.yiHud!.removeFromSuperview()
        }
        
        self.yiHud = YiHUD.initHud()
        self.yiHud!.showHUDToView(self.navigationController!.view)
    }
    
    //MARK: -
    //MARK: - Title View
    func titleView() {
        self.navigationController!.navigationBar.topItem!.title = "Checkout"
    }
    
    //MARK: -
    //MARK: - Change Mobile Number Action
    func changeMobileNumberAction(){
        var changeNumberModal = ChangeMobileNumberViewController(nibName: "ChangeMobileNumberViewController", bundle: nil)
        changeNumberModal.delegate = self
        changeNumberModal.mobileNumber = SessionManager.mobileNumber()
        changeNumberModal.isFromCheckout = true
        changeNumberModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        changeNumberModal.providesPresentationContextTransitionStyle = true
        changeNumberModal.definesPresentationContext = true
        changeNumberModal.view.backgroundColor = UIColor.clearColor()
        changeNumberModal.view.frame.origin.y = 0
        
        self.navigationController!.presentViewController(changeNumberModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
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
    
    func closeVerifyMobileNumberViewController() {
        hideDimView()
        self.dismissViewControllerAnimated(true, completion: nil)
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
        submitChangeNumberViewController()
    }
    
    //MARK: -
    //MARK: - VerifyMobileNumberStatusViewControllerDelegate
    func closeVerifyMobileNumberStatusViewController() {
        hideDimView()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func continueVerifyMobileNumberAction(isSuccessful: Bool) {
        hideDimView()
        if isSuccessful {
            if SessionManager.addressId() != 0 {
                self.fireSetCheckoutAddressWithAddressId("\(SessionManager.addressId())")
            }
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func requestNewVerificationCodeAction() {
        submitChangeNumberViewController()
    }
    
    //MARK: -
    //MARK: - Set Selected View Controller With Index
    // This function is for executing child view logic code
    func setSelectedViewControllerWithIndex(index: Int, transition: UIViewAnimationOptions) {
        if index == 0 {
            self.firsCircle()
            if SessionManager.isMobileVerified() {
                self.continueButton.setTitle(CheckoutStrings.saveAndContinue, forState: UIControlState.Normal)
            } else {
                self.continueButton.setTitle("Save and Verify", forState: UIControlState.Normal)
            }
        } else if index == 1 {
            self.secondCircle()
            self.continueButton(CheckoutStrings.saveAndGoToPayment)
        }
        
        let viewController: UIViewController = viewControllers[index]
        setSelectedViewController(viewController, transition: transition)
        
    }
    
    //MARK: -
    //MARK: - First Circle
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
    
    //MARK: -
    //MARK: - Second Circle
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
    
    //MARK: -
    //MARK: - Third Circle
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
    
    //MARK: -
    //MARK: - Set Selected View Controller
    func setSelectedViewController(viewController: UIViewController, transition: UIViewAnimationOptions) {
        self.view.layoutIfNeeded()
        self.addChildViewController(viewController)
        self.view.layoutIfNeeded()
        self.addChildViewController(viewController)
        viewController.view.frame = self.contentViewFrame!
        
        self.contentView.addSubview(viewController.view)
        
        if self.selectedChildViewController != nil {
            self.transitionFromViewController(self.selectedChildViewController!, toViewController: viewController, duration: 0.3, options: transition, animations: nil) { (Bool) -> Void in
                viewController.didMoveToParentViewController(self)
                
                if !(self.selectedChildViewController == viewController) {
                    if self.isViewLoaded() {
                        self.selectedChildViewController?.willMoveToParentViewController(self)
                        self.selectedChildViewController?.view.removeFromSuperview()
                        self.selectedChildViewController?.removeFromParentViewController()
                    }
                }
                
                self.selectedChildViewController = viewController
            }
        } else {
                viewController.didMoveToParentViewController(self)
                self.selectedChildViewController = viewController
        }
    }
    
    //MARK: -
    //MARK: - Init View Controller
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
    
    //MARK: -
    //MARK: - Back Button
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
    
    //MARK: - 
    //MARK: - Fire Set Checkout Address
    func fireSetCheckoutAddressWithAddressId(addressId: String) {
        self.showHUD()
        WebServiceManager.fireSetCheckoutAddressWithUrl(APIAtlas.setCheckoutAddressUrl, accessToken: SessionManager.accessToken(), addressId: addressId) {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            
            println(responseObject)
            if successful {
                let jsonResult: NSDictionary = responseObject as! NSDictionary
                if jsonResult["isSuccessful"] as! Bool != true {
                    self.isValidToSelectPayment = false
                    var errorMessage = ""
                    if let errorString = jsonResult["message"] as? String {
                        errorMessage = errorString
                    }
                    //self.displayAlertAndRedirectToChangeAddressWithMessage(jsonResult["message"] as! String)
                    UIAlertController.showAlertYesOrNoWithTitle(Constants.Localized.error, message: "\(errorMessage) Add checkout address now?", viewController: self, actionHandler: { (isYes) -> Void in
                        if isYes {
                            self.summaryViewController!.redirectToAddress()
                        } else {
                            //No action
                        }
                    })
                } else {
                    self.isValidToSelectPayment = true
                }
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(.SetAddress, values: [])
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        }
    }
    
    //MARK: - 
    //MARK: - Fire Voucher With Voucher Id
    func fireVoucherWithVoucherId(voucherId: String) {
        self.showHUD()
        WebServiceManager.fireVoucherWithUrl(APIAtlas.voucherUrl, accessToken: SessionManager.accessToken(), voucherCode: voucherId) {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            if successful {
                let voucherModel = VoucherModel.parseDataFromDictionary(responseObject as! NSDictionary)
                //pass the voucher model created and populate it on the summary view controller
                self.summaryViewController!.voucherRequestIsSuccessful(voucherModel)
                //self.voucherRequestIsSuccessful(cell, voucherModel: self.voucherModel)
                //self.changeButtonState(cell.addButton)
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(.Voucher, values: [voucherId])
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        }
    }
    
    
    //MARK: -
    //MARK: - Back
    func back() {
        if self.selectedIndex != 0 {
            self.selectedIndex--
            self.setSelectedViewControllerWithIndex(self.selectedIndex, transition: UIViewAnimationOptions.TransitionFlipFromRight)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: -
    //MARK: - Save And Continue
    @IBAction func saveAndContinue(sender: AnyObject) {
        if self.selectedIndex == 0 {
            if SessionManager.isLoggedIn() {
                if self.isValidToSelectPayment {
                    if self.summaryViewController!.isIncompleteInformation || SessionManager.isMobileVerified() {
                        var errorMessage = ""
                        if self.summaryViewController!.firstName == "" {
                            errorMessage = "Please insert your first name."
                        } else if self.summaryViewController!.lastName == "" {
                            errorMessage = "Please insert your last name."
                        } else if self.summaryViewController!.mobileNumber == "" {
                            errorMessage = "Please insert your mobile Number."
                        }
                        
                        if errorMessage == "" {
                            if SessionManager.isMobileVerified() {
                                self.fireSaveBasicInfoWithFirstName(self.summaryViewController!.firstName, lastName: self.summaryViewController!.lastName, mobileNumber: self.summaryViewController!.mobileNumber, confirmationCode: "", email: self.summaryViewController!.email)
                            } else {
                                self.fireGetAuthenticatedOTP(self.summaryViewController!.mobileNumber)
                            }
                        } else {
                            Toast.displayToastWithMessage(errorMessage, view: self.navigationController!.view)
                        }
                        
                    } else {
                        if SessionManager.isMobileVerified() {
                            self.selectedIndex++
                            self.setSelectedViewControllerWithIndex(self.selectedIndex, transition: UIViewAnimationOptions.TransitionFlipFromLeft)
                        } else {
                            self.fireGetAuthenticatedOTP(self.summaryViewController!.mobileNumber)
                        }
                    }
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Please choose/add a checkout address.")
                }
            } else {
                //Validate all required fields before accessing fire guest checkout
                if self.summaryViewController!.guestCheckoutTableViewCell.firstNameTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.firstNameRequired, title: AddressStrings.incompleteInformation)
                } else if !self.summaryViewController!.guestCheckoutTableViewCell.firstNameTextField.text!.isValidName() {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.illegalFirstName, title: AddressStrings.incompleteInformation)
                } else if self.summaryViewController!.guestCheckoutTableViewCell.lastNameTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.lastNameRequired, title: AddressStrings.incompleteInformation)
                } else if !self.summaryViewController!.guestCheckoutTableViewCell.lastNameTextField.text!.isValidName() {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.invalidLastName, title: AddressStrings.incompleteInformation)
                } else if self.summaryViewController!.guestCheckoutTableViewCell.mobileNumberTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AddressStrings.mobileNumberIsRequired, title: AddressStrings.incompleteInformation)
                } else if self.summaryViewController!.guestCheckoutTableViewCell.streetNameTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: AddressStrings.addressIsRequired, title: AddressStrings.incompleteInformation)
                } else {
//                    self.fireGuestCheckout()
                    self.fireGetOTP(self.summaryViewController!.guestCheckoutTableViewCell.mobileNumberTextField.text, areaCode: "63", type: "guest_checkout", storeType: "")
                }
                
                /*
                else if self.summaryViewController!.guestCheckoutTableViewCell.emailTextField.text!.isEmpty {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.emailRequired, title: AddressStrings.incompleteInformation)
                    } else if !self.summaryViewController!.guestCheckoutTableViewCell.emailTextField.text!.isValidEmail() {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: RegisterStrings.invalidEmail, title: AddressStrings.incompleteInformation)
                    }
                */
            }
        } else if self.selectedIndex == 1 {
            //Check if what payment type user choose
            if self.paymentViewController!.paymentType == PaymentType.COD {
                self.fireCOD()
            } else {
                self.firePesoPay()
            }
        } else {
            if SessionManager.isLoggedIn() {
                self.redirectToHomeView()
            } else {
                let registerModel: RegisterModel = self.summaryViewController!.guestUser()
                UIAlertController.showAlertYesOrNoWithTitle("\(Constants.Localized.hi) \(registerModel.firstName)", message: RegisterModalStrings.doYouWant, viewController: self, actionHandler: { (isYes) -> Void in
                    if isYes {
                        self.redirectToRegister()
                    } else {
                        self.redirectToHomeView()
                    }
                })
            }
        }
    }
    
    //MARK: -
    //MARK: - Redirect To Home View
    func redirectToHomeView() {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToHomeView()
    }
    
    //MARK: -
    //MARK: - Continue Button
    func continueButton(title: String) {
        if self.continueButton != nil {
            self.continueButton.setTitle(title, forState: UIControlState.Normal)
        }
    }
    
    //MARK: -
    //MARK: - Show Success Message
    func showSuccessMessage() {
        let alertController = UIAlertController(title: Constants.Localized.success, message: LoginStrings.successMessage, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    //MARK: -
    //MARK: - Redirect to Success Page
    func redirectToSuccessPage(paymentSuccessModel: PaymentSuccessModel) {
        self.selectedIndex++
        self.overViewViewController?.paymentSuccessModel = paymentSuccessModel
        let viewController: UIViewController = viewControllers[2]
        setSelectedViewController(viewController, transition: UIViewAnimationOptions.TransitionFlipFromLeft)
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
        self.continueButton(CheckoutStrings.continueShopping)
        self.thirdCircle()
        self.saveAndContinueButtonHeightConstraint.constant = 0
    }
    
    //MARK: -
    //MARK: - Redirect To Register
    func redirectToRegister() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "LoginAndRegisterTableViewController", bundle: nil)
        
        let registerViewController: LoginAndRegisterTableViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterTableViewController") as! LoginAndRegisterTableViewController
        
        registerViewController.registerModel = self.summaryViewController!.guestUser()
        registerViewController.isGuestUser = true
        
        self.navigationController?.presentViewController(registerViewController, animated: true, completion: nil)
    }
    
    //MARK: - 
    //MARK: - Fire Guest Checkout
    func fireGuestCheckout(confirmationCode: String) {
        self.showHUD()
        let registerModel: RegisterModel = self.summaryViewController!.guestUser()
        WebServiceManager.fireGuestCheckoutWithUrl(APIAtlas.guestUserUrl, firstName: registerModel.firstName, lastName: registerModel.lastName, email: registerModel.emailAddress, contactNumber: registerModel.mobileNumber, title: registerModel.title, streetName: registerModel.streetName, zipCode: registerModel.zipCode, location: registerModel.location, confirmationCode: confirmationCode) {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            if successful {
                println(responseObject)
                let dictionary: NSDictionary = responseObject as! NSDictionary
                
                let isSuccessful: Bool = dictionary["isSuccessful"] as! Bool
                
                if isSuccessful {
                    let address: String = "\(registerModel.streetName) \(self.addressModel.barangay) \(self.addressModel.city) \(self.addressModel.province)"
                    let fullName: String = "\(registerModel.firstName) \(registerModel.lastName)"
                    SessionManager.setUserFullName(fullName)
                    SessionManager.setFullAddress(address)
                    
                    self.showVerifiedSuccessModal(self.tempVerifyNumberViewController!)
//                    self.fireGetOTP(registerModel.mobileNumber, areaCode: "63", type: "guest_checkout", storeType: "")
                    
                    
                   /* self.isValidToSelectPayment = true
                    self.selectedIndex++
                    self.setSelectedViewControllerWithIndex(self.selectedIndex, transition: UIViewAnimationOptions.TransitionFlipFromLeft)*/
                } else {
                    self.tempVerifyNumberViewController!.showWrongCodeLabel()
                }
            } else {
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.tempVerifyNumberViewController!.showWrongCodeLabel()
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        }
    }
    
    //MARK: -
    //MARK: - Fire COD
    func fireCOD() {
        self.showHUD()
        WebServiceManager.fireCODWithUrl(APIAtlas.COD(), accessToken: SessionManager.accessToken()) {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            if successful {
                let paymentSuccessModel: PaymentSuccessModel = PaymentSuccessModel.parseDataWithDictionary(responseObject as! NSDictionary)
                if paymentSuccessModel.isSuccessful {
                    self.redirectToSuccessPage(paymentSuccessModel)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: paymentSuccessModel.message, title: Constants.Localized.someThingWentWrong)
                }
            } else {
                self.selectedIndex--
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(.COD, values: [])
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        }
    }
    
    //MARK: -
    //MARK: - Fire Peso Pay
    //This function is for getting the peso pay urls
    func firePesoPay() {
        WebServiceManager.firePesoPayWithUrl(APIAtlas.pesoPayUrl, accessToken: SessionManager.accessToken()) {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            if successful {
                let pesoPayModel: PesoPayModel = PesoPayModel.parseDataWithDictionary(responseObject as! NSDictionary)
                if pesoPayModel.isSuccessful {
                    self.redirectToPaymentWebViewWithUrl(pesoPayModel)
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: pesoPayModel.message, title: Constants.Localized.error)
                }

            } else {
                self.selectedIndex--
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(.Credit, values: [])
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        }
    }
    
    //MARK: -
    //MARK: - Fire Over View
    func fireOverView(transactionId: String, modalViewController: UIViewController) {
        self.showHUD()
        WebServiceManager.fireOverViewWith(APIAtlas.overViewUrl, accessToken: SessionManager.accessToken(), transactionId: transactionId) {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            if successful {
                let paymentSuccessModel: PaymentSuccessModel = PaymentSuccessModel.parseDataWithDictionary(responseObject as! NSDictionary)
                if paymentSuccessModel.isSuccessful {
                    self.redirectToSuccessPage(paymentSuccessModel)
                    modalViewController.dismissViewControllerAnimated(true, completion: nil)
                }
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(.OverView, values: [transactionId, modalViewController])
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        }
    }
    
    //MARK: -
    //MARK: - Redirect to Payment WebView With Url
    func redirectToPaymentWebViewWithUrl(pesoPayModel: PesoPayModel) {
        let paymentWebViewController = PaymentWebViewViewController(nibName: "PaymentWebViewViewController", bundle: nil)
        paymentWebViewController.pesoPayModel = pesoPayModel
        paymentWebViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController(rootViewController: paymentWebViewController)
        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    //MARK: -
    //MARK: - Payment Web View Controller Delegate
    func paymentWebViewController(paymentDidCancel paymentWebViewController: PaymentWebViewViewController) {
        self.selectedIndex--
    }
    
    func paymentWebViewController(paymentDidNotSucceed paymentWebViewController: PaymentWebViewViewController) {
        self.selectedIndex--
    }
    
    //MARK: -
    //MARK: - Fire Refresh Token
    func fireRefreshToken(refreshType: CheckoutRefreshType, values: [AnyObject]) {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                if refreshType == CheckoutRefreshType.COD {
                    self.fireCOD()
                } else if refreshType == CheckoutRefreshType.Credit {
                    self.firePesoPay()
                } else if refreshType == .SetAddress {
                    self.fireSetCheckoutAddressWithAddressId("\(SessionManager.addressId())")
                } else if refreshType == .Voucher {
                    self.fireVoucherWithVoucherId(values.first! as! String)
                } else if refreshType == .OverView {
                    self.fireOverView(values.first as! String, modalViewController: values[1] as! UIViewController)
                } else if refreshType == .SaveBasicInfo {
                    self.fireSaveBasicInfoWithFirstName(values[0] as! String, lastName: values[1] as! String, mobileNumber: values[2] as! String, confirmationCode: values[3] as! String, email: values[4] as! String)
                } else if refreshType == .VerifyOTP {
                    var mobileNumber: String = ""
                    if SessionManager.isLoggedIn() {
                        mobileNumber = self.summaryViewController!.mobileNumber
                    } else {
                        mobileNumber = values[0] as! String
                    }
                    
                   self.fireVerifyOTPCode(mobileNumber, verificationCode:  values[2] as! String, type: "checkout", storeType: "", verifyNumberViewController: values[1] as! VerifyNumberViewController)
                }
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    FBSDKLoginManager().logOut()
                    GPPSignIn.sharedInstance().signOut()
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.startPage()
                })
            }
        })
    }
    
    
    //MARK: -
    //MARK: - Hide Dim View
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            }, completion: { finished in
                
        })
    }
    
    //MARK: -
    //MARK: - Show Verify Number Modal
    func showVerifyNumberModal() {
        var verifyNumberViewController = VerifyNumberViewController(nibName: "VerifyNumberViewController", bundle: nil)
        verifyNumberViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        verifyNumberViewController.providesPresentationContextTransitionStyle = true
        verifyNumberViewController.definesPresentationContext = true
        verifyNumberViewController.view.backgroundColor = UIColor.clearColor()
        verifyNumberViewController.view.frame.origin.y = 0
        verifyNumberViewController.delegate = self
        self.navigationController!.presentViewController(verifyNumberViewController, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    //MARK: - 
    //MARK: - Verify Number View Controller Delegate
    func verifyNumberViewController(verifyNumberViewController: VerifyNumberViewController, didStartEditing textField: UITextField) {
        if IphoneType.isIphone4() {
            verifyNumberViewController.verticalSpacingConstant.constant = 40
        } else if IphoneType.isIphone5() {
            verifyNumberViewController.verticalSpacingConstant.constant = 80
        }

        UIView.animateWithDuration(0.5, animations: { () -> Void in
            verifyNumberViewController.view.layoutIfNeeded()
        })
    }
    
    func verifyNumberViewController(verifyNumberViewController: VerifyNumberViewController, didTapSend textField: UITextField) {
        verifyNumberViewController.moveScreenToDefaultPosition()
        
        verifyNumberViewController.startLoading()
        var mobileNumber: String = ""
        
        if verifyNumberViewController.submitButton.titleLabel!.text == "SUBMIT" {
            if SessionManager.isLoggedIn() {
                mobileNumber =  self.summaryViewController!.mobileNumber
                self.tempVerifyNumberViewController = verifyNumberViewController
//                self.fireVerifyOTPCode(mobileNumber, verificationCode: textField.text, type: "checkout", storeType: "",verifyNumberViewController: verifyNumberViewController)
                self.fireSaveBasicInfoWithFirstName(self.summaryViewController!.firstName, lastName: self.summaryViewController!.lastName, mobileNumber: self.summaryViewController!.mobileNumber, confirmationCode: textField.text, email: self.summaryViewController!.email)
            } else {
                let registerModel: RegisterModel = self.summaryViewController!.guestUser()
                mobileNumber = registerModel.mobileNumber
                self.tempVerifyNumberViewController = verifyNumberViewController
                self.fireGuestCheckout(textField.text)
            }
            
            
        } else {
            Delay.delayWithDuration(3.0, completionHandler: { (success) -> Void in
                verifyNumberViewController.stopLoading()
                verifyNumberViewController.updateUIToDefault()
            })
        }
    }
    
    
    //MARK: - 
    //MARK: - Show Verified Success Modal
    func showVerifiedSuccessModal(verifyNumberViewController: VerifyNumberViewController) {
        verifyNumberViewController.dismissViewControllerAnimated(true, completion: { () -> Void in
            self.showSuccessModal()
        })
    }
    
    //MARK: -
    //MARK: - Show WrongCode Label Modal
    func showWrongCodeLabelModal(verifyNumberViewController: VerifyNumberViewController) {
        verifyNumberViewController.showWrongCodeLabel()
    }
    
    func verifyNumberViewController(verifyNumberViewController: VerifyNumberViewController, changeState modalState: ModalState) {
        if modalState == .SessionExpired {
            verifyNumberViewController.updateUIToSessionExpired()
        } else if modalState == .WrongCode {
            verifyNumberViewController.showWrongCodeLabel()
        }
    }
    
    //MARK: -
    //MARK: - Show Success Modal
    func showSuccessModal() {
        var successModalViewController = SuccessModalViewController(nibName: "SuccessModalViewController", bundle: nil)
        successModalViewController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        successModalViewController.providesPresentationContextTransitionStyle = true
        successModalViewController.definesPresentationContext = true
        successModalViewController.view.backgroundColor = UIColor.clearColor()
        successModalViewController.view.frame.origin.y = 0
        successModalViewController.delegate = self
        self.navigationController!.presentViewController(successModalViewController, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    //MARK: - 
    //MARK: - Success Modal View Controller Delegate
    func successModalViewController(successModalViewController: SuccessModalViewController, didTapButton doneButton: UIButton) {
        successModalViewController.dismissViewControllerAnimated(true, completion: nil)
        self.hideDimView()
        
        if SessionManager.isLoggedIn() {
            self.selectedIndex++
            self.setSelectedViewControllerWithIndex(self.selectedIndex, transition: UIViewAnimationOptions.TransitionFlipFromLeft)
        } else {
            self.isValidToSelectPayment = true
            self.selectedIndex++
            self.setSelectedViewControllerWithIndex(self.selectedIndex, transition: UIViewAnimationOptions.TransitionFlipFromLeft)
        }
    }
    
    //MARK: -
    //MARK: - Fire Save Basic Info
    func fireSaveBasicInfoWithFirstName(firstName: String, lastName: String, mobileNumber: String, confirmationCode: String, email: String) {
        self.showHUD()
        WebServiceManager.fireSaveBasicInfoWithUrl(APIAtlas.saveBasicInfoUrl, firstName: firstName, lastName: lastName, contactNo: mobileNumber, confirmationCode: confirmationCode, email: email, accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            println(responseObject as! NSDictionary)
            if successful {
                println(responseObject)
                var basicInfoModel: BasicInfoModel = BasicInfoModel.parseDataFromDictionary(responseObject as! NSDictionary)
                
                if basicInfoModel.isSuccessful {
//                    if basicInfoModel.isVerified {
//                    self.selectedIndex++
//                    self.setSelectedViewControllerWithIndex(self.selectedIndex, transition: UIViewAnimationOptions.TransitionFlipFromLeft)
//                    } else {
//                        Toast.displayToastWithMessage("not verified", duration: 2.0, view: self.navigationController!.view)
//                    }
                    if SessionManager.isMobileVerified() {
                        self.selectedIndex++
                        self.setSelectedViewControllerWithIndex(self.selectedIndex, transition: UIViewAnimationOptions.TransitionFlipFromLeft)
                    } else {
                        self.showVerifiedSuccessModal(self.tempVerifyNumberViewController!)
                    }
                } else {
                    Toast.displayToastWithMessage(basicInfoModel.message, duration: 1.5, view: self.view)
                    self.tempVerifyNumberViewController?.showWrongCodeLabel()
//                    if !SessionManager.isMobileVerified() {
//                        self.fireGetAuthenticatedOTP(mobileNumber)
//                    }
                }
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.tempVerifyNumberViewController?.showWrongCodeLabel()
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(.SaveBasicInfo, values: [firstName, lastName, mobileNumber, confirmationCode, email])
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        }
    }
    
    //MARK: -
    //MARK: - Fire Get OTP
    func fireGetOTP(contactNumber: String, areaCode: String, type: String, storeType: String) {
        self.showHUD()
        
        WebServiceManager.fireUnauthenticatedOTPRequestWithUrl(APIAtlas.unauthenticateOTP, contactNumber: contactNumber, areaCode: areaCode, type: type, storeType: storeType, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            println(responseObject)
            if successful {
                self.showVerifyNumberModal()
            } else {
                self.yiHud?.hide()
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    //self.fireRefreshToken(.SaveBasicInfo, values: [firstName, lastName, mobileNumber])
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else if requestErrorType == .Cancel {
                    //Do nothing
                }
            }
        })
    }
    
    //MARK: -
    //MARK: - Fire Get Authenticated OTP
    func fireGetAuthenticatedOTP(mobileNumber: String) {
        self.showHUD()
        
        WebServiceManager.fireAuthenticatedOTPRequestWithUrl(APIAtlas.authenticatedOTP, accessToken: SessionManager.accessToken(), type: "checkout", contactNumber: mobileNumber) { (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            if successful {
                self.showVerifyNumberModal()
            } else {
                self.yiHud?.hide()
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    //self.fireRefreshToken(.SaveBasicInfo, values: [firstName, lastName, mobileNumber])
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else if requestErrorType == .Cancel {
                    //Do nothing
                }
            }
        }
    }
    
    //MARK: - 
    //MARK: - Fire VerifyOTPCode
    func fireVerifyOTPCode(contactNo: String, verificationCode: String, type: String, storeType: String, verifyNumberViewController: VerifyNumberViewController) {
        var url: String = ""
        var type2: String = ""
        if SessionManager.isLoggedIn() {
            url = APIAtlas.verifyAuthenticatedOTPCodeUrl
            type2 = "checkout"
        } else {
            url = APIAtlas.verifyUnAuthenticatedOTPCodeUrl
            type2 = "guest_checkout"
        }
        
        WebServiceManager.fireVerifyOTPCodeWithUrl(url, contactNo: contactNo, verificationCode: verificationCode, type: type2, storeType: storeType, accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            
            self.yiHud?.hide()
            
            if successful {
                self.showVerifiedSuccessModal(verifyNumberViewController)
            } else {
                println("contact number: \(contactNo)")
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    verifyNumberViewController.showWrongCodeLabel()
                }  else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(.VerifyOTP, values: [verificationCode, verifyNumberViewController, contactNo])
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else if requestErrorType == .Cancel {
                    //Do nothing
                }
            }
        }
    }
}
