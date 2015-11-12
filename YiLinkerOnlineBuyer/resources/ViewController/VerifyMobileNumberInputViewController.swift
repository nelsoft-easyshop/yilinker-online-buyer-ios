//
//  VerifyMobileNumberInputViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 10/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol VerifyMobileNumberInputViewControllerDelegate {
    func closeVerifyMobileNumberInputViewController()
    func sendCodeAction()
}

class VerifyMobileNumberInputViewController: UIViewController {
    
    var delegate: VerifyMobileNumberInputViewControllerDelegate?
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var sendCodeButton: UIButton!
    
    var mainViewOriginalFrame: CGRect?
    
    var screenHeight: CGFloat?
    
    var hud: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        initializeLocalizeStrings()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        mainView.layer.cornerRadius = 8
        sendCodeButton.layer.cornerRadius = 5
        mainViewOriginalFrame = mainView.frame
        
        // Add tap event to Sort View
        var viewType = UITapGestureRecognizer(target:self, action:"tapMainViewAction")
        self.tapView.addGestureRecognizer(viewType)
        
        var view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenHeight = screenSize.height
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
        
        let number: String = SessionManager.mobileNumber()
        
        if number.isEmpty {
            numberTextField.enabled = true
        } else {
            numberTextField.text = number
            numberTextField.enabled = false
        }
    }
    
    func initializeLocalizeStrings() {
        titleLabel.text = StringHelper.localizedStringWithKey("VERIFY_NUMBER_LOCALIZED_KEY")
        numberLabel.text = StringHelper.localizedStringWithKey("MOBILE_LOCALIZED_KEY")
        sendCodeButton.setTitle(StringHelper.localizedStringWithKey("SEND_CODE_LOCALIZED_KEY"), forState: UIControlState.Normal)
    }
    
    @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topMarginConstraint.constant = screenHeight! / 10
        } else if IphoneType.isIphone5() {
            topMarginConstraint.constant = screenHeight! / 5
        }
    }

    func tapMainViewAction() {
        tapMainAction()
    }
    
    func tapMainAction() {
        numberTextField.resignFirstResponder()
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }

    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.closeVerifyMobileNumberInputViewController()
        } else if sender as! UIButton == sendCodeButton {
            if self.numberTextField.text == "" {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: StringHelper.localizedStringWithKey("CONTACT_REQUIRED_LOCALIZE_KEY"))
            } else {
                self.fireGetCode()
            }
        }
    }
    
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
    
    
    // MARK: - GET CODE
    
    func fireGetCode() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken()]
        showLoader()
        manager.POST(APIAtlas.verificationGetCodeUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.sendCodeAction()
            self.dismissLoader()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                self.hud?.hide(true)
        })
    }
    
    func requestRefreshToken(url: String, params: NSDictionary!) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.dismissLoader()
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.dismissLoader()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                UIAlertController.displaySomethingWentWrongError(self)
                
        })
    }
}
