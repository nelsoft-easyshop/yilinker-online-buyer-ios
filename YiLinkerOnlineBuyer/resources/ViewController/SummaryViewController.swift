//
//  SummaryViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShipToTableViewCellDelegate, ChangeAddressViewControllerDelegate, GuestCheckoutTableViewCellDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, VoucherTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    var shipToTableViewCell: ShipToTableViewCell = ShipToTableViewCell()
    var cartItems: [CartProductDetailsModel] = []
    var totalPrice: String = ""
    var hud: MBProgressHUD?
    var isValidToSelectPayment: Bool = true
    var guestCheckoutTableViewCell: GuestCheckoutTableViewCell = GuestCheckoutTableViewCell()
    
    let guestCheckoutCellIdentifier = "GuestCheckoutTableViewCell"
    let guestCheckoutCellNibName = "GuestCheckoutTableViewCell"
    let voucherCellNibName = "VoucherTableViewCell"
    let totalCellNibName = "TotalSummaryPriceTableViewCell"
    let discountVouncherNibName = "DicountVoucherTableViewCell"
    let netTotalCellNibName = "NetTotalTableViewCell"
    let mapCellNibName = "MapTableViewCell"
    
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
    
    var additionalCellCount: Int = 2
    
    var voucherModel: VoucherModel = VoucherModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()

        if SessionManager.isLoggedIn() {
            self.tableView.layoutIfNeeded()
            
            if SessionManager.isMobileVerified() {
                self.fireSetCheckoutAddress("\(SessionManager.addressId())")
            }
            
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
    
    //MARK: - Register Nib
    func registerNib() {
        let orderSummaryNib: UINib = UINib(nibName: Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(orderSummaryNib, forCellReuseIdentifier: Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier)
        
        let shipToNib: UINib = UINib(nibName: Constants.Checkout.shipToTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(shipToNib, forCellReuseIdentifier: Constants.Checkout.shipToTableViewCellNibNameAndIdentifier)
        
        let guestCheckoutNib: UINib = UINib(nibName: self.guestCheckoutCellNibName, bundle: nil)
        self.tableView.registerNib(guestCheckoutNib, forCellReuseIdentifier: self.guestCheckoutCellNibName)
        
        let voucherNib: UINib = UINib(nibName: self.voucherCellNibName, bundle: nil)
        self.tableView.registerNib(voucherNib, forCellReuseIdentifier: self.voucherCellNibName)
        
        let totalNib: UINib = UINib(nibName: self.totalCellNibName, bundle: nil)
        self.tableView.registerNib(totalNib, forCellReuseIdentifier: self.totalCellNibName)
        
        let discountVouncherNib: UINib = UINib(nibName: self.discountVouncherNibName, bundle: nil)
        self.tableView.registerNib(discountVouncherNib, forCellReuseIdentifier: self.discountVouncherNibName)
        
        let netTotalNib: UINib = UINib(nibName: self.netTotalCellNibName, bundle: nil)
        self.tableView.registerNib(netTotalNib, forCellReuseIdentifier: self.netTotalCellNibName)
        
        let mapNib: UINib = UINib(nibName: self.mapCellNibName, bundle: nil)
        self.tableView.registerNib(mapNib, forCellReuseIdentifier: self.mapCellNibName)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Height For Header
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    //MARK: - Height For Header
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 41
        } else {
            return 17
        }
    }
    
    func changeAddressViewController(didSelectAddress address: String) {
        self.fireSetCheckoutAddress("\(SessionManager.addressId())")
        self.tableView.reloadData()
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
            return UIView(frame: CGRectZero)
        } else {
            return UIView(frame: CGRectZero)
        }
    }

    //MARK: - Cell For Row At IndexPath
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row < self.cartItems.count {
                let product: CartProductDetailsModel = self.cartItems[indexPath.row]
                let url = APIAtlas.baseUrl.stringByReplacingOccurrencesOfString("api/v1", withString: "")
                let orderSummaryCell: OrderSummaryTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier) as! OrderSummaryTableViewCell
                orderSummaryCell.productImageView.sd_setImageWithURL(NSURL(string: "\(url)\(APIAtlas.cartImage)\(product.selectedUnitImage)")!, placeholderImage: UIImage(named: "dummy-placeholder"))
                orderSummaryCell.itemTitleLabel.text = product.title
                orderSummaryCell.quantityLabel.text = "\(product.quantity)"
                
                for tempProductUnit in product.productUnits {
                    if product.unitId == tempProductUnit.productUnitId {
                        orderSummaryCell.priceLabel.text = tempProductUnit.discountedPrice.formatToTwoDecimal()
                        break
                    }
                }
                
                return orderSummaryCell
            } else if indexPath.row == ((self.cartItems.count - 1) + 1) {// 1 = to cell below the cart items
                let totalCell: TotalSummaryPriceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.totalCellNibName) as! TotalSummaryPriceTableViewCell
                
                    totalCell.totalPriceValueLabel.text = self.totalPrice.formatToPeso()
                
                 totalCell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 1000)
                return totalCell
            } else if indexPath.row == ((self.cartItems.count - 1) + 2)  {
                let voucherCell: VoucherTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.voucherCellNibName) as! VoucherTableViewCell
                voucherCell.delegate = self
                voucherCell.selectionStyle = UITableViewCellSelectionStyle.None
                return voucherCell
            } else if indexPath.row == ((self.cartItems.count - 1) + 3) {
                let discountTotalCell: DicountVoucherTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.discountVouncherNibName) as! DicountVoucherTableViewCell
                
                if self.voucherModel.isSuccessful {
                    println("Discount Value: ₱ \(self.voucherModel.less)")
                    discountTotalCell.discountVoucherLabel.text = "Discount Value: ₱ \(self.voucherModel.less)"
                } else {
                    discountTotalCell.discountVoucherLabel.text = "\(self.voucherModel.message)"
                    discountTotalCell.discountVoucherLabel.textAlignment = NSTextAlignment.Right
                    discountTotalCell.discountVoucherLabel.textColor = UIColor.redColor()
                }
               
                discountTotalCell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 1000)
                
                return discountTotalCell
            } else {
                let netTotalTableViewCell: NetTotalTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.netTotalCellNibName) as! NetTotalTableViewCell
                netTotalTableViewCell.netTotalValueLabel.text = self.voucherModel.voucherPrice.formatToPeso()
                return netTotalTableViewCell
            }
        } else {
            
            if indexPath.row == 0 {
                if SessionManager.isLoggedIn() {
                    self.shipToTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.shipToTableViewCellNibNameAndIdentifier) as! ShipToTableViewCell
                    shipToTableViewCell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, shipToTableViewCell.frame.size.height)
                    shipToTableViewCell.delegate = self
                    shipToTableViewCell.addressLabel.text = SessionManager.userFullAddress()
                    return shipToTableViewCell
                } else {
                    self.guestCheckoutTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.guestCheckoutCellIdentifier) as! GuestCheckoutTableViewCell
                    self.guestCheckoutTableViewCell.delegate = self
                    self.guestCheckoutTableViewCell.selectionStyle = UITableViewCellSelectionStyle.None
                    self.guestCheckoutTableViewCell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 1000)
                    for view in self.guestCheckoutTableViewCell.contentView.subviews {
                        if view.isKindOfClass(UITextField) {
                            let textField: UITextField = view as! UITextField
                            if !IphoneType.isIphone4() {
                                textField.addToolBarWithTarget(self, next: "next", previous: "previous:", done: "done")
                            }
                        }
                    }
                }
                
                return guestCheckoutTableViewCell
            } else {
                let mapCell: MapTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.mapCellNibName) as! MapTableViewCell
                let latitude: Double = SessionManager.latitude().toDouble()!
                let longitude: Double = SessionManager.longitude().toDouble()!
                mapCell.setLocation(latitude: latitude, longitude: longitude)
                return mapCell
            }
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
        
        if self.currentTextFieldTag == 5 {
            self.requestGetCities(self.addressModel.provinceId)
            self.addressModel.province = self.provinceModel.location[self.provinceRow]
            self.guestCheckoutTableViewCell.provinceTextField.text = self.provinceModel.location[self.provinceRow]
            self.cityRow = 0
            self.barangayRow = 0
        } else if self.currentTextFieldTag == 6 {
            self.requestGetBarangay(self.addressModel.cityId)
            self.guestCheckoutTableViewCell.cityTextField.text = self.cityModel.location[self.cityRow]
            self.addressModel.city = self.cityModel.location[self.cityRow]
            self.barangayRow = 0
        } else if self.currentTextFieldTag == 7 {
            self.addressModel.barangay = self.barangayModel.location[self.barangayRow]
            self.guestCheckoutTableViewCell.barangayTextField.text = self.barangayModel.location[self.barangayRow]
        }
    }
    
    //MARK: - Number Of Rows
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return cartItems.count + additionalCellCount
        } else {
           return 2
        }
    }
    
    //MARK: - Number Of Sections
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if SessionManager.isLoggedIn() {
            return 2
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            if indexPath.row == ((self.cartItems.count - 1) + 2) {
                return 59
            } else if indexPath.row == ((self.cartItems.count - 1) + 3) {
                return 34
            } else {
                return 71
            }

        } else {
            if indexPath.row == 0 {
                if SessionManager.isLoggedIn() {
                    return 130
                } else {
                    return 480
                }
            } else {
                return 199
            }
           
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
                self.isValidToSelectPayment = false
                self.displayAlertAndRedirectToChangeAddressWithMessage(jsonResult["message"] as! String)
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
                
                self.hud?.hide(true)
        })
    }
    
    //MARK: - Display Alert and Redirect to Address
    func displayAlertAndRedirectToChangeAddressWithMessage(message: String) {
        let alertController = UIAlertController(title: Constants.Localized.error, message: message, preferredStyle: .Alert)
        let OKAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (action) in
            Delay.delayWithDuration(0.0, completionHandler: { (success) -> Void in
                self.redirectToAddress()
            })
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    //MARK: - Mark Redirect To Address
    func redirectToAddress() {
        let changeAddressViewController: ChangeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController!.pushViewController(changeAddressViewController, animated: true)
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
                    if self.currentTextFieldTag == 0 {
                        contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag + 1))
                    } else {
                        contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag))
                    }
                    
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
                
                self.guestCheckoutTableViewCell.cityTextField.text = ""
                self.guestCheckoutTableViewCell.barangayTextField.text = ""
                self.guestCheckoutTableViewCell.provinceTextField.text = self.provinceModel.location[0]
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
        
        self.guestCheckoutTableViewCell.barangayTextField.text = ""
        
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
                self.guestCheckoutTableViewCell.cityTextField.text = self.cityModel.location[0]
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
            
            self.addressModel.barangayId = self.barangayModel.barangayId[0]
            self.addressModel.barangay = self.barangayModel.location[0]
            self.guestCheckoutTableViewCell.barangayTextField.text = self.barangayModel.location[0]
            
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
    
    //MARK: -
    //MARK: - Picker Data Source
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
        /*if self.addressPickerType == AddressPickerType.Barangay {
            self.barangayRow = row
            self.addressModel.barangayId = self.barangayModel.barangayId[row]
            self.addressModel.barangay = self.barangayModel.location[row]
            self.guestCheckoutTableViewCell.barangayTextField.text = self.barangayModel.location[row]
        } else if self.addressPickerType == AddressPickerType.Province  {
            self.addressModel.provinceId = self.provinceModel.provinceId[row]
            self.provinceRow = row
            self.requestGetCities(self.addressModel.provinceId)
            self.addressModel.province = self.provinceModel.location[row]
            self.guestCheckoutTableViewCell.provinceTextField.text = self.provinceModel.location[row]
        } else {
            self.addressModel.cityId = self.cityModel.cityId[row]
            self.cityRow = row
            self.requestGetBarangay(self.addressModel.cityId)
            self.guestCheckoutTableViewCell.cityTextField.text = self.cityModel.location[row]
            self.addressModel.city = self.cityModel.location[row]
        }*/
        
        if self.addressPickerType == AddressPickerType.Barangay {
            self.barangayRow = row
        } else if self.addressPickerType == AddressPickerType.Province  {
            self.addressModel.provinceId = self.provinceModel.provinceId[row]
            self.provinceRow = row
        } else {
            self.addressModel.cityId = self.cityModel.cityId[row]
            self.cityRow = row
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
            "user_address[title]": "Guest Address",
            "user_address[streetName]": self.guestCheckoutTableViewCell.streetNameTextField.text,
            "user_address[zipCode]": self.guestCheckoutTableViewCell.zipCodeTextField.text,
            "user_address[location]": "\(self.addressModel.barangayId)",
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
                let address: String = "\(self.guestCheckoutTableViewCell.streetNameTextField.text) \(self.addressModel.barangay) \(self.addressModel.city) \(self.addressModel.province)"
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
    
    //MARK: - Voucher Table View Cell Delegate
    func voucherTableViewCell(didTapAddButton cell: VoucherTableViewCell) {
        if cell.addButton.titleLabel!.text == "Add" {
            self.fireVoucher(cell)
        } else {
            self.voucherRequestNotSuccessful(cell)
        }
    }
    
    //MARK: Voucher Request Not Successful
    func voucherRequestNotSuccessful(cell: VoucherTableViewCell) {
        let rowCount: Int = self.additionalCellCount + self.cartItems.count
        cell.voucherTextField.enabled = true
        var indexPaths: [NSIndexPath] = []
        let totalCellAndVoucherIndexCount: Int = 2
        for var row = rowCount; row > self.cartItems.count + totalCellAndVoucherIndexCount; row-- {
            let indexPath: NSIndexPath = NSIndexPath(forRow: row - 1, inSection: 0)
            indexPaths.append(indexPath)
            self.additionalCellCount--
        }
        
        cell.voucherTextField.text = ""
        self.deActivateAddButton(cell.addButton)
        self.tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Left)
    }
    
    //MARK: Voucher Request Successful
    func voucherRequestIsSuccessful(cell: VoucherTableViewCell, voucherModel: VoucherModel) {
        cell.voucherTextField.enabled = false
        self.additionalCellCount++
        //Add Discount Value
        let cell: DicountVoucherTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.discountVouncherNibName) as! DicountVoucherTableViewCell
        
        
        var indexPaths: [NSIndexPath] = []
        let indexPath: NSIndexPath = NSIndexPath(forRow: self.additionalCellCount + (self.cartItems.count - 1), inSection: 0)
        indexPaths.append(indexPath)
        
        if self.voucherModel.isSuccessful || self.voucherModel.voucherPrice != "" {
            self.additionalCellCount++
            let indexPath2: NSIndexPath = NSIndexPath(forRow: self.additionalCellCount + (self.cartItems.count - 1), inSection: 0)
            indexPaths.append(indexPath2)
        }
        
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Left)
    }
    
    //MARK: Fire Voucher
    //f0150b95
    func fireVoucher(cell: VoucherTableViewCell) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        
        var parameters: NSDictionary = NSDictionary()
        
        if SessionManager.isLoggedIn() {
            parameters = ["access_token": SessionManager.accessToken(), "voucherCode": cell.voucherTextField.text]
        } else {
            parameters = ["voucherCode": cell.voucherTextField.text]
        }
        
        manager.GET(APIAtlas.voucherUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            self.voucherModel = VoucherModel.parseDataFromDictionary(responseObject as! NSDictionary)
            self.voucherRequestIsSuccessful(cell, voucherModel: self.voucherModel)
            self.changeButtonState(cell.addButton)
            
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.fireRefreshToken(CheckoutRefreshType.Voucher, cell: cell)
                } else if error.userInfo != nil {
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(jsonResult)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message)
                    }
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Error", title: "Something went wrong.")
                }
                
                self.hud?.hide(true)
        })
    }
    
    //MARK: - Voucher Table View Cell
    func voucherTableViewCell(textFieldDidChange cell: VoucherTableViewCell) {
        if count(cell.voucherTextField.text) >= 6 {
            self.activateAddButton(cell.addButton)
        } else {
            self.deActivateAddButton(cell.addButton)
        }
        
    }
    
    //MARK: - Change Button State
    func changeButtonState(button: UIButton) {
        if button.titleLabel!.text == "Add" {
            button.setTitle("Remove", forState: UIControlState.Normal)
            button.backgroundColor = UIColor.redColor()
        } else {
            button.setTitle("Add", forState: UIControlState.Normal)
            button.backgroundColor = Constants.Colors.appTheme
        }
    }
    
    //MARK: - Activate Button
    func activateAddButton(button: UIButton) {
        button.setTitle("Add", forState: UIControlState.Normal)
        button.backgroundColor = Constants.Colors.appTheme
        button.enabled = true
    }
    
    //MARK: - DeActivate Button
    func deActivateAddButton(button: UIButton) {
        button.setTitle("Add", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        button.enabled = false
    }
    
    //MARK: - Add User Map
    func userMapView() -> UIView {
        let containerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        let userMapView: UserMapView = XibHelper.puffViewWithNibName("UserMapView", index: 0) as! UserMapView
        userMapView.sendSubviewToBack(userMapView.mapView)
        userMapView.frame = CGRectMake(0, 40, self.view.frame.size.width, 184)
        containerView.addSubview(userMapView)
        return containerView
    }
    
    //MARK: - Refresh Token
    func fireRefreshToken(refreshType: CheckoutRefreshType, cell: VoucherTableViewCell) {
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID(), "client_secret": Constants.Credentials.clientSecret(), "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        self.showHUD()
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.hud?.hide(true)
            
            if refreshType == .Voucher {
                self.fireVoucher(cell)
            }
            
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    FBSDKLoginManager().logOut()
                    GPPSignIn.sharedInstance().signOut()
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.startPage()
                })
                
                self.hud?.hide(true)
        })
        
    }
    
}
