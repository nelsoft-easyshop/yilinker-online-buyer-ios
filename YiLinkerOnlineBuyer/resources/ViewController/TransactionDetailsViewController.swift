//
//  TransactionDetailsViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let list = ["North Face Super Uber Traver Bag", "Beats Studio Type 20 Headphones", "Sony Super Bass"]
    
    var newFrame: CGRect!
    
    var headerView: UIView!
    var transactionSectionView: TransactionSectionFooterView!
    var transactionIdView: TransactionIdView!
    var transactionDetailsView: TransactionDetailsView!
    var transactionProductListView: UIView!
    
    var footerView: UIView!
    var transactionDeliveryStatusView: TransactionDeliveryStatusView!
    var transactionSellerView: TransactionSellerView!
    var transactionButtonView: UIView!
    
    var transactionId: String = ""
    var totalProducts: String = ""
    var orderStatus: String = ""
    var paymentType: String = ""
    var dateCreated: String = ""
    var totalQuantity: String = ""
    var totalUnitCost: String = ""
    var shippingFee: String = ""
    var totalCost: String = ""
    
    var total_unit_price: Float = 0.0
    var total_handling_fee: Float = 0.0
    var total_cost: Float = 0.0
    
    var hud: MBProgressHUD?
    
    var table: [TransactionDetailsModel] = []
    var tableSectionContents: TransactionDetailsProductsModel!
    
    var cellCount: Int = 0
    var cellSection: Int = 0
    
    var transactionDetailsModel: TransactionDetailsModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.fireTransactionDetails(self.transactionId)
        
        total_unit_price = (self.totalUnitCost as NSString).floatValue
        total_handling_fee = (self.shippingFee as NSString).floatValue
        
        self.title = "Transaction Details"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if headerView == nil {
            loadViewsWithDetails()
        }
    }
    
    // MARK: - Table View Data Source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.table.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.cellCount != 0 {
            return self.table[section].transactions.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        
        cell.selectionStyle = .None
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        if(self.transactionDetailsModel != nil){
            cell.textLabel?.text = self.table[indexPath.section].transactions[indexPath.row].productName
            //cell.timeLabel?.text =  self.table[indexPath.section].activities[indexPath.row].time
        }
        //cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
        cell.textLabel?.textColor = .darkGrayColor()
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let productDetails = TransactionProductDetailsViewController(nibName: "TransactionProductDetailsViewController", bundle: nil)
        self.navigationController?.pushViewController(productDetails, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         self.transactionSectionView = XibHelper.puffViewWithNibName("TransactionViews", index: 7) as! TransactionSectionFooterView
        if self.table.count != 0 {
            if !self.table[section].feedback {
                self.transactionSectionView.leaveFeedbackButton.backgroundColor = Constants.Colors.appTheme
                self.transactionSectionView.leaveFeedbackButton.borderColor = Constants.Colors.appTheme
                self.transactionSectionView.leaveFeedbackButton.borderWidth = 1
                self.transactionSectionView.leaveFeedbackButton.setTitle("VIEW FEEDBACK FOR SELLER", forState: UIControlState.Normal)
                self.transactionSectionView.leaveFeedbackButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            } else {
                self.transactionSectionView.leaveFeedbackButton.backgroundColor = UIColor.clearColor()
                self.transactionSectionView.leaveFeedbackButton.borderColor = Constants.Colors.appTheme
                self.transactionSectionView.leaveFeedbackButton.borderWidth = 1
                self.transactionSectionView.leaveFeedbackButton.setTitle("LEAVE FEEDBACK FOR SELLER", forState: UIControlState.Normal)
                self.transactionSectionView.leaveFeedbackButton.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
            }
            self.transactionSectionView.sellerNameLabel.text = self.table[section].sellerName
            self.transactionSectionView.sellerContactNumber.text = self.table[section].sellerContact
        }
        
        return self.transactionSectionView
        
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //self.transactionIdView =
       
        
         return XibHelper.puffViewWithNibName("TransactionViews", index: 8) as! TransactionSectionHeaderView
    }

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
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
            self.transactionIdView.transactionIdLabel.text = self.transactionId
            
            if self.totalQuantity.toInt() < 2 {
                self.transactionIdView.numberOfProductsLabel.text = "\(self.totalQuantity) product"
            } else {
                self.transactionIdView.numberOfProductsLabel.text = "\(self.totalQuantity) products"
            }
            
            self.transactionIdView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionIdView
    }

    func getTransactionDetailsView() -> TransactionDetailsView {
        if self.transactionDetailsView == nil {
            self.transactionDetailsView = XibHelper.puffViewWithNibName("TransactionViews", index: 1) as! TransactionDetailsView
            transactionDetailsView.statusLabel.text = self.orderStatus
            transactionDetailsView.paymentTypeLabel.text = self.paymentType
            transactionDetailsView.dateCreatedLabel.text = self.dateCreated
            transactionDetailsView.quantityLabel.text = self.totalQuantity
            transactionDetailsView.unitCostLabel.text = self.total_unit_price.stringToFormat(2)
            transactionDetailsView.shippingFeeLabel.text = self.total_handling_fee.stringToFormat(2)
            transactionDetailsView.totalCostLabel.text = ((self.totalCost as NSString).floatValue).stringToFormat(2)
            
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
        //self.getFooterView().addSubview(self.getTransactionSellerView())
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
        
        //self.setPosition(self.transactionDeliveryStatusView, from: self.transactionSellerView)
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
        let feedbackView = TransactionLeaveFeedbackViewController(nibName: "TransactionLeaveFeedbackViewController", bundle: nil)
        feedbackView.edgesForExtendedLayout = UIRectEdge.None
        feedbackView.rateSeller = true
        self.navigationController?.pushViewController(feedbackView, animated: true)
    }
    
    //MARK: Get transactions details by type
    func fireTransactionDetails(transactionId: String) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        var sampleId = "2015-0123-77"
        println("transaction id \(transactionId)")
        let url = APIAtlas.transactionDetails+"\(SessionManager.accessToken())&transactionId=\(transactionId)" as NSString
        let urlEncoded = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        println(urlEncoded)
        manager.GET(urlEncoded!, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.transactionDetailsModel = TransactionDetailsModel.parseDataFromDictionary(responseObject as! NSDictionary)
          
            self.cellCount = self.transactionDetailsModel!.sellerId.count
            self.cellSection = self.transactionDetailsModel!.sellerId.count
            println("get transactions: \(responseObject.description)")
            println("seller store name \(self.transactionDetailsModel!.sellerStore)")
            for var a = 0; a < self.transactionDetailsModel.sellerId.count; a++ {
                var arr = [TransactionDetailsProductsModel]()
                println("\(self.transactionDetailsModel.productName.count) of \(self.transactionDetailsModel.sellerStore[a])")
                for var b = 0; b < self.transactionDetailsModel.productName.count; b++ {
                    self.tableSectionContents = TransactionDetailsProductsModel(orderProductId: self.transactionDetailsModel.orderProductStatusId[b], productId: self.transactionDetailsModel.orderProductId[b], quantity: self.transactionDetailsModel.quantity[b], unitPrice: self.transactionDetailsModel.unitPrice[b], totalPrice: self.transactionDetailsModel.totalPrice[b], productName: self.transactionDetailsModel.productName[b], handlingFee: self.transactionDetailsModel.handlingFee[b])
                        arr.append(self.tableSectionContents)
                    println("product name \(self.transactionDetailsModel.productName[b]) of \(self.transactionDetailsModel!.sellerStore[0])")
                }
                println("seller name \(self.transactionDetailsModel!.sellerStore[a])")
                self.table.append(TransactionDetailsModel(sellerName: self.transactionDetailsModel!.sellerStore[a], sellerContact: self.transactionDetailsModel!.sellerContactNumber[a], id: self.transactionDetailsModel.sellerId[a], feedback: self.transactionDetailsModel.hasFeedback[a], transactions: arr))
            }

            println("table ----- \(self.table.count)")
            self.tableView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error.userInfo)
                
        })
    }
    
    //MARK: Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
    }

}

//MARK: Number Formatter
extension Float {
    func stringToFormat(fractionDigits:Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return formatter.stringFromNumber(self) ?? "\(self)"
    }
}
