//
//  TransactionProductDetailsViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit
import MessageUI

class TransactionProductDetailsViewController: UIViewController, TransactionCancelOrderViewDelegate, TransactionCancelViewControllerDelegate, TransactionCancelOrderSuccessViewControllerDelegate, TransactionDescriptionViewDelegate, TransactionProductDetailsDescriptionViewControllerDelegate, TransactionDeliveryStatusViewDelegate, MFMessageComposeViewControllerDelegate{
    
    @IBOutlet weak var tableView: UITableView!
    
    var newFrame: CGRect!
    
    var headerView: UIView!
    var transactionProductImagesView: TransactionProductImagesView!
    var transactionPurchaseDetailsView: TransactionPurchaseDetailsView!
    var transactionCancelView: TransactionCancelOrderView!
    var transactionProductDetailsView: UIView!
    
    var footerView: UIView!
    var transactionDescriptionView: TransactionDescriptionView!
    var transactionDeliveryStatusView: TransactionDeliveryStatusView!
    var transactionButtonView: UIView!
    var dimView: UIView!
    
    var name = ["SKU", "Brand", "Color", "Size", "Weight (kg)", "Height (mm)", "Width (cm)", "Length (cm)"]
    var value = ["ABCD-1234-5678-91022", "Beats Audio Version", "0.26", "203", "3.5mm"]
    var array: NSArray?
    var mArray: NSMutableArray?
    
    var orderProductId: String = ""
    var quantity: Int = 0
    var unitPrice: String = ""
    var totalPrice: String = ""
    var productName: String = ""
    var transactionId: String = ""
    var imageUrl: String = ""
    var isCancellable: Bool = false
    var refreshtag: Int = 1001
    var time: Int = 0
    
    var myTimer: NSTimer?
    var hud: MBProgressHUD?
    var transactionProductDetailsModel: TransactionProductDetailsModel!
    var transactionDeliveryStatus: TransactionProductDetailsDeliveryStatusModel!
    var productDictionary = Dictionary<String, String>()
    
    //Product details
    var productDetailsTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_TITLE_LOCALIZE_KEY")
    
    var purchaseDetails = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_PURCHASE_DETAILS_LOCALIZE_KEY")
    var quantityTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_QUANTITY_LOCALIZE_KEY")
    var priceTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_PRICE_LOCALIZE_KEY")
    var totalCostTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_TOTAL_COST_LOCALIZE_KEY")
    
    var productDetails = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_LOCALIZE_KEY")
    
    //Description
    var descriptionTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_DESCRIPTION_LOCALIZE_KEY")
    var seeMore = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_SEE_MORE_LOCALIZE_KEY")
    
    //Cancel Order
    var cancelOrder = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DETAILS_CANCEL_ORDER_LOCALIZE_KEY")
    
    var descriptionProductTitle = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DESCRIPTION_TITLE_LOCALIZE_KEY")
    var longDescription = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_DESCRIPTION_LOCALIZE_KEY")
    
    var okTitle = StringHelper.localizedStringWithKey("OK_BUTTON_LOCALIZE_KEY")
    
