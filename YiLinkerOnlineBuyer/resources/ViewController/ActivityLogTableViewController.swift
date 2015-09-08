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
        ActivityLogModel(text: "JUNE 23, 2015", activities: [ActivityModel(time: "2:58 AM", details: "You have purchased iPhone 6 - Gold from seller2daMax"), ActivityModel(time: "1:20 AM", details: "Upload Profile Photo")]),
        ActivityLogModel(text: "JUNE 09, 2015", activities: [ActivityModel(time: "2:58 AM", details: "You have purchased iPhone 6 - Gold from seller2daMax"), ActivityModel(time: "1:20 AM", details: "Upload Profile Photo")])
    ]
    
    var activityModel: ActivityModel?
    var activityLogsModel: ActivityLogModel!
    var cellCount: Int = 0
    var cellSection: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        titleView()
        backButton()
        registerNibs()
        fireActivityLog()
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
    
    func titleView() {
        self.title = "Activity Log"
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
        var nib = UINib(nibName: "ActivityLogTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ActivityLogTableViewCell")
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        //return self.cellSection
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.cellCount != 0 {
            return self.cellCount
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityLogTableViewCell", forIndexPath: indexPath) as! ActivityLogTableViewCell

        //let dateComponents = NSDateComponents()
      
        if(self.activityLogsModel != nil){
            //var dates = self.activityLogsModel.date_array[indexPath.row] as NSString
            //dateComponents.year = dates.substringWithRange(NSRange(location: 0, length: 4)).toInt()!
            //dateComponents.month = dates.substringWithRange(NSRange(location: 5, length: 2)).toInt()!
            //dateComponents.day = dates.substringWithRange(NSRange(location: 8, length: 2)).toInt()!
            //dateComponents.hour = dates.substringWithRange(NSRange(location: 11, length: 2)).toInt()!
            //dateComponents.minute = dates.substringWithRange(NSRange(location: 14, length: 2)).toInt()!
            //dateComponents.second = dates.substringWithRange(NSRange(location: 17, length: 2)).toInt()!
            //let formatter = NSDateFormatter()
            //formatter.dateStyle = NSDateFormatterStyle.LongStyle
            //formatter.timeStyle = .MediumStyle
            //let date = NSCalendar.currentCalendar().dateFromComponents(dateComponents)!
            //let dateString = formatter.stringFromDate(date)
            //println("year \(dateComponents.year)")
            
            cell.detailsLabel?.text = self.activityLogsModel.text_array[indexPath.row]
            //var trimDate = dateString.stringByReplacingOccurrencesOfString("January 1, 1 at ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            cell.timeLabel?.text = self.activityLogsModel.date_array[indexPath.row]
            //println(trimDate.stringByReplacingOccurrencesOfString(":00", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
        }
       
        //println(tableData[indexPath.section].activities[indexPath.row].time)
        //println(tableData[indexPath.section].activities[indexPath.row].details)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.cellSection != 0 {
            return setSectionHeader(self.activityLogsModel.date_section_array[section])
        } else {
            return setSectionHeader(tableData[section].text)
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    

    func fireActivityLog(){
        let manager = APIManager.sharedInstance
        
        manager.GET(APIAtlas.activityLogs+"\(SessionManager.accessToken())", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.activityLogsModel = ActivityLogModel.parsaActivityLogsDataFromDictionary(responseObject as! NSDictionary)
                self.cellCount = self.activityLogsModel!.text_array.count
                self.cellSection = self.activityLogsModel!.date_section_array.count
            
                println("count \(self.cellSection)")
                self.tableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
        })
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
