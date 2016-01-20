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
    var hud: MBProgressHUD?

    var profileDetails: ProfileUserDetailsModel!
    var errorLocalizeString: String  = ""
    
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
    
    
    //MARK: - API Requests
    //MARK: - Fire Get User Info
    func fireGetUserInfo() {
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
                    //self.logout()
                })
            }
        })
    }
    
    //MARK: - Util Functions
    //Loader function
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
}
