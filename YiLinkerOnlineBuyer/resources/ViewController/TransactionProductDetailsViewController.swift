//
//  TransactionProductDetailsViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionProductDetailsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var newFrame: CGRect!
    
    var headerView: UIView!
    var transactionProductImagesView: TransactionProductImagesView!
    var transactionPurchaseDetailsView: TransactionPurchaseDetailsView!
    var transactionProductDetailsView: UIView!
    
    var footerView: UIView!
    var transactionDescriptionView: TransactionDescriptionView!
    var transactionButtonView: UIView!
    
    var name = ["SKU", "Brand", "Weight (kg)", "Height (mm)", "Type of Jack"]
    var value = ["ABCD-1234-5678-91022", "Beats Audio Version", "0.26", "203", "3.5mm"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TransactionProductDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TransactionProductDetailsIdentifier")
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Product Details"
        
        loadViewsWithDetails()
    }
    
    // MARK: - Table View Data Souce
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TransactionProductDetailsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionProductDetailsIdentifier") as! TransactionProductDetailsTableViewCell
        
        cell.attributeNameLabel.text = name[indexPath.row]
        cell.attributeValueLabel.text = value[indexPath.row]
        
        return cell
    }
    
    // MARK: - Init Views
    
    // MARK: HEADER
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.autoresizesSubviews = false
            self.headerView.backgroundColor = Constants.Colors.backgroundGray
        }
        return self.headerView
    }
    
    func getTransactionProductImagesView() -> TransactionProductImagesView {
        if self.transactionProductImagesView == nil {
            self.transactionProductImagesView = XibHelper.puffViewWithNibName("TransactionViews", index: 4) as! TransactionProductImagesView
            self.transactionProductImagesView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionProductImagesView
    }
    
    func getTransactionPurchaseDetailsView() -> TransactionPurchaseDetailsView {
        if self.transactionPurchaseDetailsView == nil {
            self.transactionPurchaseDetailsView = XibHelper.puffViewWithNibName("TransactionViews", index: 5) as! TransactionPurchaseDetailsView
            self.transactionPurchaseDetailsView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionPurchaseDetailsView
    }
    
    func getTransactionProductDetailsView() -> UIView {
        if self.transactionProductDetailsView == nil {
            self.transactionProductDetailsView = UIView(frame: (CGRectMake(0, 0, self.view.frame.size.width, 40)))
            self.transactionProductDetailsView.backgroundColor = .whiteColor()
            
            var textLabel = UILabel(frame: CGRectMake(8, 0, self.transactionProductDetailsView.frame.size.width - 8, self.transactionProductDetailsView.frame.size.height))
            textLabel.text = "Product Details"
            textLabel.textColor = .darkGrayColor()
            textLabel.font = UIFont.systemFontOfSize(15.0)
            
            self.transactionProductDetailsView.addSubview(textLabel)
        }
        return self.transactionProductDetailsView
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
    
    func getTransactionDescriptionView() -> TransactionDescriptionView {
        if self.transactionDescriptionView == nil {
            self.transactionDescriptionView = XibHelper.puffViewWithNibName("TransactionViews", index: 6) as! TransactionDescriptionView
            self.transactionDescriptionView.frame.size.width = self.view.frame.size.width
            self.transactionDescriptionView.frame.origin.y += CGFloat(20)
        }
        return self.transactionDescriptionView
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
        self.getHeaderView().addSubview(self.getTransactionProductImagesView())
        self.getHeaderView().addSubview(self.getTransactionPurchaseDetailsView())
        self.getHeaderView().addSubview(self.getTransactionProductDetailsView())
        
        // FOOTERS
        self.getFooterView().addSubview(self.getTransactionDescriptionView())
        self.getFooterView().addSubview(self.getTransactionButtonView())
        
        setUpViews()
    }
    
    func setUpViews() {
        // header
        self.setPosition(self.transactionPurchaseDetailsView, from: self.transactionProductImagesView)
        self.setPosition(self.transactionProductDetailsView, from: self.transactionPurchaseDetailsView)
        
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.transactionProductDetailsView.frame)
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
        
        // footer
        var footerGrayColor = UIView(frame: self.view.frame)
        footerGrayColor.backgroundColor = Constants.Colors.backgroundGray
        self.getFooterView().addSubview(footerGrayColor)
        
        self.setPosition(self.transactionButtonView, from: self.transactionDescriptionView)
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
