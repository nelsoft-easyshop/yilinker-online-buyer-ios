//
//  ProfileTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProfileTableViewCellDelegate{
    func editProfileTapAction()
    func transactionsTapAction()
    func activityLogTapAction()
    func myPointsTapAction()
    func settingsTapAction()
}

class ProfileTableViewCell: UITableViewCell {
    
    var delegate: ProfileTableViewCellDelegate?
    
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var transactionsLabel: UILabel!

    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var transactionsView: UIView!
    @IBOutlet weak var activityLogView: UIView!
    @IBOutlet weak var myPointsView: UIView!
    @IBOutlet weak var settingsView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initializesTapGesture()
    }

    func initializesTapGesture() {
        var editProfile = UITapGestureRecognizer(target:self, action:"tapEditProfileViewAction")
        editProfileView.addGestureRecognizer(editProfile)
        
        var transactions = UITapGestureRecognizer(target:self, action:"tapTransactionsViewAction")
        transactionsView.addGestureRecognizer(transactions)
        
        var activityLog = UITapGestureRecognizer(target:self, action:"tapActivityLogViewAction")
        activityLogView.addGestureRecognizer(activityLog)
        
        var myPoints = UITapGestureRecognizer(target:self, action:"tapMyPointsViewAction")
        myPointsView.addGestureRecognizer(myPoints)
        
        var settings = UITapGestureRecognizer(target:self, action:"tapSettingsViewAction")
        settingsView.addGestureRecognizer(settings)
    }
    
    // Tap gesture Functions
    @IBAction func tapEditProfileViewAction() {
        delegate?.editProfileTapAction()
    }
    
    @IBAction func tapTransactionsViewAction() {
        delegate?.transactionsTapAction()
    }
    
    @IBAction func tapActivityLogViewAction() {
        delegate?.activityLogTapAction()
    }
    
    @IBAction func tapMyPointsViewAction() {
        delegate?.myPointsTapAction()
    }
    
    @IBAction func tapSettingsViewAction() {
        delegate?.settingsTapAction()
    }
    
    
}