    //Delivery Status
    var deliveryStatus = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_DELIVERY_STATUS_LOCALIZE_KEY")
    var checkIn = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_CHECKIN_LOCALIZE_KEY")
    var pickUp = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_PICKUP_LOCALIZE_KEY")
    var delivery = StringHelper.localizedStringWithKey("TRANSACTION_DETAILS_DELIVERY_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.title = productDetailsTitle
        self.backButton()
        
        let nib = UINib(nibName: "TransactionProductDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TransactionProductDetailsIdentifier")
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
        
        println("order product id \(self.orderProductId) \(self.isCancellable)")
        self.fireTransactionProductDetailsDeliveryStatus()
        self.fireTransactionProductDetails()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: - Table View Data Souce
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.transactionProductDetailsModel != nil {
            return self.transactionProductDetailsModel.attributeName.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TransactionProductDetailsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionProductDetailsIdentifier") as! TransactionProductDetailsTableViewCell
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        cell.selectionStyle = .None
        if self.transactionProductDetailsModel != nil {
            cell.attributeNameLabel.text = self.transactionProductDetailsModel.attributeName[indexPath.row]
            cell.attributeValueLabel.text = self.transactionProductDetailsModel.attributeValue[indexPath.row]
        }
        
        
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
            self.transactionProductImagesView.nameLabel.text = self.productName
            self.imageUrl = self.transactionProductDetailsModel.productImage
            self.transactionProductImagesView.imageUrl = self.imageUrl
            if self.transactionProductDetailsModel != nil {
                self.transactionProductImagesView.descriptionLabel.text = self.transactionProductDetailsModel.shortDescription
            }
            self.transactionProductImagesView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionProductImagesView
    }
    
    func getTransactionPurchaseDetailsView() -> TransactionPurchaseDetailsView {
        if self.transactionPurchaseDetailsView == nil {
            self.transactionPurchaseDetailsView = XibHelper.puffViewWithNibName("TransactionViews", index: 5) as! TransactionPurchaseDetailsView
            self.transactionPurchaseDetailsView.quantityTitleLabel.text = self.quantityTitle
            self.transactionPurchaseDetailsView.totalCostTitleLabel.text = self.totalCostTitle
            self.transactionPurchaseDetailsView.priceTitleLabel.text = self.priceTitle
            self.transactionPurchaseDetailsView.purchaseDetailsLabel.text = self.purchaseDetails
            self.transactionPurchaseDetailsView.quantityLabel.text = "\(self.quantity)"
            self.transactionPurchaseDetailsView.totalCostLabel.text = "\((self.totalPrice).formatToPeso())"
            self.transactionPurchaseDetailsView.priceLabel.text = "\((self.unitPrice).formatToPeso())"
            self.transactionPurchaseDetailsView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionPurchaseDetailsView
    }
    
    func getTransactionProductDetailsView() -> UIView {
        if self.transactionProductDetailsView == nil {
            self.transactionProductDetailsView = UIView(frame: (CGRectMake(0, 0, self.view.frame.size.width, 40)))
            self.transactionProductDetailsView.backgroundColor = .whiteColor()
            
            var textLabel = UILabel(frame: CGRectMake(8, 0, self.transactionProductDetailsView.frame.size.width - 8, self.transactionProductDetailsView.frame.size.height))
            textLabel.text = self.productDetails
            textLabel.textColor = .darkGrayColor()
            textLabel.font = UIFont (name: "Panton-Regular", size: 15.0)
            
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
            self.transactionDescriptionView.descriptionTitleLabel.text = self.descriptionTitle
            self.transactionDescriptionView.seeMoreLabel.text = self.seeMore
            self.transactionDescriptionView.delegate = self
            if self.transactionProductDetailsModel != nil {
                self.transactionDescriptionView.descriptionLabel.text = self.transactionProductDetailsModel.shortDescription
            }
            self.transactionDescriptionView.frame.size.width = self.view.frame.size.width
            self.transactionDescriptionView.frame.origin.y += CGFloat(20)
        }
        return self.transactionDescriptionView
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
            
            if self.transactionDeliveryStatus != nil {
                self.transactionDeliveryStatusView.nameAndPlaceLabel.text = self.transactionDeliveryStatus.lastCheckedInBy + " - " + self.transactionDeliveryStatus.lastCheckedInLocation
                self.transactionDeliveryStatusView.pickupRiderLabel.text = self.transactionDeliveryStatus.pickupRider
                self.transactionDeliveryStatusView.deliveryRiderLabel.text = self.transactionDeliveryStatus.deliveryRider
            } else {
                self.transactionDeliveryStatusView.nameAndPlaceLabel.text = "-"
                self.transactionDeliveryStatusView.pickupRiderLabel.text = "-"
                self.transactionDeliveryStatusView.deliveryRiderLabel.text = "-"
            }
            
            self.transactionDeliveryStatusView.frame.size.width = self.view.frame.size.width
            self.transactionDeliveryStatusView.frame.origin.y += CGFloat(20)
        }
        return self.transactionDeliveryStatusView
    }
    
    func getTransactionCancelOrderView() -> TransactionCancelOrderView {
        if self.transactionCancelView == nil {
            self.transactionCancelView = XibHelper.puffViewWithNibName("TransactionViews", index: 9) as! TransactionCancelOrderView
            self.transactionCancelView.cancelOrderLabel.text = self.cancelOrder
            self.transactionCancelView.delegate = self
            if !self.isCancellable {
                self.transactionCancelView.cancelView.hidden = true
            }
            self.transactionCancelView.frame.size.width = self.view.frame.size.width
            self.transactionCancelView.frame.origin.y += CGFloat(20)
        }
        return self.transactionCancelView
    }
    
    func getTransactionButtonView() -> UIView {
        if self.transactionButtonView == nil {
            self.transactionButtonView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 0))
            
            var feedbackButton: UIButton = UIButton(frame: CGRectZero)
            feedbackButton.addTarget(self, action: "leaveFeedback", forControlEvents: .TouchUpInside)
            feedbackButton.setTitle("LEAVE FEEDBACK FOR PRODUCT", forState: .Normal)
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
    
    //MARK: Transaction Description Delegate Method
    func getProductDescription(desc: String) {
        let description = ProductDescriptionViewController(nibName: "ProductDescriptionViewController", bundle: nil)
        description.url = self.transactionProductDetailsModel.longDescription
        description.title = self.descriptionProductTitle
        let root: UINavigationController = UINavigationController(rootViewController: description)
        self.tabBarController?.presentViewController(root, animated: true, completion: nil)
        /*
        var productDescription = TransactionProductDetailsDescriptionViewController(nibName: "TransactionProductDetailsDescriptionViewController", bundle: nil)
        productDescription.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        productDescription.providesPresentationContextTransitionStyle = true
        productDescription.definesPresentationContext = true
        productDescription.view.frame.origin.y = productDescription.view.frame.size.height
        productDescription.descriptionTitleLabel.text = self.descriptionProductTitle
        productDescription.longDesctiptionLabel.text = self.longDescription
        productDescription.longDesctiptionLabel.text = desc
        productDescription.longDescriptionTextView.text = desc
        productDescription.okButton.setTitle(self.okTitle, forState: UIControlState.Normal)
        productDescription.delegate = self
        self.tabBarController?.presentViewController(productDescription, animated: true, completion:
            nil)
        */
    }
    
    //MARK: TransactionProductDetailsDescriptionViewController delegate method
    func closeAction() {
        self.dismissView()
    }
    
    func okAction() {
        self.dismissView()
    }
    
    // MARK: - Methods
    
    func loadViewsWithDetails() {
        // HEADERS
        self.getHeaderView().addSubview(self.getTransactionProductImagesView())
        self.getHeaderView().addSubview(self.getTransactionPurchaseDetailsView())
        self.getHeaderView().addSubview(self.getTransactionProductDetailsView())
        
        // FOOTERS
        self.getFooterView().addSubview(self.getTransactionDescriptionView())
        self.getFooterView().addSubview(self.getTransactionDeliveryStatusView())
        
        self.getFooterView().addSubview(self.getTransactionCancelOrderView())
        
        //self.getFooterView().addSubview(self.getTransactionButtonView())
        
        setUpViews()
    }
    
    func setUpViews() {
        // header
        self.setPosition(self.transactionPurchaseDetailsView, from: self.transactionProductImagesView)
        self.setPosition(self.transactionProductDetailsView, from: self.transactionPurchaseDetailsView)
        //self.setPosition(self.transactionCancelView, from: self.transactionCancelView)
        
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.transactionProductDetailsView.frame)
        self.headerView.frame = newFrame
        
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
        
        // footer
        var footerGrayColor = UIView(frame: self.view.frame)
        footerGrayColor.backgroundColor = Constants.Colors.backgroundGray
        self.getFooterView().addSubview(footerGrayColor)
        
        self.setPosition(self.transactionDeliveryStatusView, from: self.transactionDescriptionView)
        self.setPosition(footerGrayColor, from: self.transactionDeliveryStatusView)
        
        self.setPosition(self.transactionCancelView, from: self.transactionDeliveryStatusView)
        self.setPosition(footerGrayColor, from: self.transactionCancelView)
        footerGrayColor.frame.origin.y -= 20
        
        newFrame = self.footerView.frame
        newFrame.size.height = CGRectGetMaxY(self.transactionCancelView.frame)
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
        let feedbackView = TransactionLeaveSellerFeedbackTableViewController(nibName: "TransactionLeaveSellerFeedbackTableViewController", bundle: nil)
        feedbackView.edgesForExtendedLayout = UIRectEdge.None
        self.navigationController?.pushViewController(feedbackView, animated: true)
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
        self.myTimer?.invalidate()
    }
    
