//
//  ActivityLogTableViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ActivityLogTableViewController: UITableViewController {
    
    // Strings
    let activityLogTitle: String = StringHelper.localizedStringWithKey("ACTIVITY_LOG_TITLE_LOCALIZE_KEY")
    
    // Models
    var tableData:[ActivityLogModel] = []
    var activities: ActivityLogItemsModel = ActivityLogItemsModel(isSuccessful: false, message: "", activities: [])
    
    // Global variables
    var hud: MBProgressHUD?
    
    var isPageEnd: Bool = false
    var logsDictionary = Dictionary<String, String>()
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backButton()
        self.initializeViews()
        self.registerNibs()
        self.titleView()
        
        self.page = 0
        self.fireActivityLog()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation bar
    // Add back button in navigation bar
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
    
    // MARK: Navigation bar back button action
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }

    // MARK: Private methods
    // Methods used to format date and time
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
    
    // MARK: Initialize activity log
    // Add all possible date in 'tableData' append all the activities belong to that date. 
    // It's where the process of splitting up dates and splitting up activities into dates.
    func initializeActivityLogsItem() {
        self.tableData.removeAll(keepCapacity: false)
        var tempDates: [String] = []
        
        for subValue in self.activities.activities {
            if !contains(tempDates, self.formatDateToCompleteString(self.formatStringToDate(subValue.date))) {
                tempDates.append(self.formatDateToCompleteString(formatStringToDate(subValue.date)))
                self.tableData.append(ActivityLogModel(date: self.formatDateToCompleteString(self.formatStringToDate(subValue.date)), activities: []))
            }
        }
        
        for var i = 0; i < self.tableData.count; i++ {
            for subValue in self.activities.activities {
                if self.formatDateToCompleteString(self.formatStringToDate(subValue.date)) == self.tableData[i].date {
                    self.tableData[i].activities.append(ActivityModel(time: self.formatDateToTimeString(self.formatStringToDate(subValue.date)), details: subValue.text))
                }
            }
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: Initialize tableview
    func initializeViews() {
        //Add Nav Bar
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 75.0
    }
    
    // MARK: Register tableview cell
    func registerNibs() {
        var nib = UINib(nibName: "ActivityLogTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "ActivityLogTableViewCell")
    }
    
    // MARK: Show alert view
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: Show HUD
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
    
    // MARK: - Set tableview section header
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
    
    // MARK: Set the title of navigation bar
    func titleView() {
        self.title = self.activityLogTitle
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
        if self.tableData.count != 0 {
            return self.tableData[section].activities.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ActivityLogTableViewCell", forIndexPath: indexPath) as! ActivityLogTableViewCell
      
        if (self.tableData.count != 0) {
            cell.detailsLabel?.text = self.tableData[indexPath.section].activities[indexPath.row].details
            cell.timeLabel?.text =  self.tableData[indexPath.section].activities[indexPath.row].time
        }
       
        return cell
    }
    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if self.tableData.count != 0 {
            return self.setSectionHeader(self.tableData[section].date)
        } else {
            return self.setSectionHeader("MM-DD-YYYY")
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

    // MARK: -
    // MARK: - REST API request
    // MARK: GET METHOD - Fire Activity Log
    /*
    *
    * (Parameters) - access_token, perPage, page
    *
    * Function to refresh token to get another access token
    *
    */
    func fireActivityLog(){
        
        if !isPageEnd {
            
            self.showHUD()
            self.page++
            
            let perPage: String = "&perPage=15&"
            let page: String = "page=\(self.page)"
            let url: String = "\(APIAtlas.activityLogs)(\(SessionManager.accessToken())&\(perPage))\(page))"
            var parameters: NSDictionary = [:]
            
            WebServiceManager.fireGetActivityLogWithUrl(url, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
                if successful {
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
                } else {
                    if requestErrorType == .ResponseError {
                        //Error in api requirements
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                        self.showAlert(title: Constants.Localized.error, message: errorModel.message)
                        self.hud?.hide(true)
                    } else if requestErrorType == .AccessTokenExpired {
                        self.requestRefreshToken()
                    } else if requestErrorType == .PageNotFound {
                        //Page not found
                        Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                        self.hud?.hide(true)
                    } else if requestErrorType == .NoInternetConnection {
                        //No internet connection
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                        self.hud?.hide(true)
                    } else if requestErrorType == .RequestTimeOut {
                        //Request timeout
                        Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                        self.hud?.hide(true)
                    } else if requestErrorType == .UnRecognizeError {
                        //Unhandled error
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                        self.hud?.hide(true)
                    }
                }
            })
        } else {
            self.hud?.hide(true)
            let titleString = StringHelper.localizedStringWithKey("ACTIVITY_LOGS_TITLE_LOCALIZE_KEY")
            let noMoreDataString = StringHelper.localizedStringWithKey("NO_MORE_DATA_LOCALIZE_KEY")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: noMoreDataString, title: titleString)
        }
    }
    
    // MARK: -
    // MARK: - REST API request
    // MARK: POST METHOD - Refresh token
    /*
    *
    * (Parameters) - client_id, client_secret, grant_type, refresh_token
    *
    * Function to refresh token to get another access token
    *
    */
    func requestRefreshToken() {
        
        self.showHUD()
        
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID(),
            "client_secret": Constants.Credentials.clientSecret(),
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        
        manager.POST(APIAtlas.loginUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
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
}
