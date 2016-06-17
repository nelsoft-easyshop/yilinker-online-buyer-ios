//
//  EditProfileAddPhotoTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol EditProfileAddPhotoTableViewCellDelegate{
    func addPhotoAction(sender: AnyObject)
}

class EditProfileAddPhotoTableViewCell: UITableViewCell {
    
    var delegate: EditProfileAddPhotoTableViewCellDelegate?

    @IBOutlet weak var addPhotoLabel: UILabel!
    @IBOutlet weak var addPhotoView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initializeViews()
    }

    func initializeViews() {
        addPhotoView.layer.cornerRadius = addPhotoView.frame.height / 2
        
        var addPhoto = UITapGestureRecognizer(target:self, action:"tapAddPhotoAction")
        addPhotoView.addGestureRecognizer(addPhoto)
    }
    
    func tapAddPhotoAction() {
        delegate?.addPhotoAction(self)
    }

}
