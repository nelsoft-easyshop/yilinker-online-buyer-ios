//
//  TransactionDescriptionView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

// MARK: Delegate
// TransactionDescriptionView Delegate method
protocol TransactionDescriptionViewDelegate {
    func getProductDescription(desc: String)
}

class TransactionDescriptionView: UIView {
    
    // Buttons
    @IBOutlet weak var seeMoreButton: UIButton!
    
    // Labels
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var seeMoreLabel: UILabel!
    @IBOutlet weak var descriptionTitleLabel: UILabel!
    
    // Initialize TransactionDescriptionViewDelegate
    var delegate: TransactionDescriptionViewDelegate?
    
    override func awakeFromNib() {
        // Add tap gesture recognizer in self.seeMoreLabel
        var tap = UITapGestureRecognizer(target: self, action: "seeMoreAction:")
        self.seeMoreLabel.addGestureRecognizer(tap)
    }
    
    // MARK: Button actions
    @IBAction func seeMore(sender: AnyObject) {
        self.delegate?.getProductDescription(self.descriptionLabel.text!)
    }
    
    // MARK: Action for self.seeMoreLabel
    func seeMoreAction(sender: AnyObject) {
        self.delegate?.getProductDescription(self.descriptionLabel.text!)
    }
}
