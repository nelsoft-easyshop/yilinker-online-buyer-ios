//
//  AddItemTableViewCell.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DisputeAddItemTableViewCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var vendorLabel: UILabel!
    @IBOutlet weak var addImageView: UIImageView!
    
//    var added: Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setProductImage(image: String) {
        self.itemImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func updateStatusImage(added: Bool) {
        if added {
            addImageView.image = UIImage(named: "checkCategory")
        } else {
            addImageView.image = UIImage(named: "addItem")
        }
    }
    
}
