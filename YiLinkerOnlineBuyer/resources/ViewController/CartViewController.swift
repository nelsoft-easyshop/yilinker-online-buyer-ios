//
//  CartViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

enum CartRequestType {
    case GetCart
    case AddItemToCheckout
    case DeleteItem
    case UpdateItem
}

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate, CartProductAttributeViewControllerDelegate, EmptyViewDelegate {
    
    typealias TemporaryParameters = (url: String, access_token: String, productId: String, itemId: String, unitId: String, quantity: Int, cart: [Int])      //Parameters for the API Requests
    
    var requestType = CartRequestType.GetCart
    
    @IBOutlet var cartTableView: UITableView!
    var dimView: UIView?
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet var cartCounterLabel: UILabel!
    @IBOutlet var checkoutButton: UIButton!
    
    var tableData: [CartProductDetailsModel] = []
    var selectedItemIDs: [Int] = []     //Selected ids in the cart
    
    var emptyView: EmptyView?
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "checkViewSize", name: UIApplicationWillEnterForegroundNotification, object: nil)
        
        self.initializeViews()
        self.initializeLocalizedString()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        self.selectedItemIDs = []
        if self.emptyView != nil {
            self.emptyView?.hidden = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
        self.fireGetCart()
    }
    
    // MARK : Initializations
    func initializeViews() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.cartTableView.delegate = self
        self.cartTableView.dataSource = self
        
        self.cartTableView.tableFooterView = UIView()
        
        var nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        self.cartTableView.registerNib(nib, forCellReuseIdentifier: "CartTableViewCell")
        
        self.checkoutButton.layer.cornerRadius = 5
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Panton-Regular", size: 21)!]
        
        self.dimView = UIView(frame: UIScreen.mainScreen().bounds)
        self.dimView?.backgroundColor = UIColor.blackColor()
        self.dimView?.alpha = 0
        self.navigationController?.view.addSubview(dimView!)
    }
    
    func initializeLocalizedString() {
        self.totalLabel.text = StringHelper.localizedStringWithKey("TOTAL_LOCALIZE_KEY")
        
        let checkoutLocalizeString: String = StringHelper.localizedStringWithKey("CHECKOUT_LOCALIZE_KEY")
        self.checkoutButton.setTitle(checkoutLocalizeString, forState: UIControlState.Normal)
        
        self.title = StringHelper.localizedStringWithKey("CART_TITLE_LOCALIZE_KEY")
    }
    
    //Selector of the observer when the app become enter foreground
    //It will resize the view to it's original size
    func checkViewSize() {
        self.view.transform = CGAffineTransformMakeScale(1, 1)
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
        if sender as! UIButton == checkoutButton {
            //Check 'selectedItemIDs' and 'tableData' before proceeding to checkout
            if self.selectedItemIDs.count == 0 || self.tableData.count == 0 {
                let chooseItemLocalizeString: String = StringHelper.localizedStringWithKey("CHOOSE_ITEM_FROM_CART_LOCALIZE_KEY")
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: chooseItemLocalizeString, title: Constants.Localized.error)
            } else {
                self.fireCheckoutCartItems(TemporaryParameters(url: APIAtlas.updateCheckout(), access_token: SessionManager.accessToken(), productId: "", itemId: "", unitId: "", quantity: 0, cart: self.selectedItemIDs))
            }
        }
    }
    
    // MARK : REST API request
    
    func fireGetCart() {
        self.requestType = CartRequestType.GetCart
        self.showLoader()
        
        let url = APIAtlas.cart()
        WebServiceManager.fireGetCartWithUrl(url, access_token: SessionManager.accessToken(), actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            if successful {
                self.populateTableView(responseObject)
            } else {
                self.updateCounterLabel()
                self.handleErrorWithType(requestErrorType, responseObject: responseObject, params: TemporaryParameters(url: url, access_token: SessionManager.accessToken(), productId: "", itemId: "", unitId: "", quantity: 0, cart: []))
            }
        })
    }
    
    func fireDeleteCart(params: TemporaryParameters) {
        self.requestType = CartRequestType.DeleteItem
        self.showLoader()
        
        let url = APIAtlas.updateCart()
        WebServiceManager.fireDeleteCartItemWithUrl(url, access_token: SessionManager.accessToken(), productId: params.productId, unitId: params.unitId, quantity: params.quantity, actionHandler:  { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            if successful {
                self.populateTableView(responseObject)
            } else {
                self.updateCounterLabel()
                self.handleErrorWithType(requestErrorType, responseObject: responseObject, params: TemporaryParameters(url: url, access_token: SessionManager.accessToken(), productId: params.productId, itemId: params.itemId, unitId: params.unitId, quantity: 0, cart: params.cart))
            }
        })
    }
    
    func fireEditCart(params: TemporaryParameters) {
        self.requestType = CartRequestType.UpdateItem
        self.showLoader()
        
        let url = APIAtlas.updateCart()
        WebServiceManager.fireUpdateCartItemWithUrl(url, access_token: SessionManager.accessToken(), productId: params.productId, unitId: params.unitId, itemId: params.itemId, quantity: params.quantity, actionHandler:  { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            if successful {
                self.populateTableView(responseObject)
            } else {
                self.updateCounterLabel()
                self.handleErrorWithType(requestErrorType, responseObject: responseObject, params: TemporaryParameters(url: url, access_token: SessionManager.accessToken(), productId: params.productId, itemId: params.itemId, unitId: params.unitId, quantity: params.quantity, cart: params.cart))
            }
        })
    }
    
    func fireCheckoutCartItems(params: TemporaryParameters) {
        self.requestType = CartRequestType.AddItemToCheckout
        self.showLoader()
        
        let url = APIAtlas.updateCheckout()
        WebServiceManager.fireCheckoutCartItemWithUrl(url, access_token: SessionManager.accessToken(), cart: params.cart, actionHandler:  { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            if successful {
                var checkoutItems: [CartProductDetailsModel] = []
                
                if let isSuccessful: Bool = responseObject["isSuccessful"] as? Bool {
                    if isSuccessful {
                        if let data: NSArray = responseObject["data"] as? NSArray {
                            for subValue in data {
                                let model: CartProductDetailsModel = CartProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)
                                
                                for tempProductUnit in model.productUnits {
                                    if model.unitId == tempProductUnit.productUnitId {
                                        
                                        if tempProductUnit.imageIds.count != 0 {
                                            for tempImage in model.images {
                                                if tempImage.id == tempProductUnit.imageIds[0] {
                                                    model.selectedUnitImage = tempImage.fullImageLocation
                                                }
                                            }
                                        } else if model.images.count != 0 {
                                            model.selectedUnitImage = model.images[0].fullImageLocation
                                        } else {
                                            model.selectedUnitImage = ""
                                        }
                                        break
                                    }
                                }
                                checkoutItems.append(model)
                            }

                        }
                        
                        let checkout = CheckoutContainerViewController(nibName: "CheckoutContainerViewController", bundle: nil)
                        checkout.carItems = checkoutItems
                        checkout.totalPrice = self.totalPriceLabel.text!
                        let navigationController: UINavigationController = UINavigationController(rootViewController: checkout)
                        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
                        self.tabBarController?.presentViewController(navigationController, animated: true, completion: nil)
                    }
                }
            } else {
                self.handleErrorWithType(requestErrorType, responseObject: responseObject, params: TemporaryParameters(url: url, access_token: SessionManager.accessToken(), productId: params.productId, itemId: params.itemId, unitId: params.unitId, quantity: params.quantity, cart: params.cart))
            }
        })
    }
    
    
    //MARK: - Handling of API Request Error
    /* Function to handle the error and proceed/do some actions based on the error type
    *
    * (Parameters) requestErrorType: RequestErrorType -- type of error being thrown by the web service. It is used to identify what specific action is needed to be execute based on the error type.
    *              responseObject: AnyObject -- response coming from the server. It is used to identify what specific error message is being thrown by the server
    *              params: TemporaryParameters -- collection of all params needed by all API request in the Wishlist.
    *
    * This function is for checking of 'requestErrorType' and proceed/do some actions based on the error type
    */
    func handleErrorWithType(requestErrorType: RequestErrorType, responseObject: AnyObject, params: TemporaryParameters) {
        if requestErrorType == .ResponseError {
            //Error in api requirements
            let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
            Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
        } else if requestErrorType == .AccessTokenExpired {
            self.fireRefreshToken(params)
        } else if requestErrorType == .PageNotFound {
            //Page not found
            Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
        } else if requestErrorType == .NoInternetConnection {
            //No internet connection
            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
        } else if requestErrorType == .RequestTimeOut {
            //Request timeout
            Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
        } else if requestErrorType == .UnRecognizeError {
            //Unhandled error
            Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
        }
    }
    
    //MARK: - Fire Refresh Token
    /* Function called when access_token is already expired.
    * (Parameter) params: TemporaryParameters -- collection of all params
    * needed by all API request in the Wishlist.
    *
    * This function is for requesting of access token and parse it to save in SessionManager.
    * If request is successful, it will check the requestType and redirect/call the API request
    * function based on the requestType.
    * If the request us unsuccessful, it will forcely logout the user
    */
    func fireRefreshToken(params: TemporaryParameters) {
        self.showLoader()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.dismissLoader()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                switch self.requestType {
                case .GetCart :
                    self.fireGetCart()
                case .AddItemToCheckout :
                    self.fireCheckoutCartItems(params)
                case .DeleteItem :
                    self.fireDeleteCart(params)
                case .UpdateItem :
                    self.fireEditCart(params)
                }
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logoutWithTarget(self)
                })
            }
        })
    }
    
    func populateTableView(responseObject: AnyObject) {
        tableData.removeAll(keepCapacity: false)
        cartTableView.reloadData()
        if let value: AnyObject = responseObject["data"] {
            if responseObject["isSuccessful"] as! Bool {
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
                    SessionManager.setCartCount(value)
                }
            } else {
                self.addEmptyView()
            }
            
        }
        
        if SessionManager.cartCount() != 0 {
            let badgeValue = (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue?.toInt()
            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = String(SessionManager.cartCount())
        } else {
            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = nil
        }
        
        self.updateCounterLabel()
        self.calculateTotalPrice()
        self.dismissLoader()
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
        
        self.initializeCheckoutButton()
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
        
        for tempModel in self.tableData {
            if tempModel.selected {
                for tempProductUnit in tempModel.productUnits {
                    if tempModel.unitId == tempProductUnit.productUnitId {
                        let price: String = tempProductUnit.discountedPrice.stringByReplacingOccurrencesOfString(",", withString: "")
                        let discountedPrice = (price as NSString).doubleValue
                        let quantity = Double(tempModel.quantity)
                        totalPrice = totalPrice + (quantity * discountedPrice)
                        break
                    }
                }
            }
        }
        
        var price: String = "\(totalPrice)"
        self.totalPriceLabel.text = "\(price.formatToTwoDecimal())"
        
        self.initializeCheckoutButton()
    }
    
    func initializeCheckoutButton() {
        if self.tableData.count == 0 || self.selectedItemIDs.count == 0 {
            self.checkoutButton.titleLabel?.textColor = UIColor.grayColor()
            self.checkoutButton.enabled = false
            self.checkoutButton.alpha = 0.5
        } else {
            self.checkoutButton.titleLabel?.textColor = UIColor.whiteColor()
            self.checkoutButton.enabled = true
            self.checkoutButton.alpha = 1
        }
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
    
    func showDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView!.alpha = 0.5
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    func hideDimView(){
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView!.alpha = 0
            self.navigationController?.navigationBar.alpha = 1.0
        })
    }
}

