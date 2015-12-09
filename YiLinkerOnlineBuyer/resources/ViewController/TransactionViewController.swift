//
//  TransactionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController, EmptyViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var onDeliveryView: UIView!
    @IBOutlet weak var forFeedbackView: UIView!
    @IBOutlet weak var supportView: UIView!
    
    @IBOutlet weak var allImageView: UIImageView!
    @IBOutlet weak var pendingImageView: UIImageView!
    @IBOutlet weak var onDeliveryImageView: UIImageView!
    @IBOutlet weak var forFeedbackImageView: UIImageView!
    @IBOutlet weak var supportImageView: UIImageView!
    
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var onDeliveryLabel: UILabel!
    @IBOutlet weak var forFeedbackLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    @IBOutlet var noTransactionLabel: UILabel!
    
    var viewsInArray: [UIView] = []
    var imagesInArray: [UIImageView] = []
    var labelsInArray: [UILabel] = []
    var deselectedImages: [String] = []

    var hud: MBProgressHUD?
    
    var transactionModel: TransactionModel?
    var tableData:[TransactionModel] = []
    
    var transactionTitle = StringHelper.localizedStringWithKey("TRANSACTION_TITLE_TITLE_LOCALIZE_KEY")
    var all = StringHelper.localizedStringWithKey("TRANSACTION_ALL_LOCALIZE_KEY")
    var pending = StringHelper.localizedStringWithKey("TRANSACTION_PENDING_LOCALIZE_KEY")
    var onDelivery = StringHelper.localizedStringWithKey("TRANSACTION_ONDELIVERY_LOCALIZE_KEY")
    var forFeedback = StringHelper.localizedStringWithKey("TRANSACTION_FOR_FEEDBACK_LOCALIZE_KEY")
    var support = StringHelper.localizedStringWithKey("TRANSACTION_SUPPORT_LOCALIZE_KEY")
    var product = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCT_LOCALIZE_KEY")
    var products = StringHelper.localizedStringWithKey("TRANSACTION_PRODUCTS_LOCALIZE_KEY")
    var noTransaction = StringHelper.localizedStringWithKey("TRANSACTION_NO_TRANSACTION_LOCALIZE_KEY")
    
    var refreshPage: Bool = false
    var isPageEnd: Bool = false
    var page: Int = 0
    var query: String = "all"
    var transactionType: String = ""
    var transactionArray: NSArray?
    
    var emptyView : EmptyView?
    var contentViewFrame: CGRect?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentViewFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)
        
        self.title = transactionTitle
        
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TransactionIdentifier")
        
        viewsInArray = [allView, pendingView, onDeliveryView, forFeedbackView]
        imagesInArray = [allImageView, pendingImageView, onDeliveryImageView, forFeedbackImageView]
        labelsInArray = [allLabel, pendingLabel, onDeliveryLabel, forFeedbackLabel]
        deselectedImages = ["all", "pending", "onDelivery", "forFeedback"]
     
        allLabel.text = all
        pendingLabel.text = pending
        onDeliveryLabel.text = onDelivery
        forFeedbackLabel.text = forFeedback
        noTransactionLabel.text = noTransaction
        noTransactionLabel.hidden = true
        //supportLabel.text = support
        
        self.tableView.hidden = true
        self.tableView.separatorInset = UIEdgeInsetsZero
        self.tableView.layoutMargins = UIEdgeInsetsZero
       
        addViewsActions()
    
        self.backButton()
    }
    
    override func viewDidAppear(animated: Bool) {
        noTransactionLabel.hidden = true
        self.tableData.removeAll(keepCapacity: false)
        page = 0
        self.isPageEnd = false
        self.fireTransaction(self.query)
        //return true
    }
    
    // MARK: - Table View Data Source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.tableData.count != 0 {
            return self.tableData.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: TransactionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionIdentifier") as! TransactionTableViewCell
        
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
        
        if self.tableData.count != 0 {
            var price: Float = (tableData[indexPath.row].total_price2 as NSString).floatValue
            cell.priceLabel.text = "\((tableData[indexPath.row].total_price2).formatToPeso())"
            cell.dateLabel.text = tableData[indexPath.row].date_added2
           
            if tableData[indexPath.row].product_count2.toInt() < 2 {
                cell.numberLabel.text =  "\(tableData[indexPath.row].product_count2) \(product)"
            } else {
                cell.numberLabel.text =  "\(tableData[indexPath.row].product_count2) \(products)"
            }
            cell.transactionIdLabel.text = "TID-\(tableData[indexPath.row].invoice_number2)"
        }
        
        cell.selectionStyle = .None
        
        return cell
    }

    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let transactionDetails = TransactionDetailsViewController(nibName: "TransactionDetailsViewController", bundle: nil)
        transactionDetails.transactionId = tableData[indexPath.row].invoice_number2
        transactionDetails.totalProducts = tableData[indexPath.row].product_count2
        transactionDetails.orderStatus = tableData[indexPath.row].order_status2
        transactionDetails.paymentType = tableData[indexPath.row].payment_type2
        transactionDetails.dateCreated = tableData[indexPath.row].date_added2
        transactionDetails.totalQuantity = tableData[indexPath.row].total_quantity2
        transactionDetails.totalUnitCost = tableData[indexPath.row].total_unit_price2
        transactionDetails.shippingFee = tableData[indexPath.row].total_handling_fee2
        transactionDetails.totalCost = tableData[indexPath.row].total_price2
        transactionDetails.orderId = tableData[indexPath.row].order_id2
        transactionDetails.orderStatusId = tableData[indexPath.row].order_status_id2
        transactionDetails.transactionType = self.transactionType
        self.navigationController?.pushViewController(transactionDetails, animated: true)
    }
    
    func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            self.fireTransaction(self.query)
        }
    }
    
    //MARK: Actions
    func allAction(gesture: UIGestureRecognizer) {
        if allView.tag == 0 {
            selectView(allView, label: allLabel, imageView: allImageView, imageName: "all2")
            noTransactionLabel.hidden = true
            self.tableData.removeAll(keepCapacity: false)
            page = 0
            self.isPageEnd = false
            self.fireTransaction("all")
            self.query = "all"
            deselectOtherViews(allView)
        }
    }
    
    func pendingAction(gesture: UIGestureRecognizer) {
        if pendingView.tag == 0 {
            selectView(pendingView, label: pendingLabel, imageView: pendingImageView, imageName: "time")
            noTransactionLabel.hidden = true
            self.tableData.removeAll(keepCapacity: false)
            page = 0
            self.isPageEnd = false
            self.fireTransaction("pending")
            self.query = "pending"
            deselectOtherViews(pendingView)
        }
    }
    
    func onDeliveryAction(gesture: UIGestureRecognizer) {
        if onDeliveryView.tag == 0 {
            selectView(onDeliveryView, label: onDeliveryLabel, imageView: onDeliveryImageView, imageName: "onDelivery2")
            noTransactionLabel.hidden = true
            self.tableData.removeAll(keepCapacity: false)
            page = 0
            self.isPageEnd = false
            self.fireTransaction("on-delivery")
            self.query = "on-delivery"
            deselectOtherViews(onDeliveryView)
        }
    }
    
    func forFeedbackAction(gesture: UIGestureRecognizer) {
        if forFeedbackView.tag == 0 {
            noTransactionLabel.hidden = true
            selectView(forFeedbackView, label: forFeedbackLabel, imageView: forFeedbackImageView, imageName: "forFeedback2")
            self.tableData.removeAll(keepCapacity: false)
            page = 0
            self.isPageEnd = false
            self.fireTransaction("for-feedback")
            self.query = "for-feedback"
            deselectOtherViews(forFeedbackView)
        }
    }
    
    func supportAction(gesture: UIGestureRecognizer) {
        if supportView.tag == 0 {
            selectView(supportView, label: supportLabel, imageView: supportImageView, imageName: "support2")
            noTransactionLabel.hidden = true
            self.query = "support"
            deselectOtherViews(supportView)
        }
    }
    
    // Methods
    func addViewsActions() {
        self.allView.addGestureRecognizer(tap("allAction:"))
        self.pendingView.addGestureRecognizer(tap("pendingAction:"))
        self.onDeliveryView.addGestureRecognizer(tap("onDeliveryAction:"))
        self.forFeedbackView.addGestureRecognizer(tap("forFeedbackAction:"))
        //self.supportView.addGestureRecognizer(tap("supportAction:"))
    }
    
    func tap(action: Selector) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        return tap
    }
    
    func selectView(view: UIView, label: UILabel, imageView: UIImageView, imageName: String) {
        view.backgroundColor = .whiteColor()
        label.textColor = Constants.Colors.appTheme
        imageView.image = UIImage(named: imageName)
        view.tag = 1
    }
    
    func deselectOtherViews(view: UIView) {
        for i in 0..<self.viewsInArray.count {
            if view != self.viewsInArray[i] {
                viewsInArray[i].backgroundColor = Constants.Colors.appTheme
                labelsInArray[i].textColor = .whiteColor()
                imagesInArray[i].image = UIImage(named: deselectedImages[i])
                viewsInArray[i].tag = 0
            }
        }
    }
    
    //MARK: Get transactions by type
    func fireTransaction(queryType: String) {
        if !isPageEnd {
            page++
            
            if self.refreshPage {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            } else {
                self.showHUD()
            }
            
            let manager = APIManager.sharedInstance
            var url: String = APIAtlas.transactionLogs+"\(SessionManager.accessToken())&type=\(queryType)&perPage=15&page=\(page)"
            
            manager.GET(APIAtlas.transactionLogs+"\(SessionManager.accessToken())&type=\(queryType)&perPage=15&page=\(page)", parameters: nil, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                println(responseObject)
                var trans: TransactionModel?
                
                let data2 = NSJSONSerialization.dataWithJSONObject(responseObject, options: nil, error: nil)
                let string2 = NSString(data: data2!, encoding: NSUTF8StringEncoding)
   
                if queryType == "for-feedback" {
                    trans = TransactionModel.parseDataFromDictionary(responseObject as! NSDictionary)
                } else if queryType == "pending" {
                    trans = TransactionModel.parseDataFromDictionary4(responseObject as! NSDictionary)
                } else {
                    trans = TransactionModel.parseDataFromDictionary3(responseObject as! NSDictionary)
                }
                
                if trans!.product_name.count != 0 {
                    if trans!.order_id.count < 15 {
                        self.isPageEnd = true
                    }
                    if trans!.is_successful {
                        for var i = 0; i < trans!.order_id.count; i++ {
                            self.tableData.append(TransactionModel(order_id: trans!.order_id[i], date_added: trans!.date_added[i], invoice_number: trans!.invoice_number[i], payment_type: trans!.payment_type[i], payment_method_id: trans!.payment_method_id[i], order_status: trans!.order_status[i], order_status_id: trans!.order_status_id[i], total_price: trans!.total_price[i], total_unit_price: trans!.total_unit_price[i], total_item_price: trans!.total_item_price[i], total_handling_fee: trans!.total_handling_fee[i], total_quantity: trans!.total_quantity[i], product_name: trans!.product_name[i], product_count: trans!.product_count[i], is_successful: trans!.is_successful, order_count: trans!.order_count))
                        }
                    } else {
                        self.isPageEnd = true
                    }
                    
                    self.tableView.hidden = false
                } else {
                    self.tableView.hidden = true
                    self.noTransactionLabel.hidden = false
                }
               
                self.tableView.reloadData()
                
                if self.refreshPage {
                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                } else {
                  self.hud?.hide(true)
                }
                
                self.refreshPage = true
                
                }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in

                    let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                    
                    if self.query == "all" {
                    if error.userInfo != nil {
                        let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                    } else if task.statusCode == 401 {
                            self.requestRefreshToken(TransactionRefreshType.All)
                        } else if self.query == "on-delivery" {
                            self.requestRefreshToken(TransactionRefreshType.OnGoing)
                        } else if self.query == "pending" {
                            self.requestRefreshToken(TransactionRefreshType.Pending)
                        } else if self.query == "for-feedback" {
                            self.requestRefreshToken(TransactionRefreshType.ForFeedback)
                        } else {
                            self.requestRefreshToken(TransactionRefreshType.Support)
                        }
                    } else {
                        self.tableData.removeAll(keepCapacity: false)
                        self.tableView.reloadData()
                        self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                        self.addEmptyView()
                    }
                    
                    self.tableView.hidden = true
                    if self.refreshPage {
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    } else {
                        self.hud?.hide(true)
                    }
            })
        }
    }
    
    //MARK: Refresh token
    func requestRefreshToken(type: TransactionRefreshType) {
        
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID(),
            "client_secret": Constants.Credentials.clientSecret(),
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if type == TransactionRefreshType.All {
                self.fireTransaction("all")
            } else if type == TransactionRefreshType.OnGoing {
                self.fireTransaction("on-delivery")
            } else if type == TransactionRefreshType.Pending {
                self.fireTransaction("pending")
            } else if type == TransactionRefreshType.ForFeedback {
                self.fireTransaction("for-feedback")
            } else {
                self.fireTransaction("support")
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let alertController = UIAlertController(title: Constants.Localized.someThingWentWrong, message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                self.addEmptyView()
                self.tableView.hidden = true
        })
    }
    
    //MARK: Show alert dialog
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
    
    func clearModel() {
        self.transactionModel?.order_id.removeAll(keepCapacity: false)
        self.transactionModel?.date_added.removeAll(keepCapacity: false)
        self.transactionModel?.invoice_number.removeAll(keepCapacity: false)
        self.transactionModel?.payment_type.removeAll(keepCapacity: false)
        self.transactionModel?.payment_method_id.removeAll(keepCapacity: false)
        self.transactionModel?.order_status.removeAll(keepCapacity: false)
        self.transactionModel?.order_status_id.removeAll(keepCapacity: false)
        self.transactionModel?.total_price.removeAll(keepCapacity: false)
        self.transactionModel?.total_unit_price.removeAll(keepCapacity: false)
        self.transactionModel?.total_item_price.removeAll(keepCapacity: false)
        self.transactionModel?.total_handling_fee.removeAll(keepCapacity: false)
        self.transactionModel?.total_quantity.removeAll(keepCapacity: false)
        self.transactionModel?.product_name.removeAll(keepCapacity: false)
        self.transactionModel?.product_count.removeAll(keepCapacity: false)
    }
    
    //MARK: Customize navigation bar
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
    
    //MARK: Back button action
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //MARK: Add empty view to the current view
    func addEmptyView() {
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.contentViewFrame!
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
            println("unhide empty view")
        }
    }
    
    func didTapReload() {
        if self.query == "all" {
            self.fireTransaction("all")
            self.query = "all"
        } else if self.query == "on-delivery"{
            self.fireTransaction("on-delivery")
            self.query = "on-delivery"
        }  else if self.query == "for-feedback"{
            self.fireTransaction("for-feedback")
            self.query = "for-feedback"
        } else {
            self.fireTransaction("pending")
            self.query = "pending"
        }
        
        self.emptyView?.hidden = true
    }
}

//MARK: Number Formatter
extension Float {
    func string(fractionDigits:Int) -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = fractionDigits
        formatter.maximumFractionDigits = fractionDigits
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        return formatter.stringFromNumber(self) ?? "\(self)"
    }
}