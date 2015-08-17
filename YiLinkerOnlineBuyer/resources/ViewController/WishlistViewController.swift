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
    
    var tableData: [CartModel] = []
    
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
                    
                    let model: CartModel = CartModel.parseDataWithDictionary(subValue as! NSDictionary)
                    
                    self.tableData.append(model)
                }
                self.wishlistTableView.reloadData()
            }
            self.updateCounterLabel()
            self.dismissLoader()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
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
        requestProductDetails(APIAtlas.wishlistUrl, params: nil)
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
        var tempModel: CartModel = tableData[indexPath.row]
        cell.productNameLabel.text = tempModel.productDetails.title
        cell.productItemImageView.sd_setImageWithURL(tempModel.productDetails.image, placeholderImage: UIImage(named: "dummy-placeholder"))  //no image yet in API
        var tempAttributesText: String = ""
        var tempAttributeId: [Int] = []
        var tempAttributeName: [String] = []
        
        for tempAttribute in tempModel.productDetails.attributes{
            tempAttributeId += tempAttribute.valueId
            tempAttributeName += tempAttribute.valueName
        }
        
        for tempId in tempModel.selectedAttributes {
            if let index = find(tempAttributeId, tempId) {
                if tempAttributesText.isEmpty {
                    tempAttributesText = tempAttributeName[index]
                } else {
                    tempAttributesText += " | " + tempAttributeName[index]
                }
                
            }
        }
        cell.productDetailsLabel?.text = tempAttributesText
        
        cell.productPriceLabel.text = "P\(formatter.stringFromNumber(tempModel.productDetails.newPrice)!) x\(tempModel.quantity)"
        
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
