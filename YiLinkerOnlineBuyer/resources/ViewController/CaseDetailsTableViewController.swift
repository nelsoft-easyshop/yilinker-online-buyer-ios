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
    //@IBOutlet weak var complainRemarksView: UIView!
    //@IBOutlet weak var complainRemarksCell: UITableViewCell!
    @IBOutlet weak var csrRemarks: UILabel!
    
    var tableData = [String]()
    
    private var disputeId: String = ""
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupClearFields()
        setupControlShape()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        fireGetCases()
    }
    
    private func setupControlShape() {
        // rounded label highlight
        statusCase.clipsToBounds = true
        statusCase.layer.cornerRadius = 13
    }
    
    private func setupClearFields()
    {
        caseID.text = ""
        statusCase.text = ""
        dateOpen.text = ""
        otherParty.text = ""
        complainantRemarks.text = ""
        csrRemarks.text = ""
    }
    
    private func setupNavigationBar() {
        if self.navigationController != nil {
            // white Title on Navigation Bar
            self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
            self.navigationItem.title = "Case Details"
            
            // white back button, no text
            let backButton = UIBarButtonItem(title: "Back", style:.Plain, target: self, action:"goBackButton")
            backButton.image = UIImage(named: "back-white")
            backButton.tintColor = UIColor.whiteColor()
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Navigation Bar buttons
    func goBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func passData(data: ResolutionCenterElement) {
        self.disputeId = data.resolutionId
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
        var parameters: NSDictionary =
        ["access_token" : SessionManager.accessToken()
            ,"disputeId": self.disputeId];
        
        manager.GET(APIAtlas.getResolutionCenterCaseDetails, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let caseDetailsModel: CaseDetailsModel = CaseDetailsModel.parseDataWithDictionary(responseObject)
            
            println(responseObject)
            
            if caseDetailsModel.isSuccessful {
                let caseDetails = caseDetailsModel.caseData
                
                self.caseID.text = self.disputeId
                self.statusCase.text = caseDetails.statusType
                self.dateOpen.text = caseDetails.dateAdded
                // In Buyer other is Disputer, In Seller other is Disputee
                self.otherParty.text = caseDetails.disputerName
                for remarkElement in caseDetails.remarks {
                    if( remarkElement.isAdmin ) {
                        self.csrRemarks.text = remarkElement.message
                    }
                    else {
                        self.complainantRemarks.text = remarkElement.message
                    }
                }
                self.tableData = caseDetails.products
                self.tableView.reloadData()
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Error while reading Case Details", title: "Data Loading Error")
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
    
    // MARK: UITableViewController
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("ProductCell") as! UITableViewCell
        cell.textLabel!.text = self.tableData[indexPath.row]
        return cell
    }
    
}
