//
//  EditProfileTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class EditProfileTableViewController: UITableViewController, EditProfileAddPhotoTableViewCellDelegate, EditProfileAddressTableViewCellDelegate {
    
    let addPhotoCell: String = "EditProfileAddPhotoTableViewCell"
    let personalInfoCell: String = "EditProfilePersonalInformationTableViewCell"
    let addressCell: String = "EditProfileAddressTableViewCell"
    let accountCell: String = "EditProfileAccountInformationTableViewCell"
        
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        registerNibs()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeViews() {
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        var tapTableView = UITapGestureRecognizer(target:self, action:"hideKeyboard")
        self.tableView.addGestureRecognizer(tapTableView)
    }
    
    func registerNibs() {
        var nibPhoto = UINib(nibName: addPhotoCell, bundle: nil)
        self.tableView.registerNib(nibPhoto, forCellReuseIdentifier: addPhotoCell)
        
        var nibPersonal = UINib(nibName: personalInfoCell, bundle: nil)
        self.tableView.registerNib(nibPersonal, forCellReuseIdentifier: personalInfoCell)
        
        var nibAddress = UINib(nibName: addressCell, bundle: nil)
        self.tableView.registerNib(nibAddress, forCellReuseIdentifier: addressCell)
        
        var nibAccount = UINib(nibName: accountCell, bundle: nil)
        self.tableView.registerNib(nibAccount, forCellReuseIdentifier: accountCell)
    }
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addPhotoCell, forIndexPath: indexPath) as! EditProfileAddPhotoTableViewCell
            cell.delegate = self
            return cell
        } else if indexPath.row == 1 {
            let cell = tableView.dequeueReusableCellWithIdentifier(personalInfoCell, forIndexPath: indexPath) as! EditProfilePersonalInformationTableViewCell
            return cell
        } else if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCellWithIdentifier(addressCell, forIndexPath: indexPath) as! EditProfileAddressTableViewCell
            cell.delegate = self
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(accountCell, forIndexPath: indexPath) as! EditProfileAccountInformationTableViewCell
            
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 150
        } else if indexPath.row == 1 {
            return 175
        }  else if indexPath.row == 2 {
            return 145
        } else {
            return 270
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
    
    // MARK: - EditProfileAddPhotoTableViewCellDelegate
    func addPhotoAction(sender: AnyObject) {
        println("addPhotoAction")
    }
    
    // MARK: - EditProfileAddressTableViewCellDelegate
    func changeAddressAction(sender: AnyObject){
        println("changeAddressAction")
    }
    
    // Hide Keyboard 
    func hideKeyboard() {
        self.view.endEditing(true)
    }
    
}
