//
//  ProfileSettingsViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

enum NotificationType{
    case Email
    case SMS
}

struct ProfileSettingsLocalizedStrings {
    static let smsLocalizeString = StringHelper.localizedStringWithKey("SETTINGSSMS_LOCALIZE_KEY")
    static let emailLocalizeString = StringHelper.localizedStringWithKey("SETTINGSEMAIL_LOCALIZE_KEY")
    static let deactivateLocalizeString = StringHelper.localizedStringWithKey("SETTINGSDEACTIVATE_LOCALIZE_KEY")
}

class ProfileSettingsViewController: UIViewController, DeactivateModalViewControllerDelegate {

    let profileSettingsIdentifier: String = "ProfileSettingsTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [String] = []
    var tableDataStatus: [Bool] = []
    
    var hud: YiHUD?
    
    var dimView: UIView?
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    var deactivateEmailLocalizeString: String = ""
    var deactivateEmailVerificationLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.backButton()
        self.registerNibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Initializations
    
    func initializeViews() {
        self.title = StringHelper.localizedStringWithKey("SETTINGS_LOCALIZE_KEY")
        
        deactivateEmailLocalizeString = StringHelper.localizedStringWithKey("DEACTIVATE_EMAIL_ERROR_LOCALIZED_KEY")
        deactivateEmailVerificationLocalizeString = StringHelper.localizedStringWithKey("DEACTIVATE_EMAIL_VERIFICATION_ERROR_LOCALIZED_KEY")
        
        //Add Nav Bar
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        //Initialize the 'dimView' (background of 'DeactivateModalViewController')
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
        
        //Add data to the tableView
        tableData.append(ProfileSettingsLocalizedStrings.smsLocalizeString)
        tableData.append(ProfileSettingsLocalizedStrings.emailLocalizeString)
        tableData.append(ProfileSettingsLocalizedStrings.deactivateLocalizeString)
        
        
        tableView.reloadData()
    }
    
    //Add back button to Nav Bar
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
    
    //Function to close the current viewcontroller
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //Register nibs of the table view
    func registerNibs() {
        var nib = UINib(nibName: profileSettingsIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: profileSettingsIdentifier)
    }
    
    
    //MARK: -
    //MARK: - API Request
    
