//
//  TransactionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

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
    
    var viewsInArray: [UIView] = []
    var imagesInArray: [UIImageView] = []
    var labelsInArray: [UILabel] = []
    var deselectedImages: [String] = []
    
    var queryType: String = ""
    
    var hud: MBProgressHUD?
    
    var transactionModel: TransactionModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Transaction"
        
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TransactionIdentifier")
        
        viewsInArray = [allView, pendingView, onDeliveryView, forFeedbackView, supportView]
        imagesInArray = [allImageView, pendingImageView, onDeliveryImageView, forFeedbackImageView, supportImageView]
        labelsInArray = [allLabel, pendingLabel, onDeliveryLabel, forFeedbackLabel, supportLabel]
        deselectedImages = ["all", "pending", "onDelivery", "forFeedback", "support"]
        
        addViewsActions()
        
        self.fireTransaction("all")
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.transactionModel != nil {
            return self.transactionModel!.product_name.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TransactionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionIdentifier") as! TransactionTableViewCell
        
        if self.transactionModel != nil {
            var price: Float = (self.transactionModel!.total_item_price[indexPath.row] as NSString).floatValue
            cell.priceLabel.text = "(P \(price.string(2))"//NSString(format:"%.2f", self.transactionModel!.total_item_price[indexPath.row]) as String
            cell.dateLabel.text = self.transactionModel!.date_added[indexPath.row]
            if self.transactionModel!.product_count[indexPath.row].toInt() < 2 {
                cell.numberLabel.text =  "\(self.transactionModel!.product_count[indexPath.row]) product"
            } else {
                cell.numberLabel.text =  "\(self.transactionModel!.product_count[indexPath.row]) products"
            }
            cell.transactionIdLabel.text = self.transactionModel!.order_id[indexPath.row]
        }
        
        cell.selectionStyle = .None
        
        return cell
    }

    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let transactionDetails = TransactionDetailsViewController(nibName: "TransactionDetailsViewController", bundle: nil)
        self.navigationController?.pushViewController(transactionDetails, animated: true)
    }
    
    // Actions
    
    func allAction(gesture: UIGestureRecognizer) {
        if allView.tag == 0 {
            selectView(allView, label: allLabel, imageView: allImageView, imageName: "all2")
            self.fireTransaction("all")
            deselectOtherViews(allView)
        }
    }
    
    func pendingAction(gesture: UIGestureRecognizer) {
        if pendingView.tag == 0 {
            selectView(pendingView, label: pendingLabel, imageView: pendingImageView, imageName: "time")
            self.fireTransaction("pending")
            deselectOtherViews(pendingView)
        }
    }
    
    func onDeliveryAction(gesture: UIGestureRecognizer) {
        if onDeliveryView.tag == 0 {
            selectView(onDeliveryView, label: onDeliveryLabel, imageView: onDeliveryImageView, imageName: "onDelivery2")
            self.fireTransaction("ongoing")
            deselectOtherViews(onDeliveryView)
        }
    }
    
    func forFeedbackAction(gesture: UIGestureRecognizer) {
        if forFeedbackView.tag == 0 {
            selectView(forFeedbackView, label: forFeedbackLabel, imageView: forFeedbackImageView, imageName: "forFeedback2")
            deselectOtherViews(forFeedbackView)
        }
    }
    
    func supportAction(gesture: UIGestureRecognizer) {
        if supportView.tag == 0 {
            selectView(supportView, label: supportLabel, imageView: supportImageView, imageName: "support2")
            deselectOtherViews(supportView)
        }
    }
    
    // Methods
    
    func addViewsActions() {
        self.allView.addGestureRecognizer(tap("allAction:"))
        self.pendingView.addGestureRecognizer(tap("pendingAction:"))
        self.onDeliveryView.addGestureRecognizer(tap("onDeliveryAction:"))
        self.forFeedbackView.addGestureRecognizer(tap("forFeedbackAction:"))
        self.supportView.addGestureRecognizer(tap("supportAction:"))
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
        self.clearModel()
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.GET(APIAtlas.transactionLogs+"\(SessionManager.accessToken())&type=\(queryType)", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.transactionModel = TransactionModel.parseDataFromDictionary(responseObject as! NSDictionary)
                self.tableView.reloadData()
                println(responseObject.description)
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