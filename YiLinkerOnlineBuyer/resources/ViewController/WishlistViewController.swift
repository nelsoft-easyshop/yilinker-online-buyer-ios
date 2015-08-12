//
//  WishlistViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class WishlistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, WishlistTableViewCellDelegate {
    
    @IBOutlet var wishlistTableView: UITableView!
    
    @IBOutlet var wishListCounterLabel: UILabel!
    
    let viewControllerIndex = 2
    
    var tableData: [String] = ["Ferrari", "BMW", "Mitsubishi", "Lambo"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        wishlistTableView.delegate = self;
        wishlistTableView.dataSource = self;
        
        var nib = UINib(nibName: "WishlistTableViewCell", bundle: nil)
        wishlistTableView.registerNib(nib, forCellReuseIdentifier: "WishlistTableViewCell")
        
        populateWishListTableView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateWishListTableView (){
        updateCounterLabel()
    }
    
    func updateCounterLabel() {
        if tableData.count < 2 {
            wishListCounterLabel.text = "You have \(tableData.count) item in your wishlist"
        } else{
            wishListCounterLabel.text = "You have \(tableData.count) items in your wishlist"
        }
        
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell:WishlistTableViewCell = self.wishlistTableView.dequeueReusableCellWithIdentifier("WishlistTableViewCell") as! WishlistTableViewCell
        
        cell.productNameLabel.text = tableData[indexPath.row]
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
    }
    
    func addToCartButtonActionForIndex(sender: AnyObject){
        var pathOfTheCell: NSIndexPath = wishlistTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        NSLog("rowofthecell %d", rowOfTheCell);
    }
    
}
