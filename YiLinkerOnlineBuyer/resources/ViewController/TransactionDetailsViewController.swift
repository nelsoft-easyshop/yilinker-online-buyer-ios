//
//  TransactionDetailsViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let list = ["North Face Super Uber Traver Bag", "Beats Studio Type 20 Headphones", "Sony Super Bass"]
    
    var newFrame: CGRect!
    
    var headerView: UIView!
    var transactionIdView: TransactionIdView!
    var transactionDetailsView: TransactionDetailsView!
    var transactionProductListView: UIView!
    
    var footerView: UIView!
    var transactionDeliveryStatusView: TransactionDeliveryStatusView!
    var transactionSellerView: TransactionSellerView!
    var transactionButtonView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Transaction Details"
        
        loadViewsWithDetails()
    }
    
    // MARK: - Table View Data Souce
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
        cell.textLabel?.textColor = .darkGrayColor()
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let productDetails = TransactionProductDetailsViewController(nibName: "TransactionProductDetailsViewController", bundle: nil)
        self.navigationController?.pushViewController(productDetails, animated: true)
    }
    
    // MARK: - Init Views
    
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.autoresizesSubviews = false
            self.headerView.backgroundColor = Constants.Colors.backgroundGray
        }
        return self.headerView
    }
    
    func getTransactionIdView() -> TransactionIdView {
        if self.transactionIdView == nil {
            self.transactionIdView = XibHelper.puffViewWithNibName("TransactionViews", index: 0) as! TransactionIdView
            self.transactionIdView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionIdView
    }

    func getTransactionDetailsView() -> TransactionDetailsView {
        if self.transactionDetailsView == nil {
            self.transactionDetailsView = XibHelper.puffViewWithNibName("TransactionViews", index: 1) as! TransactionDetailsView
            self.transactionDetailsView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionDetailsView
    }
    
    func getTransactionProductListView() -> UIView {
        if self.transactionProductListView == nil {
            self.transactionProductListView = UIView(frame: (CGRectMake(0, 0, self.view.frame.size.width, 30)))
            
            var listLabel = UILabel(frame: CGRectMake(8, 0, self.transactionProductListView.frame.size.width - 8, self.transactionProductListView.frame.size.height))
            listLabel.text = "PRODUCT LIST"
            listLabel.textColor = .darkGrayColor()
            listLabel.font = UIFont.systemFontOfSize(12.0)
            
            self.transactionProductListView.addSubview(listLabel)
        }
        return self.transactionProductListView
    }
    
    // MARK: FOOTER
    
    func getFooterView() -> UIView {
        if self.footerView == nil {
            self.footerView = UIView(frame: CGRectZero)
            self.footerView.autoresizesSubviews = false
            self.footerView.backgroundColor = Constants.Colors.backgroundGray
        }
        return self.footerView
    }
    
    func getTransactionSellerView() -> TransactionSellerView {
        if self.transactionSellerView == nil {
            self.transactionSellerView = XibHelper.puffViewWithNibName("TransactionViews", index: 2) as! TransactionSellerView
            self.transactionSellerView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionSellerView
    }
    
    func getTransactionDeliveryStatusView() -> TransactionDeliveryStatusView {
        if self.transactionDeliveryStatusView == nil {
            self.transactionDeliveryStatusView = XibHelper.puffViewWithNibName("TransactionViews", index: 3) as! TransactionDeliveryStatusView
            self.transactionDeliveryStatusView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionDeliveryStatusView
    }
    
    func getTransactionButtonView() -> UIView {
        if self.transactionButtonView == nil {
            self.transactionButtonView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
            
            var feedbackButton: UIButton = UIButton(frame: CGRectZero)
            feedbackButton.addTarget(self, action: "leaveFeedback", forControlEvents: .TouchUpInside)
            feedbackButton.setTitle("LEAVE FEEDBACK FOR SELLER", forState: .Normal)
            feedbackButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            feedbackButton.backgroundColor = Constants.Colors.productPrice
            feedbackButton.titleLabel?.font = UIFont.boldSystemFontOfSize(10.0)
            feedbackButton.sizeToFit()
            feedbackButton.frame.size = CGSize(width: feedbackButton.frame.size.width + 20, height: 30)
            feedbackButton.center.x = self.view.center.x
            feedbackButton.layer.cornerRadius = feedbackButton.frame.size.height / 2
            
            self.transactionButtonView.addSubview(feedbackButton)
        }
        
        return self.transactionButtonView
    }
    
    // MARK: - Methods
    
    func loadViewsWithDetails() {
        // HEADERS
        self.getHeaderView().addSubview(self.getTransactionIdView())
        self.getHeaderView().addSubview(self.getTransactionDetailsView())
        self.getHeaderView().addSubview(self.getTransactionProductListView())
        
        // FOOTERS
        self.getFooterView().addSubview(self.getTransactionSellerView())
        self.getFooterView().addSubview(self.getTransactionDeliveryStatusView())
        self.getFooterView().addSubview(self.getTransactionButtonView())
        
        setUpViews()
    }
    
    func setUpViews() {
        // header
        self.setPosition(self.transactionDetailsView, from: self.transactionIdView)
        self.setPosition(self.transactionProductListView, from: self.transactionDetailsView)

        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.transactionProductListView.frame)
        self.headerView.frame = newFrame

        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
        
        // footer
        var footerGrayColor = UIView(frame: self.view.frame)
        footerGrayColor.backgroundColor = Constants.Colors.backgroundGray
        self.getFooterView().addSubview(footerGrayColor)
        
        self.setPosition(self.transactionDeliveryStatusView, from: self.transactionSellerView)
        self.setPosition(self.transactionButtonView, from: self.transactionDeliveryStatusView)
        self.setPosition(footerGrayColor, from: self.transactionButtonView)
        footerGrayColor.frame.origin.y -= 20
        
        newFrame = self.footerView.frame
        newFrame.size.height = CGRectGetMaxY(self.transactionButtonView.frame)
        self.footerView.frame = newFrame
        
        self.tableView.tableFooterView = nil
        self.tableView.tableFooterView = self.footerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame) + 20
        view.frame = newFrame
    }
    
    // MARK: - Actions
    
    func leaveFeedback() {
        println("leave a feedback")
    }

}
