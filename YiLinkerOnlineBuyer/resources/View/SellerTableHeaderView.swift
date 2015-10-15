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
    
    @IBOutlet weak var callButton: RoundedButton!
    
    @IBOutlet weak var messageButton: RoundedButton!
    
    override func awakeFromNib() {
      self.gradient()
            
        if IphoneType.isIphone4() || IphoneType.isIphone5(){
            followButton.titleLabel?.font = UIFont(name: "Panton", size: 11)
            viewFeedbackButton.titleLabel?.font = UIFont(name: "Panton", size: 11)
        }
        
        viewFeedbackButton.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 2)
    }
    
    func gradient() {
        let adjustmentInGradient: CGFloat = 50
        let background = CAGradientLayer().gradient()
        background.frame = CGRectMake(0, 0, self.coverPhotoImageView.frame.size.width, self.coverPhotoImageView.frame.size.height + adjustmentInGradient)
        self.coverPhotoImageView.layer.insertSublayer(background, atIndex: 0)
    }
    
    @IBAction func feedBack(sender: AnyObject) {
        
        self.delegate?.sellerTableHeaderViewDidViewFeedBack()
    }
    
    @IBAction func follow(sender: AnyObject) {
        self.delegate?.sellerTableHeaderViewDidFollow()
    }
    
    @IBAction func call(sender: AnyObject) {
        self.delegate?.sellerTableHeaderViewDidCall()
    }
    
    @IBAction func message(sender: AnyObject) {
        self.delegate?.sellerTableHeaderViewDidMessage()
    }
}
