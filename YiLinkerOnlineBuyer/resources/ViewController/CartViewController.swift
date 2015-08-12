//
//  CartViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate {
    
    let manager = APIManager()
    
    @IBOutlet var cartTableView: UITableView!
    
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var cartCounterLabel: UILabel!
    
    @IBOutlet var checkoutButton: UIButton!
    
    var tableData: [CartModel] = []
    
    //formatter of Text to remove trailing decimal
    let formatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        var nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.registerNib(nib, forCellReuseIdentifier: "CartTableViewCell")
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        
        populateWishListTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
    }
    
    func fireDeleteCartItem(url: String, params: NSDictionary!) {
        manager.DELETE(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            print(responseObject as! NSDictionary)
                self.updateCounterLabel()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
        })
    }
    
    func fireEditCartItem(url: String, params: NSDictionary!) {
        manager.DELETE(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            print(responseObject as! NSDictionary)
            self.updateCounterLabel()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
        })
    }
    
    func requestProductDetails(url: String, params: NSDictionary!) {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            //print(responseObject as! NSDictionary)
            
            if let value: AnyObject = responseObject["data"] {
                for subValue in value["cartItems"] as! NSArray {
                    
                    let model: CartModel = CartModel.parseDataWithDictionary(subValue as! NSDictionary)
                    
                    self.tableData.append(model)
                }
                self.cartTableView.reloadData()
            }
            self.updateCounterLabel()
            SVProgressHUD.dismiss()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
                SVProgressHUD.dismiss()
        })
    }
    
    // MARK: Methods Updating Values
    func populateWishListTableView (){
        requestProductDetails("http://demo5885209.mockable.io/api/v1/cart/getCart", params: nil)
    }
    
    func updateCounterLabel() {
        if tableData.count < 2 {
            cartCounterLabel.text = "You have \(tableData.count) item in your cart"
        } else{
            cartCounterLabel.text = "You have \(tableData.count) items in your cart"
        }
    }
    
    func calculateTotalPrice() {
        var totalPrice: Double = 0.0
        for tempModel in tableData {
            if tempModel.selected {
                totalPrice += (Double(tempModel.productDetails.newPrice) * Double(tempModel.quantity))
            }
        }
        totalPriceLabel.text = "P \(formatter.stringFromNumber(totalPrice)!)"
    }
    
    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell:CartTableViewCell = self.cartTableView.dequeueReusableCellWithIdentifier("CartTableViewCell") as! CartTableViewCell
        
        //Set cell data
        var tempModel: CartModel = tableData[indexPath.row]
        cell.productNameLabel.text = tempModel.productDetails.title
        //cell.productItemImageView.sd_setImageWithURL(tempModel.productDetails?.a, placeholderImage: <#UIImage!#>)   //no image yet in API
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    
    // MARK: - Wishlist Table View Delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: scrollView)
    }
    
    // MARK: - Wishlist Table View Delegate
    func deleteButtonActionForIndex(sender: AnyObject){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        tableData.removeAtIndex(pathOfTheCell.row);
        cartTableView.deleteRowsAtIndexPaths([pathOfTheCell], withRowAnimation: UITableViewRowAnimation.Fade)
        updateCounterLabel()
    }
    
    func editButtonActionForIndex(sender: AnyObject){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
    }
    
    func checkBoxButtonActionForIndex(sender: AnyObject, state: Bool){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        var tempModel: CartModel = tableData[rowOfTheCell]
        tempModel.selected = state

        calculateTotalPrice()
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
