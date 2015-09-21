//
//  NewDisputeTableViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by @EasyShop.ph on 9/15/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class NewDisputeTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, DisputeAddItemViewControllerDelegate {
    
    @IBOutlet weak var disputeTitle: UITextField!
    @IBOutlet weak var transactionNumber: UITextField!
    @IBOutlet weak var transactionType: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var remarks: UITextView!
    @IBOutlet weak var submitButton: UIButton!
    
    var transactionModel: TransactionModel!
    var transactionIds: [String] = []
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
        fireSubmitCase()
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Post methods
    func fireSubmitCase() {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary =
        [ "access_token": SessionManager.accessToken()
            ,"disputeTitle": self.disputeTitle.text
            ,"remarks": self.remarks.text
            ,"orderProductStatus": "10"
            ,"orderProductIds": "[2,3,4]"]
        println(parameters)
        
        manager.POST(APIAtlas.postResolutionCenterAddCase, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if error.userInfo != nil {
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        let errorDescription: String = jsonResult["error_description"] as! String
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorDescription)
                    }
                }
                
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
//        pickerView.selectRow(0, inComponent: 0, animated: false)
        self.transactionNumber.inputView = pickerView
        self.transactionNumber.text = transactionIds[0]
    }
    
    func addToolBarWithDoneTarget() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.Black
        toolBar.barTintColor = Constants.Colors.appTheme
        toolBar.tintColor = UIColor.whiteColor()
        
        let doneItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "toolBarDoneAction")
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        var toolbarButtons = [flexibleSpace, doneItem]
        
        //Put the buttons into the ToolBar and display the tool bar
        toolBar.setItems(toolbarButtons, animated: false)
        
        self.transactionNumber.inputAccessoryView = toolBar
        
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
        cell.textLabel?.font = UIFont(name: "Panton", size: 14.0)
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
            addPickerView()
            addToolBarWithDoneTarget()
        }
        
    }
    
    // MARK: - Picker View Data Source and Delegate
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return self.transactionIds.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return self.transactionIds[row]
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.transactionNumber.text = transactionIds[row]
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
