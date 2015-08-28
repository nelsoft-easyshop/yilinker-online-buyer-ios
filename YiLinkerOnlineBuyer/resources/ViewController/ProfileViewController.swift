//
//  ProfileViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileTableViewCellDelegate {
    let cellHeaderIdentifier: String = "ProfileHeaderTableViewCell"
    let cellContentIdentifier: String = "ProfileTableViewCell"
    
    let manager = APIManager.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!

    var profileDetails: ProfileUserDetailsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        registerNibs()
        
        requestProfileDetails(APIAtlas.profileUrl, params: NSDictionary(dictionary: ["access_token": SessionManager.accessToken()]), showLoader: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        requestProfileDetails(APIAtlas.profileUrl, params: NSDictionary(dictionary: ["access_token": SessionManager.accessToken()]), showLoader: false)
    }
    
    func initializeViews() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
        self.title = "Profile Page"
    }

    func registerNibs() {
        var nibHeader = UINib(nibName: cellHeaderIdentifier, bundle: nil)
        tableView.registerNib(nibHeader, forCellReuseIdentifier: cellHeaderIdentifier)
        
        var nibContent = UINib(nibName: cellContentIdentifier, bundle: nil)
        tableView.registerNib(nibContent, forCellReuseIdentifier: cellContentIdentifier)
    }
    
    func requestProfileDetails(url: String, params: NSDictionary!, showLoader: Bool) {
        if showLoader {
            self.showLoader()
        }
        
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken("getWishlist", url: url, params: params, showLoader: showLoader)
            } else {
                if let value: AnyObject = responseObject["data"] {
                    self.profileDetails = ProfileUserDetailsModel.parseDataWithDictionary(value as! NSDictionary)
                }
                self.tableView.reloadData()
                self.dismissLoader()
            }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.showAlert("Error", message: "Something went wrong. . .")
                self.dismissLoader()
        })
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellHeaderIdentifier, forIndexPath: indexPath) as! ProfileHeaderTableViewCell
            if profileDetails != nil {
                cell.profileImageView.sd_setImageWithURL(NSURL(string: profileDetails!.profileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
                cell.profileNameLabel.text = profileDetails?.fullName
                cell.profileAddressLabel.text = profileDetails!.address?.streetName
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellContentIdentifier, forIndexPath: indexPath) as! ProfileTableViewCell
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return 400
        }
    }
    
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }*/
    
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

    // MARK: - Profile Table View cell Delegate
    func editProfileTapAction() {
        var editViewController = EditProfileTableViewController(nibName: "EditProfileTableViewController", bundle: nil)
        editViewController.passModel(profileDetails!)
        self.navigationController?.pushViewController(editViewController, animated:true)
    }
    
    func transactionsTapAction() {
        var transactionViewController = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        if transactionViewController.respondsToSelector("edgesForExtendedLayout") {
            transactionViewController.edgesForExtendedLayout = UIRectEdge.None
        }
        self.navigationController?.pushViewController(transactionViewController, animated:true)
    }
    
    func activityLogTapAction() {
        var activityViewController = ActivityLogTableViewController(nibName: "ActivityLogTableViewController", bundle: nil)
        self.navigationController?.pushViewController(activityViewController, animated:true)
    }
    
    func myPointsTapAction(){

        var myPointsViewController = MyPointsTableViewController(nibName: "MyPointsTableViewController", bundle: nil)
        self.navigationController?.pushViewController(myPointsViewController, animated:true)
    }
    
    func settingsTapAction(){
        var settingsViewController = ProfileSettingsViewController(nibName: "ProfileSettingsViewController", bundle: nil)
        self.navigationController?.pushViewController(settingsViewController, animated:true)
    }
    
    //Loader function
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }

    func requestRefreshToken(type: String, url: String, params: NSDictionary!, showLoader: Bool) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SVProgressHUD.dismiss()
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestProfileDetails(url, params: params, showLoader: showLoader)
            } else {
                self.showAlert("Error", message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert("Something went wrong", message: "")
                
        })
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
}
