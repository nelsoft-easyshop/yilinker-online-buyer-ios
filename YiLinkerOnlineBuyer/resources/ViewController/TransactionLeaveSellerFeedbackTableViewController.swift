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
    
    var hud: MBProgressHUD?
    
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
    func fireSellerFeedback(feedback2: String, rateItemQuality: Int, rateCommunication: Int) {
       
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        println("\(APIManager.sharedInstance.baseURL) \(APIManager.sharedInstance)")
        
        /*  
        let jsonObject2: [String: AnyObject] = [
        "sellerId": self.sellerId,
        "ratings": ([[
        "rateType": "1",
        "rating": String(rateItemQuality)
        ], [
        "rateType": "2",
        "rating": String(rateCommunication)
        ]]),
        "title": "Seller Feedback",
        "feedback": "\(feedback)",
        "orderId": self.orderId
        ]
        
        var a: NSDictionary = jsonObject2 as NSDictionary
        let sortedKeys = (a.allKeys as! [String]).sorted(>)
        let data2 = NSJSONSerialization.dataWithJSONObject(jsonObject2, options: nil, error: nil)
        let string2: String = NSString(data: data2!, encoding: NSUTF8StringEncoding)! as! String
        let finalJsonString: String = string2.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        println(finalJsonString)
        */
        
        /*
        var dictionary: NSMutableDictionary = NSMutableDictionary()
        dictionary["rateType"] = "1"
        dictionary["rating"] = String(rateItemQuality)
        
        let data1 = NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: nil)
        var formattedRating1: String = NSString(data: data1!, encoding: NSUTF8StringEncoding) as! String

        var dictionary2: NSMutableDictionary = NSMutableDictionary()
        dictionary2["rateType"] = "2"
        dictionary2["rating"] = String(rateCommunication)
        
        let data3 = NSJSONSerialization.dataWithJSONObject(dictionary2, options: nil, error: nil)
        var formattedRating2: String = NSString(data: data3!, encoding: NSUTF8StringEncoding) as! String

        var feedback: [String] = []
        feedback.append(formattedRating1)
        feedback.append(formattedRating2)
        
        let data4 = NSJSONSerialization.dataWithJSONObject(feedback, options: nil, error: nil)
        var formattedRating3: String = NSString(data: data4!, encoding: NSUTF8StringEncoding) as! String
        
        var parameters: NSMutableDictionary = ["sellerId" : self.sellerId, "orderId" : self.orderId, "ratings" : formattedRating3, "title" : "Seller Feedback", "feedback" : "\(feedback2)", "access_token" : SessionManager.accessToken()]
        
        let jsonObject2: [String: AnyObject] = [
            "sellerId": self.sellerId,
            "ratings": formattedRating3,
            "title": "Seller Feedback",
            "feedback": "\(feedback2)",
            "orderId": self.orderId,
            "access_token" : "\(SessionManager.accessToken())"
        ]
        
        let data2 = NSJSONSerialization.dataWithJSONObject(jsonObject2, options: nil, error: nil)
        var formattedRating4: String = NSString(data: data2!, encoding: NSUTF8StringEncoding) as! String
        
        let finalJsonString: String = formattedRating4.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let finalJsonString2: String = finalJsonString.stringByReplacingOccurrencesOfString("\"{", withString: "{", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let finalJsonString3: String = finalJsonString2.stringByReplacingOccurrencesOfString("}\"", withString: "}", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let finalJsonString4: String = finalJsonString3.stringByReplacingOccurrencesOfString("\"]", withString: "]", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let finalJsonString5: String = finalJsonString4.stringByReplacingOccurrencesOfString("\"[", withString: "[", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let finalJsonString6: String = finalJsonString5.stringByReplacingOccurrencesOfString("]\"", withString: "]", options: NSStringCompareOptions.LiteralSearch, range: nil)
        */
        
        /*
        var dictionary: NSMutableDictionary = NSMutableDictionary()
        dictionary["rateType"] = "1"
        dictionary["rating"] = String(rateItemQuality)
        
        let data1 = NSJSONSerialization.dataWithJSONObject(dictionary, options: nil, error: nil)
        var formattedRating1: String = NSString(data: data1!, encoding: NSUTF8StringEncoding) as! String
        
        var dictionary2: NSMutableDictionary = NSMutableDictionary()
        dictionary2["rateType"] = "2"
        dictionary2["rating"] = String(rateCommunication)
        
        let data3 = NSJSONSerialization.dataWithJSONObject(dictionary2, options: nil, error: nil)
        var formattedRating2: String = NSString(data: data3!, encoding: NSUTF8StringEncoding) as! String
        
        var feedback: [NSDictionary] = []
        feedback.append(dictionary)
        feedback.append(dictionary2)
        
        let data4 = NSJSONSerialization.dataWithJSONObject(feedback, options: nil, error: nil)
        var formattedRating3: String = NSString(data: data4!, encoding: NSUTF8StringEncoding) as! String
        let finalJsonString: String = formattedRating3.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let finalJsonString7: String = finalJsonString.stringByReplacingOccurrencesOfString("\\\"", withString: "\"", options: NSStringCompareOptions.LiteralSearch, range: nil)
        println("---> \(finalJsonString7)")
        
        var parameters: NSMutableDictionary = ["sellerId" : self.sellerId, "orderId" : self.orderId, "ratings" : finalJsonString, "title" : "Seller Feedback", "feedback" : "feedback2", "access_token" : SessionManager.accessToken()]
        
        let data5 = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        var formattedRating5: String = NSString(data: data5!, encoding: NSUTF8StringEncoding) as! String
        let finalJsonString5: String = formattedRating5.stringByReplacingOccurrencesOfString("\"[", withString: "[", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let finalJsonString6: String = finalJsonString5.stringByReplacingOccurrencesOfString("]\"", withString: "]", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        println("\(finalJsonString7)")
        */
        
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
        println(finalJsonString3)
        
        var parameters: NSMutableDictionary = ["sellerId" : self.sellerId, "orderId" : self.orderId, "title" : "Seller Feedback", "feedback" : "feedback2", "access_token" : SessionManager.accessToken()]
        
        parameters["ratings"] = finalJsonString3.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let data4 = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        var formattedRating4: String = NSString(data: data4!, encoding: NSUTF8StringEncoding) as! String
        let finalJsonString4: String = formattedRating4.stringByReplacingOccurrencesOfString("\\", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        
        println("\(parameters) \(finalJsonString4)")
        
        manager.POST(APIAtlas.transactionLeaveSellerFeedback, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
          
            if responseObject["isSuccessful"] as! Bool {
                self.navigationController?.popViewControllerAnimated(true)
            } else {
                self.showAlert(title: "Feedback", message: responseObject["message"] as! String)
            }
            
            self.hud?.hide(true)
            self.tableView.reloadData()
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                println(error.description)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    self.tableView.reloadData()
                } else if task.statusCode == 401 {
                    self.requestRefreshToken()
                    self.tableView.reloadData()
                } else {
                    self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                    self.tableView.reloadData()
                }
                
                self.hud?.hide(true)
        })
    }
    
    //MARK: Refresh token
    func requestRefreshToken() {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
       
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.fireSellerFeedback(self.feedback, rateItemQuality: self.rate, rateCommunication: self.rateComm)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                
                self.hud?.hide(true)
        })
    }
    
    //MARK: Delegate methods
    func submitAction(feedback: String) {
        
        self.feedback = feedback
        
        if rate == 0 || rateComm == 0 {
            showAlert(title: "Rate", message: "Please select a rating.")
            self.tableView.reloadData()
        } else if feedback == "" {
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
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
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
