//
//  NewDisputeTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by @EasyShop.ph on 9/15/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

struct DisputeStrings {
    static let title = StringHelper.localizedStringWithKey("DISPUTE_TITLE_LOCALIZE_KEY")
    static let number = StringHelper.localizedStringWithKey("DISPUTE_TRANSACTION_NUMBER_LOCALIZE_KEY")
    static let placeholder = StringHelper.localizedStringWithKey("DISPUTE_TRANSACTION_NUMBER_PLACEHOLDER_LOCALIZE_KEY")
    static let type = StringHelper.localizedStringWithKey("DISPUTE_TRANSACTION_TYPE_LOCALIZE_KEY")
    static let reason = StringHelper.localizedStringWithKey("DISPUTE_REASON_LOCALIZE_KEY")
    static let refund = StringHelper.localizedStringWithKey("DISPUTE_REFUND_LOCALIZE_KEY")
    static let replacement = StringHelper.localizedStringWithKey("DISPUTE_REPLACEMENT_LOCALIZE_KEY")
    static let products = StringHelper.localizedStringWithKey("DISPUTE_PRODUCTS_LOCALIZE_KEY")
    static let add = StringHelper.localizedStringWithKey("DISPUTE_ADD_LOCALIZE_KEY")
    static let remarks = StringHelper.localizedStringWithKey("DISPUTE_REMARKS_LOCALIZE_KEY")
    static let submit = StringHelper.localizedStringWithKey("DISPUTE_SUBMIT_CASE_LOCALIZE_KEY")
    static let done = StringHelper.localizedStringWithKey("TOOLBAR_DONE_LOCALIZE_KEY")
    static let noAvailableTransaction = StringHelper.localizedStringWithKey("DISPUTE_NO_AVAILABLE_TRANSACTION_LOCALIZE_KEY")
    static let noAvailableReason = StringHelper.localizedStringWithKey("DISPUTE_NO_REASON_TRANSACTION_LOCALIZE_KEY")
    static let pleaseChooseTransactionNumber = StringHelper.localizedStringWithKey("DISPUTE_CHOOSE_TRANSACTION_NUMBER_TRANSACTION_LOCALIZE_KEY")
}

class NewDisputeTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, DisputeAddItemViewControllerDelegate {
    
    @IBOutlet weak var disputeTitleLabel: UILabel!
    @IBOutlet weak var transactionNumberLabel: UILabel!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet weak var reasonLabel: UILabel!
    @IBOutlet var productsLabel: UILabel!
    @IBOutlet var remarksLabel: UILabel!
    @IBOutlet weak var disputeTitle: UITextField!
    @IBOutlet weak var transactionNumber: UITextField!
    @IBOutlet weak var transactionType: UITextField!
    @IBOutlet weak var reasonTextField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var remarks: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var transactionModel: TransactionModel!
    var disputeReasonModel: DisputeReasonsModel!
    
    var transactionIds: [String] = []
    var transactionTypes: [String] = [DisputeStrings.refund, DisputeStrings.replacement]
    var pickerType: String = ""
    
    var productIDs: [String] = []
    var productNames: [String] = []
    
    var isCaseDetailsDone: Bool = false
    var isReasonsDone: Bool = false
    
    var itemIndexToRemove: Int = -1
    
    var hud: MBProgressHUD?
    
    var reasonId: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        requestGetCaseDetails()
        requestGetReasons()
        setupRoundedCorners()
        setupNavigationBar()
        
        self.transactionNumber.delegate = self
        self.transactionType.delegate = self
        self.reasonTextField.delegate = self
        
