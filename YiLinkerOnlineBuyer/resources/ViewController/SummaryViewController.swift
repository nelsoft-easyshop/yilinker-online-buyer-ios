//
//  SummaryViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShipToTableViewCellDelegate, ChangeAddressViewControllerDelegate, GuestCheckoutTableViewCellDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var shipToTableViewCell: ShipToTableViewCell = ShipToTableViewCell()
    var cartItems: [CartProductDetailsModel] = []
    var totalPrice: String = ""
    var hud: MBProgressHUD?
    var isValidToSelectPayment: Bool = true
    var guestCheckoutTableViewCell: GuestCheckoutTableViewCell = GuestCheckoutTableViewCell()
    
    let guestCheckoutCellIdentifier = "GuestCheckoutTableViewCell"
    let guestCheckoutCellNibName = "GuestCheckoutTableViewCell"
    
    var currentTextFieldTag: Int = 0
    
    var provinceModel: ProvinceModel = ProvinceModel()
    var cityModel: CityModel = CityModel()
    var barangayModel: BarangayModel = BarangayModel()
    
    //for selected values in picker view
    var barangayRow: Int = 0
    var cityRow: Int = 0
    var provinceRow: Int = 0
    
    var addressPickerType: AddressPickerType = AddressPickerType.Barangay
    
    var addressModel: AddressModelV2 = AddressModelV2()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        
        if SessionManager.isLoggedIn() {
            self.tableView.layoutIfNeeded()
            self.tableView.tableFooterView = self.tableFooterView()
            self.tableView.tableFooterView!.frame = CGRectMake(0, 0, 0, self.tableView.tableFooterView!.frame.size.height)
            self.fireSetCheckoutAddress("\(SessionManager.addressId())")
        } else {
            self.requestGetProvince()
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
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func registerNib() {
        let orderSummaryNib: UINib = UINib(nibName: Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(orderSummaryNib, forCellReuseIdentifier: Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier)
        
        let shipToNib: UINib = UINib(nibName: Constants.Checkout.shipToTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(shipToNib, forCellReuseIdentifier: Constants.Checkout.shipToTableViewCellNibNameAndIdentifier)
        
        let guestCheckoutNib: UINib = UINib(nibName: self.guestCheckoutCellNibName, bundle: nil)
        self.tableView.registerNib(guestCheckoutNib, forCellReuseIdentifier: self.guestCheckoutCellNibName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }
    
    func tableFooterView() -> UIView {
        self.shipToTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.shipToTableViewCellNibNameAndIdentifier) as! ShipToTableViewCell
        shipToTableViewCell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, shipToTableViewCell.frame.size.height)
        shipToTableViewCell.delegate = self
        shipToTableViewCell.addressLabel.text = SessionManager.userFullAddress()
        return shipToTableViewCell
    }
    
    func changeAddressViewController(didSelectAddress address: String) {
        self.fireSetCheckoutAddress("\(SessionManager.addressId())")
        self.tableView.tableFooterView = self.tableFooterView()
    }

    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: CheckoutViews
        if section == 0 {
          headerView = XibHelper.puffViewWithNibName("CheckoutViews", index: 0) as! CheckoutViews
        } else {
          headerView = XibHelper.puffViewWithNibName("CheckoutViews", index: 2) as! CheckoutViews
        }
        
        headerView.backgroundColor = Constants.Colors.selectedCellColor
        
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView: CheckoutViews = XibHelper.puffViewWithNibName("CheckoutViews", index: 1) as! CheckoutViews
            footerView.totalPricelabel?.text = self.totalPrice
            return footerView
        } else {
            return UIView(frame: CGRectZero)
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let product: CartProductDetailsModel = self.cartItems[indexPath.row]
            let orderSummaryCell: OrderSummaryTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier) as! OrderSummaryTableViewCell
            orderSummaryCell.productImageView.sd_setImageWithURL(NSURL(string: product.images[0])!, placeholderImage: UIImage(named: "dummy-placeholder"))
            orderSummaryCell.itemTitleLabel.text = product.title
            orderSummaryCell.quantityLabel.text = "\(product.quantity)"
            
            for tempProductUnit in product.productUnits {
                if product.unitId == tempProductUnit.productUnitId {
                    orderSummaryCell.priceLabel.text = tempProductUnit.discountedPrice.formatToTwoDecimal()
                    break
                }
            }
            
            return orderSummaryCell
        } else {
            self.guestCheckoutTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.guestCheckoutCellIdentifier) as! GuestCheckoutTableViewCell
            self.guestCheckoutTableViewCell.delegate = self
            self.guestCheckoutTableViewCell.selectionStyle = UITableViewCellSelectionStyle.None
            
            for view in self.guestCheckoutTableViewCell.contentView.subviews {
                if view.isKindOfClass(UITextField) {
                    let textField: UITextField = view as! UITextField
                    if !IphoneType.isIphone4() {
                        textField.addToolBarWithTarget(self, next: "next", previous: "previous:", done: "done")
                    }
                }
            }
            
            return guestCheckoutTableViewCell
        }
    }
    
    func next() {
        self.guestCheckoutTableViewCell.setBecomesFirstResponder(self.currentTextFieldTag + 1)
    }
    
    func previous(sender: UITextField) {
        self.guestCheckoutTableViewCell.setBecomesFirstResponder(self.currentTextFieldTag - 1)
    }
    
    func done() {
        self.view.endEditing(true)
        var contentInset: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        UIView.animateWithDuration(0.5, animations: {
            self.tableView.contentInset = contentInset
            self.tableView.scrollIndicatorInsets = contentInset
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cartItems.count
        } else {
            return 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if SessionManager.isLoggedIn() {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 71
        } else {
            return 812
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func shipToTableViewCell(didTap shipToTableViewCell: ShipToTableViewCell) {
        shipToTableViewCell.fakeContainerView.backgroundColor = Constants.Colors.selectedCellColor
        
        let seconds = 0.5
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            shipToTableViewCell.fakeContainerView.backgroundColor = UIColor.whiteColor()
        })
        
        let changeAddressViewController: ChangeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController!.pushViewController(changeAddressViewController, animated: true)
    }
    
    func fireSetCheckoutAddress(addressId: String) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(), "address_id": "\(addressId)"]
        manager.POST(APIAtlas.setCheckoutAddressUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let jsonResult: Dictionary = responseObject as! Dictionary<String, AnyObject>!
            if jsonResult["isSuccessful"] as! Bool != true {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: jsonResult["message"] as! String)
                self.isValidToSelectPayment = false
            } else {
                self.isValidToSelectPayment = true
            }
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if error.userInfo != nil {
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(jsonResult)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message)
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
    
    //Guest Checkout Delegate
    func guestCheckoutTableViewCell(guestCheckoutTableViewCell: GuestCheckoutTableViewCell, didClickNext textfieldTag: Int, textField: UITextField) {
        self.next()
    }
    
    func guestCheckoutTableViewCell(guestCheckoutTableViewCell: GuestCheckoutTableViewCell, didClickDone textfieldTag: Int, textField: UITextField) {
        self.view.endEditing(true)
        self.fireGuestUser()
    }
    func guestCheckoutTableViewCell(guestCheckoutTableViewCell: GuestCheckoutTableViewCell, didStartEditingTextFieldWithTag textfieldTag: Int, textField: UITextField) {
        self.currentTextFieldTag = textfieldTag
        
        UIView.animateWithDuration(0.5, animations: {
            var contentInset: UIEdgeInsets = self.tableView.contentInset
            contentInset.top = 0.0
            if IphoneType.isIphone6Plus() {
               contentInset.top = contentInset.top - (50 * CGFloat(textfieldTag + 1))
            } else if IphoneType.isIphone6() {

                if textfieldTag == 13 {
                    contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag))
                } else {
                    contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag + 1))
                }
                
                
            } else if IphoneType.isIphone5() {
                if textfieldTag == 3 {
                    contentInset.top = contentInset.top - (50 * CGFloat(textfieldTag - 1)) - 120
                } else if textfieldTag == 13 {
                    contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag)) - 120
                } else if textfieldTag >= 8 {
                    contentInset.top = contentInset.top - (55 * CGFloat(textfieldTag)) - 120
                } else {
                    contentInset.top = contentInset.top - (45 * CGFloat(textfieldTag + 1)) - 120
                } 
            } else if IphoneType.isIphone4() {
                 let extraSpace: CGFloat = 150
//                if textfieldTag == 3 {
//                    contentInset.top = contentInset.top - (50 * CGFloat(textfieldTag - 1)) - extraSpace
//                } else if textfieldTag >= 8 {
//                    contentInset.top = contentInset.top - (55 * CGFloat(textfieldTag)) - extraSpace
//                } else {
//                    contentInset.top = contentInset.top - (45 * CGFloat(textfieldTag)) - extraSpace
//                }
                
                if textfieldTag >= 8 {
                    contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag)) - extraSpace
                } else {
                    if textField.tag == 3 {
                        contentInset.top = contentInset.top - (45 * CGFloat(textfieldTag)) - extraSpace                        
                    } else {
                        contentInset.top = contentInset.top - (45 * CGFloat(textfieldTag + 1)) - extraSpace
                    }
                    
                }
                
            }
                self.tableView.contentInset = contentInset
                self.tableView.scrollIndicatorInsets = contentInset
        })
        
        
        if textField == self.guestCheckoutTableViewCell.provinceTextField {
            self.guestCheckoutTableViewCell.provinceTextField.text = self.addressModel.province
            self.guestCheckoutTableViewCell.provinceTextField.inputView = self.addPicker(self.provinceRow)
            self.addressPickerType = AddressPickerType.Province
        } else if textField == self.guestCheckoutTableViewCell.cityTextField {
            self.guestCheckoutTableViewCell.cityTextField.text = self.addressModel.city
            self.guestCheckoutTableViewCell.cityTextField.inputView = self.addPicker(self.cityRow)
            self.addressPickerType = AddressPickerType.City
        } else if textField == self.guestCheckoutTableViewCell.barangayTextField {
            self.guestCheckoutTableViewCell.barangayTextField.text = self.addressModel.barangay
            self.guestCheckoutTableViewCell.barangayTextField.inputView = self.addPicker(self.barangayRow)
            self.addressPickerType = AddressPickerType.Barangay
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
        var contentInset: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.contentInset = contentInset
        self.tableView.scrollIndicatorInsets = contentInset
    }
    
    //Province
    func requestGetProvince() {
        let manager = APIManager.sharedInstance
        self.showHUD()
        manager.POST(APIAtlas.provinceUrl, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            self.provinceModel = ProvinceModel.parseDataWithDictionary(responseObject)
            if self.provinceModel.location.count != 0 {
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
            if self.cityModel.cityId.count != 0 {
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
                    self.addressModel.city = self.cityModel.location[0]
                    self.addressModel.cityId = self.cityModel.cityId[0]
                    self.requestGetBarangay(self.cityModel.cityId[0])
                }
            }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
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
            
            if self.addressModel.barangayId == 0 {
                self.addressModel.barangayId = self.barangayModel.barangayId[0]
                self.addressModel.barangay = self.barangayModel.location[0]
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
        })
    }
    
    func addPicker(selectedIndex: Int) -> UIPickerView {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let pickerView: UIPickerView = UIPickerView(frame:CGRectMake(0, 0, screenSize.width, 225))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(selectedIndex, inComponent: 0, animated: false)
        return pickerView
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.addressPickerType == AddressPickerType.Barangay {
            return self.barangayModel.location.count
        } else if self.addressPickerType == AddressPickerType.Province  {
            return self.provinceModel.location.count
        } else {
            return self.cityModel.location.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if self.addressPickerType == AddressPickerType.Barangay {
            return self.barangayModel.location[row]
        } else if self.addressPickerType == AddressPickerType.Province  {
            return self.provinceModel.location[row]
        } else {
            return self.cityModel.location[row]
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.addressPickerType == AddressPickerType.Barangay {
            self.barangayRow = row
            self.addressModel.barangayId = self.barangayModel.barangayId[row]
            self.guestCheckoutTableViewCell.barangayTextField.text = self.barangayModel.location[row]
        } else if self.addressPickerType == AddressPickerType.Province  {
            self.addressModel.provinceId = self.provinceModel.provinceId[row]
            self.provinceRow = row
            self.requestGetCities(self.addressModel.provinceId)
            self.guestCheckoutTableViewCell.provinceTextField.text = self.provinceModel.location[row]
        } else {
            self.addressModel.cityId = self.cityModel.cityId[row]
            self.cityRow = row
            self.requestGetBarangay(self.addressModel.cityId)
            self.guestCheckoutTableViewCell.cityTextField.text = self.cityModel.location[row]
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func fireGuestUser() {
        let manager = APIManager.sharedInstance
        let params = ["user_guest[firstName]": self.guestCheckoutTableViewCell.firstNameTextField.text,
        "user_guest[lastName]": self.guestCheckoutTableViewCell.lastNameTextField.text,
        "user_guest[email]": self.guestCheckoutTableViewCell.emailTextField.text,
        "user_guest[contactNumber]": self.guestCheckoutTableViewCell.mobileNumberTextField.text,
        "user_address[title]": "Default Address",
        "user_address[unitNumber]": self.guestCheckoutTableViewCell.unitNumberTextField.text,
        "user_address[buildingName]": self.guestCheckoutTableViewCell.buildingNumberTextField.text,
        "user_address[streetNumber]": self.guestCheckoutTableViewCell.streetNumberTextField.text,
        "user_address[streetName]": self.guestCheckoutTableViewCell.streetNameTextField.text,
        "user_address[subdivision]": self.guestCheckoutTableViewCell.subdivisionTextField.text,
        "user_address[zipCode]": self.guestCheckoutTableViewCell.zipCodeTextField.text,
        "user_address[isDefault]": true]
        
        self.showHUD()
        SessionManager.loadCookies()
        manager.POST(APIAtlas.guestUserUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            println(responseObject)
            let dictionary: NSDictionary = responseObject as! NSDictionary
            
            let isSuccessful: Bool = dictionary["isSuccessful"] as! Bool
            
            if isSuccessful {
                let address: String = "\(self.addressModel.unitNumber) \(self.addressModel.buildingName) \(self.addressModel.streetNumber), \(self.addressModel.streetName) \(self.addressModel.subdivision) \(self.addressModel.barangay) \(self.addressModel.city) \(self.addressModel.province)"
                let fullName: String = "\(self.guestCheckoutTableViewCell.firstNameTextField.text) \(self.guestCheckoutTableViewCell.lastNameTextField.text)"
                SessionManager.setUserFullName(fullName)
                SessionManager.setFullAddress(address)
                
                let checkoutContainerViewController: CheckoutContainerViewController = self.parentViewController as! CheckoutContainerViewController
                checkoutContainerViewController.isValidGuestUser = true
                checkoutContainerViewController.guestEmail = self.guestCheckoutTableViewCell.emailTextField.text
                checkoutContainerViewController.saveAndContinue(checkoutContainerViewController.continueButton)
            } else {
                let message: String = dictionary["message"] as! String
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: message)
            }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
        })
    }
    
}
