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
    var provinceModel: ProvinceModel = ProvinceModel()
    var cityModel: CityModel = CityModel()
    var barangayModel: BarangayModel = BarangayModel()
    
    var selectedProvince: String = ""
    var selectedCity: String = ""
    
    var addressModel: AddressModelV2 = AddressModelV2()
    var activeTextField: Int = 0
    var hud: MBProgressHUD?
    
    //for selected values in picker view
    var barangayRow: Int = 0
    var cityRow: Int = 0
    var provinceRow: Int = 0
    
    var isEdit: Bool = true
    
    var pickerView: UIPickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.backButton()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.requestGetProvince()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillAppear"), name: UIKeyboardDidShowNotification, object: nil)
    }
    
    func keyboardWillAppear() {
        self.pickerView.selectRow(2, inComponent: 0, animated: true)
        self.pickerView.hidden = true
    }
    
    //Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController!.view.addSubview(self.hud!)
        self.hud?.show(true)
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
        cell.selectionStyle = UITableViewCellSelectionStyle.None
      
        if self.isEdit {
            if indexPath.row == 0 {
                cell.rowTextField.text = self.addressModel.title
            } else if indexPath.row == 1 {
                cell.rowTextField.text = self.addressModel.unitNumber
            } else if indexPath.row == 2 {
                cell.rowTextField.text == self.addressModel.buildingName
            } else if indexPath.row == 3 {
                cell.rowTextField.text = self.addressModel.streetName
            } else if indexPath.row == 4 {
                cell.rowTextField.text = self.addressModel.subdivision
            } else if indexPath.row == 5 {
                cell.rowTextField.text = self.addressModel.province
            } else if indexPath.row == 6 {
                cell.rowTextField.text = self.addressModel.city
            } else if indexPath.row == 7 {
                cell.rowTextField.text = self.addressModel.barangay
            } else if indexPath.row == 8 {
                cell.rowTextField.text == self.addressModel.zipCode
            } else {
                cell.rowTextField.text = self.addressModel.additionalInfo
                isEdit = false
            }
        }
        
        
        if indexPath.row == 6 || indexPath.row == 7 || indexPath.row == 8 {
            let screenSize: CGRect = UIScreen.mainScreen().bounds
            pickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
            pickerView.delegate = self
            pickerView.dataSource = self
            cell.rowTextField.inputView = pickerView
            
            if indexPath.row == 6 {
                cell.rowTextField.text = self.addressModel.province
                
                if self.provinceModel.location.count != 0 {
                    for (index, uid) in enumerate(self.provinceModel.provinceId) {
                        if uid == self.addressModel.provinceId {
                            pickerView.selectRow(index, inComponent: 0, animated: true)
                            pickerView.reloadAllComponents()
                        }
                    }
                }
                
                
            } else if indexPath.row == 7 {
                cell.rowTextField.text = self.addressModel.city
                
                if self.cityModel.location.count != 0 {
                    for (index, uid) in enumerate(self.cityModel.cityId) {
                        if uid == self.addressModel.cityId {
                            pickerView.selectRow(index, inComponent: 0, animated: false)
                            pickerView.reloadAllComponents()
                        }
                    }
                }
                
            } else {
                cell.rowTextField.text = self.addressModel.barangay
                
                if self.barangayModel.location.count != 0 {
                    for (index, uid) in enumerate(self.barangayModel.barangayId) {
                        if uid == self.addressModel.barangayId {
                            pickerView.selectRow(index, inComponent: 0, animated: false)
                            pickerView.reloadAllComponents()
                        }
                    }
                }
            }
        }
        
        if indexPath.row == self.activeTextField {
            cell.rowTextField.becomeFirstResponder()
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
        self.showHUD()
    
        let params = ["access_token": SessionManager.accessToken(),
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
            "locationId": self.addressModel.barangayId
        ]
        
        manager.POST(APIAtlas.addAddressUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.hud?.hide(true)
                self.navigationController!.popViewControllerAnimated(true)
                self.delegate!.addAddressTableViewController(didAddAddressSucceed: self)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken("add")
                } else {
                    self.showAlert(title: "Something went wrong", message: nil)
                    self.hud?.hide(true)
                }
        })
    }
    
    func requestRefreshToken(type: String) {
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
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
        let manager = APIManager.sharedInstance
        self.showHUD()
        manager.POST(APIAtlas.provinceUrl, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.provinceModel = ProvinceModel.parseDataWithDictionary(responseObject)
            if self.provinceModel.location.count != 0 && self.addressModel.title == "" {
                self.addressModel.province = self.provinceModel.location[0]
                self.addressModel.provinceId = self.provinceModel.provinceId[0]
                self.requestGetCities(self.provinceModel.provinceId[0])
                self.provinceRow = 0
            } else {
                if self.addressModel.provinceId != 0 {
                    self.requestGetCities(self.addressModel.provinceId)
                } else {
                    self.requestGetCities(self.provinceModel.provinceId[0])
                }
                
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                self.showAlert(title: "Something went wrong", message: nil)
        })
    }
    
    func requestGetCities(id: Int) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let params = ["provinceId": String(id)]
        
        manager.POST(APIAtlas.citiesUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.cityModel = CityModel.parseDataWithDictionary(responseObject)
            self.hud?.hide(true)
                //get all cities and assign get the id and title of the first city
                if self.cityModel.cityId.count != 0 && self.addressModel.title == "" {
                    self.addressModel.city = self.cityModel.location[0]
                    self.addressModel.cityId = self.cityModel.cityId[0]
                    self.requestGetBarangay(self.addressModel.cityId)
                    self.addressModel.barangay = ""
                    self.cityRow = 0
                    self.barangayRow = 0
                } else {
                    if self.addressModel.cityId != 0 {
                        self.requestGetBarangay(self.addressModel.cityId)
                    } else {
                        self.requestGetBarangay(self.cityModel.cityId[0])
                    }
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                self.showAlert(title: "Something went wrong", message: nil)
        })
    }
    
    func requestGetBarangay(id: Int) {
        let manager = APIManager.sharedInstance
        let params = ["cityId": String(id)]
        self.showHUD()
        manager.POST(APIAtlas.barangay, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.hud?.hide(true)
                self.barangayModel = BarangayModel.parseDataWithDictionary(responseObject)
                if self.addressModel.title == "" {
                    self.addressModel.barangayId = self.barangayModel.barangayId[0]
                    self.addressModel.barangay = self.barangayModel.location[0]
                }
                self.tableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
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
            //get province title and id
            self.addressModel.provinceId = self.provinceModel.provinceId[row]
            self.addressModel.province = self.provinceModel.location[row]
            self.addressModel.city = ""
            //request for new city data model and reload tableview
            self.requestGetCities(self.addressModel.provinceId)
            
            //save current row and reset dependent values
            self.provinceRow = row
            self.cityRow = 0
            self.barangayRow = 0
        } else if activeTextField == 7 {
            self.addressModel.cityId = self.cityModel.cityId[row]
            self.requestGetBarangay(self.addressModel.cityId)
            self.addressModel.city = self.cityModel.location[row]
            //save current row and reset dependent values
            self.cityRow = row
            self.barangayRow = 0
        } else if activeTextField == 8 {
            self.setTextAtIndex(activeTextField, text: self.barangayModel.location[row])
            self.addressModel.barangay = self.barangayModel.location[row]
            self.addressModel.barangayId = self.barangayModel.barangayId[row]
            self.barangayRow = row
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if activeTextField == 6 {
            return self.provinceModel.location.count
        } else if activeTextField == 7 {
            return self.cityModel.location.count
        } else if activeTextField == 8 {
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
        if activeTextField != 0 {
            let indexPath = NSIndexPath(forItem: activeTextField - 1, inSection: 0)
            let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(indexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
        } else {
            self.tableView.endEditing(true)
        }
    }

}
