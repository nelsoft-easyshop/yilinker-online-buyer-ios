//
//  TransactionDeliveryStatusView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

// MARK: Delegate
// TransactionDeliveryStatusView Delegate Methods
protocol TransactionDeliveryStatusViewDelegate {
    func pickupSmsAction()
    func pickupCallAction()
    func deliverySmsAction()
    func deliveryCallAction()
    func deliveryLogsAction()
}

class TransactionDeliveryStatusView: UIView {

    // Buttons
    @IBOutlet weak var deliveryLogsButton: UIButton!
    
    // Labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet var deliveryContactLabel: UILabel!
    @IBOutlet weak var deliveryRiderLabel: UILabel!
    @IBOutlet weak var deliveryStatusLabel: UILabel!
    @IBOutlet weak var deliveryRiderTitleLabel: UILabel!
    @IBOutlet weak var nameAndPlaceLabel: UILabel!
    @IBOutlet weak var nameAndPlaceTitleLabel: UILabel!
    @IBOutlet weak var pickupRiderLabel: UILabel!
    @IBOutlet weak var pickupRiderTitleLabel: UILabel!
    @IBOutlet var riderContactLabel: UILabel!
    
    // Imageviews
    @IBOutlet weak var deliveryCall: UIImageView!
    @IBOutlet weak var deliveryLogs: UIImageView!
    @IBOutlet weak var deliverySms: UIImageView!
    @IBOutlet weak var pickupCall: UIImageView!
    @IBOutlet weak var pickupSms: UIImageView!
    
    // Initiliaze TransactionDeliveryStatusViewDelegate
    var delegate: TransactionDeliveryStatusViewDelegate?
    
    override func awakeFromNib() {
        self.addViewsActions()
    }
    
    // MARK: Button action
    @IBAction func deliveryLogs(sender: UIButton){
        self.delegate?.deliveryLogsAction()
    }

    // MARK: - Add actions to imageviews when tapped
    func addViewsActions() {
        self.pickupSms.addGestureRecognizer(tap("pickupSmsAction:"))
        self.pickupCall.addGestureRecognizer(tap("pickupCallAction:"))
        self.deliverySms.addGestureRecognizer(tap("deliverySmsAction:"))
        self.deliveryCall.addGestureRecognizer(tap("deliveryCallAction:"))
        self.deliveryLogs.addGestureRecognizer(tap("arrowImageViewAction:"))
    }
    
    func tap(action: Selector) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        return tap
    }
    
    // MARK: - Imageviews actions when tapped
    func arrowImageViewAction(gesture: UIGestureRecognizer) {
        self.delegate?.deliveryLogsAction()
    }
    
    func deliverySmsAction(gesture: UIGestureRecognizer) {
        self.delegate?.deliverySmsAction()
    }
    
    func deliveryCallAction(gesture: UIGestureRecognizer) {
        self.delegate?.deliveryCallAction()
    }
    
    func pickupSmsAction(gesture: UIGestureRecognizer) {
        self.delegate?.pickupSmsAction()
    }
    
    func pickupCallAction(gesture: UIGestureRecognizer) {
        self.delegate?.pickupCallAction()
    }
}
