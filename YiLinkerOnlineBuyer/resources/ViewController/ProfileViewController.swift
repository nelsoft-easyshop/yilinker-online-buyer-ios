//
//  ProfileViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileTableViewCellDelegate {
    
    //Cell Unique Identifier
    let cellHeaderIdentifier: String = "ProfileHeaderTableViewCell"
    let cellContentIdentifier: String = "ProfileTableViewCell"
    
    let manager = APIManager.sharedInstance
    
    @IBOutlet weak var tableView: UITableView!
    var hud: MBProgressHUD?
    
    var profileDetails: ProfileUserDetailsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
        registerNibs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.fireGetUserInfo()
    }
    
    
    //MARK: - Initializations
    func initializeViews() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    //Register nibs of the table view
    func registerNibs() {
        var nibHeader = UINib(nibName: cellHeaderIdentifier, bundle: nil)
        tableView.registerNib(nibHeader, forCellReuseIdentifier: cellHeaderIdentifier)
        
        var nibContent = UINib(nibName: cellContentIdentifier, bundle: nil)
        tableView.registerNib(nibContent, forCellReuseIdentifier: cellContentIdentifier)
    }
    
    
    //MARK: - API Requests
    //MARK: - Fire Get User Info
    /* Function to request get user information data.
    *
    * It will check first if the 'profileDetails'(Object for User Details) is equal to nil,
    * if it is equal to nil, it will show the loader(HUD), if it is not equal to nil,
    * it will show the network activity indicator in the status bar. Then call the API request.
    *
    * If the API request is successful, it will convert the 'responseObject' to NSDictionary,
    * parse the 'data' object in the dictionary and set the values in the 'SessionManager'
    *
    * If the API request is unsuccessful, it will check 'requestErrorType'
    * and proceed/do some actions based on the error type
    */
    func fireGetUserInfo() {
        //Check the 'profileDetails' to identify what loader indicator will be shown
        if self.profileDetails == nil {
            self.tableView.hidden = true
            self.showHUD()
        } else {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        }
        
        WebServiceManager.fireGetUserInfoWithUrl(APIAtlas.getUserInfoUrl, accessToken: SessionManager.accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            if successful {
                if  let dictionary: NSDictionary = responseObject as? NSDictionary {
                    if let value: AnyObject = dictionary["data"] {
                        self.profileDetails = ProfileUserDetailsModel.parseDataWithDictionary(value)
                        //Insert Data to Session Manager
                        SessionManager.setFullAddress(self.profileDetails.address.fullLocation)
                        SessionManager.setUserFullName(self.profileDetails.fullName)
                        SessionManager.setAddressId(self.profileDetails.address.userAddressId)
                        SessionManager.setCartCount(self.profileDetails.cartCount)
                        SessionManager.setWishlistCount(self.profileDetails.wishlistCount)
                        SessionManager.setProfileImage(self.profileDetails.profileImageUrl)
                        
                        SessionManager.setCity(self.profileDetails.address.city)
                        SessionManager.setProvince(self.profileDetails.address.province)
                        
                        SessionManager.setLang(self.profileDetails.address.latitude)
                        SessionManager.setLong(self.profileDetails.address.longitude)
                        
                        self.tableView.hidden = false
                        self.tableView.reloadData()
                        self.dismissLoader()
                    }
                }
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    
                    if errorModel.message == "The access token provided is invalid." {
                        UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                        })
                    } else {
                        Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                    }
                    
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
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
        }
    }
    
    //MARK: -
    //MARK: - Fire Refresh Token
    func fireRefreshToken() {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireGetUserInfo()
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logoutWithTarget(self)
                })
            }
        })
    }
    
    //MARK: -
    //MARK: - Util Functions
    
    //Show Loader
    func showHUD() {
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
    
    //Hide Loader
    func dismissLoader() {
        self.hud?.hide(true)
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
}

// MARK: - Delegates and Data Source
// MARK: - Table View Delegate and Data Source
extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        //Check what row of the table to set the correct tableview cell
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
}

//MARK: - Profile Table View cell Delegate
extension ProfileViewController: ProfileTableViewCellDelegate {
    //Redirect to Edit Profile View Controller
    func editProfileTapAction() {
        var editViewController = EditProfileTableViewController(nibName: "EditProfileTableViewController", bundle: nil)
        editViewController.passModel(profileDetails!)
        self.navigationController?.pushViewController(editViewController, animated:true)
    }
    
    //Redirect to Transaction View Controller
    func transactionsTapAction() {
        var transactionViewController = TransactionViewController(nibName: "TransactionViewController", bundle: nil)
        //Prevent overlapping of tab bar and
        if transactionViewController.respondsToSelector("edgesForExtendedLayout") {
            transactionViewController.edgesForExtendedLayout = UIRectEdge.None
        }
        self.navigationController?.pushViewController(transactionViewController, animated:true)
    }
    
    //Redirect to Activity Logs Controller
    func activityLogTapAction() {
        var activityViewController = ActivityLogTableViewController(nibName: "ActivityLogTableViewController", bundle: nil)
        self.navigationController?.pushViewController(activityViewController, animated:true)
    }
    
    //Redirect to My Points Controller
    func myPointsTapAction(){
        var myPointsViewController = MyPointsTableViewController(nibName: "MyPointsTableViewController", bundle: nil)
        self.navigationController?.pushViewController(myPointsViewController, animated:true)
    }
    
    //Redirect to Resolution Center Controller
    func resolutionTapAction() {
        let storyboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        let resolutionCenter = storyboard.instantiateViewControllerWithIdentifier("ResolutionCenterViewController")
            as! ResolutionCenterViewController
        resolutionCenter.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(resolutionCenter, animated:true)
    }
    
    //Redirect to Settings Controller
    func settingsTapAction(){
        var settingsViewController = ProfileSettingsViewController(nibName: "ProfileSettingsViewController", bundle: nil)
        //Set status of SMS and Email Notification
        settingsViewController.tableDataStatus.removeAll(keepCapacity: false)
        settingsViewController.tableDataStatus.append(profileDetails.isSmsSubscribed)
        settingsViewController.tableDataStatus.append(profileDetails.isEmailSubscribed)
        settingsViewController.tableDataStatus.append(false)
        self.navigationController?.pushViewController(settingsViewController, animated:true)
    }
}
