//
//  ActivityLogTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityLogTableViewController: UITableViewController {
    
//    var tableData:[ActivityLogModel] = [
//        ActivityLogModel(text: "MM-DD-YYYY", activities: [ActivityModel(time: "0:00 AM/PM", details: "No Activity logs yet.")])
//    ]
    
    var activityModel: ActivityModel?
    var activityLogsModel: ActivityLogModel!
    
    var table: [ActivityLogModel] = []
    var tableSectionContents: ActivityModel!
    var array = [ActivityModel]()
    
    var cellCount: Int = 0
    var cellSection: Int = 0
    
    var tableData:[ActivityLogModel] = []
    
    var activities: ActivityLogItemsModel = ActivityLogItemsModel(isSuccessful: false, message: "", activities: [])
    
    var isPageEnd: Bool = false
    var page: Int = 1
    var logsDictionary = Dictionary<String, String>()
    
    var hud: MBProgressHUD?
    
    let activityLogTitle: String = StringHelper.localizedStringWithKey("ACTIVITY_LOG_TITLE_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initializeViews()
        titleView()
        backButton()
        registerNibs()
        page = 0
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
        self.title = self.activityLogTitle
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
        //return self.table.count
        return tableData.count
        //return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if self.tableData.count != 0 {
            //return self.table[section].activities.count
            return tableData[section].activities.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityLogTableViewCell", forIndexPath: indexPath) as! ActivityLogTableViewCell
      
        if (self.tableData.count != 0) {
//            cell.detailsLabel?.text = self.table[indexPath.section].activities[indexPath.row].details
//            cell.timeLabel?.text =  self.table[indexPath.section].activities[indexPath.row].time
            cell.detailsLabel?.text = tableData[indexPath.section].activities[indexPath.row].details
            cell.timeLabel?.text =  tableData[indexPath.section].activities[indexPath.row].time
        }
       
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableData.count != 0 {
            return setSectionHeader(tableData[section].date)
        } else {
            return setSectionHeader("MM-DD-YYYY")
        }
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    override func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            self.fireActivityLog()
        }
    }
    
    func initializeActivityLogsItem() {
        tableData.removeAll(keepCapacity: false)
        var tempDates: [String] = []
        
        for subValue in activities.activities {
            if !contains(tempDates, formatDateToCompleteString(formatStringToDate(subValue.date))) {
                tempDates.append(formatDateToCompleteString(formatStringToDate(subValue.date)))
                tableData.append(ActivityLogModel(date: formatDateToCompleteString(formatStringToDate(subValue.date)), activities: []))
            }
        }
        
        println(tempDates)
        
        for var i = 0; i < tableData.count; i++ {
            for subValue in activities.activities {
                if formatDateToCompleteString(formatStringToDate(subValue.date)) == tableData[i].date {
                    tableData[i].activities.append(ActivityModel(time: formatDateToTimeString(formatStringToDate(subValue.date)), details: subValue.text))
                }
            }
        }
        
        self.tableView.reloadData()
    }

    func fireActivityLog(){
        
        if !isPageEnd {
            
            self.showHUD()
            let manager = APIManager.sharedInstance
            
            page++
            
            manager.GET(APIAtlas.activityLogs+"\(SessionManager.accessToken())&perPage=15&page=\(page)", parameters: nil, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                
                /*
                self.activityLogsModel = ActivityLogModel.parsaActivityLogsDataFromDictionary(responseObject as! NSDictionary)
                self.cellCount = self.activityLogsModel!.text_array.count
                self.cellSection = self.activityLogsModel!.date_section_array.count
                if self.table.count < 15 {
                    self.isPageEnd = true
                }
                
                if responseObject["isSuccessful"] as! Bool {
                    for var a = 0; a < self.activityLogsModel.date_section_array.count; a++ {
                        var arr = [ActivityModel]()
                        for var b = 0; b < self.activityLogsModel.text_array.count; b++ {
                            if self.formatDateToCompleteString(self.formatStringToDate(self.activityLogsModel!.date_section_array[a])) == self.formatDateToCompleteString(self.formatStringToDate(self.activityLogsModel!.all_date_section_array[b])) {
                                self.tableSectionContents = ActivityModel(time: self.formatDateToTimeString(self.formatStringToDate(self.activityLogsModel!.date_array[b])), details: self.activityLogsModel!.text_array[b])
                                arr.append(self.tableSectionContents)
                            }
                        }
                        self.table.append(ActivityLogModel(text: self.formatDateToCompleteString(self.formatStringToDate(self.activityLogsModel!.date_section_array[a])), activities: arr))
                    }

                } else {
                    self.isPageEnd = true
                }*/
                let activityLogs: ActivityLogItemsModel = ActivityLogItemsModel.parseDataWithDictionary(responseObject as! NSDictionary)
                
                if activityLogs.activities.count < 15 {
                    self.isPageEnd = true
                }
                
                if activityLogs.isSuccessful {
                    self.activities.activities += activityLogs.activities
                    self.initializeActivityLogsItem()
                } else {
                    self.isPageEnd = true
                }
                
                self.hud?.hide(true)
                self.tableView.reloadData()
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    } else if task.statusCode == 401 {
                        self.requestRefreshToken()
                    } else {
                        self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                        self.hud?.hide(true)
                    }
                    self.hud?.hide(true)
            })
        
        } else {
            self.hud?.hide(true)
            let titleString = StringHelper.localizedStringWithKey("ACTIVITY_LOGS_TITLE_LOCALIZE_KEY")
            let noMoreDataString = StringHelper.localizedStringWithKey("NO_MORE_DATA_LOCALIZE_KEY")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: noMoreDataString, title: titleString)
        }
    }
    
    
    func requestRefreshToken() {
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID(),
            "client_secret": Constants.Credentials.clientSecret(),
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.fireActivityLog()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let alertController = UIAlertController(title: Constants.Localized.someThingWentWrong, message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
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
    
    func formatStringToDate(date: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        
        return dateFormatter.dateFromString(date)!
    }
    
    func formatDateToString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSSSS"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatDateToTimeString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "KK:mm aa"
        return dateFormatter.stringFromDate(date)
    }
    
    func formatDateToCompleteString(date: NSDate) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMMM dd, yyyy"
        return dateFormatter.stringFromDate(date)
    }
}
