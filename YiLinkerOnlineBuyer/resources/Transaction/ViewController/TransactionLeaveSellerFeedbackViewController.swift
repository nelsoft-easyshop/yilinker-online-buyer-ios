//
//  TransactionLeaveSellerFeedbackViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionLeaveSellerFeedbackViewController: UIViewController {

    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    @IBOutlet weak var starComm1Button: UIButton!
    @IBOutlet weak var starComm2Button: UIButton!
    @IBOutlet weak var starComm3Button: UIButton!
    @IBOutlet weak var starComm4Button: UIButton!
    @IBOutlet weak var starComm5Button: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var itemQualityLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var rateThisLabel: UILabel!
    
    @IBOutlet weak var typingAreaView: UIView!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    
    var rateButtons: [UIButton] = []
    var rateCommButtons: [UIButton] = []
    var rate: Int = 0
    var rateComm: Int = 0
    var sellerId = 0
    var orderId: Int = 0
    
    var feedbackTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_TITLE_LOCALIZE_KEY")
    var titleLabelTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_INFO_LOCALIZE_KEY")
    var itemQualityTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_QUALITY_LOCALIZE_KEY")
    var communicationTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_COMMUNICATION_LOCALIZE_KEY")
    var typeFeedback = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_TYPE_LOCALIZE_KEY")
    var sendTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_SEND_LOCALIZE_KEY")
    
    var yiHud: YiHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        rateButtons = [star1Button, star2Button, star3Button, star4Button, star5Button]
        rateCommButtons = [starComm1Button, starComm2Button, starComm3Button, starComm4Button, starComm5Button]
        
        self.inputTextField.placeholder = typeFeedback
        self.itemQualityLabel.text = itemQualityTitle
        self.rateThisLabel.text = communicationTitle
        self.sendButton.setTitle(sendTitle, forState: UIControlState.Normal)
        
        self.typingAreaView.layer.borderWidth = 1.0
        self.typingAreaView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.inputTextField.becomeFirstResponder()
        
        //Set navigation bar title
        self.title = feedbackTitle
        //Customize navigation bar
        self.backButton()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Actions
    
    @IBAction func rate1Action(sender: AnyObject) {
        updateRate(1)
    }
    
    @IBAction func rate2Action(sender: AnyObject) {
        updateRate(2)
    }
    
    @IBAction func rate3Action(sender: AnyObject) {
        updateRate(3)
    }
    
    @IBAction func rate4Action(sender: AnyObject) {
        updateRate(4)
    }
    
    @IBAction func rate5Action(sender: AnyObject) {
        updateRate(5)
    }
    
    @IBAction func rateComm1Action(sender: AnyObject) {
        updateCommRate(1)
    }
    
    @IBAction func rateComm2Action(sender: AnyObject) {
        updateCommRate(2)
    }
    
    @IBAction func rateComm3Action(sender: AnyObject) {
        updateCommRate(3)
    }
    
    @IBAction func rateComm4Action(sender: AnyObject) {
        updateCommRate(4)
    }
    
    @IBAction func rateComm5Action(sender: AnyObject) {
        updateCommRate(5)
    }

    
    @IBAction func sendAction(sender: AnyObject) {
        if rate == 0 {
            showAlert("Rate", message: "Please select a rating.")
            
        } else if self.inputTextField.text == "" {
            showAlert("Feedback", message: "Please send a feedback.")
        } else {
            self.fireSellerFeedback()
            //            showAlert(String(rate), message: self.inputTextField.text)
        }
    }
    
    //MARK: Navigation bar
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
    
    //MARK: Back button action
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // MARK: - Methods
    //MARK: Show alert dialog box
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func updateRate(index: Int) {
        self.rate = index
        
        for i in 0..<5 {
            
            if i < index {
                self.rateButtons[i].setImage(UIImage(named: "rating2"), forState: .Normal)
            } else {
                self.rateButtons[i].setImage(UIImage(named: "rating"), forState: .Normal)
            }
            
            self.rateButtons[i].frame.size = CGSize(width: 35, height: 30)
        }
        
    }
    
    func updateCommRate(index: Int) {
        self.rateComm = index
        
        for i in 0..<5 {
            
            if i < index {
                self.rateCommButtons[i].setImage(UIImage(named: "rating2"), forState: .Normal)
            } else {
                self.rateCommButtons[i].setImage(UIImage(named: "rating"), forState: .Normal)
            }

            self.rateCommButtons[i].frame.size = CGSize(width: 35, height: 30)
        }
    }
    
    //MARK: Add seller feedback
    func fireSellerFeedback() {
        
        self.showHUD()
        
        let jsonObject2: [String: AnyObject] = [
            "sellerId": String(self.sellerId),
            "orderId": String(self.orderId),
            "title": "Seller Feedback",
            "feedback": "\(self.inputTextField.text)",
            "ratings": [[
                "rateType": "1",
                "rating": String(self.rate)
                ], [
                    "rateType": "2",
                    "rating": String(self.rateComm)
                ]]
        ]
        
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.transactionLeaveSellerFeedback+"\(SessionManager.accessToken())", parameters: jsonObject2 as NSDictionary, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject["isSuccessful"] as! Bool {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                self.showAlert(title: "Feedback", message: responseObject["message"] as! String)
            }
            
            self.yiHud?.hide()
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                } else if task.statusCode == 401 {
                    self.requestRefreshToken()
                } else {
                   self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                }
                
                self.yiHud?.hide()
        })
    }
    
    //MARK: Refresh token
    func requestRefreshToken() {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID(),
        "client_secret": Constants.Credentials.clientSecret(),
        "grant_type": Constants.Credentials.grantRefreshToken,
        "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
          
            self.fireSellerFeedback()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.yiHud?.hide()
                self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
        })
    }
    
    //MARK: Show alert dialog box
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Show HUD
    func showHUD() {
       self.yiHud = YiHUD.initHud()
       self.yiHud!.showHUDToView(self.view)
    }

}
