//
//  TransactionDetailsViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource , TransactionSectionFooterViewDelegate, ViewFeedBackViewControllerDelegate, TransactionDeliveryStatusViewDelegate {

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
    
    var dimView: UIView!
    
    var viewLeaveFeedback: Bool = false
    
    var delegate: TransactionSectionFooterViewDelegate?
    
    //Transaction Details
    var transactionDetailsTitle = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_TITLE_LOCALIZE_KEY")
    
    var transactionDetails = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_LOCALIZE_KEY")
    var statusTitle = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_STATUS_LOCALIZE_KEY")
    var paymentTypeTitle = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_PAYMENT_LOCALIZE_KEY")
    var dateCreatedTitle = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_DATE_LOCALIZE_KEY")
    var totalQuantityTitle = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_QUANTITY_LOCALIZE_KEY")
    var totalUnitCostTitle = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_UNIT_COST_LOCALIZE_KEY")
    var shippingFeeTitle = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_SHIPPING_LOCALIZE_KEY")
    var totalCostTitle = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_TOTAL_COST_LOCALIZE_KEY")
    
    //Delivery Status
    var deliveryStatus = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_DELIVERY_STATUS_LOCALIZE_KEY")
    var checkIn = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_CHECKIN_LOCALIZE_KEY")
    var pickUp = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_PICKUP_LOCALIZE_KEY")
    var delivery = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_DELIVERY_LOCALIZE_KEY")
    
    //Product List
    var productList = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_PRODUCT_LIST_LOCALIZE_KEY")
    var seller = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_SELLER_LOCALIZE_KEY")
    var contactNumber = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_CONTACT_NUMBER_LOCALIZE_KEY")
    var viewFeedback = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_VIEW_FEEDBACK_LOCALIZE_KEY")
    var leaveFeedback = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_LEAVE_FEEDBACK_LOCALIZE_KEY")
    var message = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_MESSAGE_LOCALIZE_KEY")
    
    //Description
    var descriptionTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_DESCRIPTION_LOCALIZE_KEY")
    var seeMore = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_SEE_MORE_LOCALIZE_KEY")
    
    //Cancel Order
    var cancelOrder = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_CANCEL_ORDER_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.fireTransactionDetails(self.transactionId)
        
        total_unit_price = (self.totalUnitCost as NSString).floatValue
        total_handling_fee = (self.shippingFee as NSString).floatValue
        
        self.title = transactionDetailsTitle
        self.backButton()
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
            //cell.textLabel?.tag = self.table[indexPath.section].productId[indexPath.row].toInt()!
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
        productDetails.orderProductId = self.table[indexPath.section].transactions[indexPath.row].orderProductId
        productDetails.quantity = self.table[indexPath.section].transactions[indexPath.row].quantity
        productDetails.unitPrice = self.table[indexPath.section].transactions[indexPath.row].unitPrice
        productDetails.totalPrice = self.table[indexPath.section].transactions[indexPath.row].totalPrice
        productDetails.productName = self.table[indexPath.section].transactions[indexPath.row].productName
        productDetails.transactionId = self.transactionId
        println("section \(indexPath.section) product id: \(self.table[indexPath.section].transactions[indexPath.row].orderProductId)")
        self.navigationController?.pushViewController(productDetails, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
         self.transactionSectionView = XibHelper.puffViewWithNibName("TransactionViews", index: 7) as! TransactionSectionFooterView
        self.transactionSectionView.delegate = self
        self.transactionSectionView.sellerContactNumberTitle.text = self.seller
        self.transactionSectionView.sellerNameLabelTitle.text = self.contactNumber
        self.transactionSectionView.messageButton.setTitle(self.message, forState: UIControlState.Normal)
        if self.table.count != 0 {
            if self.table[section].feedback {
                self.transactionSectionView.leaveFeedbackButton.backgroundColor = Constants.Colors.appTheme
                self.transactionSectionView.leaveFeedbackButton.borderColor = Constants.Colors.appTheme
                self.transactionSectionView.leaveFeedbackButton.borderWidth = 1
                self.transactionSectionView.leaveFeedbackButton.setTitle(viewFeedback, forState: UIControlState.Normal)
                self.transactionSectionView.leaveFeedbackButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
                self.viewLeaveFeedback = false
            } else {
                self.transactionSectionView.leaveFeedbackButton.backgroundColor = UIColor.clearColor()
                self.transactionSectionView.leaveFeedbackButton.borderColor = Constants.Colors.appTheme
                self.transactionSectionView.leaveFeedbackButton.borderWidth = 1
                self.transactionSectionView.leaveFeedbackButton.setTitle(leaveFeedback, forState: UIControlState.Normal)
                self.transactionSectionView.leaveFeedbackButton.setTitleColor(Constants.Colors.appTheme, forState: UIControlState.Normal)
                self.viewLeaveFeedback = true
            }
            self.transactionSectionView.leaveFeedbackButton.tag = self.table[section].sellerIdForFeedback
            self.transactionSectionView.messageButton.backgroundColor = Constants.Colors.appTheme
            self.transactionSectionView.sellerNameLabel.text = self.table[section].sellerName
            self.transactionSectionView.sellerNameLabel.tag = self.table[section].sellerIdForFeedback
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
            transactionDetailsView.transactionDetails.text  = self.transactionDetails
            transactionDetailsView.statusTitleLabel.text = self.statusTitle
            transactionDetailsView.paymentTypeTitleLabel.text = self.paymentTypeTitle
            transactionDetailsView.dateCreatedTitleLabel.text = self.dateCreatedTitle
            transactionDetailsView.quantityTitleLabel.text = self.totalQuantityTitle
            transactionDetailsView.unitCostTitleLabel.text = self.totalUnitCostTitle
            transactionDetailsView.shippingFeeTitleLabel.text = self.shippingFeeTitle
            transactionDetailsView.totalCostTitleLabel.text = self.totalCostTitle
            
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
            listLabel.textColor = .darkGrayColor()
            listLabel.font = UIFont.systemFontOfSize(12.0)
            listLabel.text = self.productList
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
            self.transactionDeliveryStatusView.deliveryStatusLabel.text = self.deliveryStatus
            self.transactionDeliveryStatusView.nameAndPlaceTitleLabel.text = self.checkIn
            self.transactionDeliveryStatusView.pickupRiderTitleLabel.text = self.pickUp
            self.transactionDeliveryStatusView.deliveryRiderTitleLabel.text = self.delivery
            self.transactionDeliveryStatusView.frame.size.width = self.view.frame.size.width
            self.transactionDeliveryStatusView.delegate = self
        }
        return self.transactionDeliveryStatusView
    }
    
    func getTransactionButtonView() -> UIView {
        if self.transactionButtonView == nil {
            self.transactionButtonView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))//50
            
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
            feedbackButton.hidden = true
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
    
    func leaveFeedback(tag: Int) {
        let feedbackView = TransactionLeaveSellerFeedbackViewController(nibName: "TransactionLeaveSellerFeedbackViewController", bundle: nil)
        feedbackView.edgesForExtendedLayout = UIRectEdge.None
        feedbackView.sellerId = tag
        self.navigationController?.pushViewController(feedbackView, animated: true)
    }
    
    //MARK: View sellers feedback
    func leaveSellerFeedback(title: String, tag: Int) {
        println("\(self.transactionSectionView.leaveFeedbackButton.titleLabel?.text) \(tag)")
        if title == self.leaveFeedback {
            self.leaveFeedback(tag)
            println("leave feedback \(tag)")
        } else {
            self.showView()
            var attributeModal = ViewFeedBackViewController(nibName: "ViewFeedBackViewController", bundle: nil)
            attributeModal.delegate = self
            attributeModal.sellerId = tag
            println("view feedback \(tag)")
            attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            attributeModal.providesPresentationContextTransitionStyle = true
            attributeModal.definesPresentationContext = true
            attributeModal.screenWidth = self.view.frame.width
            self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        }
       
    }
    
    //MARK: Get transactions details by id
    func fireTransactionDetails(transactionId: String) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let url = APIAtlas.transactionDetails+"\(SessionManager.accessToken())&transactionId=\(transactionId)" as NSString
        let urlEncoded = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        println(urlEncoded)
        manager.GET(urlEncoded!, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.transactionDetailsModel = TransactionDetailsModel.parseDataFromDictionary(responseObject as! NSDictionary)
            
            println(responseObject.description)
          
            self.cellCount = self.transactionDetailsModel!.sellerId.count
            self.cellSection = self.transactionDetailsModel!.sellerId.count
            
            for var a = 0; a < self.transactionDetailsModel.sellerId.count; a++ {
                var arr = [TransactionDetailsProductsModel]()
                for var b = 0; b < self.transactionDetailsModel.productName.count; b++ {
                   if self.transactionDetailsModel.sellerId[a] == self.transactionDetailsModel.sellerId2[b] {
                        self.tableSectionContents = TransactionDetailsProductsModel(orderProductId: self.transactionDetailsModel.orderProductId[b], productId: self.transactionDetailsModel.productId[b], quantity: self.transactionDetailsModel.quantity[b], unitPrice: self.transactionDetailsModel.unitPrice[b], totalPrice: self.transactionDetailsModel.totalPrice[b], productName: self.transactionDetailsModel.productName[b], handlingFee: self.transactionDetailsModel.handlingFee[b])
                        arr.append(self.tableSectionContents)
                    }
                }
                self.table.append(TransactionDetailsModel(sellerName: self.transactionDetailsModel!.sellerStore[a], sellerContact: self.transactionDetailsModel!.sellerContactNumber[a], id: self.transactionDetailsModel.sellerId[a], sellerIdForFeedback: self.transactionDetailsModel.sellerId[a], feedback: self.transactionDetailsModel.hasFeedback[a], transactions: arr))
            }

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
    
    //MARK: Show and hide dim view
    
    func showView(){
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = false
            self.dimView.alpha = 0.5
            self.dimView.layer.zPosition = 2
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.93)
        })
    }
    
    func dismissDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = true
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
        })
    }
    
    //MARK: SMS and Phone call
    func pickupSmsAction() {
         UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Send SMS action.", title: "SMS pick-up")
    }
    
    func pickupCallAction() {
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:9809088798")!) {
            println("can call")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Call number action.", title: "Call Pick-up")
        } else {
            println("cant make a call")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Cannot make a call", title: "Call Pick-up")
        }
    }
    
    func deliverySmsAction() {
         UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Send SMS action.", title: "SMS Pick-up")
    }
    
    func deliveryCallAction() {
        if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:9809088798")!) {
            println("can call")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Call number action.", title: "Call Delivery")
        } else {
            println("cant make a call")
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Cannot make a call", title: "Call Delivery")
        }
    }
    
    //MARK: Navigation bar
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
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
