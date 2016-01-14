//
//  MessagingConversationTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 1/8/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class MessagingConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var senderImageView: UIImageView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var senderNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.initializeViews()
    }
    
    func initializeViews() {
        // Set senderImageView and statusView to circular
        self.senderImageView.layer.cornerRadius = self.senderImageView.frame.height / 2
        self.statusView.layer.cornerRadius = self.statusView.frame.height / 2
        
        // Set statusView border
        self.statusView.layer.borderColor = UIColor.whiteColor().CGColor
        self.statusView.layer.borderWidth = 1.0
    }
    
    func setIsOnline(isOnline: Bool) {
        if isOnline {
            self.statusView.backgroundColor = Constants.Colors.onlineColor
        } else {
            self.statusView.backgroundColor = Constants.Colors.offlineColor
        }
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
            let interval: Double = minutesInterval / 60
            if interval < 2 {
                dateText = "\(interval.formatToNoDecimal()) \(MessagingLocalizedStrings.hourAgo)"
            } else {
                dateText = "\(interval.formatToNoDecimal()) \(MessagingLocalizedStrings.hoursAgo)"
            }
        } else if minutesInterval < (7 * 24 * 60) {     // Lesser than a week
            let interval: Double = minutesInterval / 60 / 24
            if interval < 2 {
                dateText = "\(interval.formatToNoDecimal()) \(MessagingLocalizedStrings.dayAgo)"
            } else {
                dateText = "\(interval.formatToNoDecimal()) \(MessagingLocalizedStrings.daysAgo)"
            }
        } else {
            dateText = tempDate.formatDateToString("yyyy/MM/dd")
        }
        
        self.dateLabel.text = dateText
    }
    
    func setHasNewMessage(hasNew: Bool) {
        if hasNew {
            self.messageLabel.textColor = Constants.Colors.appTheme
            self.senderNameLabel.textColor = Constants.Colors.appTheme
        } else {
            self.messageLabel.textColor = Constants.Colors.grayLine
            self.senderNameLabel.textColor = Constants.Colors.grayLine
        }
        
    }
}
