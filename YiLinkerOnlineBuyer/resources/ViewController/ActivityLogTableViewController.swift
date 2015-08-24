//
//  ActivityLogTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityLogTableViewController: UITableViewController {
    
    var tableData:[ActivityLogModel] = [
        ActivityLogModel(date: "JUNE 23, 2015", activities: [ActivityModel(time: "2:58 AM", details: "You have purchased iPhone 6 - Gold from seller2daMax"), ActivityModel(time: "1:20 AM", details: "Upload Profile Photo")]),
        ActivityLogModel(date: "JUNE 09, 2015", activities: [ActivityModel(time: "2:58 AM", details: "You have purchased iPhone 6 - Gold from seller2daMax"), ActivityModel(time: "1:20 AM", details: "Upload Profile Photo")])
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
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
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 75.0
    }
    
    func registerNibs() {
        var nib = UINib(nibName: "ActivityLogTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ActivityLogTableViewCell")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return tableData[section].activities.count
    }

    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityLogTableViewCell", forIndexPath: indexPath) as! ActivityLogTableViewCell

        cell.detailsLabel?.text = tableData[indexPath.section].activities[indexPath.row].details
        cell.timeLabel?.text = tableData[indexPath.section].activities[indexPath.row].time
        
        println(tableData[indexPath.section].activities[indexPath.row].time)
        println(tableData[indexPath.section].activities[indexPath.row].details)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return setSectionHeader(tableData[section].date)
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
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
    
    // MARK: - Methods
    
    func setSectionHeader(date: String) -> UIView {
        var sectionHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.tableView.sectionHeaderHeight))
        sectionHeaderView.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
        var middleLine: UIView = UIView(frame: CGRectMake(0, 0, sectionHeaderView.frame.size.width, 0.5))
        middleLine.backgroundColor = .grayColor()
        middleLine.center.y = sectionHeaderView.center.y + (15 / 2)
        sectionHeaderView.addSubview(middleLine)
        
        var dateLabel: UILabel = UILabel(frame: CGRectMake(0, 0, sectionHeaderView.frame.size.width, 20))
        dateLabel.textAlignment = .Center
        dateLabel.font = UIFont.systemFontOfSize(12.0)
        dateLabel.textColor = .grayColor()
        dateLabel.text = "  " + date + "  "
        dateLabel.sizeToFit()
        dateLabel.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
        dateLabel.frame.size.width = dateLabel.frame.size.width + 10
        dateLabel.center.x = sectionHeaderView.center.x
        dateLabel.center.y = sectionHeaderView.center.y + (15 / 2)
        
        sectionHeaderView.addSubview(dateLabel)
        
        return sectionHeaderView
    }
    
}
