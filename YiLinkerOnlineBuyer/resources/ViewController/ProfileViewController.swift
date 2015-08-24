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
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        initializViews()
        registerNibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializViews() {
        tableView.tableFooterView = UIView(frame: CGRectZero)
    }

    func registerNibs() {
        var nibHeader = UINib(nibName: cellHeaderIdentifier, bundle: nil)
        tableView.registerNib(nibHeader, forCellReuseIdentifier: cellHeaderIdentifier)
        
        var nibContent = UINib(nibName: cellContentIdentifier, bundle: nil)
        tableView.registerNib(nibContent, forCellReuseIdentifier: cellContentIdentifier)
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
        self.navigationController?.pushViewController(editViewController, animated:true)
    }
    
    func transactionsTapAction() {
        
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

}