    //MARK: Delivery Status
    //MARK: SMS and Phone call
    func pickupSmsAction() {
        if self.transactionDeliveryStatus.pickupRiderContactNumber != "" {
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:\(self.transactionDeliveryStatus.pickupRiderContactNumber)")!) {
                println("can message")
                //UIApplication.sharedApplication().openURL(NSURL(string:"tel:\(self.transactionDeliveryStatus.pickupRiderContactNumber)")!)
                /*var toRecipents = ["\(self.transactionDeliveryStatus.pickupRiderContactNumber)"]
                var mc: MFMessageComposeViewController = MFMessageComposeViewController()
                mc.recipients = toRecipents
                mc.delegate = self
                mc.body = ""
                */
                self.sendMessage(self.transactionDeliveryStatus.pickupRiderContactNumber)
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Call number action.", title: "Call Pick-up")
            } else {
                println("cant message")
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Cannot make a call", title: "Call Pick-up")
            }
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "No available contact number.", title: "Message Pick-up")
        }
        
    }
    
    func pickupCallAction() {
        if self.transactionDeliveryStatus.pickupRiderContactNumber != "" {
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:\(self.transactionDeliveryStatus.pickupRiderContactNumber)")!) {
                println("can call")
                UIApplication.sharedApplication().openURL(NSURL(string:"tel:\(self.transactionDeliveryStatus.pickupRiderContactNumber)")!)
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Call number action.", title: "Call Pick-up")
            } else {
                println("cant make a call")
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Cannot make a call", title: "Call Pick-up")
            }
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "No available contact number.", title: "Call Pick-up")
        }
    }
    
    func deliverySmsAction() {
        //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Send SMS action.", title: "SMS Pick-up")
        if self.transactionDeliveryStatus.deliveryRiderContactNumber != "" {
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:\(self.transactionDeliveryStatus.deliveryRiderContactNumber)")!) {
                println("can message")
                self.sendMessage(self.transactionDeliveryStatus.deliveryRiderContactNumber)
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Call number action.", title: "Call Pick-up")
            } else {
                println("cant message")
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Cannot make a call", title: "Call Pick-up")
            }
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "No available contact number.", title: "Call Delivery Rider")
        }
    }
    
    func deliveryCallAction() {
        if self.transactionDeliveryStatus.deliveryRiderContactNumber != "" {
            if UIApplication.sharedApplication().canOpenURL(NSURL(string: "tel:\(self.transactionDeliveryStatus.deliveryRiderContactNumber)")!) {
                println("can call")
                UIApplication.sharedApplication().openURL(NSURL(string:"tel:\(self.transactionDeliveryStatus.deliveryRiderContactNumber)")!)
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Call number action.", title: "Call Pick-up")
            } else {
                println("cant make a call")
                //UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Cannot make a call", title: "Call Pick-up")
            }
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "No available contact number.", title: "Call Delivery Rider")
        }
    }
    
    func deliveryLogsAction() {
        let deliveryLogs = TransactionDeliveryLogTableViewController(nibName: "TransactionDeliveryLogTableViewController", bundle: nil)
        deliveryLogs.edgesForExtendedLayout = UIRectEdge.None
        deliveryLogs.orderProductId = orderProductId
        deliveryLogs.transactionId = transactionId
        self.navigationController?.pushViewController(deliveryLogs, animated: true)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
        
        if (result.value == MessageComposeResultCancelled.value) {
            NSLog("Message was cancelled.");
        }
        else if (result.value == MessageComposeResultFailed.value) {
            var warningAlert : UIAlertView = UIAlertView.alloc();
            warningAlert.title = "Error";
            warningAlert.message = "Failed to send SMS!";
            warningAlert.delegate = nil;
            warningAlert.show();
            NSLog("Message failed.");
        } else {
            NSLog("Message was sent.");
        }
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func sendMessage(contactNumber: String) {
        if (!MFMessageComposeViewController.canSendText()) {
            var warningAlert : UIAlertView = UIAlertView.alloc();
            warningAlert.title = "Error";
            warningAlert.message = "Your device does not support SMS.";
            warningAlert.delegate = nil;
            warningAlert.show();
            return;
        }
        
        var recipients  = ["\(contactNumber)"]
        var message = "Message."
        
        
        // This is the problem line I think....
        let messageController = MFMessageComposeViewController()
        
        /* In Objective-C it is: */
        // MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
        
        // I have also tried this...
        let messageC : MFMessageComposeViewController! = MFMessageComposeViewController()
        
        
        messageController.messageComposeDelegate = self
        messageController.recipients = recipients
        messageController.body = message
        
        self.tabBarController?.presentViewController(messageController, animated: true, completion: nil)
    }
    
    
    //MARK: TransactionCancelOrderViewDelegate
    func showCancelOrder() {
        self.showView()
        let cancelOrder = TransactionCancelViewController(nibName: "TransactionCancelViewController", bundle: nil)
        cancelOrder.delegate = self
        cancelOrder.invoiceNumber = self.transactionId
        cancelOrder.orderProductId = self.orderProductId
        cancelOrder.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        cancelOrder.providesPresentationContextTransitionStyle = true
        cancelOrder.definesPresentationContext = true
        cancelOrder.view.frame.origin.y = cancelOrder.view.frame.size.height
        self.tabBarController?.presentViewController(cancelOrder, animated: true, completion: nil)
        self.myTimer?.invalidate()
    }
    
    func showView(){
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = false
            self.dimView.alpha = 0.5
            //self.dimView.layer.zPosition = 2
            //self.view.transform = CGAffineTransformMakeScale(0.92, 0.93)
        })
    }
    
    //MARK: TransactionCancelViewControllerDelegate
    func dismissView() {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.hidden = true
            //self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            //self.dimView.layer.zPosition = -1
        })
    }
    
    func submitTransactionCancelReason() {
        self.showView()
        var successController = TransactionCancelOrderSuccessViewController(nibName: "TransactionCancelOrderSuccessViewController", bundle: nil)
        successController.delegate = self
        successController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        successController.providesPresentationContextTransitionStyle = true
        successController.definesPresentationContext = true
        successController.view.backgroundColor = UIColor.clearColor()
        self.tabBarController?.presentViewController(successController, animated: true, completion: nil)
        self.myTimer?.invalidate()
    }
    
    // MARK: - TransactionCancelOrderSuccessViewControllerDelegate
    func closeCancelOrderSuccessViewController() {
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.myTimer?.invalidate()
        self.dismissView()
    }
    
    func returnToDashboardAction() {
        self.dismissView()
        self.navigationController?.popToRootViewControllerAnimated(true)
        self.myTimer?.invalidate()
    }
    
    //MARK: Get transactions details by id
    func fireTransactionProductDetails() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        println("orderProductId \(self.orderProductId)")
        manager.GET(APIAtlas.transactionProductDetails+"\(SessionManager.accessToken())&orderProductId=\(self.orderProductId)", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject)
            self.transactionProductDetailsModel = TransactionProductDetailsModel.parseFromDataDictionary(responseObject as! NSDictionary)
            //for var i: Int = 0; i < self.name.count; i++ {
            //SKU", "Brand", "Weight (kg)", "Height (mm)", "Width (cm)", "Length (cm)"
            //self.productDictionary[self.name[0]] = self.transactionProductDetailsModel.sku
            //self.productDictionary[self.name[1]] = self.transactionProductDetailsModel.brandName
            //self.productDictionary[self.name[2]] = self.transactionProductDetailsModel.color
            //self.productDictionary[self.name[3]] = self.transactionProductDetailsModel.size
            // self.productDictionary[self.name[4]] = self.transactionProductDetailsModel.weight
            // self.productDictionary[self.name[5]] = self.transactionProductDetailsModel.height
            //self.productDictionary[self.name[6]] = self.transactionProductDetailsModel.width
            // self.productDictionary[self.name[7]] = self.transactionProductDetailsModel.length
            //}
            
            //self.array.
            if self.headerView == nil {
                self.loadViewsWithDetails()
            }
            self.tableView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    self.tableView.reloadData()
                    /*let alert = UIAlertController(title: Constants.Localized.someThingWentWrong,
                    message: errorModel.message,
                    preferredStyle: UIAlertControllerStyle.Alert)
                    let okButton = UIAlertAction(title: ProductStrings.alertOk,
                    style: UIAlertActionStyle.Cancel) { (alert) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    }
                    alert.addAction(okButton)
                    self.presentViewController(alert, animated: true, completion: nil)
                    */
                } else if task.statusCode == 401 {
                    self.fireRefreshToken()
                    self.tableView.reloadData()
                } else {
                    self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                    self.tableView.reloadData()
                }
                self.refreshtag = 1001
                //println(error.userInfo)
                
        })
    }
    
    //MARK: Get transactions details by id
    func fireTransactionProductDetailsDeliveryStatus() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.GET(APIAtlas.transactionDeliveryStatus+"\(SessionManager.accessToken())&transactionId=\(self.transactionId)", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println("timer \(self.time) \(self.transactionId) \(responseObject)")
            self.transactionDeliveryStatus = TransactionProductDetailsDeliveryStatusModel.parseDataFromDictionary(responseObject as! NSDictionary)
            self.timerRefresh()
            //self.tableView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    self.tableView.reloadData()
                    /*let alert = UIAlertController(title: Constants.Localized.someThingWentWrong,
                    message: errorModel.message,
                    preferredStyle: UIAlertControllerStyle.Alert)
                    let okButton = UIAlertAction(title: ProductStrings.alertOk,
                    style: UIAlertActionStyle.Cancel) { (alert) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    }
                    alert.addAction(okButton)
                    self.presentViewController(alert, animated: true, completion: nil)
                    */
                } else if task.statusCode == 401 {
                    self.fireRefreshToken()
                    self.tableView.reloadData()
                } else {
                    self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                    self.tableView.reloadData()
                }
                self.refreshtag = 1002
                println(error.userInfo)
                
        })
    }
    
    //MARK: Get transactions details by id
    func fireTransactionProductDetailsDeliveryStatusRefresh() {
        //self.showHUD()
        let manager = APIManager.sharedInstance
        manager.GET(APIAtlas.transactionDeliveryStatus+"\(SessionManager.accessToken())&transactionId=\(self.transactionId)", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println("timer \(self.time) \(self.transactionId) \(responseObject)")
            self.transactionDeliveryStatus = TransactionProductDetailsDeliveryStatusModel.parseDataFromDictionary(responseObject as! NSDictionary)
            //self.tableView.reloadData()
            //self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                //self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    self.tableView.reloadData()
                    /*let alert = UIAlertController(title: Constants.Localized.someThingWentWrong,
                    message: errorModel.message,
                    preferredStyle: UIAlertControllerStyle.Alert)
                    let okButton = UIAlertAction(title: ProductStrings.alertOk,
                    style: UIAlertActionStyle.Cancel) { (alert) -> Void in
                    self.navigationController?.popViewControllerAnimated(true)
                    }
                    alert.addAction(okButton)
                    self.presentViewController(alert, animated: true, completion: nil)
                    */
                } else if task.statusCode == 401 {
                    self.fireRefreshToken()
                    self.tableView.reloadData()
                } else {
                    self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                    self.tableView.reloadData()
                }
                self.refreshtag = 1002
                println(error.userInfo)
                
        })
    }

    
    func fireRefreshToken() {
        let manager: APIManager = APIManager.sharedInstance
        //seller@easyshop.ph
        //password
        let parameters: NSDictionary = ["client_id": Constants.Credentials.clientID(), "client_secret": Constants.Credentials.clientSecret(), "grant_type": Constants.Credentials.grantRefreshToken, "refresh_token":  SessionManager.refreshToken()]
        manager.POST(APIAtlas.refreshTokenUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            if self.refreshtag == 1001 {
                self.fireTransactionProductDetails()
            } else {
                self.fireTransactionProductDetailsDeliveryStatus()
            }
            self.hud?.hide(true)
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
           
                self.hud?.hide(true)
                self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
               
        })
        
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
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
    
    
    //You can create a scheduled timer which automatically adds itself to the runloop and starts firing:
    //NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: "timerDidFire:", userInfo: userInfo, repeats: true)
    func timerRefresh(){
        time++
        //Or, you can keep your current code, and add the timer to the runloop when you're ready for it:
        myTimer = NSTimer(timeInterval: 10, target: self, selector: "fireTransactionProductDetailsDeliveryStatusRefresh", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(myTimer!, forMode: NSRunLoopCommonModes)
    }
}


