//
//  ResolutionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ResolutionViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var currentSelectedFilter = SelectedFilters(time:.Total,status:.Both)
    @IBOutlet weak var casesTab: UIButton!
    @IBOutlet weak var openTab: UIButton!
    @IBOutlet weak var closedTab: UIButton!
    var tabSelector = ButtonToTabBehaviorizer()
    @IBOutlet weak var disputeButton: UIButton!
    var dimView: UIView? = nil
    
    @IBOutlet weak var resolutionTableView: UITableView!
    
    var tableData = [ResolutionCenterElement]()
    var tableData2:[ResolutionFilterModel] = [
        ResolutionFilterModel(title: "DATES", resolutionFilter:[ResolutionFilter2Model(date: "Today", check: true), ResolutionFilter2Model(date: "This Week", check: false), ResolutionFilter2Model(date: "This Month", check: false), ResolutionFilter2Model(date: "Total", check: false)]),
        ResolutionFilterModel(title: "STATUS", resolutionFilter:[ResolutionFilter2Model(date: "Open", check: false), ResolutionFilter2Model(date: "Close", check: false)])
    ]
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Resolution Center"
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.backButton()
        
        // Initialize tab-behavior for buttons
        tabSelector.viewDidLoadInitialize(casesTab, second: openTab, third: closedTab)
        
        // UITableViewDataSource initialization
        resolutionTableView.dataSource = self
        resolutionTableView.delegate = self
        
        // Load custom cell
        let nib = UINib(nibName:"ResolutionCenterCell", bundle:nil)
        resolutionTableView.registerNib(nib, forCellReuseIdentifier: "ResolutionCenterCell")
        resolutionTableView.rowHeight = 108
        
        self.fireGetCases()

        // Dispute button
        //disputeButton.addTarget(self, action:"disputePressed", forControlEvents:.TouchUpInside)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: UITableViewDelegate
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /*let caseDetails = self.storyboard?.instantiateViewControllerWithIdentifier("CaseDetailsTableViewController")
            as! CaseDetailsTableViewController
        
        // PASS DATA
        caseDetails.passData(self.tableData[indexPath.row])
        
        self.navigationController?.pushViewController(caseDetails, animated:true);
        */
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO complete the code below
        let cell = self.resolutionTableView.dequeueReusableCellWithIdentifier("ResolutionCenterCell") as! ResolutionCenterCell
        
        if self.tableData.count != 0 {
            // put values here
            let currentDataId:(ResolutionCenterElement) = tableData[indexPath.item]
            cell.setData(currentDataId)
        }
        
        //cell.setData(currentData.id, status:currentData.status, date:currentData.date, type:currentData.type )
        
        return cell
    }
    
    // MARK: Tab Selection Logic
    @IBAction func casesPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        
        self.tabSelector.setSelection(.TabOne)
    }
    
    @IBAction func openPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        
        self.tabSelector.setSelection(.TabTwo)
    }
    
    @IBAction func closedPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        
        self.tabSelector.setSelection(.TabThree)
    }
    
    //MARK: - File a Dispute
    func disputePressed() {
        var attributeModal = DisputeViewController(nibName: "DisputeViewController", bundle: nil)
        //attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.backgroundColor = UIColor.clearColor()
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        
    }
    
    //MARK: Navigation bar back button
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "filter", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "filter-resolution"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func filter() {
        var resolutionFilter = ResolutionFilterTableViewController(nibName: "ResolutionFilterTableViewController", bundle: nil)
        if resolutionFilter.respondsToSelector("edgesForExtendedLayout") {
            resolutionFilter.edgesForExtendedLayout = UIRectEdge.None
        }
        resolutionFilter.tableData = self.tableData2
        self.navigationController?.pushViewController(resolutionFilter, animated:true)
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
    
    func fireGetCases() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken()];
        
        manager.GET(APIAtlas.getResolutionCenterCases, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let resolutionCenterModel: ResolutionCenterModel = ResolutionCenterModel.parseDataWithDictionary(responseObject)
            
            println(responseObject)
            
            if resolutionCenterModel.isSuccessful {
                self.tableData.removeAll(keepCapacity: false)
                self.tableData = resolutionCenterModel.resolutionArray
                self.resolutionTableView.reloadData()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Error while reading Resolution Center table", title: "Data Loading Error")
            }
            
            
            self.hud?.hide(true)
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken()
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Error Refreshing Token", title: "Refresh Token Error")
                }
                
                println(error)
        })
    }
    
    func fireRefreshToken() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.fireGetCases()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
