//
//  ProfileSettingsViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProfileSettingsTableViewCellDelegate, DeactivateModalViewControllerDelegate {

    let profileSettingsIdentifier: String = "ProfileSettingsTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!
    
    var tableData: [String] = []
    var tableDataStatus: [Bool] = []
    
    var hud: MBProgressHUD?
    
    var dimView: UIView?
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        initializeLocalizedString()
        titleView()
        backButton()
        registerNibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        //Add Nav Bar
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        tableView.tableFooterView = UIView(frame: CGRectZero)
        
        dimView = UIView(frame: self.view.bounds)
        dimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(dimView!)
        //self.view.addSubview(dimView!)
        dimView?.hidden = true
        dimView?.alpha = 0
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")
        
        let smsLocalizeString = StringHelper.localizedStringWithKey("SETTINGSSMS_LOCALIZE_KEY")
        let emailLocalizeString = StringHelper.localizedStringWithKey("SETTINGSEMAIL_LOCALIZE_KEY")
        let deactivateLocalizeString = StringHelper.localizedStringWithKey("SETTINGSDEACTIVATE_LOCALIZE_KEY")
        
        tableData.append(smsLocalizeString)
        tableData.append(emailLocalizeString)
        tableData.append(deactivateLocalizeString)
        
        tableView.reloadData()
    }
    
    func titleView() {
        self.title = StringHelper.localizedStringWithKey("SETTINGS_LOCALIZE_KEY")
    }
    
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
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func registerNibs() {
        var nib = UINib(nibName: profileSettingsIdentifier, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: profileSettingsIdentifier)
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(profileSettingsIdentifier, forIndexPath: indexPath) as! ProfileSettingsTableViewCell
        
        cell.delegate = self
        cell.settingsLabel.text = tableData[indexPath.row]
        cell.settingsSwitch.setOn(tableDataStatus[indexPath.row], animated: true)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    // MARK: - ProfileSettingsTableViewCellDelegate
    func settingsSwitchAction(sender: AnyObject, value: Bool) {
        var pathOfTheCell: NSIndexPath = tableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        if rowOfTheCell == 0 {
            tableDataStatus[0] = value
            firePostSettings("email", isOn: value)
        } else if rowOfTheCell == 1 {
            tableDataStatus[1] = value
            firePostSettings("sms", isOn: value)
        } else {
            tableDataStatus[2] = value
            showDeactivateModal()
        }
    }
    
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
    
    
    
    func firePostSettings(type: String, isOn: Bool) {
        showHUD()
        let manager = APIManager.sharedInstance
        var parameters: NSDictionary
        var url: String = ""
        
        if type == "email" {
            url = APIAtlas.postEmailNotif
        } else if type == "sms" {
            url = APIAtlas.postSMSNotif
        }
        url = "\(url)?access_token=\(SessionManager.accessToken())&isSubscribe=\(isOn)"
        
        manager.POST(url, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            println("RESPONSE \(responseObject)")
            self.hud?.hide(true)
            
            if let tempDict = responseObject as? NSDictionary {
                let tempVar = tempDict["isSuccessful"] as! Bool
                if !(tempVar){
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: tempDict["message"] as! String, title: self.errorLocalizeString)
                } else {
                    let notifLocalizeString = StringHelper.localizedStringWithKey("NOTIFICATION_LOCALIZE_KEY")
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: tempDict["message"] as! String, title: notifLocalizeString)
                }
            }
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken(type, isON: isOn)
                } else {
                    if Reachability.isConnectedToNetwork() {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.somethingWrongLocalizeString, title: self.errorLocalizeString)
                    } else {
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.connectionMessageLocalizeString, title: self.errorLocalizeString)
                    }
                    println(error)
                }
        })
    }
    
    func fireRefreshToken(type: String, isON: Bool) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.firePostSettings(type, isOn: isON)
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
    
    //Method for
    func handleIOS8(){
        let deactivateAccountLocalizeString = StringHelper.localizedStringWithKey("DEACTIVATEACCOUNT_LOCALIZE_KEY")
        let deactivateLocalizeString = StringHelper.localizedStringWithKey("DEACTIVATE_LOCALIZE_KEY")
        let cancelLocalizeString = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
        
        let alert = UIAlertController(title: deactivateAccountLocalizeString, message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let libButton = UIAlertAction(title: deactivateLocalizeString, style: UIAlertActionStyle.Destructive) { (alert) -> Void in
            self.showDeactivateModal()
        }
        
        let cancelButton = UIAlertAction(title: cancelLocalizeString, style: UIAlertActionStyle.Cancel) { (alert) -> Void in
            println("Cancel Pressed")
        }
        
        alert.addAction(libButton)
        alert.addAction(cancelButton)
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func controllerAvailable() -> Bool {
        if let gotModernAlert: AnyClass = NSClassFromString("UIAlertController") {
            return true;
        }
        else {
            return false;
        }
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        println("Title : \(actionSheet.buttonTitleAtIndex(buttonIndex))")
        println("Button Index : \(buttonIndex)")
        
        if buttonIndex == 0 {
            self.showDeactivateModal()
        } else if buttonIndex == 1 {
        } else {
            
        }
    }
    
    func showDeactivateModal(){
        var deactivateModal = DeactivateModalViewController(nibName: "DeactivateModalViewController", bundle: nil)
        deactivateModal.delegate = self
        deactivateModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        deactivateModal.providesPresentationContextTransitionStyle = true
        deactivateModal.definesPresentationContext = true
        deactivateModal.view.backgroundColor = UIColor.clearColor()
        deactivateModal.view.frame.origin.y = 0
        self.tabBarController?.presentViewController(deactivateModal, animated: true, completion: nil)
        
        self.dimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 1
            }, completion: { finished in
        })
    }
    
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0
            }, completion: { finished in
                self.dimView!.hidden = true
        })
    }
    // MARK : DeactivateModalViewControllerDelegate
    func closeDeactivateModal(){
        tableDataStatus[2] = false
        hideDimView()
        tableView.reloadData()
    }

    
    func submitDeactivateModal(password: String){
        tableDataStatus[2] = false
        hideDimView()
        tableView.reloadData()
        
        SessionManager.logout()
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToHomeView()
    }
}
