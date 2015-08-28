//
//  AddAddressViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol AddAddressTableViewControllerDelegate {
    func addAddressTableViewController(didAddAddressSucceed addAddressTableViewController: AddAddressTableViewController)
}

class AddAddressTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, NewAddressTableViewCellDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let titles: [String] = ["Address Title:", "Unit No.:", "Building Name:", "Street No.:", "Street Name:", "Subdivision:", "Province:", "City:", "Barangay:", "Zip Code:", "Additional Info:"]
    
    var delegate: AddAddressTableViewControllerDelegate?
    
    let manager = APIManager.sharedInstance
    var provinceModel: ProvinceModel!
    var cityModel: CityModel!
    var barangayModel: BarangayModel!
    
    var idProvince: Int = 0
    var idCity: Int = 0
    var activeTextField: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.backButton()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        requestGetProvince()
    }
    
    func registerNib() {
        let nib: UINib = UINib(nibName: Constants.Checkout.newAddressTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: Constants.Checkout.newAddressTableViewCellNibNameAndIdentifier)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: NewAddressTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.newAddressTableViewCellNibNameAndIdentifier) as! NewAddressTableViewCell
        cell.rowTitleLabel.text = titles[indexPath.row]
        cell.tag = indexPath.row
        cell.delegate = self
        cell.rowTextField.addToolBarWithTarget(self, next: "next", previous: "previous", done: "done")
        if indexPath.row == 0 {
            cell.rowTextField.becomeFirstResponder()
        }
        
        if indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
            
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
            pickerView.delegate = self
            pickerView.dataSource = self
            cell.rowTextField.inputView = pickerView
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
    }
    
    func newAddressTableViewCell(didClickNext newAddressTableViewCell: NewAddressTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(newAddressTableViewCell)!
        
        if indexPath.row + 1 != self.titles.count {
            let nextIndexPath: NSIndexPath = NSIndexPath(forItem: indexPath.row + 1, inSection: indexPath.section)
            let cell: NewAddressTableViewCell = self.tableView.cellForRowAtIndexPath(nextIndexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
        
    }
    
    func newAddressTableViewCell(didClickPrevious newAddressTableViewCell: NewAddressTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(newAddressTableViewCell)!
        
        if indexPath.row - 1 != 0 {
            let nextIndexPath: NSIndexPath = NSIndexPath(forItem: indexPath.row - 1, inSection: indexPath.section)
            let cell: NewAddressTableViewCell = self.tableView.cellForRowAtIndexPath(nextIndexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
    }
    
    func newAddressTableViewCell(didBeginEditing newAddressTableViewCell: NewAddressTableViewCell, index: Int) {
        activeTextField = index
        
        if index == 6 && self.provinceModel != nil {
            setTextAtIndex(6, text: self.provinceModel.location[0])
        } else if index == 7 && self.cityModel != nil {
            setTextAtIndex(7, text: self.cityModel.location[0])
        } else if index == 8 && self.barangayModel != nil {
            setTextAtIndex(8, text: self.barangayModel.location[0])
        }
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
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "check", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func check() {
//        self.endEditing(true)
        var filledUpAllFields: Bool = true
        for i in 0..<10 {
            if getTextAtIndex(i) == "" {
                filledUpAllFields = false
            }
        }
        
        if filledUpAllFields {
            requestAddAddress()
        } else {
            showAlert(title: "Error", message: "All text fields must be filled up.")
        }

    }
    
    func done() {
        let row = NSIndexPath(forItem: activeTextField, inSection: 0)
        let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(row) as! NewAddressTableViewCell
        cell.rowTextField.endEditing(true)
        
        if activeTextField == 6 && getTextAtIndex(activeTextField) != "" {
            requestGetCities(idProvince)
        } else if activeTextField == 7 && getTextAtIndex(activeTextField) != "" {
            requestGetBarangay(idCity)
        }
        

    }
    
    func getTextAtIndex(index: Int) -> String {
        let row = NSIndexPath(forItem: index, inSection: 0)
        let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(row) as! NewAddressTableViewCell
        return cell.rowTextField.text
    }
    
    func setTextAtIndex(index: Int, text: String) {
        let row = NSIndexPath(forItem: index, inSection: 0)
        let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(row) as! NewAddressTableViewCell
        cell.rowTextField.text = text
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Requests
    
    func requestAddAddress() {
        SVProgressHUD.show()
        
        let url = "http://online.api.easydeal.ph/api/v1/auth/address/addNewAddress"
        let params = ["access_token": /*SessionManager.accessToken()*/"NmUxZjU5NjZjODdhYWZmMjY0NDE4YmI0YzQwMDc0NzIzYTM4MzI1NWJiMGFkNTNmNWM2N2ZiMzQyNGFlMGQ1Yg",
            "title": getTextAtIndex(0),
            "unitNumber": getTextAtIndex(1),
            "buildingName": getTextAtIndex(2),
            "streetNumber": getTextAtIndex(3),
            "streetName": getTextAtIndex(4),
            "subdivision": getTextAtIndex(5),
            "province": getTextAtIndex(6),
            "city": getTextAtIndex(7),
            "barangay": getTextAtIndex(8),
            "zipCode": getTextAtIndex(9),
            "addtionalInfo": getTextAtIndex(10),
        ]
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.showAlert(title: "Address successfully added", message: nil)
            SVProgressHUD.dismiss()
            self.delegate!.addAddressTableViewController(didAddAddressSucceed: self)
            self.navigationController!.popViewControllerAnimated(true)

            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken("add")
                } else {
                    self.showAlert(title: "Something went wrong", message: nil)
                    SVProgressHUD.dismiss()
                }
        })
    }
    
    func requestRefreshToken(type: String) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if type == "add" {
                self.requestAddAddress()
            } else if type == "update" {
                
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Something went wrong", message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func requestGetProvince() {
        let url: String = "http://online.api.easydeal.ph/api/v1/location/getAllProvinces"
        let manager = APIManager.sharedInstance
        
        manager.POST(url, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.provinceModel = ProvinceModel.parseDataWithDictionary(responseObject)
            println(self.provinceModel.location)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                self.showAlert(title: "Something went wrong", message: nil)
        })
    }
    
    func requestGetCities(id: Int) {
        let url: String = "http://online.api.easydeal.ph/api/v1/location/getChildCities"
        let manager = APIManager.sharedInstance
        let params = ["provinceId": String(id)]
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.cityModel = CityModel.parseDataWithDictionary(responseObject)
            println(self.cityModel.location)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                self.showAlert(title: "Something went wrong", message: nil)
        })
    }
    
    func requestGetBarangay(id: Int) {
        let url: String = "http://online.api.easydeal.ph/api/v1/location/getBarangaysByCity"
        let manager = APIManager.sharedInstance
        let params = ["cityId": String(id)]
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.barangayModel = BarangayModel.parseDataWithDictionary(responseObject)
            println(self.barangayModel.location)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                self.showAlert(title: "Something went wrong", message: nil)
        })
    }
    
    // MARK: - Picker
    
    func addPicker() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
