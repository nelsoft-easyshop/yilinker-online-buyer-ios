//
//  VerifyMobileNumberViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 9/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol VerifyMobileNumberViewControllerDelegate {
    func closeVerifyMobileNumberViewController()
    func verifyMobileNumberAction(isSuccessful: Bool)
    func requestNewCodeAction()
}

class VerifyMobileNumberViewController: UIViewController {
    
    let manager = APIManager.sharedInstance
    
    var delegate: VerifyMobileNumberViewControllerDelegate?
    
    @IBOutlet weak var topMarginConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var tapView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var pleaseLabel: UILabel!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var requestButton: UIButton!
    
    var mainViewOriginalFrame: CGRect?
    
    var screenHeight: CGFloat?
    
    var seconds: Int = 300
    var timer = NSTimer()
    
    var hud: MBProgressHUD?

    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        initializeLocalizeStrings()
        fireGetCode()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func startTimer() {
        seconds = 300
        timer.invalidate()
        timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }

    func initializeViews() {
        mainView.layer.cornerRadius = 8
        verifyButton.layer.cornerRadius = 5
        mainViewOriginalFrame = mainView.frame
        
        // Add tap event to Sort View
        var viewType = UITapGestureRecognizer(target:self, action:"tapMainViewAction")
        self.tapView.addGestureRecognizer(viewType)
        
        var view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        screenHeight = screenSize.height
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    func initializeLocalizeStrings() {
        titleLabel.text = StringHelper.localizedStringWithKey("VERIFY_NUMBER_LOCALIZED_KEY")
        pleaseLabel.text = StringHelper.localizedStringWithKey("PLEASE_ENTER_VERIFY_NUMBER_LOCALIZED_KEY")
        timeLeftLabel.text = StringHelper.localizedStringWithKey("TIME_LEFT_LOCALIZED_KEY")
        verifyButton.setTitle(StringHelper.localizedStringWithKey("VERIFY_NUMBER_LOCALIZED_KEY"), forState: .Normal)
        requestButton.setTitle(StringHelper.localizedStringWithKey("REQUEST_NEW_CODE_LOCALIZED_KEY"), forState: .Normal)
    }
    
    @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            topMarginConstraint.constant = screenHeight! / 10
        } else if IphoneType.isIphone5() {
            topMarginConstraint.constant = screenHeight! / 5
        }
    }
    
    func subtractTime() {
        seconds--
        var secondsTemp: Int = seconds % 60
        var minutes: Int = Int(seconds / 60)
        if secondsTemp < 10 {
            timeLabel.text = "0\(minutes):0\(secondsTemp)"
        } else {
            timeLabel.text = "0\(minutes):\(secondsTemp)"
        }
        
        if(seconds == 0)  {
            timer.invalidate()
            timeLabel.text = "00:00"
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.verifyMobileNumberAction(false)
        }
    }
    
    func tapMainViewAction() {
        tapMainAction()
    }
    
    func tapMainAction() {
        codeTextField.resignFirstResponder()
        
        topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            self.dismissViewControllerAnimated(true, completion: nil)
            delegate?.closeVerifyMobileNumberViewController()
        } else if sender as! UIButton == verifyButton {
            fireVerify(APIAtlas.smsVerification, params: NSDictionary(dictionary: [
                "access_token": SessionManager.accessToken(),
                "code": codeTextField.text]))
        } else if sender as! UIButton == requestButton {
            self.fireGetCode()
        }
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
            if responseObject["isSuccessful"] as! Bool {
                self.startTimer()
                self.dismissLoader()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String)
                self.dismissLoader()
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                self.hud?.hide(true)
        })
    }

    
    func fireVerify(url: String, params: NSDictionary!) {
        showLoader()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken(url, params: params)
            } else {
                if responseObject["isSuccessful"] as! Bool {
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.verifyMobileNumberAction(true)
                    self.dismissLoader()
                } else {
                    self.dismissLoader()
                    self.dismissViewControllerAnimated(true, completion: nil)
                    self.delegate?.verifyMobileNumberAction(false)
                }
            }
            println(responseObject)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if Reachability.isConnectedToNetwork() {
                    if error.userInfo != nil {
                        if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                            let errorDescription: String = jsonResult["message"] as! String
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorDescription)
                        }
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                    }
                    self.dismissLoader()
                } else {
                    UIAlertController.displaySomethingWentWrongError(self)
                }
                
                println(error)
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
                self.fireVerify(url, params: params)
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
