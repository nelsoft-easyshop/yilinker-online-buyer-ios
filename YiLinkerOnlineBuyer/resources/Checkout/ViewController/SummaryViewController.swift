//
//  SummaryViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShipToTableViewCellDelegate, ChangeAddressViewControllerDelegate, GuestCheckoutTableViewCellDelegate, UIScrollViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, VoucherTableViewCellDelegate, IncompleteRequirementsTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    //Cells
    var shipToTableViewCell: ShipToTableViewCell = ShipToTableViewCell()
    var guestCheckoutTableViewCell: GuestCheckoutTableViewCell = GuestCheckoutTableViewCell()
    
    //Identifiers
    let guestCheckoutCellIdentifier = "GuestCheckoutTableViewCell"
    let guestCheckoutCellNibName = "GuestCheckoutTableViewCell"
    let voucherCellNibName = "VoucherTableViewCell"
    let totalCellNibName = "TotalSummaryPriceTableViewCell"
    let discountVouncherNibName = "DicountVoucherTableViewCell"
    let netTotalCellNibName = "NetTotalTableViewCell"
    let mapCellNibName = "MapTableViewCell"
    
    //active textfield in guest checkout
    var currentTextFieldTag: Int = 0
    
    var totalPrice: String = ""
    var deliveryFee: String = ""
    var hasFlashSaleItem: Bool = false
    
    var yiHud: YiHUD?
    
    var cartItems: [CartProductDetailsModel] = []
    var addressPickerType: AddressPickerType = AddressPickerType.Barangay
    
    var voucherModel: VoucherModel = VoucherModel()
    
    //number of rows above voucher cell
    var additionalCellCount: Int = 2
    
    var checkoutContainerViewController: CheckoutContainerViewController = CheckoutContainerViewController()
    
    var isIncompleteInformation: Bool = true
    
    let kHalfSecond: NSTimeInterval = 0.5
    
    var firstName: String = ""
    var lastName: String = ""
    var mobileNumber: String = ""
    var email: String = ""
    
    //MARK: - 
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        
        //Get the parent view controller
        self.checkoutContainerViewController = self.parentViewController as! CheckoutContainerViewController
        
        self.tableView.estimatedRowHeight = 68.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        /*
            First check if the user is loged in. If yes set the checkout address of the user, get the address id of the user in our session manager and 
            pass it to the setCheckout address func on our parentController.
        */
        
        if SessionManager.isLoggedIn() {
            self.tableView.layoutIfNeeded()
            self.checkoutContainerViewController.fireSetCheckoutAddressWithAddressId("\(SessionManager.addressId())")
        } else {
           self.checkoutContainerViewController.fireProvinces()
        }
        
        if SessionManager.mobileNumber() != "" && SessionManager.firstName() != "" && SessionManager.lastName() != "" && SessionManager.emailAddress() != "" {
            self.isIncompleteInformation = false
        }
        
        if SessionManager.firstName() != "" {
            self.firstName = SessionManager.firstName()
        }
        
        if SessionManager.lastName() != "" {
            self.lastName = SessionManager.lastName()
        }
        
        if SessionManager.emailAddress() != "" {
            self.email = SessionManager.emailAddress()
        }
        
        if SessionManager.mobileNumber() != "" {
            self.mobileNumber = SessionManager.mobileNumber()
        }
        
        self.tableView.reloadData()
        
        if self.hasFlashSaleItem {
            self.voucherRequestIsSuccessful(VoucherModel(isSuccessful: false, less: "", originalPrice: "", voucherPrice: "", message: "Voucher is not allowed for promo items"))
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    //MARK: - Show HUD
    func showHUD() {
       self.yiHud = YiHUD.initHud()
       self.yiHud!.showHUDToView(self.view)
    }
    
    //MARK: -
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
        
        let incompeleteInformationNib: UINib = UINib(nibName: IncompleteRequirementsTableViewCell.nibNameAndIdentifier(), bundle: nil)
        self.tableView.registerNib(incompeleteInformationNib, forCellReuseIdentifier: IncompleteRequirementsTableViewCell.nibNameAndIdentifier())
    }
    
    //MARK: -
    //MARK: - Change Address View Controller
    func changeAddressViewController(didSelectAddress address: String) {
        self.checkoutContainerViewController.fireSetCheckoutAddressWithAddressId("\(SessionManager.addressId())")
        self.tableView.reloadData()
    }

    //MARK: -
    //MARK: - Table View Data Source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            if indexPath.row < self.cartItems.count {
                //Make a func for creating orderSemmaryTableViewCell for cleaner code.
                return self.orderSummaryTableViewCellWithIndexPath(indexPath)
            } else if indexPath.row == self.cartItems.count {// 1 = to cell below the cart items
                
                return self.totalSummaryPriceTableViewCellWithIndexPath(indexPath)
            } else if indexPath.row == (self.cartItems.count + 1)  {
                
                return self.voucherTableViewCellWithIndexPath(indexPath)
            } else if indexPath.row == (self.cartItems.count + 2) {
                
                return self.discountVoucherTotalViewCellWithIndexPath(indexPath)
            } else {
                let netTotalTableViewCell: NetTotalTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.netTotalCellNibName) as! NetTotalTableViewCell
                netTotalTableViewCell.netTotalValueLabel.text = self.voucherModel.voucherPrice.formatToTwoDecimal()
                return netTotalTableViewCell
            }
        } else {
            if !self.isIncompleteInformation && SessionManager.isLoggedIn() {
               return self.cellWithPath(indexPath)
            } else {
                if indexPath.section == 1 {
                    if SessionManager.isLoggedIn() {
                        return self.incompleteRequirementsTableViewCellWithIndexPath(indexPath)
                    } else {
                        return self.guestCheckoutTableViewCellWithindexPath(indexPath)
                    }
                } else {
                    return self.cellWithPath(indexPath)
                }
            }
        }
    }
    
    func cellWithPath(indexPath: NSIndexPath) -> UITableViewCell {
        if SessionManager.isLoggedIn() {
            return self.shipToTableViewCellWithIndexPath(indexPath)
        } else {
            return self.guestCheckoutTableViewCellWithindexPath(indexPath)
        }
        
//        if indexPath.row == 0 {
//            if SessionManager.isLoggedIn() {
//                return self.shipToTableViewCellWithIndexPath(indexPath)
//            } else {
//                return self.guestCheckoutTableViewCellWithindexPath(indexPath)
//            }
//            
//        } else {
//            return self.mapTableViewCellWithIndexPath(indexPath)
//        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 41
        } else {
            return 17
        }
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

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !self.isIncompleteInformation {
            if section == 0 {
                return cartItems.count + additionalCellCount
            } else {
                return 1
            }
        } else {
            if section == 0 {
                return cartItems.count + additionalCellCount
            } else if section == 1 {
                return 1
            } else {
                return 2
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if SessionManager.isLoggedIn() {
            if self.isIncompleteInformation {
                return 3
            } else {
                return 2
            }
        } else {
            return 2
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let kIncompleteInformationCellHeight: CGFloat = 170
        let kVoucherCellHeight: CGFloat = 60
        let kVoucherNetTotalCellHeight: CGFloat = 34
        let kGuestCheckoutForm: CGFloat = 480
        let kMapCellHeight: CGFloat = 199
        let kCheckoutAddressHeight: CGFloat = 130
        
        if indexPath.section == 0 {
            if indexPath.row == ((self.cartItems.count) + 1) {
                return kVoucherCellHeight
            } else if indexPath.row == ((self.cartItems.count) + 2) {
                return kVoucherNetTotalCellHeight
            } else {
                return UITableViewAutomaticDimension
            }
            
        } else {
            if SessionManager.isLoggedIn() {
                if indexPath.row == 0 {
                    if self.isIncompleteInformation {
                        if indexPath.section == 1 {
                            return kIncompleteInformationCellHeight
                        } else {
                            return kCheckoutAddressHeight
                        }
                    } else {
                        return kCheckoutAddressHeight
                    }
                } else {
                    return kMapCellHeight
                }
            } else {
                return kGuestCheckoutForm
            }
        }
    }
    
    //MARK: - 
    //MARK: - Table View Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    //MARK: - 
    //MARK: - Next
    func next() {
        self.guestCheckoutTableViewCell.setBecomesFirstResponder(self.currentTextFieldTag + 1)
    }
    
    //MARK: -
    //MARK: - Previous
    func previous(sender: UITextField) {
        self.guestCheckoutTableViewCell.setBecomesFirstResponder(self.currentTextFieldTag - 1)
    }
    
    //MARK: -
    //MARK: - Done
    func done() {
        self.view.endEditing(true)
        var contentInset: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        
        UIView.animateWithDuration(0.5, animations: {
            self.tableView.contentInset = contentInset
            self.tableView.scrollIndicatorInsets = contentInset
        })
        
        if self.currentTextFieldTag == 5 {
            self.checkoutContainerViewController.fireCitiesWithProvinceId("\(self.checkoutContainerViewController.addressModel.provinceId)")
            self.checkoutContainerViewController.addressModel.province = self.checkoutContainerViewController.provinceModel.location[self.checkoutContainerViewController.provinceRow]
            self.guestCheckoutTableViewCell.provinceTextField.text = self.checkoutContainerViewController.provinceModel.location[self.checkoutContainerViewController.provinceRow]
            
            self.checkoutContainerViewController.cityRow = 0
            self.checkoutContainerViewController.barangayRow = 0
        } else if self.currentTextFieldTag == 6 {
            self.checkoutContainerViewController.fireBarangaysWithCityId("\(self.checkoutContainerViewController.addressModel.cityId)")
            self.guestCheckoutTableViewCell.cityTextField.text = self.checkoutContainerViewController.cityModel.location[self.checkoutContainerViewController.cityRow]
            self.checkoutContainerViewController.addressModel.city = self.checkoutContainerViewController.cityModel.location[self.checkoutContainerViewController.cityRow]
            self.checkoutContainerViewController.barangayRow = 0
        } else if self.currentTextFieldTag == 7 {
            self.checkoutContainerViewController.addressModel.barangay = self.checkoutContainerViewController.barangayModel.location[self.checkoutContainerViewController.barangayRow]
            self.guestCheckoutTableViewCell.barangayTextField.text = self.checkoutContainerViewController.barangayModel.location[self.checkoutContainerViewController.barangayRow]
        }
    }
    
    //MARK: -
    //MARK: - Ship To TableViewCell
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
    
    
    //MARK: -
    //MARK: - Display Alert And Redirect To Change Address With Message
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
    
    //MARK: -
    //MARK: - Mark Redirect To Address
    func redirectToAddress() {
        let changeAddressViewController: ChangeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController!.pushViewController(changeAddressViewController, animated: true)
    }
    
    //MARK: -
    //MARK: - Guest Checkout Delegate
    func guestCheckoutTableViewCell(guestCheckoutTableViewCell: GuestCheckoutTableViewCell, didClickNext textfieldTag: Int, textField: UITextField) {
        self.next()
    }
    
    func guestCheckoutTableViewCell(guestCheckoutTableViewCell: GuestCheckoutTableViewCell, didClickDone textfieldTag: Int, textField: UITextField) {
        self.view.endEditing(true)
//        self.checkoutContainerViewController.fireGuestCheckout()
    }
    func guestCheckoutTableViewCell(guestCheckoutTableViewCell: GuestCheckoutTableViewCell, didStartEditingTextFieldWithTag textfieldTag: Int, textField: UITextField) {
        self.currentTextFieldTag = textfieldTag
        
//        if textfieldTag < 4 {
//            
//            if self.tableView.indexPathForCell(self.guestCheckoutTableViewCell) != nil {
//                var indexPath: NSIndexPath = self.tableView.indexPathForCell(self.guestCheckoutTableViewCell)!
//                self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
//            }
//            
//        }
//        
//        UIView.animateWithDuration(0.5, animations: {
//            var contentInset: UIEdgeInsets = self.tableView.contentInset
//            contentInset.top = 0.0
//            if IphoneType.isIphone6Plus() {
//               contentInset.top = contentInset.top - (50 * CGFloat(textfieldTag + 1))
//            } else if IphoneType.isIphone6() {
//
//                if textfieldTag == 13 {
//                    contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag))
//                } else {
//                    if self.currentTextFieldTag == 0 {
//                        contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag + 1))
//                    } else {
//                        contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag))
//                    }
//                }
//            } else if IphoneType.isIphone5() {
//                if textfieldTag == 3 {
//                    contentInset.top = contentInset.top - (50 * CGFloat(textfieldTag - 1)) - 120
//                } else if textfieldTag == 13 {
//                    contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag)) - 120
//                } else if textfieldTag >= 8 {
//                    contentInset.top = contentInset.top - (55 * CGFloat(textfieldTag)) - 120
//                } else {
//                    contentInset.top = contentInset.top - (45 * CGFloat(textfieldTag + 1)) - 120
//                } 
//            } else if IphoneType.isIphone4() {
//                let extraSpace: CGFloat = 150
//                
//                if textfieldTag >= 8 {
//                    contentInset.top = contentInset.top - (60 * CGFloat(textfieldTag)) - extraSpace
//                } else {
//                    if textField.tag == 3 {
//                        contentInset.top = contentInset.top - (45 * CGFloat(textfieldTag)) - extraSpace                        
//                    } else {
//                        contentInset.top = contentInset.top - (45 * CGFloat(textfieldTag + 1)) - extraSpace
//                    }
//                }
//            }
//                self.tableView.contentInset = contentInset
//                self.tableView.scrollIndicatorInsets = contentInset
//        })
        
        
        if textField == self.guestCheckoutTableViewCell.provinceTextField {
            self.addressPickerType = AddressPickerType.Province
            self.guestCheckoutTableViewCell.provinceTextField.text = self.checkoutContainerViewController.addressModel.province
            self.guestCheckoutTableViewCell.provinceTextField.inputView = self.addPicker(self.checkoutContainerViewController.provinceRow)
            
        } else if textField == self.guestCheckoutTableViewCell.cityTextField {
            self.addressPickerType = AddressPickerType.City
            self.guestCheckoutTableViewCell.cityTextField.text = self.checkoutContainerViewController.addressModel.city
            self.guestCheckoutTableViewCell.cityTextField.inputView = self.addPicker(self.checkoutContainerViewController.cityRow)
        } else if textField == self.guestCheckoutTableViewCell.barangayTextField {
            self.addressPickerType = AddressPickerType.Barangay
            self.guestCheckoutTableViewCell.barangayTextField.text = self.checkoutContainerViewController.addressModel.barangay
            self.guestCheckoutTableViewCell.barangayTextField.inputView = self.addPicker(self.checkoutContainerViewController.barangayRow)
        }
    }
    
    //MARK: - 
    //MARK: - Scroll View Will Begin Draging
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.view.endEditing(true)
        var contentInset: UIEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0)
        self.tableView.contentInset = contentInset
        self.tableView.scrollIndicatorInsets = contentInset
    }
    
    //MARK: -
    //MARK: - Add Picker
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
            return self.checkoutContainerViewController.barangayModel.location.count
        } else if self.addressPickerType == AddressPickerType.Province  {
            return self.checkoutContainerViewController.provinceModel.location.count
        } else {
            return self.checkoutContainerViewController.cityModel.location.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        if self.addressPickerType == AddressPickerType.Barangay {
            return self.checkoutContainerViewController.barangayModel.location[row]
        } else if self.addressPickerType == AddressPickerType.Province  {
            return self.checkoutContainerViewController.provinceModel.location[row]
        } else {
            return self.checkoutContainerViewController.cityModel.location[row]
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.addressPickerType == AddressPickerType.Barangay {
            self.checkoutContainerViewController.barangayRow = row
            self.checkoutContainerViewController.addressModel.barangayId = self.checkoutContainerViewController.barangayModel.barangayId[row]
        } else if self.addressPickerType == AddressPickerType.Province  {
            self.checkoutContainerViewController.addressModel.provinceId = self.checkoutContainerViewController.provinceModel.provinceId[row]
            self.checkoutContainerViewController.provinceRow = row
        } else {
            self.checkoutContainerViewController.addressModel.cityId = self.checkoutContainerViewController.cityModel.cityId[row]
            self.checkoutContainerViewController.cityRow = row
        }
    }
    
    //MARK: - 
    //MARK: - Text Field Should Return
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    //MARK: -
    //MARK: - Voucher Table View Cell Delegate
    func voucherTableViewCell(didTapAddButton cell: VoucherTableViewCell) {
        if cell.addButton.titleLabel!.text == "ADD" {
            self.checkoutContainerViewController.fireVoucherWithVoucherId(cell.voucherTextField.text)
        } else {
            self.voucherRequestNotSuccessful(cell)
        }
    }
    
    func voucherTableViewCell(voucherTableViewCell: VoucherTableViewCell, startEditingAtTextField textField: UITextField) {
        var indexPath: NSIndexPath = self.tableView.indexPathForCell(voucherTableViewCell)!
        self.tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Top, animated: true)
    }
    
    //MARK: -
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
    
    //MARK: -
    //MARK: - Voucher Request Successful
    func voucherRequestIsSuccessful(voucherModel: VoucherModel) {
        //copy the voucher model to our global voucher model
        self.voucherModel = voucherModel
        let voucherCell: VoucherTableViewCell = self.tableView.cellForRowAtIndexPath(NSIndexPath(forItem: ((self.cartItems.count - 1) + 2), inSection: 0)) as! VoucherTableViewCell
        voucherCell.voucherTextField.enabled = false
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
        
        if !self.hasFlashSaleItem {
           self.changeButtonState(voucherCell.addButton)
        }
        
        self.tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: UITableViewRowAnimation.Left)
    }
    
    //MARK: -
    //MARK: - Voucher Table View Cell
    func voucherTableViewCell(textFieldDidChange cell: VoucherTableViewCell) {
        if count(cell.voucherTextField.text) >= 6 {
            self.activateAddButton(cell.addButton)
        } else {
            self.deActivateAddButton(cell.addButton)
        }
        
    }
    
    //MARK: -
    //MARK: - Change Button State
    func changeButtonState(button: UIButton) {
        if button.titleLabel!.text == "ADD" {
            button.setTitle("Remove", forState: UIControlState.Normal)
            button.backgroundColor = UIColor.redColor()
        } else {
            button.setTitle("ADD", forState: UIControlState.Normal)
            button.backgroundColor = Constants.Colors.appTheme
        }
    }
    
    //MARK: -
    //MARK: - Activate Button
    func activateAddButton(button: UIButton) {
        button.setTitle("ADD", forState: UIControlState.Normal)
        button.backgroundColor = Constants.Colors.appTheme
        button.enabled = true
    }
    
    //MARK: -
    //MARK: - DeActivate Button
    func deActivateAddButton(button: UIButton) {
        button.setTitle("ADD", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.lightGrayColor()
        button.enabled = false
    }
    
    //MARK: -
    //MARK: - Add User Map
    func userMapView() -> UIView {
        let containerView: UIView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 300))
        let userMapView: UserMapView = XibHelper.puffViewWithNibName("UserMapView", index: 0) as! UserMapView
        userMapView.sendSubviewToBack(userMapView.mapView)
        userMapView.frame = CGRectMake(0, 40, self.view.frame.size.width, 184)
        containerView.addSubview(userMapView)
        return containerView
    }
    
    //MARK: - 
    //MARK: - Total Summary Price Table View Cell With IndexPath
    func totalSummaryPriceTableViewCellWithIndexPath(indexPath: NSIndexPath) -> TotalSummaryPriceTableViewCell  {
        let totalCell: TotalSummaryPriceTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.totalCellNibName) as! TotalSummaryPriceTableViewCell
        
        totalCell.totalPriceValueLabel.text = "\(self.totalPrice)"
        
        if self.deliveryFee == "0" || self.deliveryFee == "" {
            self.deliveryFee = "FREE"
        }
        
        totalCell.shippingFeeValueLabel.text = "\(self.deliveryFee)"
        
        totalCell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 1000)
        return totalCell
    }
    
    //MARK: - 
    //MARK: - Discount Voucher Total ViewCell With IndexPath
    func discountVoucherTotalViewCellWithIndexPath(indexPath: NSIndexPath) -> DicountVoucherTableViewCell {
        let discountTotalCell: DicountVoucherTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.discountVouncherNibName) as! DicountVoucherTableViewCell
        
        if self.voucherModel.isSuccessful {
            discountTotalCell.discountVoucherLabel.text = "Discount Value: \(self.voucherModel.less.formatToTwoDecimal())"
        } else {
            discountTotalCell.discountVoucherLabel.text = "\(self.voucherModel.message)"
            discountTotalCell.discountVoucherLabel.textAlignment = NSTextAlignment.Right
            discountTotalCell.discountVoucherLabel.textColor = UIColor.redColor()
        }
        
        discountTotalCell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 1000)
        
        return discountTotalCell
    }
    
    //MARK: -
    //MARK: - Voucher Table View Cell With Index Path
    func voucherTableViewCellWithIndexPath(indexPath: NSIndexPath) -> VoucherTableViewCell {
        let voucherCell: VoucherTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.voucherCellNibName) as! VoucherTableViewCell
        voucherCell.delegate = self
        
        if self.hasFlashSaleItem {
            voucherCell.voucherTextField.enabled = false
        }
        
        voucherCell.selectionStyle = UITableViewCellSelectionStyle.None
        return voucherCell
    }
    
    //MARK: - 
    //MARK: - Guest Checkout Table View Cell  With Index Path
    func guestCheckoutTableViewCellWithindexPath(indexPath: NSIndexPath) -> GuestCheckoutTableViewCell {
        self.guestCheckoutTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.guestCheckoutCellIdentifier) as! GuestCheckoutTableViewCell
        self.guestCheckoutTableViewCell.delegate = self
        self.guestCheckoutTableViewCell.selectionStyle = UITableViewCellSelectionStyle.None
        self.guestCheckoutTableViewCell.separatorInset = UIEdgeInsetsMake(0, 1000, 0, 1000)
        for view in self.guestCheckoutTableViewCell.contentView.subviews {
            if view.isKindOfClass(UITextField) {
                let textField: UITextField = view as! UITextField
                if !IphoneType.isIphone4() {
                    if textField.tag > 4 && textField.tag < 8 {
                        textField.addToolBarWithTarget(self, done: "done")
                    } else {
                        textField.addToolBarWithTarget(self, next: "next", previous: "previous:", done: "done")
                    }
                }
            }
        }
        
        return guestCheckoutTableViewCell
    }
    
    //MARK: - Ship To Table View Cell With Index Path
    //MARK: - 
    func shipToTableViewCellWithIndexPath(indexPath: NSIndexPath) -> ShipToTableViewCell {
        self.shipToTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.shipToTableViewCellNibNameAndIdentifier) as! ShipToTableViewCell
        shipToTableViewCell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, shipToTableViewCell.frame.size.height)
        shipToTableViewCell.delegate = self
        shipToTableViewCell.addressLabel.text = SessionManager.userFullAddress()
        return shipToTableViewCell
    }
    
    //MARK: - 
    //MARK: - Map Table View Cell With Index Path
    func mapTableViewCellWithIndexPath(indexPath: NSIndexPath) -> MapTableViewCell {
        let mapCell: MapTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.mapCellNibName) as! MapTableViewCell
        let latitude: Double = SessionManager.latitude().toDouble()!
        let longitude: Double = SessionManager.longitude().toDouble()!
        mapCell.setLocation(latitude: latitude, longitude: longitude)
        mapCell.disableTouch()
        return mapCell
    }
    
    //MARK: -
    //MARK: - Order Summary Table View Cell With IndexPath
    func orderSummaryTableViewCellWithIndexPath(indexPath: NSIndexPath) -> OrderSummaryTableViewCell {
        let product: CartProductDetailsModel = self.cartItems[indexPath.row]
        let url = APIAtlas.baseUrl.stringByReplacingOccurrencesOfString("api/v1", withString: "")
        let orderSummaryCell: OrderSummaryTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier) as! OrderSummaryTableViewCell
        /*orderSummaryCell.productImageView.sd_setImageWithURL(NSURL(string: "\(url)\(APIAtlas.cartImage)\(product.selectedUnitImage)")!, placeholderImage: UIImage(named: "dummy-placeholder"))*/
        
        orderSummaryCell.productImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(product.selectedUnitImage), placeholderImage: UIImage(named: "dummy-placeholder"))
        
        orderSummaryCell.itemTitleLabel.text = product.title
        orderSummaryCell.quantityLabel.text = "x\(product.quantity)"
        
        if product.isCODAvailable {
            orderSummaryCell.noCODLabel.hidden = true
        } else {
            orderSummaryCell.noCODLabel.hidden = false
            checkoutContainerViewController.noCOD = true
        }
        
        for tempProductUnit in product.productUnits {
            if product.unitId == tempProductUnit.productUnitId {
                orderSummaryCell.priceLabel.text = tempProductUnit.discountedPrice.formatToTwoDecimal()
                
                if tempProductUnit.imageIds.count != 0 {
                    for tempImage in product.images {
                        if tempImage.id == tempProductUnit.imageIds[0] {
                            orderSummaryCell.productImageView.sd_setImageWithURL(NSURL(string: tempImage.fullImageLocation), placeholderImage: UIImage(named: "dummy-placeholder"))
                        }
                    }
                } else if product.images.count != 0 {
                    orderSummaryCell.productImageView.sd_setImageWithURL(NSURL(string: product.images[0].fullImageLocation), placeholderImage: UIImage(named: "dummy-placeholder"))
                } else {
                    orderSummaryCell.productImageView.image = UIImage(named: "dummy-placeholder")
                }
                break
            }
        }
        
        return orderSummaryCell
    }
    
    //MARK: - 
    //MARK: - Incomplete Requirements Table View Cell With Index Path
    func incompleteRequirementsTableViewCellWithIndexPath(indexPath: NSIndexPath) -> IncompleteRequirementsTableViewCell {
        let cell: IncompleteRequirementsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(IncompleteRequirementsTableViewCell.nibNameAndIdentifier()) as! IncompleteRequirementsTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.delegate = self
        
        if SessionManager.firstName() != "" {
            cell.setFirstNameAndDisabledTextFieldWithValue(SessionManager.firstName())
        }
       
        if SessionManager.lastName() != "" {
            cell.setLastNameAndDisabledTextFieldWithValue(SessionManager.lastName())
        }
        
        if SessionManager.mobileNumber() != "" {
            cell.setMobileNumberAndDisabledTextWithFieldWithValue(SessionManager.mobileNumber())
        }
        
        if SessionManager.emailAddress() != "" {
            cell.setEmailAndDisabledTextFieldWithValue(SessionManager.emailAddress())
        } else {
            cell.emailAddressTextField.enabled = true
        }
        
        return cell
    }
    
    //MARK: - 
    //MARK: - Clear City and Barangay TextField
    func clearCityAndBarangayTextField() {
        self.guestCheckoutTableViewCell.cityTextField.text = AddressStrings.selectCity
        self.guestCheckoutTableViewCell.barangayTextField.text = AddressStrings.selectBarangay
    }
    
    //MARK: - 
    //MARK: - Set Barangay TextField Text With String
    func setBarangayTextFieldTextWithString(barangay: String) {
        self.guestCheckoutTableViewCell.barangayTextField.text = barangay
    }
    
    //MARK: -
    //MARK: - Set City TextField Text With String
    func setCityTextFieldTextWithString(city: String) {
        self.guestCheckoutTableViewCell.cityTextField.text = city
    }
    
    //MARK: -
    //MARK: - Set Barangay TextField Text With String
    func setProvinceTextFieldTextWithString(province: String) {
        self.guestCheckoutTableViewCell.provinceTextField.text = province
    }
    
    //MARK: - 
    //MARK: - Guest Checkout User
    func guestUser() -> RegisterModel {
        return RegisterModel(firstName: self.guestCheckoutTableViewCell.firstNameTextField.text, lastName: self.guestCheckoutTableViewCell.lastNameTextField.text, emailAddress: self.guestCheckoutTableViewCell.emailTextField.text, mobileNumber: self.guestCheckoutTableViewCell.mobileNumberTextField.text, title: "Guest Address", streetName: self.guestCheckoutTableViewCell.streetNameTextField.text, zipCode: self.guestCheckoutTableViewCell.zipCodeTextField.text, location: "\(self.checkoutContainerViewController.addressModel.barangayId)")
    }
    
    //MARK: - 
    //MARK: - Incomplete Requirements Table View Cell Delegate
    func incompleteRequirementsTableViewCell(incompleteRequirementsTableViewCell: IncompleteRequirementsTableViewCell, didStartEditingAtTextField textField: UITextField) {
        var contentInset: UIEdgeInsets = self.tableView.contentInset
        contentInset.top = 0.0
        
        if textField.isEqual(incompleteRequirementsTableViewCell.firstNameTextField) || textField.isEqual(incompleteRequirementsTableViewCell.lastNameTextField) {
            UIView.animateWithDuration(kHalfSecond, animations: { () -> Void in
                if IphoneType.isIphone4() {
                    textField.autocorrectionType = UITextAutocorrectionType.No
                    contentInset.top = contentInset.top - 400
                } else if IphoneType.isIphone5() {
                    contentInset.top = contentInset.top - 450
                } else if IphoneType.isIphone6() {
                    contentInset.top = contentInset.top - 300
                } else {
                    contentInset.top = contentInset.top - 350
                }
                
                self.tableView.contentInset = contentInset
                self.tableView.scrollIndicatorInsets = contentInset
            })
        } else if textField.isEqual(incompleteRequirementsTableViewCell.mobileNumberTextField) || textField.isEqual(incompleteRequirementsTableViewCell.emailAddressTextField) {
            UIView.animateWithDuration(kHalfSecond, animations: { () -> Void in
                if IphoneType.isIphone4() {
                    textField.autocorrectionType = UITextAutocorrectionType.No
                    contentInset.top = contentInset.top - 450
                } else if IphoneType.isIphone5() {
                    textField.autocorrectionType = UITextAutocorrectionType.No
                    contentInset.top = contentInset.top - 450
                } else if IphoneType.isIphone6() {
                    contentInset.top = contentInset.top - 350
                } else {
                    contentInset.top = contentInset.top - 350
                }
                self.tableView.contentInset = contentInset
                self.tableView.scrollIndicatorInsets = contentInset
            })
        }
    }
    
    func incompleteRequirementsTableViewCell(incompleteRequirementsTableViewCell: IncompleteRequirementsTableViewCell, didChangeValueAtTextField textField: UITextField, textValue: String) {
        if textField == incompleteRequirementsTableViewCell.firstNameTextField {
            self.firstName = textValue
        } else if textField == incompleteRequirementsTableViewCell.lastNameTextField {
            self.lastName = textValue
        } else if textField == incompleteRequirementsTableViewCell.mobileNumberTextField {
            self.mobileNumber = textValue
        } else if textField == incompleteRequirementsTableViewCell.emailAddressTextField {
            self.email = textValue
        }
    }
    
    func incompleteRequirementsTableViewCell(incompleteRequirementsTableViewCell: IncompleteRequirementsTableViewCell, didTapReturnAtTextField textField: UITextField) {
        if textField.isEqual(incompleteRequirementsTableViewCell.firstNameTextField) {
            if incompleteRequirementsTableViewCell.lastNameTextField.enabled == true {
                incompleteRequirementsTableViewCell.lastNameTextField.becomeFirstResponder()
            } else if incompleteRequirementsTableViewCell.mobileNumberTextField.enabled == true {
                incompleteRequirementsTableViewCell.mobileNumberTextField.becomeFirstResponder()
            } else {
                self.tableView.endEditing(true)
            }
        } else if textField.isEqual(incompleteRequirementsTableViewCell.lastNameTextField) {
            if incompleteRequirementsTableViewCell.mobileNumberTextField.enabled == true {
                incompleteRequirementsTableViewCell.mobileNumberTextField.becomeFirstResponder()
            } else {
                self.tableView.endEditing(true)
            }
        } else if textField.isEqual(incompleteRequirementsTableViewCell.mobileNumberTextField) {
            if incompleteRequirementsTableViewCell.emailAddressTextField.enabled == true {
                incompleteRequirementsTableViewCell.emailAddressTextField.becomeFirstResponder()
            } else {
                self.tableView.endEditing(true)
            }
        } else if textField.isEqual(incompleteRequirementsTableViewCell.emailAddressTextField) {
            self.tableView.endEditing(true)
        }
    }
}