//        self.attributeTextField.inputView = pickerView
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if activeTextField == 6 {
            setTextAtIndex(6, text: self.provinceModel.location[row])
            idProvince = self.provinceModel.provinceId[row]
        } else if activeTextField == 7 {
            setTextAtIndex(7, text: self.cityModel.location[row])
            idCity = self.cityModel.cityId[row]
        } else if activeTextField == 8 {
            setTextAtIndex(8, text: self.barangayModel.location[row])
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == 6 && self.provinceModel != nil {
            return self.provinceModel.location.count
        } else if activeTextField == 7 && self.cityModel != nil {
            return self.cityModel.location.count
        } else if activeTextField == 8 && self.barangayModel != nil  {
            return self.barangayModel.location.count
        }
        
        return 0
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if activeTextField == 6 {
            return self.provinceModel.location[row]
        } else if activeTextField == 7 {
            return self.cityModel.location[row]
        } else if activeTextField == 8 {
            return self.barangayModel.location[row]
        }
        
        return ""
    }
    
    // MARK: - Keyboard Toolbar Actions 
    
    func next() {
        
        if activeTextField + 1 != self.titles.count {
            let indexPath = NSIndexPath(forItem: activeTextField + 1, inSection: 0)
            let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
    }
    
    func previous() {
        if activeTextField - 1 != self.titles.count {
            let indexPath = NSIndexPath(forItem: activeTextField - 1, inSection: 0)
            let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
    }

}
