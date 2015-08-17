//
//  ProfileAddPhotoTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/16/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileAddPhotoTableViewCell: UITableViewCell {

    @IBOutlet weak var addPhotoView: UIView!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeViews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initializeViews () {
        addPhotoView.layer.cornerRadius = addPhotoView.frame.width / 2
    }
    
}
