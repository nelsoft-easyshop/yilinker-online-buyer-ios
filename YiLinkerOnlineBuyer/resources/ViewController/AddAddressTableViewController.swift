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

class AddAddressTableViewController: UITableViewController, UITableViewDelegate, UITableViewDataSource, NewAddressTableViewCellDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let mapCellNibName = "MapTableViewCell"
    
    let titles: [String] = ["\(AddressStrings.addressTitle):", "\(AddressStrings.address):", "\(AddressStrings.province):", "\(AddressStrings.city):", "\(AddressStrings.barangay):", "\(AddressStrings.zipCode):"]
    
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
    var isEdit2: Bool = true
    var isIndexReady: Bool = false
    
    var pickerView: UIPickerView = UIPickerView()
    var addressCellReference = [NewAddressTableViewCell?]()
    
    var rowForPicker: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        self.backButton()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.requestGetProvince()
       
        if self.isEdit {
            self.title = AddressStrings.editAddress
        } else {
            self.title = AddressStrings.addAddress
        }
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
        
        let mapNib: UINib = UINib(nibName: self.mapCellNibName, bundle: nil)
        self.tableView.registerNib(mapNib, forCellReuseIdentifier: self.mapCellNibName)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row < 6 {
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
                    cell.rowTextField.text = self.addressModel.streetName
                } else if indexPath.row == 2 {
                    cell.rowTextField.text = self.addressModel.province
                } else if indexPath.row == 3 {
                    cell.rowTextField.text = self.addressModel.city
                } else if indexPath.row == 4 {
                    cell.rowTextField.text = self.addressModel.barangay
                } else if indexPath.row == 5 {
                    cell.rowTextField.text = self.addressModel.zipCode
                }
            }
            
            if indexPath.row != 5 {
               cell.rowTitleLabel.required()
            }
            
            addressCellReference.append(cell)
            
            return cell
        } else {
            let mapCell: MapTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.mapCellNibName) as! MapTableViewCell
            return mapCell
        }
    }
    
    //MARK: - Height For Row At Index Path
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row < 6 {
            return 41
        } else {
            //map height
            return 199
        }
    }
    
    //MARK: - Add Picker
    func addPicker(selectedIndex: Int, textField: UITextField) {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        textField.inputView = pickerView
    }
    
    //MARK: - Picker Data Source
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.activeTextField == 2 {
            return self.provinceModel.location.count
        } else if self.activeTextField == 3 {
            return self.cityModel.location.count
        } else {
            return self.barangayModel.location.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if self.activeTextField == 2 {
            return self.provinceModel.location[row]
        } else if self.activeTextField == 3 {
            return self.cityModel.location[row]
        } else {
            return self.barangayModel.location[row]
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.rowForPicker = row
    }
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.titles.count + 1// + mapCell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func newAddressTableViewCell(didClickNext newAddressTableViewCell: NewAddressTableViewCell) {
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(newAddressTableViewCell)!
        
        if indexPath.row + 1 != self.titles.count {
            let nextIndexPath: NSIndexPath = NSIndexPath(forItem: indexPath.row + 1, inSection: indexPath.section)
            let cell: NewAddressTableViewCell = self.tableView.cellForRowAtIndexPath(nextIndexPath) as! NewAddressTableViewCell
            cell.rowTextField.becomeFirstResponder()
            
            if indexPath.row == 2 {
                self.addPicker(self.provinceRow, textField: cell.rowTextField)
            } else if indexPath.row == 3 {
                self.addPicker(self.cityRow, textField: cell.rowTextField)
            } else if indexPath.row == 4 {
                self.addPicker(self.barangayRow, textField: cell.rowTextField)
            }
            
        } else {
            
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
        
        let indexPath: NSIndexPath = self.tableView.indexPathForCell(newAddressTableViewCell)!
        
        let cell: NewAddressTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! NewAddressTableViewCell
        
        if indexPath.row == 2 {
            self.addPicker(self.provinceRow, textField: cell.rowTextField)
        } else if indexPath.row == 3 {
            self.addPicker(self.cityRow, textField: cell.rowTextField)
        } else if indexPath.row == 4 {
            self.addPicker(self.barangayRow, textField: cell.rowTextField)
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
    
    //MARK: - Check
    func check() {
        self.addressModel.title = getTextAtIndex(0)
        self.addressModel.streetName =  getTextAtIndex(1)
        self.addressModel.zipCode = getTextAtIndex(5)

        
        if self.addressModel.title == "" {
            showAlert(title: AddressStrings.incompleteInformation, message: AddressStrings.addressTitleRequired)
        } else if self.addressModel.streetName == "" {
            showAlert(title: AddressStrings.incompleteInformation, message: AddressStrings.streetNameRequired)
        } else {
            if self.isEdit2 {
                self.fireEditAddress()
            } else {
                requestAddAddress()
            }
        }
        
    }
    
    func done() {
        let row = NSIndexPath(forItem: activeTextField, inSection: 0)
        let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(row) as! NewAddressTableViewCell
        cell.rowTextField.endEditing(true)
        
        
        if activeTextField == 2 {
            //get province title and id
            self.addressModel.provinceId = self.provinceModel.provinceId[self.rowForPicker]
            self.addressModel.province = self.provinceModel.location[self.rowForPicker]
            self.addressModel.city = ""
            //request for new city data model and reload tableview
            self.requestGetCities(self.addressModel.provinceId)
            
            //save current row and reset dependent values
            self.provinceRow = self.rowForPicker
            self.cityRow = 0
            self.barangayRow = 0
            self.setTextAtIndex(2, text: self.provinceModel.location[self.rowForPicker])
            self.rowForPicker = 0
        } else if activeTextField == 3 {
            self.addressModel.cityId = self.cityModel.cityId[self.rowForPicker]
            self.requestGetBarangay(self.addressModel.cityId)
            self.addressModel.city = self.cityModel.location[self.rowForPicker]
            //save current row and reset dependent values
            self.cityRow = self.rowForPicker
            self.barangayRow = 0
            self.setTextAtIndex(3, text: self.cityModel.location[self.rowForPicker])
            self.rowForPicker = 0
        } else if activeTextField == 4 {
            self.setTextAtIndex(activeTextField, text: self.barangayModel.location[self.rowForPicker])
            self.addressModel.barangay = self.barangayModel.location[self.rowForPicker]
            self.addressModel.barangayId = self.barangayModel.barangayId[self.rowForPicker]
            self.barangayRow = self.rowForPicker
            self.setTextAtIndex(4, text: self.barangayModel.location[self.rowForPicker])
            self.rowForPicker = 0
        }

    }
    
    func getTextAtIndex(index: Int) -> String {
        // Fix for Issue #303
        //let row = NSIndexPath(forItem: index, inSection: 0)
        let cell: NewAddressTableViewCell = //tableView.cellForRowAtIndexPath(row) as! NewAddressTableViewCell
            addressCellReference[index]!
        return cell.rowTextField.text
    }
    
    func setTextAtIndex(index: Int, text: String) {
        let row = NSIndexPath(forItem: index, inSection: 0)
        let cell: NewAddressTableViewCell = tableView.cellForRowAtIndexPath(row) as! NewAddressTableViewCell
        cell.rowTextField.text = text
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Requests
   func requestAddAddress() {
        self.showHUD()
    
        let indexPath: NSIndexPath = NSIndexPath(forRow: 6, inSection: 0)
        let cell: MapTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! MapTableViewCell
    
        let params = ["access_token": SessionManager.accessToken(),
            "title": getTextAtIndex(0),
            "streetName": getTextAtIndex(1),
            "province": getTextAtIndex(2),
            "city": getTextAtIndex(3),
            "barangay": getTextAtIndex(4),
            "zipCode": getTextAtIndex(5),
            "locationId": self.addressModel.barangayId,
            "longitude":cell.longitude(),
            "latitude":cell.latitude()
        ]
        
        manager.POST(APIAtlas.addAddressUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.hud?.hide(true)
                self.navigationController!.popViewControllerAnimated(true)
                self.delegate!.addAddressTableViewController(didAddAddressSucceed: self)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken(AddressRefreshType.Create)
                } else {
                    self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                    self.hud?.hide(true)
                }
        })
    }
    
    func fireEditAddress() {
        self.showHUD()
        
        let params = ["access_token": SessionManager.accessToken(),
            "title": getTextAtIndex(0),
            "streetName": getTextAtIndex(1),
            "province": getTextAtIndex(2),
            "city": getTextAtIndex(3),
            "barangay": getTextAtIndex(4),
            "zipCode": getTextAtIndex(5),
            "locationId": self.addressModel.barangayId,
            "userAddressId": self.addressModel.userAddressId
        ]
        
        manager.POST(APIAtlas.editAddress, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.navigationController!.popViewControllerAnimated(true)
            self.delegate!.addAddressTableViewController(didAddAddressSucceed: self)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                } else if task.statusCode == 401 {
                    self.requestRefreshToken(AddressRefreshType.Edit)
                } else {
                    self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                    self.hud?.hide(true)
                }
        })
    }
    
    func requestRefreshToken(type: AddressRefreshType) {
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if type == AddressRefreshType.Create {
                self.requestAddAddress()
            } else if type == AddressRefreshType.Edit {
                self.fireEditAddress()
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let alertController = UIAlertController(title: Constants.Localized.someThingWentWrong, message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
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
                self.setTextAtIndex(2, text: self.provinceModel.location[0])
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
                self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
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
                    self.addressModel.barangayId = 0
                    self.requestGetBarangay(self.addressModel.cityId)
                    self.addressModel.barangay = ""
                    self.cityRow = 0
                    self.barangayRow = 0
                    self.setTextAtIndex(3, text: self.cityModel.location[0])
                } else {
                    if self.addressModel.cityId != 0 {
                        self.requestGetBarangay(self.addressModel.cityId)
                    } else {
                        self.addressModel.city = self.cityModel.location[0]
                        self.addressModel.cityId = self.cityModel.cityId[0]
                        self.requestGetBarangay(self.cityModel.cityId[0])
                    }
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                
                if let task = task.response as? NSHTTPURLResponse {
                    if error.userInfo != nil {
                        if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                            let errorDescription: String = jsonResult["error_description"] as! String
                            Toast.displayToastWithMessage(errorDescription, duration: 3.0, view: self.view)
                        }
                    } else {
                        if task.statusCode == 401 {
                            Toast.displayToastWithMessage(LoginStrings.mismatch, duration: 3.0, view: self.view)
                        } else {
                            Toast.displayToastWithMessage(Constants.Localized.someThingWentWrong, duration: 3.0, view: self.view)
                        }
                    }
                }
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
            
                if self.barangayModel.barangayId.count != 0 && self.addressModel.barangayId == 0 {
                    self.addressModel.barangayId = self.barangayModel.barangayId[0]
                    self.addressModel.barangay = self.barangayModel.location[0]
                    self.setTextAtIndex(4, text: self.barangayModel.location[0])
                } else {
                    
                }
            
            if self.isIndexReady == false && self.isEdit2 {
                self.isIndexReady = true
                self.defaultIndexes()
            }
            
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
        })
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

    //MARK: - Default Indexes
    func defaultIndexes() {
        for (index, uid) in enumerate(self.provinceModel.provinceId) {
            if uid == self.addressModel.provinceId {
                self.provinceRow = index
            }
        }
        
        for (index, uid) in enumerate(self.cityModel.cityId) {
            if uid == self.addressModel.cityId {
                self.cityRow = index
            }
        }
        
        for (i, location) in enumerate(self.barangayModel.location) {
            if location == self.addressModel.barangay {
                self.barangayRow = i
            }
        }
    }
}
