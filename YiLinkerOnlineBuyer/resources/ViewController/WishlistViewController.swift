//
//  WishlistViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WishlistTableViewCellDelegate, EmptyViewDelegate {
    
    let manager = APIManager.sharedInstance
    
    @IBOutlet var wishlistTableView: UITableView!
    @IBOutlet var wishListCounterLabel: UILabel!
    
    let viewControllerIndex = 2
    
    var tableData: [WishlistProductDetailsModel] = []
    
    var emptyView: EmptyView?
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wishlistTableView.delegate = self;
        wishlistTableView.dataSource = self;
        
        initializeViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if emptyView != nil {
            emptyView?.hidden = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
        getWishlistData()
    }
    
    // MARK : Initialization
    func initializeViews() {
        wishlistTableView.tableFooterView = UIView()
        
        var nib = UINib(nibName: "WishlistTableViewCell", bundle: nil)
        wishlistTableView.registerNib(nib, forCellReuseIdentifier: "WishlistTableViewCell")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Panton-Regular", size: 21)!]
        self.title = StringHelper.localizedStringWithKey("WISHLISTTITLE_LOCALIZE_KEY")
    }
    
    
    // MARK : REST API request
    func getWishlistData() {
        if Reachability.isConnectedToNetwork() {
            requestProductDetails(APIAtlas.wishlistUrl, params: NSDictionary(dictionary: ["access_token": SessionManager.accessToken(), "wishlist": "true"]))
        } else {
            UIAlertController.displayNoInternetConnectionError(self)
            addEmptyView()
        }
    }
    
    func fireDeleteCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken("deleteWishlist", url: url, params: params)
                } else {
                    self.populateTableView(responseObject)
                }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if task.response as? NSHTTPURLResponse != nil {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.requestRefreshToken("deleteWishlist", url: url, params: params)
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
                var data: NSDictionary = responseObject["data"] as! NSDictionary
                var cart: NSArray = data["cart"] as! NSArray
                println(responseObject)
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken("addToCart", url: url, params: params)
                } else{
                    SessionManager.setCartCount(cart.count)
                    if SessionManager.cartCount() != 0 {
                        let badgeValue = (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue?.toInt()
                        (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = String(SessionManager.cartCount())
                    } else {
                        (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = nil
                    }
                    //self.populateTableView(responseObject)
                    self.getWishlistData()
                }
                self.dismissLoader()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                if task.response as? NSHTTPURLResponse != nil {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.requestRefreshToken("addToCart", url: url, params: params)
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        self.dismissLoader()
                    }
                }
        })
    }
    
    func requestProductDetails(url: String, params: NSDictionary!) {
        showLoader()
        
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
                if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken("getWishlist", url: url, params: params)
                } else {
                    self.populateTableView(responseObject)
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if task.response as? NSHTTPURLResponse != nil {
                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if task.statusCode == 401 {
                        self.requestRefreshToken("getWishlist", url: url, params: params)
                    } else {
                        UIAlertController.displaySomethingWentWrongError(self)
                        self.updateCounterLabel()
                        self.dismissLoader()
                    }
                }
        })
    }
    
    func requestRefreshToken(type: String, url: String, params: NSDictionary!) {
        let url: String = APIAtlas.refreshTokenUrl
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID(),
            "client_secret": Constants.Credentials.clientSecret(),
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.dismissLoader()
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                if type == "getWishlist" {
                    self.requestProductDetails(url, params: params)
                } else if type == "addToCart" {
                    self.fireAddToCartItem(url, params: params)
                } else if type == "deleteWishlist" {
                    self.fireDeleteCartItem(url, params: params)
                }
            } else {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: responseObject["message"] as! String, title: Constants.Localized.error)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.dismissLoader()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                UIAlertController.displaySomethingWentWrongError(self)
                
        })
    }
    
    // MARK: Methods Updating Values
    func populateTableView(responseObject: AnyObject) {
        tableData.removeAll(keepCapacity: false)
        wishlistTableView.reloadData()
        wishListCounterLabel.text = ""
        if let value: AnyObject = responseObject["data"] {
            if let tempVar = value["items"] as? NSArray {
                for subValue in tempVar {
                    println(subValue)
                    let model: WishlistProductDetailsModel = WishlistProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)
                    
                    self.tableData.append(model)
                }

            } else if let tempVar = value["wishlist"] as? NSArray {
                for subValue in tempVar {
                    println(subValue)
                    let model: WishlistProductDetailsModel = WishlistProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)
                    
                    self.tableData.append(model)
                }
            }
            self.wishlistTableView.reloadData()
        }
        self.updateCounterLabel()
        self.dismissLoader()
        
        if tableData.count != 0 {
            let badgeValue = (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue?.toInt()
            (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue = String(tableData.count)
        } else {
            (self.tabBarController!.tabBar.items![3] as! UITabBarItem).badgeValue = nil
        }
        
        SessionManager.setWishlistCount(tableData.count)
    }
    
    func updateCounterLabel() {
        let youHaveLocalizeString: String = StringHelper.localizedStringWithKey("YOU_HAVE_LOCALIZE_KEY")
        let itemsLocalizeString: String = StringHelper.localizedStringWithKey("ITEMSINWISHLIST_LOCALIZE_KEY")
        
        if tableData.count < 2 {
            let itemString: String = StringHelper.localizedStringWithKey("ITEM_LOCALIZE_KEY")
            wishListCounterLabel.text = "\(youHaveLocalizeString) \(tableData.count) \(itemString) \(itemsLocalizeString)"
        } else {
            let itemString: String = StringHelper.localizedStringWithKey("ITEMS_LOCALIZE_KEY")
            wishListCounterLabel.text = "\(youHaveLocalizeString) \(tableData.count) \(itemString) \(itemsLocalizeString)"
        }
    }
    
    // MARK: - Delegates
    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell:WishlistTableViewCell = self.wishlistTableView.dequeueReusableCellWithIdentifier("WishlistTableViewCell") as! WishlistTableViewCell
        
        //Set cell data
        var tempModel: WishlistProductDetailsModel = tableData[indexPath.row]
        
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("Row \(indexPath.row) selected")
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
            var pathOfTheCell: NSIndexPath = wishlistTableView.indexPathForCell(sender as! UITableViewCell)!
            var rowOfTheCell: Int = pathOfTheCell.row
            
            let tempModel: WishlistProductDetailsModel = tableData[rowOfTheCell]
            
            var params: NSDictionary = ["access_token": SessionManager.accessToken(),
                "productId": tempModel.id,
                "unitId": tempModel.unitId,
                "quantity": 0,
                "wishlist": "true"
            ]
            fireDeleteCartItem(APIAtlas.updateWishlistUrl, params: params)
        } else {
            UIAlertController.displayNoInternetConnectionError(self)
        }
    }
    
    func addToCartButtonActionForIndex(sender: AnyObject){
        if Reachability.isConnectedToNetwork() {
            var pathOfTheCell: NSIndexPath = wishlistTableView.indexPathForCell(sender as! UITableViewCell)!
            var rowOfTheCell: Int = pathOfTheCell.row
            
            let tempModel: WishlistProductDetailsModel = tableData[rowOfTheCell]
            
//            var params: NSDictionary = ["access_token": SessionManager.accessToken(),
//                "productId": tempModel.id,
//                "unitId": tempModel.unitId,
//                "quantity": tempModel.quantity
//            ]
            
            var params: NSDictionary = ["access_token": SessionManager.accessToken(),
                "itemIds[]": tempModel.itemId
            ]
            
            fireAddToCartItem(APIAtlas.addWishlistToCartUrl, params: params)
        } else {
            UIAlertController.displayNoInternetConnectionError(self)
        }
    }
    
    func swipeViewDidScroll(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
    }
    
    func didTapReload() {
        emptyView?.hidden = true
        getWishlistData()
    }
    
    // MARK : Functions
    func addEmptyView() {
        if self.emptyView == nil {
            tableData.removeAll(keepCapacity: false)
            wishlistTableView.reloadData()
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.view.frame
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
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

}