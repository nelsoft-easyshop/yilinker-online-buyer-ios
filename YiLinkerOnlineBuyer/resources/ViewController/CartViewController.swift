//
//  CartViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate, CartProductAttributeViewControllerDelegate, EmptyViewDelegate {
    
    var manager = APIManager()
    
    @IBOutlet var cartTableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet var cartCounterLabel: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    
    var tableData: [CartProductDetailsModel] = []
    var selectedValue: [String] = []
    
    var emptyView: EmptyView?
    
    var selectedItemIDs: [Int] = []
    
    var hud: MBProgressHUD?
    
    var badgeCount: Int = 0
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager = APIManager.sharedInstance
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        cartTableView.tableFooterView = UIView()
        
        var nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.registerNib(nib, forCellReuseIdentifier: "CartTableViewCell")
        
        checkoutButton.layer.cornerRadius = 5
        
        self.title = StringHelper.localizedStringWithKey("CARTTITLE_LOCALIZE_KEY")
        
        initializeLocalizedString()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        selectedItemIDs = []
        if emptyView != nil {
            emptyView?.hidden = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
        getCartData()
        
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")
        
        let totalLocalizeString: String = StringHelper.localizedStringWithKey("TOTAL_LOCALIZE_KEY")
        totalLabel.text = totalLocalizeString
        
        let checkoutLocalizeString: String = StringHelper.localizedStringWithKey("CHECKOUT_LOCALIZE_KEY")
        checkoutButton.setTitle(checkoutLocalizeString, forState: UIControlState.Normal)
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        if sender as! UIButton == checkoutButton {
            if selectedItemIDs.count == 0 {
                let chooseItemLocalizeString: String = StringHelper.localizedStringWithKey("CHOOSEITEMFROMCART_LOCALIZE_KEY")
                showAlert(errorLocalizeString, message: chooseItemLocalizeString, redirectToHome: false)
            } else {
                firePassCartItem(APIAtlas.updateCheckout(), params: NSDictionary(dictionary: ["cart": selectedItemIDs, "access_token": SessionManager.accessToken()]))
            }
        }
    }
    
    //REST API request
    func getCartData() {
        
        if Reachability.isConnectedToNetwork() {
            requestProductDetails(APIAtlas.cart(), params: NSDictionary(dictionary: ["access_token": SessionManager.accessToken()]))
        } else {
            addEmptyView()
        }
    }
    
    func firePassCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!)in
                var array: [CartProductDetailsModel] = []
            
                if let value: AnyObject = responseObject["data"] {
                    for subValue in responseObject["data"] as! NSArray {
                        let model: CartProductDetailsModel = CartProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)
                        array.append(model)
                    }
                }
            
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken("passCart", url: url, params: params)
                } else {
                    let checkout = CheckoutContainerViewController(nibName: "CheckoutContainerViewController", bundle: nil)
                    checkout.carItems = array
                    checkout.totalPrice = self.totalPriceLabel.text!
                    let navigationController: UINavigationController = UINavigationController(rootViewController: checkout)
                    navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
                    self.tabBarController?.presentViewController(navigationController, animated: true, completion: nil)
                    self.dismissLoader()
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.somethingWrongLocalizeString, title: self.errorLocalizeString)
                self.dismissLoader()
        })
    }
    
    func fireDeleteCartItem(url: String, params: NSDictionary!) {
        showLoader()
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken("getCart", url: url, params: params)
                } else {
                    self.populateTableView(responseObject)
                }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.somethingWrongLocalizeString, title: self.errorLocalizeString)
                self.dismissLoader()
        })
    }
    
    func fireAddToCartItem(url: String, params: NSDictionary!) {
        showLoader()
    
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken("editToCart", url: url, params: params)
                } else {
                    self.getCartData()
                }
                self.dismissLoader()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.somethingWrongLocalizeString, title: self.errorLocalizeString)
                self.dismissLoader()
        })
    }
    
    func requestProductDetails(url: String, params: NSDictionary!) {
        showLoader()
        
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken("getCart", url: url, params: params)
                } else {
                    self.populateTableView(responseObject)
                }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: self.somethingWrongLocalizeString, title: self.errorLocalizeString)
                self.updateCounterLabel()
                self.dismissLoader()
        })
    }
    
    func populateTableView(responseObject: AnyObject) {
        tableData.removeAll(keepCapacity: false)
        cartTableView.reloadData()
        if let value: AnyObject = responseObject["data"] {
            for subValue in value["items"] as! NSArray {
                let model: CartProductDetailsModel = CartProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)
                model.selected = true
                let tempItemId = model.itemId
                if model.selected {
                    selectedItemIDs.append(tempItemId)
                } else {
                    selectedItemIDs = selectedItemIDs.filter({$0 != tempItemId})
                }
                self.tableData.append(model)
            }
            
            self.cartTableView.reloadData()
            
            if let value: Int = value["total"] as? Int {
                self.badgeCount = value
            }
        }
        self.updateCounterLabel()
        self.calculateTotalPrice()
        self.dismissLoader()
        
        if badgeCount != 0 {
            let badgeValue = (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue?.toInt()
            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = String(badgeCount)
        } else {
            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = nil
        }
        
        SessionManager.setCartCount(badgeCount)
    }
    
    func updateCounterLabel() {
        let youHaveLocalizeString: String = StringHelper.localizedStringWithKey("YOUHAVE_LOCALIZE_KEY")
        let itemsLocalizeString: String = StringHelper.localizedStringWithKey("ITEMSINCART_LOCALIZE_KEY")
        
        if tableData.count < 2 {
            let itemString: String = StringHelper.localizedStringWithKey("ITEM_LOCALIZE_KEY")
            cartCounterLabel.text = "\(youHaveLocalizeString) \(tableData.count) \(itemString) \(itemsLocalizeString)"
        } else {
            let itemString: String = StringHelper.localizedStringWithKey("ITEMS_LOCALIZE_KEY")
            cartCounterLabel.text = "\(youHaveLocalizeString) \(tableData.count) \(itemString) \(itemsLocalizeString)"
        }
    }
    
    
    //Loader function
    func showLoader() {
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
    
    func dismissLoader() {
        self.hud?.hide(true)
    }
    
    func calculateTotalPrice() {
        var totalPrice: Double = 0.0
        
        for tempModel in tableData {
            if tempModel.selected {
                for tempProductUnit in tempModel.productUnits {
                    if tempModel.unitId == tempProductUnit.productUnitId {
                        let discountedPrice = (tempProductUnit.discountedPrice as NSString).doubleValue
                        let quantity = Double(tempModel.quantity)
                        totalPrice = totalPrice + (quantity * discountedPrice)
                    }
                }
            }
        }
        
        var price: String = "\(totalPrice)"
        totalPriceLabel.text = "\(price.formatToTwoDecimal())"
    }
    
    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell:CartTableViewCell = self.cartTableView.dequeueReusableCellWithIdentifier("CartTableViewCell") as! CartTableViewCell
        
        //Set cell data
        var tempModel: CartProductDetailsModel = tableData[indexPath.row]
        
        cell.checkBox.selected = true
        cell.checkBox.backgroundColor = UIColor(red: 68/255.0, green: 164/255.0, blue: 145/255.0, alpha: 1.0)
        cell.checkBox.layer.borderWidth = 0
        cell.checkBox.layer.borderColor = UIColor.whiteColor().CGColor
        
        for tempProductUnit in tempModel.productUnits {
            if tempModel.unitId == tempProductUnit.productUnitId {
                if tempProductUnit.imageIds.count == 0 {
                    cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempModel.image), placeholderImage: UIImage(named: "dummy-placeholder"))
                } else {
                    cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempProductUnit.imageIds[0]), placeholderImage: UIImage(named: "dummy-placeholder"))
                }
                
                var tempAttributesText: String = ""
                for tempId in tempProductUnit.combination {
                    for tempAttributes in tempModel.attributes {
                        if let index = find(tempAttributes.valueId, tempId) {
                            if tempAttributesText.isEmpty {
                                tempAttributesText = tempAttributes.valueName[index]
                            } else {
                                tempAttributesText += " | " + tempAttributes.valueName[index]
                            }
                        }
                    }
                }
                
                cell.productDetailsLabel?.text = tempAttributesText
                cell.productPriceLabel.text = tempProductUnit.discountedPrice.formatToTwoDecimal() + " x \(tempModel.quantity)"
            }
        }
        
        cell.productNameLabel.text = tempModel.title
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    
    // MARK: - Wishlist Table View Delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: scrollView)
    }
    
    // MARK: - Wishlist Table View Delegate
    func deleteButtonActionForIndex(sender: AnyObject){
        if Reachability.isConnectedToNetwork() {
            var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
            var rowOfTheCell: Int = pathOfTheCell.row
            
            let tempModel: CartProductDetailsModel = tableData[rowOfTheCell]
            
            var params: NSDictionary = ["access_token": SessionManager.accessToken(),
                "productId": tempModel.id,
                "unitId": tempModel.unitId,
                "quantity": 0,
            ]
            fireDeleteCartItem(APIAtlas.updateCart(), params: params)
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: connectionMessageLocalizeString, title: connectionLocalizeString)
        }
    }
    
    func seeMoreAttribute(index: Int) {
        var tempModel: CartProductDetailsModel = tableData[index]
        var selectedProductUnits: ProductUnitsModel?
        
        for tempProductUnit in tempModel.productUnits {
            if tempModel.unitId == tempProductUnit.productUnitId {
                selectedProductUnits = tempProductUnit
            }
        }
        
        var attributeModal = CartProductAttributeViewController(nibName: "CartProductAttributeViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.backgroundColor = UIColor.clearColor()
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        attributeModal.passModel(cartModel: tempModel, selectedProductUnits: selectedProductUnits!)
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            self.navigationController?.navigationBar.alpha = 0.0
        })
        
    }
    
    func editButtonActionForIndex(sender: AnyObject){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        seeMoreAttribute(rowOfTheCell)
    }
    
    func checkBoxButtonActionForIndex(sender: AnyObject, state: Bool){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        tableData[rowOfTheCell].selected = state
        
        let tempItemId = tableData[rowOfTheCell].itemId
        if state {
            selectedItemIDs.append(tempItemId)
        } else {
            selectedItemIDs = selectedItemIDs.filter({$0 != tempItemId})
        }
        
        calculateTotalPrice()
    }
    
    func swipeViewDidScroll(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
    }
    
    // MARK: - Cart Product Attribute View Controller Delegate
    func pressedCancelAttribute(controller: CartProductAttributeViewController) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.navigationController?.navigationBar.alpha = 1.0
        })
    }
    
    func pressedDoneAttribute(controller: CartProductAttributeViewController, productID: Int, unitID: Int, itemID: Int, quantity: Int) {
        
        if Reachability.isConnectedToNetwork() {
            var params: NSDictionary = ["access_token": SessionManager.accessToken(),
                "productId": "\(productID)",
                "unitId": "\(unitID)",
                "itemId": "\(itemID)",
                "quantity": "\(quantity)"
            ]
            
            fireAddToCartItem(APIAtlas.updateCart(), params: params)
        } else {
            showAlert(connectionLocalizeString, message: connectionMessageLocalizeString, redirectToHome: false)
        }
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.navigationController?.navigationBar.alpha = 1.0
        })
    }
    
    func didTapReload() {
        emptyView?.hidden = true
        getCartData()
    }
    
    func addEmptyView() {
        if self.emptyView == nil {
            tableData.removeAll(keepCapacity: false)
            cartTableView.reloadData()
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.view.frame
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    func showAlert(title: String, message: String, redirectToHome: Bool) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okLocalizeString: String = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
        
        let OKAction = UIAlertAction(title: okLocalizeString, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            
            if redirectToHome {
                let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                appDelegate.changeRootToHomeView()
            }
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    func requestRefreshToken(type: String, url: String, params: NSDictionary!) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
                SVProgressHUD.dismiss()
            
                if (responseObject["isSuccessful"] as! Bool) {
                    SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                    if type == "getCart" {
                        self.requestProductDetails(url, params: params)
                    } else if type == "editToCart" {
                        self.fireAddToCartItem(url, params: params)
                    } else if type == "deleteWishlist" {
                        self.fireDeleteCartItem(url, params: params)
                    } else if type == "passCart" {
                        self.firePassCartItem(url, params: params)
                    }
                } else {
                    self.showAlert(self.errorLocalizeString, message: responseObject["message"] as! String, redirectToHome: true)
                }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
        })
    }
}
