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
    func resolutionTapAction()
    func settingsTapAction()
}

class ProfileTableViewCell: UITableViewCell {
    
    var delegate: ProfileTableViewCellDelegate?
    
    @IBOutlet weak var followingValueLabel: UILabel!
    @IBOutlet weak var transactionsValueLabel: UILabel!
    @IBOutlet weak var followingLabel: UILabel!
    @IBOutlet weak var transactionsLabel: UILabel!
    @IBOutlet weak var editProfileLabel: UILabel!
    @IBOutlet weak var transactionButtonLabel: UILabel!
    @IBOutlet weak var activityLogsLabel: UILabel!
    @IBOutlet weak var myPointsLabel: UILabel!
    @IBOutlet weak var resolutionCenterLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!

    @IBOutlet weak var editProfileView: UIView!
    @IBOutlet weak var transactionsView: UIView!
    @IBOutlet weak var activityLogView: UIView!
    @IBOutlet weak var myPointsView: UIView!
    @IBOutlet weak var resolutionView: UIView!
    @IBOutlet weak var settingsView: UIView!
    
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var transactionsButton: UIButton!
    @IBOutlet weak var activityLogButton: UIButton!
//    @IBOutlet weak var myPointsButton: UIButton!
    @IBOutlet weak var resolutionButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initializeViews()
        initializesTapGesture()
        initializeLocalizedString()
    }

    func initializeViews() {
        editProfileButton.layer.cornerRadius = editProfileButton.frame.height / 2
        transactionsButton.layer.cornerRadius = transactionsButton.frame.height / 2
        activityLogButton.layer.cornerRadius = activityLogButton.frame.height / 2
        //myPointsButton.layer.cornerRadius = myPointsButton.frame.height / 2
        resolutionButton.layer.cornerRadius = resolutionButton.frame.height / 2
        settingsButton.layer.cornerRadius = settingsButton.frame.height / 2
    }
    
    func initializeLocalizedString() {
        let followingLocalizeString: String = StringHelper.localizedStringWithKey("FOLLOWING_LOCALIZE_KEY")
        let transactionsLocalizeString: String = StringHelper.localizedStringWithKey("TRANSACTIONS_LOCALIZE_KEY")
        let editProfileLocalizeString: String = StringHelper.localizedStringWithKey("EDITPROFILE_LOCALIZE_KEY")
        let activityLogsLocalizeString: String = StringHelper.localizedStringWithKey("ACTIVITYLOGS_LOCALIZE_KEY")
//        let myPointsLocalizeString: String = StringHelper.localizedStringWithKey("MYPOINTS_LOCALIZE_KEY")
        let resolutionCenterLocalizeString: String = StringHelper.localizedStringWithKey("RESOLUTIONCENTER_LOCALIZE_KEY")
        let settingssLocalizeString: String = StringHelper.localizedStringWithKey("SETTINGS_LOCALIZE_KEY")
        
        followingLabel.text = followingLocalizeString
        transactionsLabel.text = transactionsLocalizeString
        editProfileLabel.text = editProfileLocalizeString
        transactionButtonLabel.text = transactionsLocalizeString
        activityLogsLabel.text = activityLogsLocalizeString
//        myPointsLabel.text = myPointsLocalizeString
        resolutionCenterLabel.text = resolutionCenterLocalizeString
        settingsLabel.text = settingssLocalizeString
    }
    
    func initializesTapGesture() {
        var editProfile = UITapGestureRecognizer(target:self, action:"tapEditProfileViewAction")
        editProfileView.addGestureRecognizer(editProfile)
        
        var transactions = UITapGestureRecognizer(target:self, action:"tapTransactionsViewAction")
        transactionsView.addGestureRecognizer(transactions)
        
        var activityLog = UITapGestureRecognizer(target:self, action:"tapActivityLogViewAction")
        activityLogView.addGestureRecognizer(activityLog)
        
//        var myPoints = UITapGestureRecognizer(target:self, action:"tapMyPointsViewAction")
//        myPointsView.addGestureRecognizer(myPoints)
        
        var resolution = UITapGestureRecognizer(target:self, action:"tapResolutionViewAction")
        resolutionView.addGestureRecognizer(resolution)
        
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
    
    @IBAction func tapResolutionViewAction() {
        delegate?.resolutionTapAction()
    }
    
}
