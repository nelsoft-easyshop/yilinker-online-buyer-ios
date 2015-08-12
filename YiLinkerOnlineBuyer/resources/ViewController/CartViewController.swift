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
    
    var tableData: [String] = ["Ferrari", "BMW", "Mitsubishi", "Lambo"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        var nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.registerNib(nib, forCellReuseIdentifier: "CartTableViewCell")
        
        populateWishListTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
    }
    
    func requestProductDetails(url: String, params: NSDictionary!) {
        
    }
    
    // MARK: Methods Updating Values
    func populateWishListTableView (){
        updateCounterLabel()
    }
    
    func updateCounterLabel() {
        if tableData.count < 2 {
            cartCounterLabel.text = "You have \(tableData.count) item in your cart"
        } else{
            cartCounterLabel.text = "You have \(tableData.count) items in your cart"
        }
    }
    
    func calculateTotalPrice() {
        
    }
    
    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell:CartTableViewCell = self.cartTableView.dequeueReusableCellWithIdentifier("CartTableViewCell") as! CartTableViewCell
        
        cell.productNameLabel.text = tableData[indexPath.row]
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
