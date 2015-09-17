//
//  ResolutionFilterTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ResolutionFilterTableViewController: UITableViewController {
    
    var tableData:[ResolutionFilterModel] = []
    var resolutionCenter = ResolutionViewController(nibName: "ResolutionViewController", bundle: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Filter"
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }

        self.backButton()
        
        // Load custom cell
        let nib = UINib(nibName:"ResolutionFilterTableViewCell", bundle:nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "ResolutionFilterTableViewCell")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return self.tableData.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.tableData[section].resolutionFilter.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO complete the code below
        let cell = self.tableView.dequeueReusableCellWithIdentifier("ResolutionFilterTableViewCell") as! ResolutionFilterTableViewCell
        
        var tempModel = tableData[indexPath.section]
        if indexPath.section == 0 {
            cell.setType(0)
        } else {
            cell.setType(1)
        }

        cell.setTitleLabelText(tempModel.resolutionFilter[indexPath.row].date)
        cell.setChecked(tempModel.resolutionFilter[indexPath.row].check)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.width, 40))
        headerView.backgroundColor = Constants.Colors.selectedCellColor
        var headerTextLabel: UILabel = UILabel(frame: CGRectMake(16, 15, (self.view.bounds.width - 32), 20))
        headerTextLabel.textColor = Constants.Colors.grayText
        headerTextLabel.font = UIFont(name: "Panton-Regular", size: CGFloat(12))
        headerTextLabel.text = self.tableData[section].title
        headerView.addSubview(headerTextLabel)
        
        return headerView
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 3 {
                for var i: Int = 0; i < tableData[0].resolutionFilter.count; i++ {
                    tableData[0].resolutionFilter[i].check = true
                    println("row 4 \(tableData[0].resolutionFilter[indexPath.row].check)")
                }
                tableData[indexPath.section].resolutionFilter[indexPath.row].check = true
            } else {
                for var i: Int = 0; i < tableData[0].resolutionFilter.count; i++ {
                    tableData[0].resolutionFilter[i].check = false
                    println(tableData[0].resolutionFilter[i].check)
                }
                tableData[indexPath.section].resolutionFilter[indexPath.row].check = true
            }
            
            self.tableView.reloadData()
        } else {
            tableData[indexPath.section].resolutionFilter[indexPath.row].check = !tableData[indexPath.section].resolutionFilter[indexPath.row].check
        }
        self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func setSectionHeader(date: String) -> UIView {
        var sectionHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.tableView.sectionHeaderHeight))
        sectionHeaderView.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
        
        var dateLabel: UILabel = UILabel(frame: CGRectMake(0, 0, sectionHeaderView.frame.size.width, 30))
        dateLabel.textAlignment = .Left
        dateLabel.font = UIFont.systemFontOfSize(12.0)
        dateLabel.textColor = .grayColor()
        dateLabel.text = date
        dateLabel.sizeToFit()
        dateLabel.backgroundColor = UIColor(red: 225/255.0, green: 225/255.0, blue: 225/255.0, alpha: 1.0)
        dateLabel.frame.size.width = dateLabel.frame.size.width + 10
        dateLabel.frame.size.height = dateLabel.frame.size.height + 40
        sectionHeaderView.addSubview(dateLabel)
        
        return sectionHeaderView
    }
    
    //MARK: Navigation bar back button
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 15, 15)
        backButton.addTarget(self, action: "close", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "close-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -5
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func close() {
        println("close")
        self.navigationController!.popViewControllerAnimated(true)
    }

    func check() {
        println("check")
        resolutionCenter.tableData2 = tableData
        self.navigationController!.popViewControllerAnimated(true)
    }
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
