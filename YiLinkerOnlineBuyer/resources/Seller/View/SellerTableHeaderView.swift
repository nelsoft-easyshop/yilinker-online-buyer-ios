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

    @IBOutlet weak var viewFeedbackButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    
    @IBOutlet weak var profileImageView: RoundedButton!
    @IBOutlet weak var callButton: UIButton!
    @IBOutlet weak var messageButton: UIButton!
    
    @IBOutlet weak var coverPhotoImageView: UIImageView!
    
    @IBOutlet weak var sellernameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var delegate: SellerTableHeaderViewDelegate?
 
    override func awakeFromNib() {
      self.gradient()
            
        if IphoneType.isIphone4() || IphoneType.isIphone5(){
            followButton.titleLabel?.font = UIFont(name: "Panton", size: 11)
            viewFeedbackButton.titleLabel?.font = UIFont(name: "Panton", size: 11)
        }
        
        viewFeedbackButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)
        self.callButton.layer.cornerRadius = self.callButton.frame.size.width / 2
        self.messageButton.layer.cornerRadius = self.messageButton.frame.size.width / 2
        
        self.callButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.messageButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.callButton.layer.borderWidth = 1.5
        self.messageButton.layer.borderWidth = 1.5
        
        
        self.followButton.layer.cornerRadius = 15
        
        self.viewFeedbackButton.layer.cornerRadius = 15
        
        self.viewFeedbackButton.layer.borderColor = UIColor.whiteColor().CGColor
        self.viewFeedbackButton.backgroundColor = .whiteColor()
        self.viewFeedbackButton.layer.borderWidth = 1.5
    }
    
    func gradient() {
        if self.coverPhotoImageView != nil {
            self.coverPhotoImageView.layer.sublayers = nil
            let adjustmentInGradient: CGFloat = 50
            let background = CAGradientLayer().gradient()
            background.frame = CGRectMake(0, 0, self.coverPhotoImageView.frame.size.width, self.coverPhotoImageView.frame.size.height + adjustmentInGradient)
            self.coverPhotoImageView.layer.insertSublayer(background, atIndex: 0)
        }
    }
    
    @IBAction func feedBack(sender: AnyObject) {
        self.bounceButton(sender)
        self.delegate?.sellerTableHeaderViewDidViewFeedBack()
    }
    
    @IBAction func follow(sender: AnyObject) {
        self.bounceButton(sender)
        self.delegate?.sellerTableHeaderViewDidFollow()
    }
    
    @IBAction func call(sender: AnyObject) {
        self.bounceButton(sender)
        self.delegate?.sellerTableHeaderViewDidCall()
    }
    
    @IBAction func message(sender: AnyObject) {
        self.bounceButton(sender)
        self.delegate?.sellerTableHeaderViewDidMessage()
    }
    
    func bounceButton(sender: AnyObject) {
        var sprintAnimation: POPSpringAnimation = POPSpringAnimation(propertyNamed: kPOPViewScaleXY)
        sprintAnimation.toValue = NSValue(CGPoint: CGPointMake(1.0, 1.0))
        sprintAnimation.velocity = NSValue(CGPoint: CGPointMake(2.0, 2.0))
        sprintAnimation.springBounciness = 20.0
        let button: UIButton = sender as! UIButton
        button.pop_addAnimation(sprintAnimation, forKey: "springAnimation")
    }
}
