//
//  WishlistViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct WishlistLocalizedStrings {
    static let title = StringHelper.localizedStringWithKey("WISHLISTTITLE_LOCALIZE_KEY")
    static let youHaveLocalizeString: String = StringHelper.localizedStringWithKey("YOU_HAVE_LOCALIZE_KEY")
    static let itemsLocalizeString: String = StringHelper.localizedStringWithKey("ITEMSINWISHLIST_LOCALIZE_KEY")
}

enum WishlistRequestType {
    case GetWishlist
    case AddItemToCart
    case DeleteItem
}

class WishlistViewController: UIViewController {
    
    typealias TemporaryParameters = (url: String, access_token: String, productId: String, unitId: String, quantity: Int, wishlist: String, itemIds: Int)
    
    var requestType = WishlistRequestType.GetWishlist
    
    let manager = APIManager.sharedInstance
    
    @IBOutlet var wishlistTableView: UITableView!
    @IBOutlet var wishListCounterLabel: UILabel!
    
    var emptyView: EmptyView?
    var hud: YiHUD?
    
    var tableData: [WishlistProductDetailsModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if emptyView != nil {
            emptyView?.hidden = true
        }
        
        //Add observer for the swipe action in the cell
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
        
        self.fireGetWishlist()
    }
    
    //MARK : Initialization
    func initializeViews() {
        //Initialize table view's attributes
        self.wishlistTableView.tableFooterView = UIView()
        self.wishlistTableView.delegate = self;
        self.wishlistTableView.dataSource = self;
        
        //Register nibs of the table view
        var nib = UINib(nibName: "WishlistTableViewCell", bundle: nil)
        wishlistTableView.registerNib(nib, forCellReuseIdentifier: "WishlistTableViewCell")
        
        //Initialize navigation bar's title
        self.title = WishlistLocalizedStrings.title
    }
    
    //MARK: -
    //MARK: - REST API request
    //MARK: - Fire Get Wishlist Item
    /* Function to request wishlist data.
    *
    * If the API request is successful, it will parse the 'responseObject', check if the
    * key of the content of 'data' JSONObject is 'items' or 'wishlist', parse it to convert
    * into WishlistProductDetailsModel object and reload the 'wishlistTableView'.
    * (Sometimes the server returns either 'items' or 'wishlist' key for the JSON array of wishlist item.)
    *
    * If the API request is unsuccessful, it will add empty view, update the counter and call
    * 'handleErrorWithType' function (funcion for handling of error based on the error type)
    */
    func fireGetWishlist() {
        self.showLoader()
        let url = APIAtlas.wishlistUrl
        WebServiceManager.fireGetWishlistWithUrl(url, access_token: SessionManager.accessToken(), wishlist: "true", actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            if successful {
                self.tableData.removeAll(keepCapacity: false)
                self.wishListCounterLabel.text = ""
                if let value: AnyObject = responseObject["data"] {
                    if let tempVar = value["items"] as? NSArray {
                        for subValue in tempVar {
                            let model: WishlistProductDetailsModel = WishlistProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)             //Parse data to convert into WishlistProductDetailsModel
                            self.tableData.append(model)
                        }
                    } else if let tempVar = value["wishlist"] as? NSArray {
                        for subValue in tempVar {
                            let model: WishlistProductDetailsModel = WishlistProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)             //Parse data to convert into WishlistProductDetailsModel
                            self.tableData.append(model)
                        }
                    }
                    self.wishlistTableView.reloadData()
                }
                
                //Update counter label and tab bar badge count
                self.updateCounterLabel()
                if self.tableData.count != 0 {
                    let badgeValue = (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue?.toInt()
                    (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue = String(self.tableData.count)
                } else {
                    (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue = nil
                }
                
                SessionManager.setWishlistCount(self.tableData.count)
            } else {
                self.addEmptyView()
                self.updateCounterLabel()
                self.handleErrorWithType(requestErrorType, responseObject: responseObject, params: TemporaryParameters(url: url, access_token: SessionManager.accessToken(), productId: "", unitId: "", quantity: 0, wishlist: "true", itemIds: 0))
            }
        })
    }
    
