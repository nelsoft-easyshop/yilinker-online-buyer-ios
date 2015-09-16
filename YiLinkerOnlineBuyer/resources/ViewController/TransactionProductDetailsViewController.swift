//
//  TransactionProductDetailsViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionProductDetailsViewController: UIViewController, TransactionCancelOrderViewDelegate, TransactionCancelViewControllerDelegate, TransactionCancelOrderSuccessViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var newFrame: CGRect!
    
    var headerView: UIView!
    var transactionProductImagesView: TransactionProductImagesView!
    var transactionPurchaseDetailsView: TransactionPurchaseDetailsView!
    var transactionCancelView: TransactionCancelOrderView!
    var transactionProductDetailsView: UIView!
    
    var footerView: UIView!
    var transactionDescriptionView: TransactionDescriptionView!
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
    
    var hud: MBProgressHUD?
    var transactionProductDetailsModel: TransactionProductDetailsModel!
    var productDictionary = Dictionary<String, String>()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dimView = UIView(frame: UIScreen.mainScreen().bounds)
        dimView.backgroundColor=UIColor.blackColor()
        dimView.alpha = 0.5
        self.navigationController?.view.addSubview(dimView)
        dimView.hidden = true
        
        self.title = "Product Details"
        self.backButton()
        
        let nib = UINib(nibName: "TransactionProductDetailsTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TransactionProductDetailsIdentifier")
        
        println("order product id \(self.orderProductId)")
        self.fireTransactionProductDetails()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if headerView == nil {
            loadViewsWithDetails()
        }
    }
    
    // MARK: - Table View Data Souce
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TransactionProductDetailsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionProductDetailsIdentifier") as! TransactionProductDetailsTableViewCell

        cell.selectionStyle = .None
        if self.transactionProductDetailsModel != nil {
            cell.attributeNameLabel.text = name[indexPath.row]
            cell.attributeValueLabel.text = self.productDictionary[name[indexPath.row]]
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
            self.transactionProductImagesView.frame.size.width = self.view.frame.size.width
        }
        return self.transactionProductImagesView
    }
    
    func getTransactionPurchaseDetailsView() -> TransactionPurchaseDetailsView {
        if self.transactionPurchaseDetailsView == nil {
            self.transactionPurchaseDetailsView = XibHelper.puffViewWithNibName("TransactionViews", index: 5) as! TransactionPurchaseDetailsView
            self.transactionPurchaseDetailsView.quantityLabel.text = "\(self.quantity)"
            self.transactionPurchaseDetailsView.totalCostLabel.text = ((self.totalPrice as NSString).floatValue).stringToFormat(2)
            self.transactionPurchaseDetailsView.priceLabel.text = ((self.unitPrice as NSString).floatValue).stringToFormat(2)
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
    
    func getTransactionCancelOrderView() -> TransactionCancelOrderView {
        if self.transactionCancelView == nil {
            self.transactionCancelView = XibHelper.puffViewWithNibName("TransactionViews", index: 9) as! TransactionCancelOrderView
            self.transactionCancelView.delegate = self
            self.transactionCancelView.frame.size.width = self.view.frame.size.width
            self.transactionCancelView.frame.origin.y += CGFloat(120)
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
    
    // MARK: - Methods
    
    func loadViewsWithDetails() {
        // HEADERS
        self.getHeaderView().addSubview(self.getTransactionProductImagesView())
        self.getHeaderView().addSubview(self.getTransactionPurchaseDetailsView())
        self.getHeaderView().addSubview(self.getTransactionProductDetailsView())
        
        // FOOTERS
        self.getFooterView().addSubview(self.getTransactionDescriptionView())
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
        
        self.setPosition(self.transactionCancelView, from: self.transactionDescriptionView)
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
        let feedbackView = TransactionLeaveFeedbackViewController(nibName: "TransactionLeaveFeedbackViewController", bundle: nil)
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
    }
    
    //MARK: TransactionCancelOrderViewDelegate
    func showCancelOrder() {
        self.showView()
        let cancelOrder = TransactionCancelViewController(nibName: "TransactionCancelViewController", bundle: nil)
        cancelOrder.delegate = self
        cancelOrder.invoiceNumber = self.transactionId
        cancelOrder.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        cancelOrder.providesPresentationContextTransitionStyle = true
        cancelOrder.definesPresentationContext = true
        cancelOrder.view.frame.origin.y = cancelOrder.view.frame.size.height
        self.navigationController?.presentViewController(cancelOrder, animated: true, completion: nil)
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
        var successController = TransactionCancelOrderSuccessViewController(nibName: "TransactionCancelOrderSuccessViewController", bundle: nil)
        successController.delegate = self
        successController.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        successController.providesPresentationContextTransitionStyle = true
        successController.definesPresentationContext = true
        successController.view.backgroundColor = UIColor.clearColor()
        self.tabBarController?.presentViewController(successController, animated: true, completion: nil)
    }
    
    // MARK: - TransactionCancelOrderSuccessViewControllerDelegate
    func closeCancelOrderSuccessViewController() {
        self.dismissView()
    }
    
    func returnToDashboardAction() {
        self.dismissView()
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    //MARK: Get transactions details by id
    func fireTransactionProductDetails() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.GET(APIAtlas.transactionProductDetails+"\(SessionManager.accessToken())&orderProductId=\(self.orderProductId)", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.transactionProductDetailsModel = TransactionProductDetailsModel.parseFromDataDictionary(responseObject as! NSDictionary)
            //for var i: Int = 0; i < self.name.count; i++ {
            //SKU", "Brand", "Weight (kg)", "Height (mm)", "Width (cm)", "Length (cm)"
            self.productDictionary[self.name[0]] = self.transactionProductDetailsModel.sku
            self.productDictionary[self.name[1]] = self.transactionProductDetailsModel.brandName
            self.productDictionary[self.name[2]] = self.transactionProductDetailsModel.color
            self.productDictionary[self.name[3]] = self.transactionProductDetailsModel.size
            self.productDictionary[self.name[4]] = self.transactionProductDetailsModel.weight
            self.productDictionary[self.name[5]] = self.transactionProductDetailsModel.height
            self.productDictionary[self.name[6]] = self.transactionProductDetailsModel.width
            self.productDictionary[self.name[7]] = self.transactionProductDetailsModel.length
            //}
            
            //self.array.
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


