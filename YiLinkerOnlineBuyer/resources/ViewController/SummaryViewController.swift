//
//  SummaryViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SummaryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ShipToTableViewCellDelegate, ChangeAddressViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    var shipToTableViewCell: ShipToTableViewCell = ShipToTableViewCell()
    var cartItems: [CartProductDetailsModel] = []
    var totalPrice: String = ""
    var hud: MBProgressHUD?
    var isValidToSelectPayment: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.registerNib()
        
        self.tableView.estimatedRowHeight = 71
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, -5)
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.layoutIfNeeded()
        self.tableView.tableFooterView = self.tableFooterView()
        self.tableView.tableFooterView!.frame = CGRectMake(0, 0, 0, self.tableView.tableFooterView!.frame.size.height)
        self.fireSetCheckoutAddress(SessionManager.addressId())
    }
    
    //Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func registerNib() {
        let orderSummaryNib: UINib = UINib(nibName: Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(orderSummaryNib, forCellReuseIdentifier: Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier)
        
        let shipToNib: UINib = UINib(nibName: Constants.Checkout.shipToTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(shipToNib, forCellReuseIdentifier: Constants.Checkout.shipToTableViewCellNibNameAndIdentifier)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 58
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 41
    }
    
    func tableFooterView() -> UIView {
        self.shipToTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.shipToTableViewCellNibNameAndIdentifier) as! ShipToTableViewCell
        shipToTableViewCell.frame = CGRectMake(0, 0, self.tableView.frame.size.width, shipToTableViewCell.frame.size.height)
        shipToTableViewCell.delegate = self
        shipToTableViewCell.addressLabel.text = SessionManager.userFullAddress()
        return shipToTableViewCell
    }
    
    func changeAddressViewController(didSelectAddress address: String) {
        self.tableView.tableFooterView = self.tableFooterView()
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var headerView: CheckoutViews
        if section == 0 {
          headerView = XibHelper.puffViewWithNibName("CheckoutViews", index: 0) as! CheckoutViews
        } else {
          headerView = XibHelper.puffViewWithNibName("CheckoutViews", index: 2) as! CheckoutViews
        }
        
        return headerView
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            let footerView: CheckoutViews = XibHelper.puffViewWithNibName("CheckoutViews", index: 1) as! CheckoutViews
            footerView.totalPricelabel?.text = self.totalPrice
            return footerView
        } else {
            return UIView(frame: CGRectZero)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let product: CartProductDetailsModel = self.cartItems[indexPath.row]
        let orderSummaryCell: OrderSummaryTableViewCell = tableView.dequeueReusableCellWithIdentifier(Constants.Checkout.orderSummaryTableViewCellNibNameAndIdentifier) as! OrderSummaryTableViewCell
        orderSummaryCell.productImageView.sd_setImageWithURL(NSURL(string: product.image)!, placeholderImage: UIImage(named: "dummy-placeholder"))
        orderSummaryCell.itemTitleLabel.text = product.title
        orderSummaryCell.quantityLabel.text = "\(product.quantity)"
        
        for tempProductUnit in product.productUnits {
            if product.unitId == tempProductUnit.productUnitId {
                orderSummaryCell.priceLabel.text = "P " + tempProductUnit.discountedPrice
                break
            }
        }
        
        return orderSummaryCell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartItems.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 71
        } else {
            return 105
        }
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func shipToTableViewCell(didTap shipToTableViewCell: ShipToTableViewCell) {
        shipToTableViewCell.fakeContainerView.backgroundColor = Constants.Colors.selectedCellColor
        
        let seconds = 0.5
        let delay = seconds * Double(NSEC_PER_SEC)  // nanoseconds per seconds
        var dispatchTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        
        dispatch_after(dispatchTime, dispatch_get_main_queue(), {
            shipToTableViewCell.fakeContainerView.backgroundColor = UIColor.whiteColor()
        })
        
        let changeAddressViewController: ChangeAddressViewController = ChangeAddressViewController(nibName: "ChangeAddressViewController", bundle: nil)
        changeAddressViewController.delegate = self
        self.navigationController!.pushViewController(changeAddressViewController, animated: true)
    }
    
    func fireSetCheckoutAddress(addressId: Int) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(), "address_id": addressId]
        manager.POST(APIAtlas.setCheckoutAddressUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            let jsonResult: Dictionary = responseObject as! Dictionary<String, AnyObject>!
            if jsonResult["isSuccessful"] as! Bool != true {
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: jsonResult["message"] as! String)
                self.isValidToSelectPayment = false
            }
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if error.userInfo != nil {
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(jsonResult)
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message)
                    }
                }
                
                if task.statusCode == 401 {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Mismatch username and password", title: "Login Failed")
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
                
                self.hud?.hide(true)
        })
    }
}
