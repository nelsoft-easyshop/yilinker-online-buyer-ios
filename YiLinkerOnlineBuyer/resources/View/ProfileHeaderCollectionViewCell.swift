//
//  ProfileHeaderCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProfileHeaderCollectionViewCellDelegate{
    func editProfileButtonActionForIndex(sender: AnyObject)
    func switchViewButtonActionForIndex(sender: AnyObject)
}

class ProfileHeaderCollectionViewCell: UICollectionViewCell {
    var delegate: ProfileHeaderCollectionViewCellDelegate?
    
    @IBOutlet weak var profileImageView: RoundedImageView!
    @IBOutlet weak var statusButton: RoundedButton!
    @IBOutlet weak var editProfileButton: SemiRoundedButton!
    @IBOutlet weak var viewTypeButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeViews()
    }
    
    func initializeViews() {
        statusButton.layer.borderWidth = 3
        statusButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        editProfileButton.layer.borderWidth = 2
        editProfileButton.layer.borderColor = UIColor.grayColor().CGColor
        
    }
    
    @IBAction func switchViewAction(sender: AnyObject) {
        delegate?.switchViewButtonActionForIndex(self)
    }
    
    @IBAction func editActionProfile(sender: AnyObject) {
        delegate?.editProfileButtonActionForIndex(self)
    }
}