extension CartViewController: UITableViewDelegate, UITableViewDataSource {
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
                if tempProductUnit.imageIds.count != 0 {
                    for tempImage in tempModel.images {
                        if tempImage.id == tempProductUnit.imageIds[0] {
                            cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempImage.fullImageLocation), placeholderImage: UIImage(named: "dummy-placeholder"))
                            break
                        }
                    }
                } else if tempModel.images.count != 0 {
                    cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempModel.images[0].fullImageLocation), placeholderImage: UIImage(named: "dummy-placeholder"))
                } else {
                    cell.productItemImageView.image = UIImage(named: "dummy-placeholder")
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
}

extension CartViewController: CartTableViewCellDelegate {
    func deleteButtonActionForIndex(sender: AnyObject){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
            
        let tempModel: CartProductDetailsModel = tableData[rowOfTheCell]
        self.fireDeleteCart(TemporaryParameters(url: APIAtlas.updateCart(), access_token: SessionManager.accessToken(), productId: tempModel.id, itemId: "\(tempModel.itemId)", unitId: tempModel.unitId, quantity: 0, cart: []))
    }
    
    func editButtonActionForIndex(sender: AnyObject){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        var tempModel: CartProductDetailsModel = tableData[rowOfTheCell]
        var selectedProductUnits: ProductUnitsModel?
        
        for tempProductUnit in tempModel.productUnits {
            if tempModel.unitId == tempProductUnit.productUnitId {
                selectedProductUnits = tempProductUnit
                break
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
        
        self.showDimView()
    }
    
    func checkBoxButtonActionForIndex(sender: AnyObject, state: Bool){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        self.tableData[rowOfTheCell].selected = state
        
        let tempItemId = self.tableData[rowOfTheCell].itemId
        if state {
            self.selectedItemIDs.append(tempItemId)
        } else {
            self.selectedItemIDs = selectedItemIDs.filter({$0 != tempItemId})
        }
        
        self.calculateTotalPrice()
    }
    
    func swipeViewDidScroll(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
    }
    
    func tapDetails(sender: AnyObject) {
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        var tempModel: CartProductDetailsModel = tableData[rowOfTheCell]
        var productUnitId: String = ""
        
        for tempProductUnit in tempModel.productUnits {
            if tempModel.unitId == tempProductUnit.productUnitId {
                productUnitId = tempProductUnit.productUnitId
                break
            }
        }
        
        let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        productViewController.tabController = self.tabBarController as! CustomTabBarController
        productViewController.productId = tableData[rowOfTheCell].id
        productViewController.isFromCart = true
        productViewController.unitId = productUnitId
        productViewController.quantity = tempModel.quantity
        self.navigationController?.pushViewController(productViewController, animated: true)
    }

}

extension CartViewController: CartProductAttributeViewControllerDelegate {
    func pressedCancelAttribute(controller: CartProductAttributeViewController) {
        self.hideDimView()
    }
    
    func pressedDoneAttribute(controller: CartProductAttributeViewController, productID: Int, unitID: Int, itemID: Int, quantity: Int) {
        self.fireEditCart(TemporaryParameters(url: APIAtlas.updateCart(), access_token: SessionManager.accessToken(), productId: "\(productID)", itemId: "\(itemID)", unitId: "\(unitID)", quantity: quantity, cart: []))
        self.hideDimView()
    }
}

extension CartViewController: EmptyViewDelegate {
    func didTapReload() {
        self.emptyView?.hidden = true
        self.fireGetCart()
    }
}
