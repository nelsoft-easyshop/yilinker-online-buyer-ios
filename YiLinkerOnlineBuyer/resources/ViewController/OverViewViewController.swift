//
//  OverViewViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct OverViewStrings {
    static let congrats: String = StringHelper.localizedStringWithKey("CONGRATULATIONS_LOCALIZE_KEY")
    static let successPurchase: String = StringHelper.localizedStringWithKey("SUCCESS_PURCHASE_LOCALIZE_KEY")
    static let total: String = StringHelper.localizedStringWithKey("TOTAL_LOCALIZE_KEY")
}

class OverViewViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var paymentSuccessModel: PaymentSuccessModel = PaymentSuccessModel()
    
    //MARK: - 
    //MARK: - Life Cycle
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let successHeaderView: SuccessTableHeaderViewCell = XibHelper.puffViewWithNibName("SuccessTableHeaderViewCell", index: 0) as! SuccessTableHeaderViewCell
        self.tableView.tableHeaderView = successHeaderView
        
        let totalTableViewCell: TotalTableViewCell = XibHelper.puffViewWithNibName(Constants.Checkout.OverView.totalTableViewCellNibNameAndIdentifier, index: 0) as! TotalTableViewCell
        totalTableViewCell.priceLabel.text = self.paymentSuccessModel.data.totalPrice.formatToPeso()
        
        tableView.estimatedRowHeight = 41.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.tableView.tableFooterView = totalTableViewCell
        self.registerNib()
    }
    
    //MARK: -
    //MARK: - Register Nib
    func registerNib() {
        let plainNib: UINib = UINib(nibName: Constants.Checkout.OverView.plainTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(plainNib, forCellReuseIdentifier: Constants.Checkout.OverView.plainTableViewCellNibNameAndIdentifier)
    }
    
    //MARK: -
    //MARK: - Table View Data Source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: PlainTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.OverView.plainTableViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! PlainTableViewCell
        
        cell.productNameLabel.text = self.paymentSuccessModel.data.orderedProductsModel[indexPath.row].productName
        cell.productQuantityLabel.text = "\(self.paymentSuccessModel.data.orderedProductsModel[indexPath.row].quantity)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentSuccessModel.data.orderedProductsModel.count
    }
}
