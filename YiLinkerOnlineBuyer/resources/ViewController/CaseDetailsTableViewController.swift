//
//  CaseDetailsTableViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 9/2/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class CaseDetailsTableViewController: UITableViewController {
    @IBOutlet weak var caseID: UILabel!
    @IBOutlet weak var statusCase: UILabel!
    @IBOutlet weak var dateOpen: UILabel!
    @IBOutlet weak var otherParty: UILabel!
    @IBOutlet weak var complainantRemarks: UILabel!
    @IBOutlet weak var complainRemarksView: UIView!
    @IBOutlet weak var complainRemarksCell: UITableViewCell!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Title text in Navigation Bar will now turn WHITE
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        let backButton = UIBarButtonItem(title: "Back", style:.Plain, target: self, action:"goBackButton")
        backButton.image = UIImage(named: "back-white")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
        
        // rounded label highlight
        statusCase.clipsToBounds = true
        statusCase.layer.cornerRadius = 13
        
        // make it bigger
        //complainantRemarks.sizeToFit()
        complainRemarksView.sizeToFit()
        //complainRemarksCell.sizeToFit()
        //remarksCell.sizeToFit()
        complainRemarksCell.bounds.size.height = 160//complainantRemarks.bounds.height + 16
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Navigation Bar buttons
    func goBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }


    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Potentially incomplete method implementation.
//        // Return the number of sections.
//        return 0
//    }
//
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete method implementation.
//        // Return the number of rows in the section.
//        return 0
//    }

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
