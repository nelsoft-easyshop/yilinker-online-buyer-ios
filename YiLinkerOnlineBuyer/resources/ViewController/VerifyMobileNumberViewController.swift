//
//  VerifyMobileNumberViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 9/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

enum VerifyMobileNumberRequestType {
    case GetCode
    case UpdateMobileNumber
    case VerifyCode
}

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
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeViews()
        self.initializeLocalizeStrings()
        self.getCode()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.timer.invalidate()
    }
    
    //MARK: Initialization
    //Initializes views
    func initializeViews() {
        self.mainView.layer.cornerRadius = 8
        self.verifyButton.layer.cornerRadius = 5
        self.mainViewOriginalFrame = mainView.frame
        
        // Add tap event to Sort View
        var viewType = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.tapView.addGestureRecognizer(viewType)
        
        var view = UITapGestureRecognizer(target:self, action:"tapMainAction")
        self.mainView.addGestureRecognizer(view)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        self.screenHeight = screenSize.height
        
        self.topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    //Initializes the localized string
    func initializeLocalizeStrings() {
        self.titleLabel.text = StringHelper.localizedStringWithKey("VERIFY_NUMBER_LOCALIZED_KEY")
        self.pleaseLabel.text = StringHelper.localizedStringWithKey("PLEASE_ENTER_VERIFY_NUMBER_LOCALIZED_KEY")
        self.timeLeftLabel.text = StringHelper.localizedStringWithKey("TIME_LEFT_LOCALIZED_KEY")
        self.verifyButton.setTitle(StringHelper.localizedStringWithKey("VERIFY_NUMBER_LOCALIZED_KEY"), forState: .Normal)
        self.requestButton.setTitle(StringHelper.localizedStringWithKey("REQUEST_NEW_CODE_LOCALIZED_KEY"), forState: .Normal)
    }
    
    
    //MARK: - IBAction
    @IBAction func buttonAction(sender: AnyObject) {
        if sender as! UIButton == closeButton {
            SessionManager.setMobileNumber("")
            self.setNewMobileNumber("")
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.closeVerifyMobileNumberViewController()
        } else if sender as! UIButton == verifyButton {
            self.fireVerifyVerificationCode(codeTextField.text)
        } else if sender as! UIButton == requestButton {
            self.getCode()
        }
    }
    
    @IBAction func editBegin(sender: AnyObject) {
        if IphoneType.isIphone4() {
            self.topMarginConstraint.constant = screenHeight! / 10
        } else if IphoneType.isIphone5() {
            self.topMarginConstraint.constant = screenHeight! / 5
        }
    }
    
    
    //MARK/: - Util function
    //Loader function
    
    //Start the time
    func startTimer() {
        self.seconds = 300
        self.timer.invalidate()
        self.timer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("subtractTime"), userInfo: nil, repeats: true)
    }
    
    //Decrement the time and set the values to the 'timeLabel'
    func subtractTime() {
        self.seconds--
        var secondsTemp: Int = seconds % 60
        var minutes: Int = Int(seconds / 60)
        if secondsTemp < 10 {
            self.timeLabel.text = "0\(minutes):0\(secondsTemp)"
        } else {
            self.timeLabel.text = "0\(minutes):\(secondsTemp)"
        }
        
        if(seconds == 0)  {
            self.timer.invalidate()
            self.timeLabel.text = "00:00"
            self.dismissViewControllerAnimated(true, completion: nil)
            self.delegate?.verifyMobileNumberAction(false)
        }
    }
    
    //Return the position of the view to the center when the main view(dim view) is tapped
    func tapMainAction() {
        self.codeTextField.resignFirstResponder()
        self.topMarginConstraint.constant = (screenHeight! / 2) - (mainView.frame.height / 2)
    }
    
    //Show loader
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
    
    //Hide loader
    func dismissLoader() {
        self.hud?.hide(true)
    }
    
    //Check the mobile number to identify what specific request is needed.
    func getCode() {
        if !SessionManager.isMobileVerified(){
            if SessionManager.mobileNumber().isEmpty {
                self.fireChangeMobileNumber(NSDictionary(dictionary: ["access_token" : SessionManager.accessToken(),
                    "newContactNumber": getNewMobileNumber()]))
            } else {
                if SessionManager.mobileNumber() == getNewMobileNumber() {
                    self.fireGetVerificationCode()
                } else {
                    self.fireChangeMobileNumber(NSDictionary(dictionary: [
                        "access_token" : SessionManager.accessToken(),
                        "newContactNumber": getNewMobileNumber(),
                        "oldContactNumber": SessionManager.mobileNumber()]))
                }
            }
        } else {
            if SessionManager.mobileNumber() == getNewMobileNumber() {
                self.fireGetVerificationCode()
            } else {
                self.fireChangeMobileNumber(NSDictionary(dictionary: [
                    "access_token" : SessionManager.accessToken(),
                    "newContactNumber": getNewMobileNumber(),
                    "oldContactNumber": SessionManager.mobileNumber()]))
            }
        }
    }
    
    //Set the Value of temporary new mobile number
    func setNewMobileNumber(newMobileNumber: String) {
        NSUserDefaults.standardUserDefaults().setObject(newMobileNumber, forKey: "newMobileNumber")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    //Get the Value of temporary new mobile number
    func getNewMobileNumber() -> String {
        var result: String = ""
        if let val: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("newMobileNumber") as? String {
            result = val as! String
        }
        return result
    }
    
    
    //MARK: - API Requests
    //MARK: - Fire Get Mobile Verification Code
    
    /* Function to request new verification code
     *
     * If the API request is successful, it will star the countdown timer before the code will expire.
     *
     * If the API request is unsuccessful, it will check 'requestErrorType'
     * and proceed/do some actions based on the error type
    */
    func fireGetVerificationCode() {
        self.showLoader()
        let url: String = APIAtlas.verificationGetCodeUrl
        
        WebServiceManager.fireGetMobileCode(url, accessToken: SessionManager.accessToken(), actionHandler:  { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            if successful {
                if let isSuccessful: Bool = responseObject["isSuccessful"] as? Bool {
                    if isSuccessful {
                        self.startTimer()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String)
                    }
                } else {
                    UIAlertController.displaySomethingWentWrongError(self)
                }
                
            } else {
                self.handleErrorWithType(requestErrorType, requestType: VerifyMobileNumberRequestType.GetCode, responseObject: responseObject, params: NSDictionary(), code: "")
            }
        })
    }
    
     //MARK: - Fire Change Mobile Number
    /* Function to change/update the mobile number.
    *
    * (Parameter) params: NSDictionary  --  Parameters of the request
    *
    * If the API request is successful, it will start the countdown timer before the code will expire.
    *
    * If the API request is unsuccessful, it will check 'requestErrorType'
    * and proceed/do some actions based on the error type
    */
    func fireChangeMobileNumber(params: NSDictionary) {
        self.showLoader()
        
        WebServiceManager.fireChangeMobileNumber(APIAtlas.updateMobileNumber, accessToken: SessionManager.accessToken(), parameters: params, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                if let isSuccessful: Bool = responseObject["isSuccessful"] as? Bool {
                    if isSuccessful {
                        self.startTimer()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String)
                    }
                } else {
                    UIAlertController.displaySomethingWentWrongError(self)
                }
            } else {
                self.handleErrorWithType(requestErrorType, requestType: VerifyMobileNumberRequestType.UpdateMobileNumber, responseObject: responseObject, params: params, code: "")
            }
        })
    }
    
     //MARK: - Fire Verify Code
    /* Function to verify the verification code sent to the mobile number.
    * (Parameter) code: String -- the verification code.
    *
    * If the API request is successful, it will set the values from the server to the local data('SessionManager') 
    * and call the 'verifyMobileNumberAction(true)' of the 'delegate' with 'true' parameter
    *
    * If the API request is unsuccessful, it will check 'requestErrorType'
    * and proceed/do some actions based on the error type
    */
    func fireVerifyVerificationCode(code: String) {
        self.showLoader()
        WebServiceManager.fireVerifyVerificationCode(APIAtlas.smsVerification, accessToken: SessionManager.accessToken(), code: code, actionHandler:  { (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                if let isSuccessful: Bool = responseObject["isSuccessful"] as? Bool {
                    if isSuccessful {
                        self.dismissViewControllerAnimated(true, completion: nil)
                        SessionManager.setIsMobileVerified(true)
                        SessionManager.setMobileNumber(self.getNewMobileNumber())
                        self.delegate?.verifyMobileNumberAction(true)
                        self.dismissLoader()
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String)
                        self.dismissViewControllerAnimated(true, completion: nil)
                        self.delegate?.verifyMobileNumberAction(false)
                    }
                } else {
                    UIAlertController.displaySomethingWentWrongError(self)
                }
            } else {
                self.handleErrorWithType(requestErrorType, requestType: VerifyMobileNumberRequestType.VerifyCode, responseObject: responseObject, params: NSDictionary(), code: code)
            }
        })
    }
    
    
    
    //MARK: - Handling of API Request Error
    /* Function to handle the error and proceed/do some actions based on the error type
    *
    * (Parameters) requestErrorType: RequestErrorType -- type of error being thrown by the web service. It is used to identify what specific action is needed to be execute based on the error type.
    
    *              responseObject: AnyObject -- response coming from the server. It is used to identify what specific error message is being thrown by the server
    *               requestType: VerifyMobileNumberRequestType -- the type of request so that it can identify
    *                                                           what specific request if the who called the 'fireRefreshToken' function/
    *
    * This function is for checking of 'requestErrorType' and proceed/do some actions based on the error type
    */
    func handleErrorWithType(requestErrorType: RequestErrorType, requestType: VerifyMobileNumberRequestType, responseObject: AnyObject, params: NSDictionary, code: String) {
        if requestErrorType == .ResponseError {
            //Error in api requirements
            let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
            Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
            self.delegate?.verifyMobileNumberAction(false)
        } else if requestErrorType == .AccessTokenExpired {
            self.fireRefreshToken(requestType, params: params, code: code)
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
            Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
        }
    }
    
    
    //MARK: - Fire Refresh Token
    /* Function called when access_token is already expired.
    * (Parameter) requestType: VerifyMobileNumberRequestType -- the type of request so that it can identify
    *                                                           what specific request if the who called the 'fireRefreshToken' function/
    *             params: NSDictionary  --  Parameters of the request
    *             code: String -- the verification code.
    *
    * This function is for requesting of access token and parse it to save in SessionManager.
    * If request is successful, it will check the requestType and redirect/call the API request
    * function based on the requestType.
    * If the request us unsuccessful, it will forcely logout the user
    */
    func fireRefreshToken(requestType: VerifyMobileNumberRequestType, params: NSDictionary, code: String) {
        self.showLoader()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                switch requestType {
                case .GetCode:
                    self.fireGetVerificationCode()
                case .UpdateMobileNumber:
                    var paramsTemp: Dictionary<String, String> = params as! Dictionary<String, String>
                    paramsTemp["access_token"] = SessionManager.accessToken()
                    self.fireChangeMobileNumber(paramsTemp)
                case .VerifyCode:
                    self.fireVerifyVerificationCode(code)
                }
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logoutWithTarget(self)
                })
            }
        })
    }
    
}