    //MARK: - Fire Delete Wishlist Item
    /* Function to delete item in the wishlist.
    *
    * (Parameters) productId: String -- product ID of the item to be deleted
    *              unitId: String -- unique identifier of the item to be deleted
    *              quantity: Int -- desired quantity of the item (setting this to 0 will delete the item in the wishlist)
    *              wishlist: String -- used to check if it is API request for wishlist (wishlist and cart have the same API)
    *
    * If the API request is successful, it will call the 'fireGetWishlist' function to refresh/reload the 
    * data/items in the Wishlist.
    *
    * If the API request is unsuccessful, it will add empty view, update the counter and call
    * 'handleErrorWithType' function (funcion for handling of error based on the error type)
    */
    func fireDeleteWishlistItem(productId: String, unitId: String, quantity: Int, wishlist: String) {
        self.showLoader()
        let url = APIAtlas.updateWishlistUrl
        WebServiceManager.fireDeleteWishlistItemWithUrl(url, access_token: SessionManager.accessToken(), productId: productId, unitId: unitId, quantity: quantity, wishlist: wishlist, actionHandler:  { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            if successful {
                self.fireGetWishlist()
            } else {
                self.addEmptyView()
                self.updateCounterLabel()
                self.handleErrorWithType(requestErrorType, responseObject: responseObject, params: TemporaryParameters(url: url, access_token: SessionManager.accessToken(), productId: productId, unitId: unitId, quantity: quantity, wishlist: wishlist, itemIds: 0))
            }
        })
    }

    //MARK: - Fire Add to Cart Item
    /* Function to transfer/add Wishlist Item to Cart Item
    *
    * (Parameters) itemIds: Int -- unique identifer of the item to be transfered/added to the Cart
    *
    * If the API request is successful, it will parse/convert the 'data' JSON object into NSDictionary, convert the 'cart'
    * object of the 'data' dictionary and update the cart tab bar badge count and call the 'fireGetWishlist'
    * function to refresh/reload the data/items in the Wishlist.
    *
    * If the API request is unsuccessful, it will add empty view, update the counter and call
    * 'handleErrorWithType' function (funcion for handling of error based on the error type)
    */
    func fireAddToCartItem(itemIds: Int) {
        self.showLoader()
        let url = APIAtlas.updateWishlistUrl
        WebServiceManager.fireAddWishlistItemToCartWithUrl(APIAtlas.addWishlistToCartUrl, access_token: SessionManager.accessToken(), itemIds: itemIds, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            
            self.dismissLoader()
            println(responseObject)
            if successful {
                if let data: NSDictionary = responseObject["data"] as? NSDictionary {
                    if let cart: NSArray = data["cart"] as? NSArray {
                        SessionManager.setCartCount(SessionManager.cartCount() + 1)
                        if SessionManager.cartCount() != 0 {
                            let badgeValue = (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue?.toInt()
                            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = String(SessionManager.cartCount())
                        } else {
                            (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = nil
                        }
                    }
                    self.fireGetWishlist()
                }
            } else {
                self.addEmptyView()
                self.updateCounterLabel()
                self.handleErrorWithType(requestErrorType, responseObject: responseObject, params: TemporaryParameters(url: url, access_token: SessionManager.accessToken(), productId: "", unitId: "", quantity: 0, wishlist: "true", itemIds: itemIds))
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
                case .GetWishlist:
                    self.fireGetWishlist()
                case .AddItemToCart:
                    self.fireAddToCartItem(params.itemIds)
                case .DeleteItem:
                    self.fireDeleteWishlistItem(params.productId, unitId: params.unitId, quantity: params.quantity, wishlist: params.wishlist)
                }
            } else {
                //Show UIAlert and force the user to logout
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logoutWithTarget(self)
                })
            }
        })
    }
    
    //MARK: -
    //MARK: - Util Functions
    //MARK: - Methods Updating Values
    func updateCounterLabel() {
        if tableData.count < 2 {
            let itemString: String = StringHelper.localizedStringWithKey("ITEM_LOCALIZE_KEY")
            wishListCounterLabel.text = "\(WishlistLocalizedStrings.youHaveLocalizeString) \(tableData.count) \(itemString) \(WishlistLocalizedStrings.itemsLocalizeString)"
        } else {
            let itemString: String = StringHelper.localizedStringWithKey("ITEMS_LOCALIZE_KEY")
            wishListCounterLabel.text = "\(WishlistLocalizedStrings.youHaveLocalizeString) \(tableData.count) \(itemString) \(WishlistLocalizedStrings.itemsLocalizeString)"
        }
    }
    
    //Remove 'wishlistTableView' data and Add or Unhide EmptyView
    func addEmptyView() {
        self.tableData.removeAll(keepCapacity: false)
        self.wishlistTableView.reloadData()
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.view.frame
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    //MARK: Loader function
    func showLoader() {
        self.hud = YiHUD.initHud()
        self.hud?.showHUDToView(self.view)
    }
    
    //Hide loader
    func dismissLoader() {
        self.hud?.hide()
    }
    
    //Get te row of the cell
    func rowIndexOfCell(sender: AnyObject) -> Int {
        var pathOfTheCell: NSIndexPath = wishlistTableView.indexPathForCell(sender as! UITableViewCell)!
        return pathOfTheCell.row
    }
}

