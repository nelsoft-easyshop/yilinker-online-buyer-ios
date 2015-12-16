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
  
    var dimView: UIView!
    var footerView: UIView!
    var headerView: UIView!
    var transactionButtonView: UIView!
    var transactionProductListView: UIView!
    
    var transactionSectionView: TransactionSectionFooterView!
    var transactionIdView: TransactionIdView!
    var transactionDetailsView: TransactionDetailsView!
    var transactionDeliveryStatusView: TransactionDeliveryStatusView!
    var transactionSellerView: TransactionSellerView!
    
    var viewLeaveFeedback: Bool = false
    var canMessage: Bool = false
    var total_unit_price: Float = 0.0
    var total_handling_fee: Float = 0.0
    var total_cost: Float = 0.0
    var cellCount: Int = 0
    var cellSection: Int = 0
    var transactionId: String = ""
    var totalProducts: String = ""
    var orderStatus: String = ""
    var orderStatusId: String = ""
    var paymentType: String = ""
    var dateCreated: String = ""
    var totalQuantity: String = ""
    var totalUnitCost: String = ""
    var shippingFee: String = ""
    var totalCost: String = ""
    var orderId: String = ""
    
    var hud: MBProgressHUD?
    
    var table: [TransactionDetailsModel] = []
    var tableSectionContents: TransactionDetailsProductsModel!
    var transactionDetailsModel: TransactionDetailsModel!
    var sellerModel: SellerModel!
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
    
    //Error messages
    let ok: String = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
    let somethingWentWrong: String = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
    let error: String = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
    let errorFeedback: String = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_NOT_ALLOWED_FEEDBACK_LOCALIZE_KEY")
    let errorMessage: String = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_NOT_ALLOWED_FEEDBACK_LOCALIZE_KEY")
    
    //Contacts
    var selectedContact : W_Contact?
    var emptyView : EmptyView?
    var conversations = [W_Conversation]()
    var contacts = [W_Contact()]
    var contactsNotFollowed = [W_Contact()]
    var arrayContacts: [String] = []
    
    //Strings
    var sellerId: String = ""
    var transactionType: String = ""
    var refreshPage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Added dimView
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.tableView.layoutMargins = UIEdgeInsetsZero
        self.tableView.separatorInset = UIEdgeInsetsZero
        
        total_unit_price = (self.totalUnitCost as NSString).floatValue
        total_handling_fee = (self.shippingFee as NSString).floatValue
        
        //Set title of navigation bar
        self.title = transactionDetailsTitle
        //Customize navigation bar
        self.backButton()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.table.removeAll(keepCapacity: false)
        self.conversations.removeAll(keepCapacity: false)
        self.contacts.removeAll(keepCapacity: false)
        self.contactsNotFollowed.removeAll(keepCapacity: false)
        
        //Get transaction details
        self.fireTransactionDetails(self.transactionId)
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

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 84
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /*
        let cell = UITableViewCell(style: .Default, reuseIdentifier: "identifier")
        
        cell.selectionStyle = .None
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        if(self.transactionDetailsModel != nil){
            cell.textLabel?.text = self.table[indexPath.section].transactions[indexPath.row].productName
        }
        
        cell.textLabel?.font = UIFont.systemFontOfSize(15.0)
        cell.textLabel?.textColor = .darkGrayColor()
        */
        let transactionDetailsTableViewCell: TransactionDetailsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionDetailsTableViewCell") as! TransactionDetailsTableViewCell
        transactionDetailsTableViewCell.selectionStyle = UITableViewCellSelectionStyle.None
        transactionDetailsTableViewCell.layoutMargins = UIEdgeInsetsZero
        transactionDetailsTableViewCell.separatorInset = UIEdgeInsetsZero
        if(self.transactionDetailsModel != nil){
            transactionDetailsTableViewCell.productNameLabel.text = self.table[indexPath.section].transactions[indexPath.row].productName
            transactionDetailsTableViewCell.productStatusLabel.text = self.table[indexPath.section].orderStatus
        }
        
        return transactionDetailsTableViewCell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let productDetails = TransactionProductDetailsViewController(nibName: "TransactionProductDetailsViewController", bundle: nil)
        productDetails.orderProductId = self.table[indexPath.section].transactions[indexPath.row].orderProductId
        productDetails.productId = self.table[indexPath.section].transactions[indexPath.row].productId
        productDetails.quantity = self.table[indexPath.section].transactions[indexPath.row].quantity
        productDetails.unitPrice = self.table[indexPath.section].transactions[indexPath.row].unitPrice
        productDetails.totalPrice = self.calculateTotalUnitCost(self.table[indexPath.section].transactions[indexPath.row].quantity, price: self.table[indexPath.section].transactions[indexPath.row].unitPrice).formatToTwoDecimal().formatToPeso()
        productDetails.hasProductFeedback = self.table[indexPath.section].transactions[indexPath.row].hasProductFeedback
        //self.table[indexPath.section].transactions[indexPath.row].totalPrice
        productDetails.productName = self.table[indexPath.section].transactions[indexPath.row].productName
        productDetails.transactionId = self.transactionId
        productDetails.isCancellable = self.table[indexPath.section].transactions[indexPath.row].isCancellable
        self.navigationController?.pushViewController(productDetails, animated: true)
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        self.transactionSectionView = XibHelper.puffViewWithNibName("TransactionViews", index: 7) as! TransactionSectionFooterView
        self.transactionSectionView.delegate = self
        self.transactionSectionView.sellerContactNumberTitle.text = self.contactNumber
        self.transactionSectionView.sellerNameLabelTitle.text = self.seller
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
            self.transactionSectionView.messageButton.tag = self.table[section].sellerIdForFeedback
            self.transactionSectionView.sellerNameLabel.text = self.table[section].sellerName
            self.transactionSectionView.sellerNameLabel.tag = self.table[section].sellerIdForFeedback
            self.transactionSectionView.sellerContactNumber.text = self.table[section].sellerContact
        }
        
        return self.transactionSectionView
        
    }
    
    func sellerPage(sellerId: Int) {
        let sellerViewController: SellerViewController = SellerViewController(nibName: "SellerViewController", bundle: nil)
        sellerViewController.sellerId = sellerId
        self.navigationController!.pushViewController(sellerViewController, animated: true)
    }
    
    func calculateTotalUnitCost(quantity: Int, price: String) -> String {
        var tempUnitCost: Double = 0
        
        for i in 1...quantity {
            tempUnitCost += (price.stringByReplacingOccurrencesOfString(",", withString: "") as NSString).doubleValue
        }
        
        return "\(tempUnitCost)"
    }

    /*
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //self.transactionIdView =
        
        
        return XibHelper.puffViewWithNibName("TransactionViews", index: 8) as! TransactionSectionHeaderView
    }
    */
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 140
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
            self.transactionIdView.transactionIdLabel.text = "TID-" + self.transactionId
            
            if self.totalProducts.toInt() < 2 {
                self.transactionIdView.numberOfProductsLabel.text = "\(self.totalProducts) product"
            } else {
                self.transactionIdView.numberOfProductsLabel.text = "\(self.totalProducts) products"
            }
            
            self.transactionIdView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionIdView
    }
    
    func getTransactionDetailsView() -> TransactionDetailsView {
        if self.transactionDetailsView == nil {
            self.transactionDetailsView = XibHelper.puffViewWithNibName("TransactionViews", index: 1) as! TransactionDetailsView
            
            if(self.transactionDetailsModel != nil){
               
                var totalProductCost = self.calculateTotalUnitCost(self.totalQuantity.toInt()!, price: self.transactionDetailsModel.transactionTotalPrice)
                //transactionDetailsView.unitCostLabel.text = (self.transactionDetailsModel.transactionUnitPrice).formatToTwoDecimal().formatToPeso()
                transactionDetailsView.unitCostLabel.text = (self.totalCost).formatToPeso()
                    //(self.transactionDetailsModel.transactionUnitPrice).formatToPeso()
                transactionDetailsView.shippingFeeLabel.text = (self.transactionDetailsModel.transactionShippingFee).formatToPeso()
                transactionDetailsView.totalCostLabel.text = (self.transactionDetailsModel.transactionTotalPrice).formatToPeso()
                //("\((self.transactionDetailsModel.transactionUnitPrice + self.transactionDetailsModel.transactionShippingFee))").formatToTwoDecimal().formatToPeso()
                
            }
            
            transactionDetailsView.transactionDetails.text  = self.transactionDetails
            transactionDetailsView.statusTitleLabel.text = self.statusTitle
            transactionDetailsView.paymentTypeTitleLabel.text = self.paymentTypeTitle
            transactionDetailsView.dateCreatedTitleLabel.text = self.dateCreatedTitle
            transactionDetailsView.quantityTitleLabel.text = self.totalQuantityTitle
            transactionDetailsView.unitCostTitleLabel.text = self.totalUnitCostTitle
            transactionDetailsView.shippingFeeTitleLabel.text = self.shippingFeeTitle
            transactionDetailsView.totalCostTitleLabel.text = self.totalCostTitle
            //transactionDetailsView.statusLabel.text = self.orderStatus
            transactionDetailsView.statusLabel.text = self.transactionType
            transactionDetailsView.paymentTypeLabel.text = self.paymentType
            transactionDetailsView.dateCreatedLabel.text = self.dateCreated
            transactionDetailsView.quantityLabel.text = self.totalQuantity
//            transactionDetailsView.unitCostLabel.text = "\((self.totalUnitCost).formatToPeso())"
//            transactionDetailsView.shippingFeeLabel.text = "\((self.shippingFee).formatToPeso())"
//            transactionDetailsView.totalCostLabel.text = "\((self.totalCost).formatToPeso())"
            
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
        
        //CELL
        let transactionNib: UINib = UINib(nibName: "TransactionDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(transactionNib, forCellReuseIdentifier: "TransactionDetailsTableViewCell")
        
        // HEADERS
        self.getHeaderView().addSubview(self.getTransactionIdView())
        self.getHeaderView().addSubview(self.getTransactionDetailsView())
        self.getHeaderView().addSubview(self.getTransactionProductListView())
        
        
        // FOOTERS
        //self.getFooterView().addSubview(self.getTransactionSellerView())
        //self.getFooterView().addSubview(self.getTransactionDeliveryStatusView())
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
        //self.setPosition(self.transactionButtonView, from: self.transactionDeliveryStatusView)
        //self.setPosition(footerGrayColor, from: self.transactionButtonView)
        //footerGrayColor.frame.origin.y -= 20
        
        //newFrame = self.footerView.frame
        //newFrame.size.height = CGRectGetMaxY(self.transactionButtonView.frame)
        //self.footerView.frame = newFrame
        
        //self.tableView.tableFooterView = nil
        //self.tableView.tableFooterView = self.footerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame) + 20
        view.frame = newFrame
    }
    
    // MARK: - Actions
    
    func leaveFeedback(tag: Int) {
        //let feedbackView = TransactionLeaveSellerFeedbackViewController(nibName: "TransactionLeaveSellerFeedbackViewController", bundle: nil)
        //feedbackView.edgesForExtendedLayout = UIRectEdge.None
        let feedbackView = TransactionLeaveSellerFeedbackTableViewController(nibName: "TransactionLeaveSellerFeedbackTableViewController", bundle: nil)
        feedbackView.sellerId = tag
        feedbackView.orderId = self.orderId.toInt()!
        feedbackView.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.pushViewController(feedbackView, animated: true)
    }
    
    func messageSeller(sellerId: Int) {
        self.canMessage = false
        if contains(self.arrayContacts, "\(sellerId)") {
            for var i = 0; i < self.contacts.count; i++ {
                if "\(sellerId)" == contacts[i].userId {
                    self.selectedContact = contacts[i]
                    self.canMessage = true
                    self.showMessaging()
                }
            }
        } else {
            self.fireSeller("\(sellerId)")
        }
    }
    
    func showMessaging(){
        let storyBoard: UIStoryboard = UIStoryboard(name: "HomeStoryBoard", bundle: nil)
        let messagingViewController: MessageThreadVC = (storyBoard.instantiateViewControllerWithIdentifier("MessageThreadVC") as? MessageThreadVC)!
        
        var isOnline = "-1"
        if (SessionManager.isLoggedIn()){
            isOnline = "1"
        } else {
            isOnline = "0"
        }
        
        messagingViewController.sender = W_Contact(fullName: SessionManager.userFullName() , userRegistrationIds: "", userIdleRegistrationIds: "", userId: SessionManager.accessToken(), profileImageUrl: SessionManager.profileImageStringUrl(), isOnline: isOnline)
        messagingViewController.recipient = selectedContact
        
        if self.canMessage {
            self.navigationController?.pushViewController(messagingViewController, animated: true)
        } else {
            self.showAlert(title: self.error, message: self.errorMessage)
        }
    }
    
    //MARK: Get seller/store info
    func fireSeller(sellerId: String) {
        
        self.showHUD()
        
        self.sellerId = sellerId
        
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary?
        
        var url: String = ""
        
        if SessionManager.isLoggedIn() {
            url = APIAtlas.getSellerInfoLoggedIn
            parameters = ["userId" : sellerId, "access_token" : SessionManager.accessToken()] as NSDictionary
        } else {
            url = APIAtlas.getSellerInfo
            parameters = ["userId" : sellerId] as NSDictionary
        }
        
        manager.POST(url, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if responseObject["isSuccessful"] as! Bool {
                self.sellerModel = SellerModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
                self.contactsNotFollowed.append(W_Contact(fullName: self.sellerModel.store_name, userRegistrationIds: "", userIdleRegistrationIds: "", userId: sellerId, profileImageUrl: "\(self.sellerModel.avatar)", isOnline: "1"))
                
                for var i = 0; i < self.contactsNotFollowed.count; i++ {
                    if "\(sellerId)" == self.contactsNotFollowed[i].userId {
                        self.selectedContact = self.contactsNotFollowed[i]
                        self.canMessage = true
                        self.showMessaging()
                    }
                }
                
            } else {
                self.showAlert(title: "Error", message: responseObject["message"] as! String)
            }
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken(TransactionDetailsType.Seller)
                } else {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    //self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                    self.hud?.hide(true)
                }
        })
    }
    
    func deliveryLogsAction() {
        let deliveryLogs = TransactionDeliveryLogViewController(nibName: "TransactionDeliveryLogViewController", bundle: nil)
        deliveryLogs.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.pushViewController(deliveryLogs, animated: true)
    }
    
    //MARK: View sellers feedback
    func leaveSellerFeedback(title: String, tag: Int) {
        
        if title == self.leaveFeedback {
            if self.orderStatusId == "3" || self.orderStatusId == "6"{
                self.leaveFeedback(tag)
            } else {
                self.showAlert(title: self.errorFeedback, message: "")
            }
        } else {
            self.showView()
            var attributeModal = ViewFeedBackViewController(nibName: "ViewFeedBackViewController", bundle: nil)
            attributeModal.delegate = self
            attributeModal.sellerId = tag
            attributeModal.feedback = true
            attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            attributeModal.providesPresentationContextTransitionStyle = true
            attributeModal.definesPresentationContext = true
            attributeModal.screenWidth = self.view.frame.width
            self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        }
    }
    
    //MARK: Get transactions details by id
    func fireTransactionDetails(transactionId: String) {
        
        self.showProgressBar()
       
        let manager = APIManager.sharedInstance
        let url = APIAtlas.transactionDetails+"\(SessionManager.accessToken())&transactionId=\(transactionId)" as NSString
        let urlEncoded = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
        
        manager.GET(urlEncoded!, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            if responseObject["isSuccessful"] as! Bool {
                self.transactionDetailsModel = TransactionDetailsModel.parseDataFromDictionary2(responseObject as! NSDictionary)
                
                self.cellCount = self.transactionDetailsModel!.sellerId.count
                self.cellSection = self.transactionDetailsModel!.sellerId.count
                
                for var a = 0; a < self.transactionDetailsModel.sellerId.count; a++ {
                    var arr = [TransactionDetailsProductsModel]()
                    for var b = 0; b < self.transactionDetailsModel.productName.count; b++ {
                        if self.transactionDetailsModel.sellerId[a] == self.transactionDetailsModel.sellerId2[b] {
                            self.tableSectionContents = TransactionDetailsProductsModel(orderProductId: self.transactionDetailsModel.orderProductId[b], productId: self.transactionDetailsModel.productId[b], quantity: self.transactionDetailsModel.quantity[b], unitPrice: self.transactionDetailsModel.unitPrice[b], totalPrice: self.transactionDetailsModel.totalPrice[b], productName: self.transactionDetailsModel.productName[b], handlingFee: self.transactionDetailsModel.handlingFee[b], isCancellable: self.transactionDetailsModel.isCancellable[b], hasProductFeedback: self.transactionDetailsModel.hasProductFeedback[b])
                            arr.append(self.tableSectionContents)
                        }
                    }
                    
                    self.table.append(TransactionDetailsModel(sellerName: self.transactionDetailsModel!.sellerStore[a], sellerContact: self.transactionDetailsModel!.sellerContactNumber[a], id: self.transactionDetailsModel.sellerId[a], sellerIdForFeedback: self.transactionDetailsModel.sellerId[a], feedback: self.transactionDetailsModel.hasFeedback[a], transactions: arr, orderStatus: self.transactionDetailsModel.name[a]))
                }
                
                if self.headerView == nil {
                    self.loadViewsWithDetails()
                }
                
                self.tableView.reloadData()
                
                self.hideProgressBar()
                
                //Get buyer's contacts
                self.getContactsFromEndpoint("1", limit: "30", keyword: "")
            } else {
                self.showAlert(title: self.error, message: self.somethingWentWrong)
            }
            
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    if (SessionManager.isLoggedIn()){
                        //self.fireRefreshToken()
                    }
                    self.fireRefreshToken(TransactionDetailsType.Details)
                } else {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    
                    self.hideProgressBar()
                    
                    //self.showAlert(title: self.error, message: self.somethingWentWrong)
                }
        })
    }
    
    func getContactsFromEndpoint(
        page : String,
        limit : String,
        keyword: String){
            if (Reachability.isConnectedToNetwork()) {
                
                self.showProgressBar()
                
                let manager: APIManager = APIManager.sharedInstance
                manager.requestSerializer = AFHTTPRequestSerializer()
                
                let parameters: NSDictionary = [
                    "page"          : "\(page)",
                    "limit"         : "\(limit)",
                    "keyword"       : keyword,
                    "access_token"  : SessionManager.accessToken()
                    ]   as Dictionary<String, String>
                
                let url = APIAtlas.baseUrl + APIAtlas.ACTION_GET_CONTACTS
                
                manager.POST(url, parameters: parameters, success: {
                    (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                    println(responseObject)
                    self.contacts = W_Contact.parseContacts(responseObject as! NSDictionary)
                    
                    for var i = 0; i < self.contacts.count; i++ {
                        self.arrayContacts.append(self.contacts[i].userId)
                    }
                    
                    self.hideProgressBar()
                    
                    self.refreshPage = true
                    
                    }, failure: {
                        (task: NSURLSessionDataTask!, error: NSError!) in
                        let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                        
                        if task.statusCode == 401 {
                            if (SessionManager.isLoggedIn()){
                                //self.fireRefreshToken()
                            }
                            self.fireRefreshToken(TransactionDetailsType.Contacts)
                        } else {
                            let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                            let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                            self.hud?.hide(true)
                            //self.showAlert(title: self.error, message: self.somethingWentWrong)
                        }
                        
                        self.contacts = Array<W_Contact>()
                        self.hideProgressBar()
                })
            }
    }
    
    func fireRefreshToken(type: TransactionDetailsType) {
        
        self.showProgressBar()
        
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID(), "client_secret": Constants.Credentials.clientSecret(), "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
            if type == TransactionDetailsType.Details {
                self.fireTransactionDetails(self.transactionId)
            } else if type == TransactionDetailsType.Seller {
                self.fireSeller(self.sellerId)
            } else {
                self.getContactsFromEndpoint("1", limit: "30", keyword: "")
            }
            
            self.hideProgressBar()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                
                self.hideProgressBar()
                //self.showAlert(title: self.error, message: self.somethingWentWrong)
        })
        
    }
    
    func showProgressBar() {
        if self.refreshPage {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        } else {
            self.showHUD()
        }
    }
    
    func hideProgressBar() {
        if self.refreshPage {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        } else {
            self.hud?.hide(true)
        }
    }
    
    //MARK: Show alert dialog box
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: self.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
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
    //Show
    func showView(){
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = false
            self.dimView.alpha = 0.5
            self.dimView.layer.zPosition = 2
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.93)
        })
    }
    
    //Hide
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