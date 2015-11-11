//
//  CartViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate, CartProductAttributeViewControllerDelegate, EmptyViewDelegate {
    
    var manager = APIManager.sharedInstance
    
    @IBOutlet var cartTableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet var cartCounterLabel: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    
    var tableData: [CartProductDetailsModel] = []
    var selectedValue: [String] = []
    var selectedItemIDs: [Int] = []
    
    var emptyView: EmptyView?
    var hud: MBProgressHUD?
    
    var badgeCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeViews()
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
    
    // MARK : Initializations
    func initializeViews() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        cartTableView.tableFooterView = UIView()
        
        var nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.registerNib(nib, forCellReuseIdentifier: "CartTableViewCell")
        
        checkoutButton.layer.cornerRadius = 5
        
        self.title = StringHelper.localizedStringWithKey("CART_TITLE_LOCALIZE_KEY")
    }
    
    func initializeLocalizedString() {
        totalLabel.text = StringHelper.localizedStringWithKey("TOTAL_LOCALIZE_KEY")
        
        let checkoutLocalizeString: String = StringHelper.localizedStringWithKey("CHECKOUT_LOCALIZE_KEY")
        checkoutButton.setTitle(checkoutLocalizeString, forState: UIControlState.Normal)
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        if sender as! UIButton == checkoutButton {
//            if selectedItemIDs.count == 0 {
//                let chooseItemLocalizeString: String = StringHelper.localizedStringWithKey("CHOOSE_ITEM_FROM_CART_LOCALIZE_KEY")
//                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: chooseItemLocalizeString, title: Constants.Localized.error)
//            } else {
//                firePassCartItem(APIAtlas.updateCheckout(), params: NSDictionary(dictionary: ["cart": selectedItemIDs, "access_token": SessionManager.accessToken()]))
//            }
            
            
            let alertController = UIAlertController(title: "Feature Not Available", message: "Check-out not available in Beta Testing", preferredStyle: .Alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }

        }
    }
    
    // MARK : REST API request
    func getCartData() {
        if Reachability.isConnectedToNetwork() {
            fireGetCartItems(APIAtlas.cart(), params: NSDictionary(dictionary: ["access_token": SessionManager.accessToken()]))
        } else {
            addEmptyView()
        }
    }
    
    // MARK : Pass Cart Item to Checkout
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
                if task.response as? NSHTTPURLResponse != nil {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.requestRefreshToken("passCart", url: url, params: params)
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        self.dismissLoader()
                    }
                }
        })
    }
    
    func fireDeleteCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)

                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken("deleteCart", url: url, params: params)
                } else {
                    self.populateTableView(responseObject)
                }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if task.response as? NSHTTPURLResponse != nil {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse

                    if task.statusCode == 401 {
                        self.requestRefreshToken("deleteCart", url: url, params: params)
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        self.dismissLoader()
                    }
                }
        })
    }
    
    func fireAddToCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken("editToCart", url: url, params: params)
                } else {
                    self.populateTableView(responseObject)
                }
                self.dismissLoader()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if task.response as? NSHTTPURLResponse != nil {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.requestRefreshToken("editToCart", url: url, params: params)
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        self.dismissLoader()
                    }
                }
        })
    }
    
    func fireGetCartItems(url: String, params: NSDictionary!) {
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
                if task.response as? NSHTTPURLResponse != nil {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.requestRefreshToken("getCart", url: url, params: params)
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        self.updateCounterLabel()
                        self.dismissLoader()
                    }
                }
                
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
                SessionManager.setCartCount(value)
            }
        }
        
        if badgeCount != 0 {
            let badgeValue = (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue?.toInt()
            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = String(badgeCount)
        } else {
            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = nil
        }
        
        self.updateCounterLabel()
        self.calculateTotalPrice()
        self.dismissLoader()
    }
    
    func requestRefreshToken(type: String, url: String, params: NSDictionary!) {
        let url: String = APIAtlas.refreshTokenUrl
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                if type == "getCart" {
                    self.fireGetCartItems(url, params: params)
                } else if type == "editToCart" {
                    self.fireAddToCartItem(url, params: params)
                } else if type == "deleteCart" {
                    self.fireDeleteCartItem(url, params: params)
                } else if type == "passCart" {
                    self.firePassCartItem(url, params: params)
                }
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
        })
    }
    
    // MARK: - DELEGATES
    
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
//                if tempProductUnit.imageIds.count == 0 {
//                    cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempModel.image), placeholderImage: UIImage(named: "dummy-placeholder"))
//                } else {
//                    cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempProductUnit.imageIds[0]), placeholderImage: UIImage(named: "dummy-placeholder"))
//                }
                
                
                if tempProductUnit.primaryImage.isNotEmpty() {
                    let url = APIAtlas.baseUrl.stringByReplacingOccurrencesOfString("api/v1", withString: "")
                    cell.productItemImageView.sd_setImageWithURL(NSURL(string: "\(url)\(APIAtlas.cartImage)\(tempProductUnit.primaryImage)"), placeholderImage: UIImage(named: "dummy-placeholder"))
                } else {
                    if tempModel.images.count != 0 {
                        cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempModel.images[0]), placeholderImage: UIImage(named: "dummy-placeholder"))
                    } else {
                        cell.productItemImageView.image = UIImage(named: "dummy-placeholder")
                    }

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
                cell.productPriceLabel.text = tempProductUnit.discountedPrice.formatToPeso() + " x \(tempModel.quantity)"
            }
        }
        
        cell.productNameLabel.text = tempModel.title
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    
    // MARK: - Cart Table View Delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: scrollView)
    }
    
    // MARK: - Cart Table View Delegate
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
            UIAlertController.displayNoInternetConnectionError(self)
        }
    }
    
    func editButtonActionForIndex(sender: AnyObject){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        editItem(rowOfTheCell)
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
            UIAlertController.displayNoInternetConnectionError(self)
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
    
    // MARK: - METHODS
    func updateCounterLabel() {
        let cartCount = SessionManager.cartCount()
        
        let youHaveLocalizeString: String = StringHelper.localizedStringWithKey("YOU_HAVE_LOCALIZE_KEY")
        let itemsLocalizeString: String = StringHelper.localizedStringWithKey("ITEMS_IN_CART_LOCALIZE_KEY")
        
        if cartCount < 2 {
            let itemString: String = StringHelper.localizedStringWithKey("ITEM_LOCALIZE_KEY")
            cartCounterLabel.text = "\(youHaveLocalizeString) \(cartCount) \(itemString) \(itemsLocalizeString)"
        } else {
            let itemString: String = StringHelper.localizedStringWithKey("ITEMS_LOCALIZE_KEY")
            cartCounterLabel.text = "\(youHaveLocalizeString) \(cartCount) \(itemString) \(itemsLocalizeString)"
        }
    }
    
    // MARK: - Loader function
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
                        let price: String = tempProductUnit.discountedPrice.stringByReplacingOccurrencesOfString(",", withString: "")
                        let discountedPrice = (price as NSString).doubleValue
                        let quantity = Double(tempModel.quantity)
                        totalPrice = totalPrice + (quantity * discountedPrice)
                    }
                }
            }
        }
        
        var price: String = "\(totalPrice)"
        totalPriceLabel.text = "\(price.formatToTwoDecimal())"
    }
    
    func editItem(index: Int) {
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
}
