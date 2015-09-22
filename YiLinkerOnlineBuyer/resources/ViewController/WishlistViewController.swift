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
    
    //formatter of Text to remove trailing decimal
    let formatter = NSNumberFormatter()
    
    var emptyView: EmptyView?
    
    var hud: MBProgressHUD?
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wishlistTableView.delegate = self;
        wishlistTableView.dataSource = self;
        
        wishlistTableView.tableFooterView = UIView()
        
        var nib = UINib(nibName: "WishlistTableViewCell", bundle: nil)
        wishlistTableView.registerNib(nib, forCellReuseIdentifier: "WishlistTableViewCell")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.title = StringHelper.localizedStringWithKey("WISHLISTTITLE_LOCALIZE_KEY")
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
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
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")
    }
    
    //REST API request
    
    func getWishlistData() {
        
        if Reachability.isConnectedToNetwork() {
            requestProductDetails(APIAtlas.wishlistUrl, params: NSDictionary(dictionary: ["access_token": SessionManager.accessToken(), "wishlist": "true"]))
        } else {
            addEmptyView()
        }
    }
    
    func fireDeleteCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken("getWishlist", url: url, params: params)
            } else {
                self.populateTableView(responseObject)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.showAlert(self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                self.dismissLoader()
        })
    }
    
    func fireAddToCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken("addToCart", url: url, params: params)
            } else{
                SessionManager.setCartCount(SessionManager.cartCount() + 1)
                if SessionManager.cartCount() != 0 {
                    let badgeValue = (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue?.toInt()
                    (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = String(SessionManager.cartCount())
                } else {
                    (self.tabBarController!.tabBar.items![4] as! UITabBarItem).badgeValue = nil
                }
            }
            self.dismissLoader()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.showAlert(self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                self.dismissLoader()
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
                self.showAlert(self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                self.updateCounterLabel()
                self.dismissLoader()
        })
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
    
    // MARK: Methods Updating Values
    
    func populateTableView(responseObject: AnyObject) {
        tableData.removeAll(keepCapacity: false)
        wishlistTableView.reloadData()
        wishListCounterLabel.text = ""
        if let value: AnyObject = responseObject["data"] {
            for subValue in value["items"] as! NSArray {
                println(subValue)
                let model: WishlistProductDetailsModel = WishlistProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)
                
                self.tableData.append(model)
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
        let youHaveLocalizeString: String = StringHelper.localizedStringWithKey("YOUHAVE_LOCALIZE_KEY")
        let itemsLocalizeString: String = StringHelper.localizedStringWithKey("ITEMSINWISHLIST_LOCALIZE_KEY")
        
        if tableData.count < 2 {
            let itemString: String = StringHelper.localizedStringWithKey("ITEM_LOCALIZE_KEY")
            wishListCounterLabel.text = "\(youHaveLocalizeString) \(tableData.count) \(itemString) \(itemsLocalizeString)"
        } else {
            let itemString: String = StringHelper.localizedStringWithKey("ITEMS_LOCALIZE_KEY")
            wishListCounterLabel.text = "\(youHaveLocalizeString) \(tableData.count) \(itemString) \(itemsLocalizeString)"
        }
    }
    
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
            showAlert(connectionLocalizeString, message: connectionMessageLocalizeString)
        }
    }
    
    func addToCartButtonActionForIndex(sender: AnyObject){
        if Reachability.isConnectedToNetwork() {
            var pathOfTheCell: NSIndexPath = wishlistTableView.indexPathForCell(sender as! UITableViewCell)!
            var rowOfTheCell: Int = pathOfTheCell.row
            
            let tempModel: WishlistProductDetailsModel = tableData[rowOfTheCell]
            
            var params: NSDictionary = ["access_token": SessionManager.accessToken(),
                "productId": tempModel.id,
                "unitId": tempModel.unitId,
                "quantity": tempModel.quantity
            ]
            
            fireAddToCartItem(APIAtlas.updateWishlistUrl, params: params)
        } else {
            showAlert(connectionLocalizeString, message: connectionMessageLocalizeString)
        }
    }
    
    func swipeViewDidScroll(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
    }
    
    func didTapReload() {
        emptyView?.hidden = true
        getWishlistData()
    }
    
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
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let okLocalizeString: String = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
        let OKAction = UIAlertAction(title: okLocalizeString, style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
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
                
                if type == "getWishlist" {
                    self.requestProductDetails(url, params: params)
                } else if type == "addToCart" {
                    self.fireAddToCartItem(url, params: params)
                } else if type == "deleteWishlist" {
                    self.fireDeleteCartItem(url, params: params)
                }
            } else {
                self.showAlert(self.errorLocalizeString, message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert(self.somethingWrongLocalizeString, message: self.somethingWrongLocalizeString)
                
        })
    }
}