//
//  ProductDetailTVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/23/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class ProductDetailTVC: UITableViewCell {

    
    @IBOutlet weak var productDetailLabel: UILabel!
    @IBOutlet weak var productDefinitionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
