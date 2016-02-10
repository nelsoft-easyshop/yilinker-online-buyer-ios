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
    
    @IBOutlet weak var continueShoppingButton: UIButton!
    @IBOutlet weak var viewTransactionButton: UIButton!
    
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
        
        self.continueShoppingButton.layer.cornerRadius = 5
        self.viewTransactionButton.layer.cornerRadius = 5
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
        cell.productQuantityLabel.text = "x\(self.paymentSuccessModel.data.orderedProductsModel[indexPath.row].quantity)"
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentSuccessModel.data.orderedProductsModel.count
    }
    
    //MARK: - 
    //MARK: - View Transaction
    @IBAction func viewTransaction(sender: AnyObject) {
        if SessionManager.isLoggedIn() {
            self.redirectToTransaction()
            
        } else {
            self.redirectToLogin()
        }
    }
    
    //MARK: -
    //MARK: - Continue Shopping
    @IBAction func continueShopping(sender: AnyObject) {
        self.redirectToHomeView()
    }
    
    //MARK: - 
    //MARK: - Redirect To Transaction
    func redirectToTransaction() {
        let transactionViewController: TransactionViewController = TransactionViewController(nibName: "TransactionViewController", bundle: nil) as TransactionViewController
        let transactionNavigationController: UINavigationController = UINavigationController(rootViewController: transactionViewController)
        transactionNavigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        self.navigationController?.presentViewController(transactionNavigationController, animated: true, completion: nil)
    }
    
    //MARK: - 
    //MARK: - Redirect To Login
    func redirectToLogin() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "StartPageStoryBoard", bundle: nil)
        let loginRegisterViewController: LoginAndRegisterTableViewController = storyBoard.instantiateViewControllerWithIdentifier("LoginAndRegisterTableViewController") as! LoginAndRegisterTableViewController
        loginRegisterViewController.isLogin = true
        self.navigationController!.presentViewController(loginRegisterViewController, animated: true, completion: nil)
    }
    
    func redirectToHomeView() {
        let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegate.changeRootToHomeView()
    }
}
