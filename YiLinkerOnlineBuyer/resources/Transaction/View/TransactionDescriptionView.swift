//
//  TransactionDescriptionView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol TransactionDescriptionViewDelegate {
    func getProductDescription(desc: String)
}

class TransactionDescriptionView: UIView {
    
    @IBOutlet weak var seeMoreButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var seeMoreLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    
    var delegate: TransactionDescriptionViewDelegate?
    
    override func awakeFromNib() {
        
        var tap = UITapGestureRecognizer(target: self, action: "seeMoreAction:")
        seeMoreLabel.addGestureRecognizer(tap)
    }
    
    func seeMoreAction(sender: AnyObject) {
        println("see more here")
        self.delegate?.getProductDescription(self.descriptionLabel.text!)
    }
    
    @IBAction func seeMore(sender: AnyObject) {
        self.delegate?.getProductDescription(self.descriptionLabel.text!)
    }
    
}
