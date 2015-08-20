//
//  SummaryViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerNib()
        self.tableView.estimatedRowHeight = 71
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -5)
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func registerNib() {
        let orderSummaryNib: UINib = UINib(nibName: Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(orderSummaryNib, forCellReuseIdentifier: Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier)
        
        let shipToNib: UINib = UINib(nibName: Constants.Checkout.shipToTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(shipToNib, forCellReuseIdentifier: Constants.Checkout.shipToTableViewCellNibNameAndIdentifier)
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
        if indexPath.section == 0 {
            let orderSummaryCell: OrderSummaryTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier) as! OrderSummaryTableViewCell
            
            return orderSummaryCell
        } else {
            let shipToTableViewCell: ShipToTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.shipToTableViewCellNibNameAndIdentifier) as! ShipToTableViewCell
            shipToTableViewCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            return shipToTableViewCell
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 71
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 1 {
            
        }
    }
}
