//
//  WishlistViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WishlistTableViewCellDelegate {
    
    let manager = APIManager.sharedInstance
    
    @IBOutlet var wishlistTableView: UITableView!
    
    @IBOutlet var wishListCounterLabel: UILabel!
    
    let viewControllerIndex = 2
    
    var tableData: [WishlistModel] = []
    
    //formatter of Text to remove trailing decimal
    let formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wishlistTableView.delegate = self;
        wishlistTableView.dataSource = self;
        
        wishlistTableView.tableFooterView = UIView()
        
        var nib = UINib(nibName: "WishlistTableViewCell", bundle: nil)
        wishlistTableView.registerNib(nib, forCellReuseIdentifier: "WishlistTableViewCell")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
        populateWishListTableView()
    }
    
    //REST API request
    //
    func fireDeleteCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.DELETE(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            print(responseObject as! NSDictionary)
            self.updateCounterLabel()
            self.dismissLoader()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
                self.dismissLoader()
        })
    }
    
    func fireAddToCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.DELETE(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            print(responseObject as! NSDictionary)
            self.updateCounterLabel()
            self.dismissLoader()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
                self.dismissLoader()
        })
    }
    
    func requestProductDetails(url: String, params: NSDictionary!) {
        showLoader()
        
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            if let value: AnyObject = responseObject["data"] {
                for subValue in value["cartItems"] as! NSArray {
                    println(subValue)
                    let model: WishlistModel = WishlistModel.parseDataWithDictionary(subValue as! NSDictionary)
                    
                    self.tableData.append(model)
                }
                self.wishlistTableView.reloadData()
            }
            self.updateCounterLabel()
            self.dismissLoader()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
                self.updateCounterLabel()
                self.dismissLoader()
        })
    }
    
    
    //Loader function
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }
    
    // MARK: Methods Updating Values
    func populateWishListTableView () {
        tableData = []
        //requestProductDetails(APIAtlas.wishlistUrl, params: NSDictionary(dictionary: ["access_token": SessionManager.accessToken(), "wishlist": "true"]))
        
        requestProductDetails("http://demo3526363.mockable.io/api/v1/auth/cart/getCart", params: nil)
    }
    
    func updateCounterLabel() {
        if tableData.count < 2 {
            wishListCounterLabel.text = "You have \(tableData.count) item in your wishlist"
        } else {
            wishListCounterLabel.text = "You have \(tableData.count) items in your wishlist"
        }
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell:WishlistTableViewCell = self.wishlistTableView.dequeueReusableCellWithIdentifier("WishlistTableViewCell") as! WishlistTableViewCell
        
        //Set cell data
        var tempModel: WishlistModel = tableData[indexPath.row]
        
        for selectedProductUnit in tempModel.selectedAttributes {
            for tempProductUnit in tempModel.productDetails.productUnits {
                if selectedProductUnit == tempProductUnit.productUnitId.toInt() {
                    if tempProductUnit.imageIds.count == 0 {
                        cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempModel.productDetails.image), placeholderImage: UIImage(named: "dummy-placeholder"))
                    } else {
                        cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempProductUnit.imageIds[0]), placeholderImage: UIImage(named: "dummy-placeholder"))
                    }
                    
                    var tempAttributesText: String = ""
                    for tempId in tempProductUnit.combination {
                        for tempAttributes in tempModel.productDetails.attributes {
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
                    
                    
                    cell.productPriceLabel.text = "P" + tempProductUnit.discountedPrice + " x\(tempModel.quantity)"
                }
            }
        }
        
        cell.productNameLabel.text = tempModel.productDetails.title
        
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
        var pathOfTheCell: NSIndexPath = wishlistTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        tableData.removeAtIndex(pathOfTheCell.row);
        wishlistTableView.deleteRowsAtIndexPaths([pathOfTheCell], withRowAnimation: UITableViewRowAnimation.Fade)
        NSLog("rowofthecell %d", rowOfTheCell);
        updateCounterLabel()
        
        //No API yet
        //fireDeleteCartItem(<#url: String#>, params: <#NSDictionary!#>)
    }
    
    func addToCartButtonActionForIndex(sender: AnyObject){
        var pathOfTheCell: NSIndexPath = wishlistTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        tableData.removeAtIndex(pathOfTheCell.row);
        wishlistTableView.deleteRowsAtIndexPaths([pathOfTheCell], withRowAnimation: UITableViewRowAnimation.Fade)
        NSLog("rowofthecell %d", rowOfTheCell);
        updateCounterLabel()
        
        //No API yet
        //fireAddToßCartItem(<#url: String#>, params: <#NSDictionary!#>)
    }
    
    func swipeViewDidScroll(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
    }
    
}
