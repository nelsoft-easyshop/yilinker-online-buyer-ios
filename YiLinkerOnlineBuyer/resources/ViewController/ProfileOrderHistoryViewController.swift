//
//  ProfileOrderHistoryViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileOrderHistoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ProductReviewFooterTableViewCellDelegate {
    @IBOutlet weak var closeButton: RoundedButton!
    @IBOutlet weak var tableView: UITableView!
    var tableData: [String] = ["Quantity: 1x\tElement: Wood\tVolt: 110v", "Payment confirmed. 07/22/2015", "YiLinker Express pickup item #705321 from Seller. 07/22/2015", "YiLinker Express delivered item #705321 to Van Dalism. 07/23/2015", "Van Dalism confirmed item #705321. 07/232015"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initializeViews() {
        
        var nib = UINib(nibName: "OrderHistoryTableViewCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "orderHistoryTableViewCell")
        var nib1 = UINib(nibName: "ProductReviewFooterTableViewCell", bundle: nil)
        tableView.registerNib(nib1, forCellReuseIdentifier: "productReviewFooterTableViewCell")
        
        
        //tableView.tableFooterView = cell
        
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.blackColor().CGColor
    }
    
    @IBAction func closeButtonAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    //Methods for HTTP Request 
    func firePostReview (review: String, rate: Int) {
        /*
        var params = Dictionary<String, String>()
        
        var cartModelTemp = tableData[index]
        
        params["access_token"] = "access_token"
        params["productId"] = ""
        params["rating"] = rate
        params["review"] = review
        
        showLoader()
        manager.GET(url, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.dismissLoader()
            self.populateWishListTableView()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
                self.dismissLoader()
        })
        */
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    // Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
    // Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
         var cell:OrderHistoryTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("orderHistoryTableViewCell") as! OrderHistoryTableViewCell
        cell.descriptionLabel.text = tableData[indexPath.row]
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        var cell:ProductReviewFooterTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("productReviewFooterTableViewCell") as! ProductReviewFooterTableViewCell
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150.0
    }
    
    // MARK: - Table View footer Delegate
    
    func sendAction(sender: AnyObject, rate: Int, review: String) {
        if rate == 0 || review.isEmpty {
            showAlertMessage("Product Review", message: "Complete necessary field!")
        } else{
            firePostReview(review, rate: rate)
        }
    }
    
    
    // Method for showing alert
    func showAlertMessage(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    //Method for Loader
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }
    
}
