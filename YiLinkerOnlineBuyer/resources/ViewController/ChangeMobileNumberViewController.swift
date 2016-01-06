//
//  ChangeMobileNumberViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 9/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ChangeMobileNumberViewControllerDelegate {
    func closeChangeNumbderViewController()
    func submitChangeNumberViewController()
}

class ChangeMobileNumberViewController: UIViewController {
    
    var delegate: ChangeMobileNumberViewControllerDelegate?
    
    let manager = APIManager.sharedInstance
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var oldNumberTextField: UITextField!
    @IBOutlet weak var newNumberTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var changeMobileLabel: UILabel!
    @IBOutlet weak var oldNumberLabel: UILabel!
    @IBOutlet weak var newNumberLabel: UILabel!
    @IBOutlet weak var oldNumberConstant: NSLayoutConstraint!
    @IBOutlet weak var oldNumberTextConstant: NSLayoutConstraint!
    
    @IBOutlet weak var mainViewConstant: NSLayoutConstraint!
    var mainViewOriginalFrame: CGRect?
    
    var screenHeight: CGFloat?
    
    var mobileNumber: String = ""
    
    var hud: MBProgressHUD?
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    
    var isFromCheckout: Bool = false

    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        initializeLocalizedString()
        
        oldNumberTextField.text = mobileNumber
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func initializeViews() {
        mainView.layer.cornerRadius = 8
        submitButton.layer.cornerRadius = 5
        mainViewOriginalFrame = mainView.frame
        
        // Add tap event to Sort View
        let viewType = UITapGestureRecognizer(target:self, action:"tapMainViewAction")
        self.tapView.addGestureRecognizer(viewType)
        
        let view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenHeight = screenSize.height
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
        
        if !SessionManager.isMobileVerified() {
            if isFromCheckout {
                oldNumberTextField.hidden = true
                oldNumberLabel.hidden = true
                oldNumberConstant.constant = 0
                oldNumberTextConstant.constant = 0
                mainViewConstant.constant = mainViewConstant.constant - 50

                newNumberTextField.text = mobileNumber
//                newNumberTextField.enabled = false
            }
        }
        
//        if SessionManager.mobileNumber().isEmpty || !SessionManager.isMobileVerified(){
//            oldNumberTextField.hidden = true
//            oldNumberLabel.hidden = true
//            oldNumberConstant.constant = 0
//            oldNumberTextConstant.constant = 0
//            mainViewConstant.constant = mainViewConstant.constant - 50
//            if isFromCheckout {
//                newNumberTextField.text = mobileNumber
//                newNumberTextField.enabled = false
//            }
//        } else {
//            if isFromCheckout {
//                newNumberTextField.text = SessionManager.mobileNumber()
//                newNumberTextField.enabled = false
//            }
//        }
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        
        var changeMobileLocalizeString = StringHelper.localizedStringWithKey("CHANGEMOBILE_LOCALIZE_KEY")
        var oldNumberLocalizeString = StringHelper.localizedStringWithKey("OLDNUMBER_LOCALIZE_KEY")
        var newNumberLocalizeString = StringHelper.localizedStringWithKey("NEWNUMBER_LOCALIZE_KEY")
        var submitLocalizeString = StringHelper.localizedStringWithKey("SUBMIT_LOCALIZE_KEY")
        
        submitButton.setTitle(submitLocalizeString, forState: UIControlState.Normal)
        
        changeMobileLabel.text = changeMobileLocalizeString
        oldNumberLabel.text = oldNumberLocalizeString
        newNumberLabel.text = newNumberLocalizeString
        
//        if SessionManager.mobileNumber().isEmpty || !SessionManager.isMobileVerified(){
//            newNumberLabel.text = StringHelper.localizedStringWithKey("MOBILE_LOCALIZED_KEY")
//            newNumberTextField.placeholder = StringHelper.localizedStringWithKey("MOBILE_LOCALIZED_KEY")
//            submitButton.setTitle(StringHelper.localizedStringWithKey("SEND_CODE_LOCALIZED_KEY"), forState: UIControlState.Normal)
//        }
        
        if !SessionManager.isMobileVerified() {
            titleLabel.text = StringHelper.localizedStringWithKey("YOUR_MOBILE_LOCALIZE_KEY")
            newNumberLabel.text = StringHelper.localizedStringWithKey("PLEASE_ENTER_NUMBER_LOCALIZE_KEY")
            newNumberTextField.placeholder = StringHelper.localizedStringWithKey("MOBILE_LOCALIZED_KEY")
            submitButton.setTitle(StringHelper.localizedStringWithKey("SUBMIT_CAPS_LOCALIZE_KEY"), forState: UIControlState.Normal)
        } else {
            titleLabel.text = StringHelper.localizedStringWithKey("CHANGEMOBILE_LOCALIZE_KEY")
        }
    }
    
