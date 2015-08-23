//
//  TransactionDetailsVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/22/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class TransactionDetailsVC: UIViewController {
    
    @IBOutlet weak var transactionIDLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    
    @IBOutlet weak var detailStatusLabel: RoundedLabel!
    @IBOutlet weak var detailPaymentTypeLabel: UILabel!
    @IBOutlet weak var detailDateCreatedLabel: UILabel!
    @IBOutlet weak var detailTotalQuantityLabel: UILabel!
    @IBOutlet weak var detailTotalUnitCostLabel: UILabel!
    @IBOutlet weak var detailShippingFeeLabel: UILabel!
    @IBOutlet weak var detailTotalCostLabel: UILabel!
    
    @IBOutlet weak var productListTable: UITableView!
    @IBOutlet weak var productListTableHeightConstraint: NSLayoutConstraint!
    let productIdentifier = "productCell"
    
    @IBOutlet weak var consigneeNameLabel: UILabel!
    @IBOutlet weak var consigneeAddressLabel: UILabel!
    @IBOutlet weak var consigneeContactNoLabel: UILabel!
    @IBOutlet weak var consigneeNameMessage: RoundedButtonWithBorder!
    
    @IBAction func onConsigneeNameMessage(sender: RoundedButtonWithBorder) {
        
    }
    
    @IBAction func onConsigneeSMSContactNo(sender: UIButton) {
        
    }
    
    @IBAction func onConsigneeCallContactNo(sender: UIButton) {
        
    }
    
    @IBOutlet weak var deliveryStatusLastCheckIn: UILabel!
    @IBOutlet weak var deliveryStatusLastCheckInAddress: UILabel!
    @IBOutlet weak var deliveryStatusPickupRider: UILabel!
    @IBOutlet weak var deliveryStatusDeliveryRider: UILabel!
    
    @IBAction func onDeliveryStatusLastCheckInClicked(sender: UIButton) {
        
    }
    
    @IBAction func onDeliveryStatusSMSPickupRider(sender: UIButton) {
        
    }
    
    @IBAction func onDeliveryStatusCallPickupRider(sender: UIButton) {
        
    }

    @IBAction func onDeliveryStatusSMSDeliveryRider(sender: UIButton) {
        
    }
    
    @IBAction func onDeliveryStatusCallDeliveryRider(sender: UIButton) {
        
    }
    
    
    @IBOutlet weak var feedbackButton: RoundedButtonWithBorder!
    @IBOutlet weak var cancelOrderButton: RoundedButton!
    @IBOutlet weak var shipItemButton: RoundedButton!
    let popTransitioningDelegate = PopTransitioningDelegate()
    
    @IBAction func onFeedback(sender: RoundedButtonWithBorder) {
        
    }
    
    @IBAction func onCancelOrder(sender: RoundedButton) {
        transitioningDelegate = popTransitioningDelegate
        let vc = storyboard?.instantiateViewControllerWithIdentifier("CancelOrderViewController") as! CancelOrderVC
        vc.transitioningDelegate = popTransitioningDelegate
        vc.modalPresentationStyle = UIModalPresentationStyle.Custom

        presentViewController(vc, animated: true, completion: nil)
        
    }
    
    @IBAction func onShipItem(sender: RoundedButton) {
        
    }
    
    var products = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        products.append("Magic Sing")
        products.append("Magic TV")
        products.append("Magic Stick")
        
        self.productListTable.scrollEnabled = false
        
        var newHeight = 44 * CGFloat(products.count)
        println(self.productListTable.rowHeight)
        println(newHeight)
        self.productListTable.frame.size.height = newHeight
        productListTableHeightConstraint.constant = newHeight
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TransactionDetailsVC : UITableViewDataSource, UITableViewDelegate{

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(productIdentifier) as! ProductTVC
        
        cell.productLabel.text = products[indexPath.row]
        
        var image = UIImage(named: "right2.png")
        
        var button : UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        var frame = CGRectMake(0, 0, 10, 20)
        button.frame = frame
        button.setImage(image, forState: UIControlState.Normal)
        
        button.addTarget(self, action: Selector("rightButtonTapped:event:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.accessoryView = button
        
        return cell
    }
    
    func rightButtonTapped(sender: UIButton, event : UIEvent!){
        var touches : NSSet = event.allTouches()!
        var touch : UITouch = touches.anyObject() as! UITouch
        
        var currentTouchPosition : CGPoint = touch.locationInView(self.productListTable)
        var indexPath : NSIndexPath = self.productListTable.indexPathForRowAtPoint(currentTouchPosition)!
        if (!indexPath.isEqual(nil)) {
            self.tableView(self.productListTable, accessoryButtonTappedForRowWithIndexPath: indexPath)
        }

    }
    
    func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        println("tapped \(indexPath.row)")
    }
    
}
