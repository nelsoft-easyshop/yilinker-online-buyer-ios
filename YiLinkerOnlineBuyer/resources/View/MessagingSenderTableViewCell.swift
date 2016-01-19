//
//  MessagingSenderTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 1/12/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class MessagingSenderTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var arrowView: UIView!
    @IBOutlet weak var dateTimeView: UIView!
    @IBOutlet weak var dateTimeLabel: UILabel!
    @IBOutlet weak var seenView: UIView!
    @IBOutlet weak var seenWidthConstant: NSLayoutConstraint!
    @IBOutlet weak var resendButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        //Make Image circular
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.resendButton.layer.cornerRadius = self.resendButton.frame.height / 2
        
        //Make Message view rounded corner
        self.messageView.layer.cornerRadius = 5
        
        //Rotate arrow view
        self.arrowView.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_4))
        self.arrowView.layer.cornerRadius = 3
        
        // Aadd shadow to newMessageButton
        self.messageView.layer.shadowColor = UIColor.grayColor().CGColor
        self.messageView.layer.shadowOffset = CGSizeMake(1.0, 2.0);
        self.messageView.layer.shadowOpacity = 0.5;
        self.messageView.layer.shadowRadius = 1.0;
    }
    
    func setDate(date: String) {
        let tempDate: NSDate = date.formatStringToDate("yyyy-MM-dd HH:mm:ss")
        let minutesInterval: Double = tempDate.differenceInMinutesWithCurrentDate()
        var dateText: String = ""
        
        if minutesInterval < 1{
            dateText = "Now"
        } else if minutesInterval < 60 {                // Lesser than 60 minutes
            if minutesInterval < 2 {
                dateText = "\(minutesInterval.formatToNoDecimal()) \(MessagingLocalizedStrings.minuteAgo)"
            } else {
                dateText = "\(minutesInterval.formatToNoDecimal()) \(MessagingLocalizedStrings.minutesAgo)"
            }
        } else if minutesInterval < (24 * 60) {         // Lesser than 24 hours
            dateText = tempDate.formatDateToString("HH:mm")
        } else if minutesInterval < (7 * 24 * 60) {     // Lesser than a week
            dateText = tempDate.formatDateToString("yyyy/MM/dd HH:mm")
        } else {
            dateText = tempDate.formatDateToString("yyyy/MM/dd HH:mm")
        }

        self.dateTimeLabel.text = dateText
    }
    
    func setSeen(isSeen: Bool) {
        if isSeen {
            self.seenWidthConstant.constant = 43
            self.seenView.hidden = false
        } else {
            self.seenWidthConstant.constant = 0
            self.seenView.hidden = true
        }
    }
    
    func setIsSent(isSent: Bool) {
        if isSent {
            self.contentView.alpha = 1.0
        } else {
            self.contentView.alpha = 0.5
        }
    }
    
    func setHasError(hasError: Bool) {
        if hasError {
            self.resendButton.hidden = false
        } else {
            self.resendButton.hidden = true
        }
    }
}
