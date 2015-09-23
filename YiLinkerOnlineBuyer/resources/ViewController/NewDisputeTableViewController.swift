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
    static let refund = StringHelper.localizedStringWithKey("DISPUTE_REFUND_LOCALIZE_KEY")
    static let replacement = StringHelper.localizedStringWithKey("DISPUTE_REPLACEMENT_LOCALIZE_KEY")
    static let products = StringHelper.localizedStringWithKey("DISPUTE_PRODUCTS_LOCALIZE_KEY")
    static let add = StringHelper.localizedStringWithKey("DISPUTE_ADD_LOCALIZE_KEY")
    static let remarks = StringHelper.localizedStringWithKey("DISPUTE_REMARKS_LOCALIZE_KEY")
    static let submit = StringHelper.localizedStringWithKey("DISPUTE_SUBMIT_CASE_LOCALIZE_KEY")
    static let done = StringHelper.localizedStringWithKey("TOOLBAR_DONE_LOCALIZE_KEY")
}

class NewDisputeTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, DisputeAddItemViewControllerDelegate {
    
    @IBOutlet weak var disputeTitleLabel: UILabel!
    @IBOutlet weak var transactionNumberLabel: UILabel!
    @IBOutlet weak var transactionTypeLabel: UILabel!
    @IBOutlet var productsLabel: UILabel!
    @IBOutlet var remarksLabel: UILabel!
    @IBOutlet weak var disputeTitle: UITextField!
    @IBOutlet weak var transactionNumber: UITextField!
    @IBOutlet weak var transactionType: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var remarks: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var transactionModel: TransactionModel!
    var transactionIds: [String] = []
    var transactionTypes: [String] = [DisputeStrings.refund, DisputeStrings.replacement]
    var pickerType: String = ""
    
    var productIDs: [String] = []
    var productNames: [String] = []
    
    
    var itemIndexToRemove: Int = -1
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestGetCaseDetails()
        setupRoundedCorners()
        setupNavigationBar()
        
        self.transactionNumber.delegate = self
        self.transactionType.delegate = self
        
        self.disputeTitleLabel.required()
        self.transactionNumberLabel.required()
        self.transactionTypeLabel.required()
        self.productsLabel.required()
        self.remarksLabel.required()

        setStrings()
    }
    
    func setStrings() {
        self.title = CaseStrings.title
        disputeTitleLabel.text = DisputeStrings.title
        transactionNumberLabel.text = DisputeStrings.number
        transactionNumber.placeholder = DisputeStrings.placeholder
        transactionTypeLabel.text = DisputeStrings.type
        
        productsLabel.text = DisputeStrings.products
        addButton.setTitle(DisputeStrings.add, forState: .Normal)
        
        remarksLabel.text = DisputeStrings.remarks
        
        submitButton.setTitle(DisputeStrings.submit, forState: .Normal)
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
        //seller@easyshop.ph
        //password
        var status: Int = 16
        if self.transactionType.text == DisputeStrings.refund {
            status == 10
        }
        
        let parameters: NSDictionary = [ "access_token": SessionManager.accessToken()
                                        ,"disputeTitle": self.disputeTitle.text
                                             ,"remarks": self.remarks.text
                                  ,"orderProductStatus": status
                                     ,"orderProductIds": self.productIDs]
        
        println(parameters)
        
        manager.POST(APIAtlas.postResolutionCenterAddCase, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.navigationController?.popViewControllerAnimated(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    println(error.userInfo)
//                if error.userInfo != nil {
//                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
//                        let errorDescription: String = jsonResult["error_description"] as! String
//                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorDescription)
//                    }
//                }
                
                if task.statusCode == 401 {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Mismatch username and password", title: "Login Failed")
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                self.hud?.hide(true)
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
            self.transactionNumber.inputView = pickerView
            self.transactionNumber.text = transactionIds[0]
        } else {
            self.transactionType.inputView = pickerView
            self.transactionType.text = transactionTypes[0]
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
        } else {
            self.transactionType.inputAccessoryView = toolBar
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
    
    // MARK: - Actions
    
    @IBAction func addAction(sender: AnyObject) {
        if self.transactionNumber.text != "" {
            let disputeAddItems = DisputeAddItemViewController(nibName: "DisputeAddItemViewController", bundle: nil)
            disputeAddItems.delegate = self
            disputeAddItems.transactionId = self.transactionNumber.text
            var root = UINavigationController(rootViewController: disputeAddItems)
            self.navigationController?.presentViewController(root, animated: true, completion: nil)
        }
    }
    
    func toolBarDoneAction() {
        self.transactionNumber.resignFirstResponder()
        self.transactionType.resignFirstResponder()
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
        manager.GET(APIAtlas.transactionLogs + "\(SessionManager.accessToken())", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.transactionModel = TransactionModel.parseDataFromDictionary(responseObject as! NSDictionary)
            
            for i in 0..<self.transactionModel.order_id.count {
                self.transactionIds.append(self.transactionModel.invoice_number[i])
            }
            self.tableView.reloadData()
            
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error.userInfo)
                
        })

    }
    
    // MARK: - Text Field delegate
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        if textField == self.transactionNumber {
            pickerType = "Number"
            addPickerView()
            addToolBarWithDoneTarget()
        } else if textField == self.transactionType {
            pickerType = "Type"
            addPickerView()
            addToolBarWithDoneTarget()
        }
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    // MARK: - Picker View Data Source and Delegate
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == "Type" {
            return self.transactionTypes.count
        }
        return self.transactionIds.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if pickerType == "Type" {
            return self.transactionTypes[row]
        }
        return self.transactionIds[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerType == "Type" {
            self.transactionType.text = transactionTypes[row]
        } else {
            self.transactionNumber.text = transactionIds[row]
        }
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
