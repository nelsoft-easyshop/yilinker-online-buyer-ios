//
//  ResolutionCenterViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResolutionCenterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var casesTab: UIButton!
    @IBOutlet weak var openTab: UIButton!
    @IBOutlet weak var closedTab: UIButton!
    var tabSelector = ButtonToTabBehaviorizer()
    @IBOutlet weak var disputeButton: UIButton!
    var dimView: UIView? = nil
    
    @IBOutlet weak var resolutionTableView: UITableView!
    var tableData = [ResolutionCenterElement]()
    /*: [(ResolutionCenterElement)] =
    [ ("7889360001", "Open"  , "December 12, 2015", "Seller", "Not Happy", "It's okay")
    ,("7889360002", "Closed", "January 2, 2016"  , "Buyer" , "Yo wassup", "Go voltron!")
    ,("7889360003", "Open"  , "February 4, 2016" , "Seller", "hmm...", "hack'd'planet")
    ,("2345647856", "Open"  , "January 21, 2016" , "Seller", "Numbers game", "13")
    ,("2345647856", "Closed", "January 21, 2016" , "Buyer" , "On-start", "What's goin on")]
    **/
    
    var currentSelectedFilter = SelectedFilters(time:.Total,status:.Both)
    
    var hud: MBProgressHUD?
    
    /// Don't Call fireGetCases() everytime this screen is shown
    /// Call it intentionally whenever a screen completes
    //override func viewDidAppear(animated: Bool) {
    //    super.viewDidAppear(animated)
    //    fireGetCases()
    //}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialize tab-behavior for buttons
        tabSelector.viewDidLoadInitialize(casesTab, second: openTab, third: closedTab)
        
        // UITableViewDataSource initialization
        resolutionTableView.dataSource = self
        resolutionTableView.delegate = self
        
        // Load custom cell
        let nib = UINib(nibName:"ResolutionCenterCell", bundle:nil)
        resolutionTableView.registerNib(nib, forCellReuseIdentifier: "RcCell")
        resolutionTableView.rowHeight = 108
        
        setupNavigationBar()
        
        // Dispute button
        disputeButton.addTarget(self, action:"disputePressed", forControlEvents:.TouchUpInside)
        
        // Initial data load
        fireGetCases()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: initialization functions
    func setupNavigationBar() {
        // Title text in Navigation Bar will now turn WHITE
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        
        // Back button
        let backButton = UIBarButtonItem(title:" ", style:.Plain, target: self, action:"goBackButton")
        backButton.image = UIImage(named: "back-white")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
        
        // Filter button
        let filterButton = UIBarButtonItem(title:" ", style:.Plain, target: self, action:"goFilterButton")
        filterButton.image = UIImage(named: "filter-resolution")
        filterButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = filterButton
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let caseDetails = self.storyboard?.instantiateViewControllerWithIdentifier("CaseDetailsTableViewController")
            as! CaseDetailsTableViewController
        caseDetails.passData(tableData[indexPath.row])
        
        self.navigationController?.pushViewController(caseDetails, animated:true);
    }
    
    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = resolutionTableView.dequeueReusableCellWithIdentifier("RcCell") as! ResolutionCenterCell
        
        let currentDataId:(ResolutionCenterElement) = tableData[indexPath.item]
        cell.setData(currentDataId)
        
        return cell
    }
    
    // MARK: Tab Selection Logic
    @IBAction func casesPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        self.tabSelector.setSelection(.TabOne)
        self.currentSelectedFilter.status = .Both
        fireGetCases()
    }
    
    @IBAction func openPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        self.tabSelector.setSelection(.TabTwo)
        self.currentSelectedFilter.status = .Open
        fireGetCases()
    }
    
    @IBAction func closedPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        self.tabSelector.setSelection(.TabThree)
        self.currentSelectedFilter.status = .Closed
        fireGetCases()
    }
    
    // Mark: - New Dispute View Controller
    func disputePressed() {
        let newDispute = self.storyboard?.instantiateViewControllerWithIdentifier("NewDisputeTableViewController")
            as! NewDisputeTableViewController
        
        self.navigationController?.pushViewController(newDispute, animated:true);
    }
    
    // Mark: - OLD VERSION FOR MODAL File a Dispute
    private func disputeOldPressed() {
        var attributeModal = DisputeViewController(nibName: "DisputeViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.backgroundColor = UIColor.clearColor()
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        
        //UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(attributeModal, animated: true, completion: nil)
        self.navigationController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        if self.dimView == nil {
            let dimView = UIView(frame: self.view.frame)
            dimView.tag = 1337;
            dimView.backgroundColor = UIColor.blackColor();
            dimView.alpha = 0.7;
            self.dimView = dimView
        }
        self.view.addSubview(self.dimView!);
        
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView?.alpha = 0.5
            self.dimView?.layer.zPosition = 2
            //self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            //self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    func dissmissDisputeViewController(controller: DisputeViewController, type: String) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView?.alpha = 0
            self.dimView?.layer.zPosition = -1
            //self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            //self.navigationController?.navigationBar.alpha = CGFl oat(self.visibility)
        })
    }
    
    
    
    // MARK: - Navigation Bar Buttons
    func goBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goFilterButton() {
        let filtrationNav =
        self.storyboard?.instantiateViewControllerWithIdentifier("FilterNavigationController")
            as! UINavigationController
        let filtrationView = filtrationNav.viewControllers[0] as! ResolutionFilterViewController
        filtrationView.delegate = self
        
        self.navigationController?.presentViewController(filtrationNav, animated: true, completion: nil)
    }
    
    func applyFilter() {
        switch self.currentSelectedFilter.status {
        case .Both:
            tabSelector.setSelection(.TabOne)
        case .Open:
            tabSelector.setSelection(.TabTwo)
        case .Closed:
            tabSelector.setSelection(.TabThree)
        default:
            tabSelector.setSelection(.TabOne)
        }
        fireGetCases()
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
        var parameters: NSDictionary = NSDictionary();
        var urlString: String = APIAtlas.getResolutionCenterCases
        
        // add filters to parameter
        if self.currentSelectedFilter.isDefault() {
            parameters = ["access_token" : SessionManager.accessToken()]
        } else {
            let statusFilter = self.currentSelectedFilter.getStatusFilter()
            let timeFilter = self.currentSelectedFilter.getTimeFilter()
            if timeFilter == ""  {
                parameters = [ "access_token" : SessionManager.accessToken()
                    , "disputeStatusType" : statusFilter]
            } else if statusFilter == "0" {
                parameters = [ "access_token" : SessionManager.accessToken()
                    , "dateFrom" : timeFilter]
            } else {
                parameters = [ "access_token" : SessionManager.accessToken()
                    , "disputeStatusType" : statusFilter
                    , "dateFrom" : timeFilter]
            }
        }
        println(parameters)
        
        manager.GET(urlString, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let resolutionCenterModel: ResolutionCenterModel = ResolutionCenterModel.parseDataWithDictionary(responseObject)
            
            if resolutionCenterModel.isSuccessful {
                self.tableData.removeAll(keepCapacity: false)
                self.tableData = resolutionCenterModel.resolutionArray
                self.resolutionTableView.reloadData()
            } else {
                println(responseObject)
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Error while reading Resolution Center table", title: "Data Loading Error")
                self.tableData.removeAll(keepCapacity: false)
                self.tableData = resolutionCenterModel.resolutionArray
                self.resolutionTableView.reloadData()
            }
            
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
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
}
