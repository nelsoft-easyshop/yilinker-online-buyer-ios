//
//  SellerTableHeaderView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol SellerTableHeaderViewDelegate {
    func sellerTableHeaderViewDidCall()
    func sellerTableHeaderViewDidMessage()
    func sellerTableHeaderViewDidFollow()
    func sellerTableHeaderViewDidViewFeedBack()
}

class SellerTableHeaderView: UIView {

    @IBOutlet weak var coverPhotoImageView: UIImageView!
    @IBOutlet weak var viewFeedbackButton: DynamicRoundedButton!
    @IBOutlet weak var followButton: DynamicRoundedButton!
    
    @IBOutlet weak var sellernameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var profileImageView: RoundedButton!
    
    var delegate: SellerTableHeaderViewDelegate?
    
    override func awakeFromNib() {
      self.gradient()
    }
    
    func gradient() {
        let adjustmentInGradient: CGFloat = 50
        let background = CAGradientLayer().gradient()
        background.frame = CGRectMake(0, 0, self.coverPhotoImageView.frame.size.width, self.coverPhotoImageView.frame.size.height + adjustmentInGradient)
        self.coverPhotoImageView.layer.insertSublayer(background, atIndex: 0)
    }
    
    @IBAction func feedBack(sender: AnyObject) {
        if self.viewFeedbackButton.selected {
            self.viewFeedbackButton.selected = false
            self.viewFeedbackButton.backgroundColor = Constants.Colors.appTheme
            self.viewFeedbackButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.viewFeedbackButton.borderColor = UIColor.clearColor()
        } else {
            self.viewFeedbackButton.selected = true
            self.viewFeedbackButton.layer.borderColor = Constants.Colors.grayLine.CGColor
            self.viewFeedbackButton.setTitleColor(Constants.Colors.grayLine, forState: UIControlState.Normal)
            self.viewFeedbackButton.backgroundColor = UIColor.clearColor()
        }
        
        self.delegate?.sellerTableHeaderViewDidViewFeedBack()
    }
    
    @IBAction func follow(sender: AnyObject) {
        if self.followButton.selected {
            self.followButton.selected = false
            self.followButton.backgroundColor = Constants.Colors.appTheme
            self.followButton.borderColor = UIColor.clearColor()
            self.followButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.followButton.setTitle("FOLLOWING", forState: UIControlState.Normal)
            println(self.followButton.titleLabel?.text)
        } else {
            self.followButton.selected = true
            self.followButton.layer.borderColor = Constants.Colors.grayLine.CGColor
            self.followButton.setTitleColor(Constants.Colors.grayLine, forState: UIControlState.Normal)
            self.followButton.backgroundColor = UIColor.clearColor()
            self.followButton.setTitle("UNFOLLOW", forState: UIControlState.Normal)
            println(self.followButton.titleLabel?.text)
        }
       
        self.delegate?.sellerTableHeaderViewDidFollow()
    }
    
    @IBAction func call(sender: AnyObject) {
        self.delegate?.sellerTableHeaderViewDidCall()
    }
    
    @IBAction func message(sender: AnyObject) {
        self.delegate?.sellerTableHeaderViewDidMessage()
    }
}
