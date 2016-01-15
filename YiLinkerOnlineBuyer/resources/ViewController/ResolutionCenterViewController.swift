//
//  ResolutionCenterViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct ResolutionStrings {
    static let title = StringHelper.localizedStringWithKey("RESOLUTION_TITLE_LOCALIZE_KEY")
    static let cases = StringHelper.localizedStringWithKey("RESOLUTION_CASES_LOCALIZE_KEY")
    static let open = StringHelper.localizedStringWithKey("RESOLUTION_OPEN_LOCALIZE_KEY")
    static let closed = StringHelper.localizedStringWithKey("RESOLUTION_CLOSED_LOCALIZE_KEY")
    static let file = StringHelper.localizedStringWithKey("RESOLUTION_FILE_LOCALIZE_KEY")
    static let emptyText = StringHelper.localizedStringWithKey("RESOLUTION_EMPTY_LOCALIZE_KEY")
}

class ResolutionCenterViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var casesTab: UIButton!
    @IBOutlet weak var openTab: UIButton!
    @IBOutlet weak var closedTab: UIButton!
    var tabSelector = ButtonToTabBehaviorizer()
    @IBOutlet weak var disputeButton: UIButton!
    var dimView: UIView? = nil
    
    @IBOutlet weak var resolutionTableView: UITableView!
    var tableData = [ResolutionCenterElement]()
    
    var transactionIds: [String] = []
    var transactionModel: TransactionModel!
    
    /*: [(ResolutionCenterElement)] =
    [ ("7889360001", "Open"  , "December 12, 2015", "Seller", "Not Happy", "It's okay")
    ,("7889360002", "Closed", "January 2, 2016"  , "Buyer" , "Yo wassup", "Go voltron!")
    ,("7889360003", "Open"  , "February 4, 2016" , "Seller", "hmm...", "hack'd'planet")
    ,("2345647856", "Open"  , "January 21, 2016" , "Seller", "Numbers game", "13")
    ,("2345647856", "Closed", "January 21, 2016" , "Buyer" , "On-start", "What's goin on")]
    **/
    
    @IBOutlet weak var casesContainerView: UIView!
    @IBOutlet weak var casesImageView: UIImageView!
    @IBOutlet weak var casesLabel: UILabel!
    @IBOutlet weak var openContainerView: UIView!
    @IBOutlet weak var openImageView: UIImageView!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var closedContainerView: UIView!
    @IBOutlet weak var closedImageView: UIImageView!
    @IBOutlet weak var closedLabel: UILabel!
    @IBOutlet weak var emptyLabel: UILabel!
    
    var currentSelectedFilter = SelectedFilters(time:.Total,status:.Both)
    
    var hud: MBProgressHUD?
    
    /// Don't Call fireGetCases() everytime this screen is shown
    /// Call it intentionally whenever a screen completes
    //override func viewDidAppear(animated: Bool) {
    //    super.viewDidAppear(animated)
    //    fireGetCases()
    //}
    
    var resolutionCenterModel: ResolutionCenterModel!
    
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
        
        self.casesLabel.text = ResolutionStrings.cases
        self.openLabel.text = ResolutionStrings.open
        self.closedLabel.text = ResolutionStrings.closed
        self.disputeButton.setTitle(ResolutionStrings.file, forState: .Normal)
        self.emptyLabel.text = ResolutionStrings.emptyText
        
        self.casesContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "casesAction:"))
        self.openContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "openAction:"))
        self.closedContainerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "closedAction:"))
        
        setSelectedTab(0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.emptyLabel.hidden = true
        fireGetCases()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: initialization functions
    func setupNavigationBar() {
        // Title text in Navigation Bar will now turn WHITE
        self.title = ResolutionStrings.title
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.tintColor = .whiteColor()
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
    
    // MARK: - Tabs Actions
    
    func casesAction(gesture: UIGestureRecognizer) {
        setSelectedTab(0)
        self.currentSelectedFilter.status = .Both
        fireGetCases()
        self.emptyLabel.hidden = true
    }
    
    func openAction(gesture: UIGestureRecognizer) {
        setSelectedTab(1)
        self.currentSelectedFilter.status = .Open
        fireGetCases()
        self.emptyLabel.hidden = true
    }
    
    func closedAction(gesture: UIGestureRecognizer) {
        setSelectedTab(2)
        self.currentSelectedFilter.status = .Closed
        fireGetCases()
        self.emptyLabel.hidden = true
    }
    
    func setSelectedTab(index: Int) {
        self.casesContainerView.backgroundColor = Constants.Colors.appTheme
        self.casesImageView.image = UIImage(named: "rc-cases-white")
        self.casesLabel.textColor = UIColor.whiteColor()
        
        self.openContainerView.backgroundColor = Constants.Colors.appTheme
        self.openImageView.image = UIImage(named: "rc-open-white")
        self.openLabel.textColor = UIColor.whiteColor()
        
        self.closedContainerView.backgroundColor = Constants.Colors.appTheme
        self.closedImageView.image = UIImage(named: "rc-close-white")
        self.closedLabel.textColor = UIColor.whiteColor()
        
        if index == 0 {
            self.casesContainerView.backgroundColor = UIColor.whiteColor()
            self.casesImageView.image = UIImage(named: "rc-cases-violet")
            self.casesLabel.textColor = Constants.Colors.appTheme
        } else if index == 1 {
            self.openContainerView.backgroundColor = UIColor.whiteColor()
            self.openImageView.image = UIImage(named: "rc-open-violet")
            self.openLabel.textColor = Constants.Colors.appTheme
        } else if index == 2 {
            self.closedContainerView.backgroundColor = UIColor.whiteColor()
            self.closedImageView.image = UIImage(named: "rc-close-violet")
            self.closedLabel.textColor = Constants.Colors.appTheme
        }
    }
    
    // Mark: - New Dispute View Controller
    func disputePressed() {
        if Reachability.isConnectedToNetwork() {
            self.requestGetTransactionsIds()
        } else {
            
        }
        
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
//        fireGetCases()
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
            
            var fullDate = timeFilter.componentsSeparatedByString("-")

            if timeFilter == ""  {
                parameters = [ "access_token" : SessionManager.accessToken(), "disputeStatusType" : statusFilter]
            } else if statusFilter == "0" {
                if self.currentSelectedFilter.getFilterType() == ResolutionTimeFilter.ThisMonth {
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : "\(fullDate[0])-\(fullDate[1])-1",
                        "dateTo": timeFilter]
                    
                } else if self.currentSelectedFilter.getFilterType() == ResolutionTimeFilter.ThisWeek {
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : self.currentSelectedFilter.sundayDate(),
                        "dateTo": timeFilter]
                } else {    
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : timeFilter]
                }
            } else {
                if self.currentSelectedFilter.getFilterType() == ResolutionTimeFilter.ThisMonth {
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : "\(fullDate[0])-\(fullDate[1])-1",
                        "dateTo": timeFilter,
                        "disputeStatusType" : statusFilter]
                    
                } else if self.currentSelectedFilter.getFilterType() == ResolutionTimeFilter.ThisWeek {
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : self.currentSelectedFilter.sundayDate(),
                        "dateTo": timeFilter,
                        "disputeStatusType" : statusFilter]
                } else {
                    parameters = [ "access_token" : SessionManager.accessToken()
                        , "dateFrom" : timeFilter,
                        "disputeStatusType" : statusFilter]
                }
            }
        }
        println(parameters)
        
        WebServiceManager.fireGetCasesWithUrl(urlString, parameter: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            self.resolutionCenterModel = ResolutionCenterModel.parseDataWithDictionary(responseObject)
            if successful {
                if responseObject["isSuccessful"] as! Bool {
                    if self.resolutionCenterModel.resolutionArray.count == 0 {
                        self.emptyLabel.hidden = false
                    } else {
                        self.tableData.removeAll(keepCapacity: false)
                        self.tableData = self.resolutionCenterModel.resolutionArray
                        self.resolutionTableView.reloadData()
                    }
                } else {
                    self.emptyLabel.hidden = false
                }
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken("cases")
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: ProductStrings.alertWentWrong)
                }
            }
        })
    }
    
    func fireRefreshToken(type: String) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = [
            "client_id": Constants.Credentials.clientID(),
            "client_secret": Constants.Credentials.clientSecret(),
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            if type == "cases" {
                self.fireGetCases()
            } else {
                self.requestGetTransactionsIds()
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.hud?.hide(true)
        })
        
    }
    
    // Get Transaction ids
    
    func requestGetTransactionsIds() {
        self.showHUD()
        
        WebServiceManager.fireGetTransactionIdsWithUrl(APIAtlas.transactionLogs + "\(SessionManager.accessToken())" + "&perPage=999" + "&type=for-resolution", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if responseObject["isSuccessful"] as! Bool {
                    self.transactionModel = TransactionModel.parseDataFromDictionary(responseObject as! NSDictionary)
                    self.transactionIds = self.transactionModel.invoice_number
                    if self.transactionIds.count != 0 {
                        let newDispute = self.storyboard?.instantiateViewControllerWithIdentifier("NewDisputeTableViewController")
                            as! NewDisputeTableViewController
                        newDispute.transactionIds = self.transactionIds
                        self.navigationController?.pushViewController(newDispute, animated:true)
                    } else {
                        self.view.makeToast(DisputeStrings.noAvailableTransaction, duration: 3.0, position: CSToastPositionBottom, style: CSToastManager.sharedStyle())
                    }
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String, title: ProductStrings.alertError)
                }
                self.hud?.hide(true)
            } else {
                self.hud?.hide(true)
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken("id")
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: ProductStrings.alertWentWrong)
                }
            }
        })
    }
}
