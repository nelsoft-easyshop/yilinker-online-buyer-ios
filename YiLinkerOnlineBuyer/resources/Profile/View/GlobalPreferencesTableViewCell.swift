//
//  GlobalPreferencesTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/14/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class GlobalPreferencesTableViewCell: UITableViewCell {
    
    static let reuseIdentifier: String = "GlobalPreferencesTableViewCell"

    @IBOutlet var valueImageView: UIImageView!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var checkImageView: UIImageView!
    
    @IBOutlet var valueImageWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setType(type: GlobalPreferencesPickerType) {
        switch type {
            case .Country :
                self.valueImageWidthConstraint.constant = 37
            case .Language :
                self.valueImageWidthConstraint.constant = 0
            default:
                self.valueImageWidthConstraint.constant = 0
        }
    }
    
    func setValueImage(url: String) {
        self.valueImageView.sd_setImageWithURL(StringHelper.convertStringToUrl(url), placeholderImage: UIImage(named: "dummy-placeholder"))
    }
    
    func setValueText(text:String) {
        self.valueLabel.text = text
    }
    
    func setIsChecked(isCheck: Bool) {
        self.checkImageView.hidden = !isCheck
    }
}
