//
//  GuestCheckoutViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 8/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class GuestCheckoutSummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GuestCheckoutTableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        
        self.tableView.estimatedRowHeight = 71
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -5)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()
        self.tableView.tableFooterView = self.tableFooterView()
        self.tableView.tableFooterView!.frame = CGRectMake(0, 0, 0, self.tableView.tableFooterView!.frame.size.height)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func registerNib() {
       
        let shipToNib: UINib = UINib(nibName: "GuestCheckoutTableViewCell", bundle: nil)
        self.tableView.registerNib(shipToNib, forCellReuseIdentifier: "GuestCheckoutTableViewCell")
        
        let orderSummaryNib: UINib = UINib(nibName: "OrderSummaryTableViewCell", bundle: nil)
        self.tableView.registerNib(orderSummaryNib, forCellReuseIdentifier: "OrderSummaryTableViewCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }
    
    func tableFooterView() -> UIView {
        let guestCheckoutTableViewCell: GuestCheckoutTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("GuestCheckoutTableViewCell") as! GuestCheckoutTableViewCell
        guestCheckoutTableViewCell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, guestCheckoutTableViewCell.frame.size.height)
        guestCheckoutTableViewCell.delegate = self
        
        return guestCheckoutTableViewCell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: CheckoutViews
        if section == 0 {
            headerView = XibHelper.puffViewWithNibName("CheckoutViews", index: 0) as! CheckoutViews
        } else {
            headerView = XibHelper.puffViewWithNibName("CheckoutViews", index: 2) as! CheckoutViews
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView: CheckoutViews = XibHelper.puffViewWithNibName("CheckoutViews", index: 1) as! CheckoutViews
            return footerView
        } else {
            return UIView(frame: CGRectZero)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let orderSummaryCell: OrderSummaryTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier) as! OrderSummaryTableViewCell
        
        return orderSummaryCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 71
        } else {
            return 312
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
}