    //MARK: - Fire Post Settings
    /* Function called when access_token is already expired.
    * (Parameter) type: NotificationType -- Type of notification(SMS or Email) needed to identify
    *                                        the url to be used for the API request
    *             isON: Bool -- Requested status of the choosen 'NotificationType'
    *
    * This function is for requesting of to update the current of the choosen notification.
    * (ALlow to be notified or not)
    *
    * At first it will check the 'NotificationType' to identify the url to be used for the API request.
    *
    * If the API request is unsuccessful, it will check the r'equestErrorType'  
    * and execute/do action/s  based on the error type)
    */
    func firePostSettings(type: NotificationType, isOn: Bool) {
        self.showHUD()
        
        var url: String = ""
        switch type {
        case .SMS:
            url = APIAtlas.postSMSNotif
        case .Email:
            url = APIAtlas.postEmailNotif
        }
        
        WebServiceManager.fireSetNotificationSettingsWithUrl(url, accessToken: SessionManager.accessToken(), isSubscribe: isOn) { (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            println(responseObject)
            if !successful {
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
                    self.fireRefreshToken(type, isON: isOn)
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
    
    //MARK: - Fire Refresh Token
    /* Function called when access_token is already expired.
    * (Parameter) type: NotificationType -- Type of notification(SMS or Email) needed to identify 
    *                                        the url to be used for the API request
    *             isON: Bool -- Requested status of the choosen 'NotificationType'
    *
    * This function is for requesting of access token and parse it to save in SessionManager.
    * If request is successful, it will check the requestType and redirect/call the API request
    * function based on the requestType.
    * If the request us unsuccessful, it will forcely logout the user
    */
    func fireRefreshToken(type: NotificationType, isON: Bool) {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.firePostSettings(type, isOn: isON)
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
    //Show loader
    func showHUD() {
        self.hud = YiHUD.initHud()
        self.hud?.showHUDToView(self.view)
        self.view.userInteractionEnabled = false
    }
    
    //Hide loader
    func dismissLoader() {
        self.hud?.hide()
        self.view.userInteractionEnabled = true
    }
    
    //Set attributes and open 'DeactivateModalViewController'
    func showDeactivateModal(){
        //Open 'DeactivateModalViewController' (Controller where the user input his/her password to )
        var deactivateModal = DeactivateModalViewController(nibName: "DeactivateModalViewController", bundle: nil)
        deactivateModal.delegate = self
        deactivateModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        deactivateModal.providesPresentationContextTransitionStyle = true
        deactivateModal.definesPresentationContext = true
        deactivateModal.view.backgroundColor = UIColor.clearColor()
        deactivateModal.view.frame.origin.y = 0
        self.tabBarController?.presentViewController(deactivateModal, animated: true, completion: nil)
        
        //Show 'dimView'(background of 'DeactivateModalViewController') with fade in animation
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    //Hide 'dimView'(background of 'DeactivateModalViewController') with fade out animation
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            }, completion: { finished in
                self.dimView!.hidden = true
        })
    }
}


// MARK: - Delegates and Data Source
// MARK: - Table View Delegate and Data Source
extension ProfileSettingsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(profileSettingsIdentifier, forIndexPath: indexPath) as! ProfileSettingsTableViewCell
        
        cell.delegate = self
        if indexPath.row == tableData.count {
            cell.settingsLabel.textColor = UIColor.redColor()
            cell.settingsLabel.textAlignment = NSTextAlignment.Center
            cell.settingsLabel.text = StringHelper.localizedStringWithKey("LOGOUT_LOCALIZE_KEY")
            cell.switchContraint.constant = 0
            cell.settingsSwitch.hidden = true
        } else {
            cell.settingsLabel.text = tableData[indexPath.row]
            cell.settingsSwitch.setOn(tableDataStatus[indexPath.row], animated: true)
            cell.settingsLabel?.textColor = Constants.Colors.grayText
            cell.settingsLabel?.textAlignment = NSTextAlignment.Left
            cell.switchContraint.constant = 49
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.row == tableData.count {
            SessionManager.logoutWithTarget(self)
        }
    }
}

//MARK: - ProfileSettingsTableViewCellDelegate
extension ProfileSettingsViewController: ProfileSettingsTableViewCellDelegate {
    func settingsSwitchAction(sender: AnyObject, value: Bool) {
        var pathOfTheCell: NSIndexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        if rowOfTheCell == 0 {
            self.tableDataStatus[0] = value
            self.firePostSettings(.SMS, isOn: value)
        } else if rowOfTheCell == 1 {
            self.tableDataStatus[1] = value
            self.firePostSettings(.Email, isOn: value)
        } else {
            if !SessionManager.isEmailVerified() {
                self.tableDataStatus[2] = false
                Toast.displayToastWithMessage(deactivateEmailVerificationLocalizeString, duration: 2, view: self.view)
                self.tableView.reloadData()
            } else if SessionManager.emailAddress().isEmpty {
                self.tableDataStatus[2] = false
                Toast.displayToastWithMessage(deactivateEmailLocalizeString, duration: 2, view: self.view)
                self.tableView.reloadData()
            } else {
                self.tableDataStatus[2] = value
                self.showDeactivateModal()
            }
            
        }
    }
}


//MARK: - DeactivateModalViewControllerDelegate
extension ProfileSettingsViewController: DeactivateModalViewControllerDelegate {
    func closeDeactivateModal(){
        self.tableDataStatus[2] = false
        self.hideDimView()
        self.tableView.reloadData()
    }
    
    func submitDeactivateModal(password: String){
        self.tableDataStatus[2] = false
        self.hideDimView()
        self.tableView.reloadData()
        
        SessionManager.logoutWithTarget(self)
    }
}