        setStrings()
    }
    
    func setStrings() {
        self.title = CaseStrings.title
        disputeTitleLabel.text = DisputeStrings.title
        transactionNumberLabel.text = DisputeStrings.number
        transactionNumber.placeholder = DisputeStrings.placeholder
        transactionTypeLabel.text = DisputeStrings.type
        reasonLabel.text = DisputeStrings.reason
        productsLabel.text = DisputeStrings.products
        addButton.setTitle(DisputeStrings.add, forState: .Normal)
        remarksLabel.text = DisputeStrings.remarks
        submitButton.setTitle(DisputeStrings.submit, forState: .Normal)
        
        self.disputeTitleLabel.required()
        self.transactionNumberLabel.required()
        self.transactionTypeLabel.required()
        self.reasonLabel.required()
        self.productsLabel.required()
        self.remarksLabel.required()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper functions
    func setupRoundedCorners() {
        self.remarks.layer.cornerRadius = 5
        self.submitButton.layer.cornerRadius = 5
        self.addButton.layer.cornerRadius = self.addButton.frame.size.height / 2
    }
    
    func setupNavigationBar() {
        // white Title on Navigation Bar
        //self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        self.navigationItem.title = "Case Details"
        
        let backButton = UIBarButtonItem(title:" ", style:.Plain, target: self, action:"goBackButton")
        backButton.image = UIImage(named: "back-white")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    // MARK: - Navigation Bar Buttons
    func goBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Event Handlers
    @IBAction func goSubmitCase(sender: AnyObject) {
        if self.disputeTitle.text != "" && self.transactionNumber.text != "" && self.transactionType.text != "" && self.remarks.text != "" && self.productIDs.count != 0 {
            fireSubmitCase()
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "All field must be filled up.", title: "Error")
        }
    }
    
    // MARK: - Post methods
    func fireSubmitCase() {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance

        var parameters: NSDictionary!
        
        if self.transactionType.text == DisputeStrings.replacement {
            parameters = [ "access_token": SessionManager.accessToken()
                ,"disputeTitle": self.disputeTitle.text
                ,"remarks": self.remarks.text
                ,"orderProductStatus": 16
                ,"reasonId": self.reasonId
                ,"orderProductIds": self.productIDs.description]
        } else if self.transactionType.text == DisputeStrings.refund {
            parameters = [ "access_token": SessionManager.accessToken()
                ,"disputeTitle": self.disputeTitle.text
                ,"remarks": self.remarks.text
                ,"orderProductStatus": 10
                ,"reasonId": self.reasonId
                ,"orderProductIds": self.productIDs.description]
        }
        
        println(parameters)
        
        WebServiceManager.fireSubmitDispute(APIAtlas.postResolutionCenterAddCase, parameter: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if responseObject["isSuccessful"] as! Bool {
                    self.navigationController?.popViewControllerAnimated(true)
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
                    self.fireRefreshToken("submit")
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
    
    // MARK: hudle in darkness
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
    
    // MARK: - Add Picker View
    
    func addPickerView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        
        if pickerType == "Number" {
            if self.transactionIds.count != 0 {
                self.transactionNumber.inputView = pickerView
                self.transactionNumber.text = transactionIds[0]
            } else {
               UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: DisputeStrings.noAvailableTransaction)
            }
        } else if pickerType == "Type" {
            self.transactionType.inputView = pickerView
            self.transactionType.text = transactionTypes[0]
            self.reasonTextField.text = ""
            self.reasonTextField.enabled = true
            self.reasonTextField.backgroundColor = .whiteColor()
        } else if pickerType == "Reason" {
            if self.transactionType.text == DisputeStrings.refund {
                if disputeReasonModel.refundReason.count != 0 {
                    self.reasonTextField.inputView = pickerView
                    self.reasonTextField.text = disputeReasonModel.refundReason[0]
                    self.reasonId = self.disputeReasonModel.refundId[0]
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: DisputeStrings.noAvailableReason)
                }
            } else if self.transactionType.text == DisputeStrings.replacement {
                if disputeReasonModel.replacementReason.count != 0 {
                    self.reasonTextField.inputView = pickerView
                    self.reasonTextField.text = disputeReasonModel.replacementReason[0]
                    self.reasonId = self.disputeReasonModel.replacementId[0]
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: DisputeStrings.noAvailableReason)
                }
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "", title: DisputeStrings.noAvailableReason)
            }
        }
    }
    
    // MARK: - Add Tool Bar
    
    func addToolBarWithDoneTarget() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.Black
        toolBar.barTintColor = Constants.Colors.appTheme
        toolBar.tintColor = UIColor.whiteColor()
        
        let doneItem = UIBarButtonItem(title: DisputeStrings.done, style: UIBarButtonItemStyle.Done, target: self, action: "toolBarDoneAction")
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        var toolbarButtons = [flexibleSpace, doneItem]
        
        //Put the buttons into the ToolBar and display the tool bar
        toolBar.setItems(toolbarButtons, animated: false)
        
        if pickerType == "Number" {
            self.transactionNumber.inputAccessoryView = toolBar
        } else if pickerType == "Type" {
            self.transactionType.inputAccessoryView = toolBar
        } else if pickerType == "Reason" {
            self.reasonTextField.inputAccessoryView = toolBar
        }
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.productIDs.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        
        cell.textLabel!.text = self.productNames[indexPath.row]
        cell.selectionStyle = .None
        cell.textLabel?.font = UIFont(name: "Panton-Regular", size: 13.0)
        cell.textLabel?.textColor = .blackColor()
        
        let removeButton: UIButton = UIButton(frame: CGRectMake(0, 0, 15, 15))
        removeButton.setImage(UIImage(named: "closeRed"), forState: .Normal)
        removeButton.addTarget(self, action: "removeItemAction", forControlEvents: .TouchUpInside)
        itemIndexToRemove = indexPath.row
        cell.accessoryView = removeButton
        
        return cell
    }

    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    // MARK: - Actions
    
    @IBAction func addAction(sender: AnyObject) {
        if self.transactionNumber.text != "" {
            let disputeAddItems = DisputeAddItemViewController(nibName: "DisputeAddItemViewController", bundle: nil)
            disputeAddItems.delegate = self
            disputeAddItems.transactionId = self.transactionNumber.text
            var root = UINavigationController(rootViewController: disputeAddItems)
            self.navigationController?.presentViewController(root, animated: true, completion: nil)
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: DisputeStrings.pleaseChooseTransactionNumber, title: "")
        }
    }
    
    func toolBarDoneAction() {
        self.transactionNumber.resignFirstResponder()
        self.transactionType.resignFirstResponder()
        self.reasonTextField.resignFirstResponder()
    }
    
    func removeItemAction() {
        self.productIDs.removeAtIndex(itemIndexToRemove)
        self.productNames.removeAtIndex(itemIndexToRemove)
        self.tableView.reloadData()
    }
    
    // MARK: - Requests
    
    func requestGetCaseDetails() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.GET(APIAtlas.transactionLogs + "\(SessionManager.accessToken())" + "&perPage=999" + "&type=for-resolution", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.transactionModel = TransactionModel.parseDataFromDictionary(responseObject as! NSDictionary)
            self.transactionIds = self.transactionModel.invoice_number
//            for i in 0..<self.transactionModel.order_id.count {
//                if self.transactionModel.order_status_id[i] == "3" || self.transactionModel.order_status_id[i] == "6" {
//                    self.transactionIds.append(self.transactionModel.invoice_number[i])
//                }
//            }
            self.hud?.hide(true)
            self.tableView.reloadData()
//            self.isCaseDetailsDone = true
//            self.requestChecker()
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
//                self.hud?.hide(true)
                println(error.userInfo)
                self.isCaseDetailsDone = true
                self.requestChecker()
                
                
                self.hud?.hide(true)
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken("details")
                } else {
                    if task.statusCode != 404 {
                        println(error.userInfo)
//                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    }
                }
        })
    }
    
    func requestGetReasons() {
        
        WebServiceManager.fireGetReasonsWithUrl(APIAtlas.getReasons + "\(SessionManager.accessToken())", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if responseObject["isSuccessful"] as! Bool {
                    self.disputeReasonModel = DisputeReasonsModel.parseDataWithDictionary(responseObject)
                    self.tableView.reloadData()
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
                    self.fireRefreshToken("reasons")
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
    
    func requestChecker() {
        if self.isCaseDetailsDone && self.isReasonsDone {
            self.tableView.reloadData()
            self.hud?.hide(true)
        }
    }
    
    func fireRefreshToken(type: String) {
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestGetCaseDetails()
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    FBSDKLoginManager().logOut()
                    GPPSignIn.sharedInstance().signOut()
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.startPage()
                })
            }
        })
    }
    
    // MARK: - Text Field delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == self.transactionNumber {
            pickerType = "Number"
        } else if textField == self.transactionType {
            pickerType = "Type"
        } else if textField == self.reasonTextField {
            pickerType = "Reason"
        }
        
        addPickerView()
        addToolBarWithDoneTarget()
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    // MARK: - Picker View Data Source and Delegate
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == "Type" {
            return self.transactionTypes.count
        } else if pickerType == "Reason" {
            if self.transactionType.text == DisputeStrings.refund {
                return disputeReasonModel.refundReason.count
            } else if self.transactionType.text == DisputeStrings.replacement {
                return disputeReasonModel.replacementReason.count
            } else {
                return 0
            }
        }
        return self.transactionIds.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerType == "Type" {
            return self.transactionTypes[row]
        } else if pickerType == "Number" {
            return self.transactionIds[row]
        } else if pickerType == "Reason" {
            if self.transactionType.text == DisputeStrings.refund {
                return self.disputeReasonModel.refundReason[row]
            } else if self.transactionType.text == DisputeStrings.replacement {
                return self.disputeReasonModel.replacementReason[row]
            }
        }
        
        return ""
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerType == "Type" {
            self.transactionType.text = transactionTypes[row]
        } else if pickerType == "Number" {
            self.transactionNumber.text = transactionIds[row]
        } else if pickerType == "Reason" && self.transactionType.text == DisputeStrings.refund {
            self.reasonTextField.text = self.disputeReasonModel.refundReason[row]
            self.reasonId = self.disputeReasonModel.refundId[row]
        } else if pickerType == "Reason" && self.transactionType.text == DisputeStrings.replacement {
            self.reasonTextField.text = self.disputeReasonModel.replacementReason[row]
            self.reasonId = self.disputeReasonModel.replacementId[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        
        if pickerType == "Type" {
            pickerLabel.text = self.transactionTypes[row]
        } else if pickerType == "Number" {
            pickerLabel.text = self.transactionIds[row]
        } else if pickerType == "Reason" {
            if self.transactionType.text == DisputeStrings.refund {
                pickerLabel.text = self.disputeReasonModel.refundReason[row]
            } else if self.transactionType.text == DisputeStrings.replacement {
                pickerLabel.text = self.disputeReasonModel.replacementReason[row]
            }
        }
        
        pickerLabel.numberOfLines = 0
        pickerLabel.font = UIFont(name: "Panton-Regular", size: 12)
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel

    }
    
    // MARK: - Dispute Add Item View Controller Delegate
    
    func addTransactionProducts(productIds: [String], productNames: [String]) {
        for i in 0..<productIds.count {
            if (find(productIDs, productIds[i]) == nil) {
                self.productIDs.append(productIds[i])
                self.productNames.append(productNames[i])
            }
            
        }
        self.tableView.reloadData()
    }
    
}
