//
//  PaymentTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol PaymentTableViewCellDelegate {
    func paymentTableViewCell(didChoosePaymentType paymentType: PaymentType)
    func paymentTableViewCell(rememberPaymentType result: Bool)
}

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet weak var rememberPaymentOption: UILabel!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var codLabel: UILabel!
    @IBOutlet weak var howDoYouWishLabel: UILabel!
    @IBOutlet weak var cellSwitch: UISwitch!
    @IBOutlet weak var codView: UIView!
    @IBOutlet weak var creditCardView: UIView!
    @IBOutlet weak var codCheckBoxButton: SemiRoundedButton!
    @IBOutlet weak var creditCardCheckBoxbutton: SemiRoundedButton!
    
    var delegate: PaymentTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.howDoYouWishLabel.text = PaymentStrings.howDoYou
        self.codLabel.text = PaymentStrings.cod
        self.creditCardLabel.text = PaymentStrings.creditCard
        self.rememberPaymentOption.text = PaymentStrings.rememberPayment
            
        for touchableView in self.contentView.subviews {
            if touchableView.tag == Constants.Checkout.Payment.touchabelTagCOD || touchableView.tag == Constants.Checkout.Payment.touchabelTagCreditCard  {
                let tapGestureRecongnizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapView:")
                let touchView: UIView = touchableView as! UIView
                touchView.userInteractionEnabled = true
                touchView.addGestureRecognizer(tapGestureRecongnizer)
            }
        }
    }
    
    func tapView(sender: UITapGestureRecognizer) {
        let view = sender.view
        self.selectPaymentType(view!.tag)
    }
    
    func selectPaymentType(tag: Int) {
        if tag == Constants.Checkout.Payment.touchabelTagCOD {
            self.delegate?.paymentTableViewCell(didChoosePaymentType: PaymentType.COD)
            
            self.highlightSelectedView(self.codView, unSelectedView: self.creditCardView, selectedButton: self.codCheckBoxButton, unSelectedButton: self.creditCardCheckBoxbutton)
        } else {
            self.delegate?.paymentTableViewCell(didChoosePaymentType: PaymentType.CreditCard)
            
            self.highlightSelectedView(self.creditCardView, unSelectedView: self.codView, selectedButton: self.creditCardCheckBoxbutton, unSelectedButton: self.codCheckBoxButton)
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func highlightSelectedView(selectedView: UIView, unSelectedView: UIView, selectedButton: UIButton, unSelectedButton: UIButton) {
        selectedView.layer.borderWidth = 1
        selectedView.layer.borderColor = Constants.Colors.selectedGreenColor.CGColor
        selectedView.layer.cornerRadius = 5
        
        unSelectedView.layer.borderWidth = 1
        unSelectedView.layer.borderColor = Constants.Colors.grayLine.CGColor
        unSelectedView.layer.cornerRadius = 5
        
        selectedButton.setImage(UIImage(named: "checkBox"), forState: UIControlState.Normal)
        selectedButton.layer.borderColor = UIColor.clearColor().CGColor
        selectedButton.layer.borderWidth = 1
        selectedButton.backgroundColor = Constants.Colors.selectedGreenColor
        
        unSelectedButton.setImage(nil, forState: UIControlState.Normal)
        unSelectedButton.layer.borderColor = Constants.Colors.grayLine.CGColor
        unSelectedButton.layer.borderWidth = 1
        unSelectedButton.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func rememberPaymentType(sender: UISwitch) {
        if sender.on {
            self.delegate!.paymentTableViewCell(rememberPaymentType: true)
        } else {
            self.delegate!.paymentTableViewCell(rememberPaymentType: false)
        }

    }
}