    @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topMarginConstraint.constant = screenHeight! / 10
        } else if IphoneType.isIphone5() {
            topMarginConstraint.constant = screenHeight! / 5
        }
    }
    
    func tapMainViewAction() {
        if IphoneType.isIphone4() {
            if topMarginConstraint.constant == screenHeight! / 10 {
                tapMainAction()
            } else {
                buttonAction(closeButton)
            }
        } else if(IphoneType.isIphone5() ) {
            if topMarginConstraint.constant == screenHeight! / 5 {
                tapMainAction()
            } else {
                buttonAction(closeButton)
            }
        } else {
            buttonAction(closeButton)
        }
    }
    
    func tapMainAction() {
        oldNumberTextField.resignFirstResponder()
        newNumberTextField.resignFirstResponder()
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.closeChangeNumbderViewController()
        } else if sender as! UIButton == submitButton {
            oldNumberTextField.resignFirstResponder()
            newNumberTextField.resignFirstResponder()
            
            if !SessionManager.isMobileVerified(){
                if newNumberTextField.text.isEmpty{
                    var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                    showAlert(title: errorLocalizeString, message: completeLocalizeString)
                } else {
                    if SessionManager.mobileNumber().isEmpty {
                        SessionManager.setMobileNumber(newNumberTextField.text)
                        setNewMobileNumber(newNumberTextField.text)
//                        fireUpdateProfile(APIAtlas.updateMobileNumber, params: NSDictionary(dictionary: ["access_token" : SessionManager.accessToken(),
//                            "newContactNumber": newNumberTextField.text ]))
                    } else {
                        if SessionManager.mobileNumber() == newNumberTextField.text {
                            SessionManager.setMobileNumber(SessionManager.mobileNumber())
                            setNewMobileNumber(SessionManager.mobileNumber())
                        } else {
                            setNewMobileNumber(newNumberTextField.text)
//                            fireUpdateProfile(APIAtlas.updateMobileNumber, params: NSDictionary(dictionary: ["access_token" : SessionManager.accessToken(),
//                                "newContactNumber": newNumberTextField.text ,
//                                "oldContactNumber": SessionManager.mobileNumber()]))
                        }
                    }
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.submitChangeNumberViewController()
                }
            } else {
                if oldNumberTextField.text.isEmpty ||  newNumberTextField.text.isEmpty{
                    var completeLocalizeString = StringHelper.localizedStringWithKey("COMPLETEFIELDS_LOCALIZE_KEY")
                    showAlert(title: errorLocalizeString, message: completeLocalizeString)
                } else if oldNumberTextField.text != mobileNumber {
                    var incorrectLocalizeString = StringHelper.localizedStringWithKey("INCORRECTMOBILE_LOCALIZE_KEY")
                    showAlert(title: errorLocalizeString, message: incorrectLocalizeString)
                } else {
                    SessionManager.setMobileNumber(oldNumberTextField.text)
                    setNewMobileNumber(newNumberTextField.text)
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.submitChangeNumberViewController()
//                    fireUpdateProfile(APIAtlas.updateMobileNumber, params: NSDictionary(dictionary: ["access_token" : SessionManager.accessToken(),
//                        "oldContactNumber": oldNumberTextField.text,
//                        "newContactNumber": newNumberTextField.text]))
                }
            }
        }
    }
    
    func setNewMobileNumber(newMobileNumber: String) {
        NSUserDefaults.standardUserDefaults().setObject(newMobileNumber, forKey: "newMobileNumber")
        NSUserDefaults.standardUserDefaults().synchronize()
    }

    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        var okLocalizeString = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
        let defaultAction = UIAlertAction(title: okLocalizeString, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //Loader function
    func showLoader() {
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
    
    func dismissLoader() {
        self.hud?.hide(true)
    }
    
    func fireUpdateProfile(url: String, params: NSDictionary!) {
        showLoader()

            manager.POST(url, parameters: params, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken("change", url: url, params: params)
                } else {
                    if responseObject["isSuccessful"] as! Bool {
                        SessionManager.setMobileNumber(self.newNumberTextField.text)
                        SessionManager.setIsMobileVerified(true)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.delegate?.submitChangeNumberViewController()
                        self.dismissLoader()
                    } else {
                        self.showAlert(title: self.errorLocalizeString, message: responseObject["message"] as! String)
                        self.dismissLoader()
                    }
                }
                println(responseObject)
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    
                    println(error)
                    if Reachability.isConnectedToNetwork() {
                        var info = error.userInfo!
                        
                        if let data = info["data"] as? NSDictionary {
                            if let errors = data["errors"] as? NSArray {
                                if errors.count == 0 {
                                    if let message = info["message"] as? NSString {
                                        self.showAlert(title: self.errorLocalizeString, message: message as String)
                                    }
                                    
                                } else {
                                    self.showAlert(title: self.errorLocalizeString, message: errors[0] as! String)
                                }
                            }
                        } else {
                            UIAlertController.displaySomethingWentWrongError(self)
                        }
                        
                    } else {
                        UIAlertController.displayNoInternetConnectionError(self)
                    }
                    
                    self.dismissLoader()
                    
            })

    }
    
    
    func requestRefreshToken(type: String, url: String, params: NSDictionary!) {
        let urlTemp: String = APIAtlas.loginUrl
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID(),
            "client_secret": Constants.Credentials.clientSecret(),
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(urlTemp, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.dismissLoader()
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            if type == "change" {
                self.fireUpdateProfile(url, params: params)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.dismissLoader()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert(title: self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                
        })
    }
    



}