// MARK: - Delegates and Data Source
// MARK: - Table View Delegate and Data Source
extension WishlistViewController: UITableViewDelegate, UITableViewDataSource {
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: scrollView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell:WishlistTableViewCell = self.wishlistTableView.dequeueReusableCellWithIdentifier("WishlistTableViewCell") as! WishlistTableViewCell
        var tempModel: WishlistProductDetailsModel = tableData[indexPath.row]       //Get the selected data
        
        //Loop to 'tempModel.productUnits' to get the specific details of the selected product attributes
        for tempProductUnit in tempModel.productUnits {
            if tempModel.unitId == tempProductUnit.productUnitId {
                //Check if the image array is not empty and get the image of the specific product attribute
                if tempProductUnit.imageIds.count != 0 {
                    //Loop to 'tempModel.images'(array of all images) to get the image of the specific product attribute
                    for tempImage in tempModel.images {
                        if tempImage.id == tempProductUnit.imageIds[0] {
                            //Set image to selected image
                            cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempImage.fullImageLocation), placeholderImage: UIImage(named: "dummy-placeholder"))
                        }
                    }
                } else if tempModel.images.count != 0 {
                    cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempModel.images[0].fullImageLocation), placeholderImage: UIImage(named: "dummy-placeholder"))           //
                } else {
                    //Set image of the product to placeholder
                    cell.productItemImageView.image = UIImage(named: "dummy-placeholder")
                }
                
                //Generate string for the details of the product based in the atttributes selected
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
                cell.productPriceLabel.text = tempProductUnit.discountedPrice.formatToPeso()
                break
            }
        }
        
        cell.productNameLabel.text = tempModel.title
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
}

// MARK: - WishlistTableViewCellDelegate
extension WishlistViewController: WishlistTableViewCellDelegate {
    func deleteButtonActionForIndex(sender: AnyObject){
        //Get the selected WishlistProductDetailsModel and call fireDeleteWishlistItem function
        let tempModel: WishlistProductDetailsModel = tableData[self.rowIndexOfCell(sender)]
        self.fireDeleteWishlistItem(tempModel.id, unitId: tempModel.unitId, quantity: 0, wishlist: "true")
    }
    
    func addToCartButtonActionForIndex(sender: AnyObject){
        //Get the selected WishlistProductDetailsModel and call fireDeleteWishlistItem function
        let tempModel: WishlistProductDetailsModel = tableData[self.rowIndexOfCell(sender)]
         self.fireAddToCartItem(tempModel.itemId)
    }
    
    func swipeViewDidScroll(sender: AnyObject) {
        //Post notification to notify that the WishlistTableViewCell is being swipe
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
    }
    
}

// MARK: - EmptyViewDelegate
extension WishlistViewController: EmptyViewDelegate {
    func didTapReload() {
        emptyView?.hidden = true
        self.fireGetWishlist()
    }
}