//
//  EditProfileViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/16/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDataSource {
    
    let manager = APIManager.sharedInstance
    
    let addPhotoIdentifier: String = "ProfileAddPhotoTableViewCell"
    let personalIdentifier: String = "ProfilePersonalTableViewCell"
    let addressIdentifier: String = "ProfileAddressTableViewCell"
    let accountInformationIdentifier: String = "ProfileAccountInformationTableViewCell"
    let accountSettingsIdentifier: String = "ProfileAccountSettingsTableViewCell"
    
    @IBOutlet weak var tableView: UITableView!

    var tableData: [String] = ["photo", "personal", "shipping", "account information", "account settings"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        registerCells()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        tableView.tableFooterView = UIView()
    }
    
    func getUserInfo() {
        showLoader()
    }
    
    func initializeKeyboardObserver() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)

    }
    
    func registerCells() {
        var nibPhoto = UINib(nibName: addPhotoIdentifier, bundle: nil)
        tableView.registerNib(nibPhoto, forCellReuseIdentifier: addPhotoIdentifier)
        
        var nibPersonal = UINib(nibName: personalIdentifier, bundle: nil)
        tableView.registerNib(nibPersonal, forCellReuseIdentifier: personalIdentifier)
        
        var nibAddress = UINib(nibName: addressIdentifier, bundle: nil)
        tableView.registerNib(nibAddress, forCellReuseIdentifier: addressIdentifier)
        
        var nibAccountInformation = UINib(nibName: accountInformationIdentifier, bundle: nil)
        tableView.registerNib(nibAccountInformation, forCellReuseIdentifier: accountInformationIdentifier)
        
        var nibAccountSettings = UINib(nibName: accountSettingsIdentifier, bundle: nil)
        tableView.registerNib(nibAccountSettings, forCellReuseIdentifier: accountSettingsIdentifier)
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 170.0
        } else if indexPath.row == 1 {
            return 160.0
        } else if indexPath.row == 2 {
            return 160.0
        } else if indexPath.row == 3 {
            return 160.0
        } else {
            return 150.0
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addPhotoIdentifier, forIndexPath: indexPath) as! ProfileAddPhotoTableViewCell
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(personalIdentifier, forIndexPath: indexPath) as! ProfilePersonalTableViewCell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addressIdentifier, forIndexPath: indexPath) as! ProfileAddressTableViewCell
            return cell
        } else if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCellWithIdentifier(accountInformationIdentifier, forIndexPath: indexPath) as! ProfileAccountInformationTableViewCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(accountSettingsIdentifier, forIndexPath: indexPath) as! ProfileAccountSettingsTableViewCell
            return cell
        }
    }

    
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
    
    //Loader function
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }
}
