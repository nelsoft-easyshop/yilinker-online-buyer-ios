//
//  BottomLoaderTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/5/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class BottomLoaderTableViewCell: UITableViewCell {

    @IBOutlet weak var loaderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setLoaderTitle(text: String) {
        self.loaderLabel.text = text
    }
}
