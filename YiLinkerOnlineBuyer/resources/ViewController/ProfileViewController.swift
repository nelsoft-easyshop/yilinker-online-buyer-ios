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

    var profileDetails: ProfileUserDetailsModel!
    
    var hud: MBProgressHUD?
    
    var errorLocalizeString: String  = ""
    
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
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
    }
    
    func initializeViews() {
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
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
                UIAlertController.displaySomethingWentWrongError(self)
                self.dismissLoader()
        })
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellHeaderIdentifier, forIndexPath: indexPath) as! ProfileHeaderTableViewCell
            if profileDetails != nil {
                cell.profileImageView.sd_setImageWithURL(NSURL(string: profileDetails!.profileImageUrl), placeholderImage: UIImage(named: "dummy-placeholder"))
                cell.profileNameLabel.text = profileDetails?.fullName
                cell.profileAddressLabel.text = profileDetails!.address.fullLocation
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(cellContentIdentifier, forIndexPath: indexPath) as! ProfileTableViewCell
            if profileDetails != nil {
                cell.followingValueLabel.text = "\(profileDetails!.followingCount)"
                cell.transactionsValueLabel.text = "\(profileDetails!.transactionCount)"
            }
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 200
        } else {
            return 375
        }
    }
    
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
    
    func resolutionTapAction() {
        let storyboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        let resolutionCenter = storyboard.instantiateViewControllerWithIdentifier("ResolutionCenterViewController")
            as! ResolutionCenterViewController
        resolutionCenter.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(resolutionCenter, animated:true)
        
    }
    
    func settingsTapAction(){
        var settingsViewController = ProfileSettingsViewController(nibName: "ProfileSettingsViewController", bundle: nil)
        settingsViewController.tableDataStatus.removeAll(keepCapacity: false)
        settingsViewController.tableDataStatus.append(profileDetails.isSmsSubscribed)
        settingsViewController.tableDataStatus.append(profileDetails.isEmailSubscribed)
        settingsViewController.tableDataStatus.append(false)
        self.navigationController?.pushViewController(settingsViewController, animated:true)
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

    func requestRefreshToken(type: String, url: String, params: NSDictionary!, showLoader: Bool) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestProfileDetails(url, params: params, showLoader: showLoader)
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String, title: Constants.Localized.error)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                UIAlertController.displaySomethingWentWrongError(self)
                
        })
    }
}
