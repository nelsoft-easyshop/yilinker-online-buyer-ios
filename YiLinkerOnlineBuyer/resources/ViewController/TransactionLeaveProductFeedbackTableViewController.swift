//
//  TransactionLeaveProductFeedbackTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 12/14/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionLeaveProductFeedbackTableViewController: UITableViewController, TransactionLeaveFeedbackFieldTableViewCellDelegate, TransactionLeaveProductFeedbackRateTableViewCellDelegate {
    
    var feedbackTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_TITLE_LOCALIZE_KEY")
    
    var sellerId = 0
    var productId: Int = 0
    var orderProductId: Int = 0
    var rate: Int = 0
    var feedback: String = ""
    
    var hud: MBProgressHUD?
    var yiHud: YiHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let rateNib: UINib = UINib(nibName: "TransactionLeaveProductFeedbackRateTableViewCell", bundle: nil)
        self.tableView.registerNib(rateNib, forCellReuseIdentifier: "TransactionLeaveProductFeedbackRateTableViewCell")
        
        let feedbackNib: UINib = UINib(nibName: "TransactionLeaveFeedbackFieldTableViewCell", bundle: nil)
        self.tableView.registerNib(feedbackNib, forCellReuseIdentifier: "TransactionLeaveFeedbackFieldTableViewCell")
        
        //Customize navigation bar
        self.backButton()
        //Set title of navigation bar
        self.title = feedbackTitle
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }
    
    /* override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
    
    }
    */
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let rateCell: TransactionLeaveProductFeedbackRateTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionLeaveProductFeedbackRateTableViewCell") as! TransactionLeaveProductFeedbackRateTableViewCell
            rateCell.delegate = self
            return rateCell
        } else {
            let feedbackCell: TransactionLeaveFeedbackFieldTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionLeaveFeedbackFieldTableViewCell") as! TransactionLeaveFeedbackFieldTableViewCell
            feedbackCell.delegate = self
            return feedbackCell
        }
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 232
        } else {
            return 50
        }
        
    }
    
    //MARK: Customize navigation bar
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
    
    //MARK: Add seller feedback
    func fireSellerFeedback(feedback2: String, rate: Int) {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        var parameters: NSMutableDictionary = ["productId" : self.productId, "orderProductId" : self.orderProductId, "title" : "Product Feedback", "review" : feedback2, "access_token" : SessionManager.accessToken(), "rating" : "\(rate)"]
        
        manager.POST(APIAtlas.transactionLeaveProductFeedback, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject["isSuccessful"] as! Bool {
                Feedback.setProductFeedback = true
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                self.showAlert(title: "Feedback", message: responseObject["message"] as! String)
            }
            
            self.yiHud?.hide()
            self.tableView.reloadData()
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                println(error.description)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken()
                    self.tableView.reloadData()
                } else {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    //let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    println(dictionary)
                    var errors: String = ""
                    if let value: AnyObject = dictionary["data"] {
                        
                        if let values = dictionary["data"] as? NSArray {
                            errors = values[0] as! String
                        } else {
                            if let val = value["message"] as? String {
                                errors = val
                            } else if let val = value["error"] as? String {
                                errors = val
                            } else {
                                errors = "User already reviewed this product."
                            }
                        }
                        
                        /*
                        if let val = value["message"] as? String {
                            errors = val
                        } else if let val = value["error"] as? String {
                            errors = val
                        } else {
                            errors = "User already reviewed this product."
                        }
                        */
                    }
                    
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errors, title: Constants.Localized.error)
                    self.tableView.reloadData()
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
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            self.fireSellerFeedback(self.feedback, rate: self.rate)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                
                self.yiHud?.hide()
        })
    }
    
    //MARK: Delegate methods
    func submitAction(feedback: String) {
        
        self.feedback = feedback
        
        /*if rate == 0 || rateComm == 0 {
        //showAlert(title: "Rate", message: "Please select a rating.")
        self.tableView.reloadData()
        } else*/
        if feedback == "" {
            showAlert(title: "Feedback", message: "Please send a feedback.")
            self.tableView.reloadData()
        } else {
            self.fireSellerFeedback(feedback, rate: self.rate)
            //self.tableView.reloadData()
        }
    }
    
    func rate(rate: Int) {
        self.rate = rate
    }
    
    //MARK: Show HUD
    func showHUD() {
        self.yiHud = YiHUD.initHud()
        self.yiHud!.showHUDToView(self.view)
    }
    
    //MARK: Show alert dialog box
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: Alert view
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in
            self.navigationController?.popToRootViewControllerAnimated(true)
            //alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}
