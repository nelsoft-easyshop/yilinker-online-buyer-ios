//
//  TransactionLeaveSellerFeedbackTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionLeaveSellerFeedbackTableViewController: UITableViewController, TransactionLeaveFeedbackFieldTableViewCellDelegate, TransactionLeaveFeedbackRateTableViewCellDelegate {
    
    var feedbackTitle = StringHelper.localizedStringWithKey("TRANSACTION_LEAVE_FEEDBACK_TITLE_LOCALIZE_KEY")
    
    var sellerId = 0
    var orderId: Int = 0
    var rate: Int = 0
    var rateComm: Int = 0
    var feedback: String = ""

    var yiHud: YiHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let rateNib: UINib = UINib(nibName: "TransactionLeaveFeedbackRateTableViewCell", bundle: nil)
        self.tableView.registerNib(rateNib, forCellReuseIdentifier: "TransactionLeaveFeedbackRateTableViewCell")
        
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
            let rateCell: TransactionLeaveFeedbackRateTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionLeaveFeedbackRateTableViewCell") as! TransactionLeaveFeedbackRateTableViewCell
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
            return 280
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
    func fireSellerFeedback(feedback: String, rateItemQuality: Int, rateCommunication: Int) {
       
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        
        var rating1: NSDictionary = ["rateType" : "1", "rating" : String(rateItemQuality)]
        var rating2: NSDictionary = ["rateType" : "2", "rating" : String(rateCommunication)]
        
        let data1 = NSJSONSerialization.dataWithJSONObject(rating1, options: nil, error: nil)
        var formattedRating1: String = NSString(data: data1!, encoding: NSUTF8StringEncoding) as! String
        
        let data2 = NSJSONSerialization.dataWithJSONObject(rating2, options: nil, error: nil)
        var formattedRating2: String = NSString(data: data2!, encoding: NSUTF8StringEncoding) as! String
        
        var ratings: [NSDictionary] = []
        ratings.append(rating1)
        ratings.append(rating2)
        
        let data3 = NSJSONSerialization.dataWithJSONObject(ratings, options: nil, error: nil)
        var formattedRating3: String = NSString(data: data3!, encoding: NSUTF8StringEncoding) as! String
        
        let finalJsonString: String = formattedRating3.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let finalJsonString2: String = finalJsonString.stringByReplacingOccurrencesOfString("\"{", withString: "{", options: NSStringCompareOptions.LiteralSearch, range: nil)

        let finalJsonString3: String = finalJsonString2.stringByReplacingOccurrencesOfString("}\"", withString: "}", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        var parameters: NSMutableDictionary = ["sellerId" : self.sellerId, "orderId" : self.orderId, "title" : "Seller Feedback", "feedback" : feedback, "access_token" : SessionManager.accessToken()]
        
        parameters["ratings"] = finalJsonString3.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        let data4 = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        
        var formattedRating4: String = NSString(data: data4!, encoding: NSUTF8StringEncoding) as! String
       
        let finalJsonString4: String = formattedRating4.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        WebServiceManager.fireSellerFeedbackWithUrl(APIAtlas.transactionLeaveSellerFeedback, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if responseObject["isSuccessful"] as! Bool {
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    self.showAlert(title: "Feedback", message: responseObject["message"] as! String)
                }
                
                self.yiHud?.hide()
                self.tableView.reloadData()
            } else {
                self.yiHud?.hide()
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken()
                    self.tableView.reloadData()
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
        })
    }
    
    //MARK: Refresh token
    func requestRefreshToken() {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireSellerFeedback(self.feedback, rateItemQuality: self.rate, rateCommunication: self.rateComm)
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    
                })
            }
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
            self.fireSellerFeedback(feedback, rateItemQuality: self.rate, rateCommunication: self.rateComm)
            self.tableView.reloadData()
        }
    }
    
    func rateCommunication(rate: Int) {
        self.rateComm = rate
    }
    
    func rateItemQuality(rate: Int) {
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
