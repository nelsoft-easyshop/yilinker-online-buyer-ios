//
//  ProductDescriptionView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductDescriptionViewDelegate {
    func seeMoreDescription(controller: ProductDescriptionView)
}

class ProductDescriptionView: UIView {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var seeMoreView: UIView!
    
    var fullDescription: String = ""
    
    var delegate: ProductDescriptionViewDelegate?
    
    override func awakeFromNib() {
        
        var tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: "seeMoreAction:")
        self.addGestureRecognizer(tap)
    }
    
    func seeMoreAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.seeMoreDescription(self)
        }
    }
    
    func setDescription(short: String, full: String) {
        self.descriptionLabel.text = short
        self.fullDescription = full
        
        var label: UILabel = UILabel(frame: CGRectMake(10, 0, self.frame.size.width - 10, 0))
        label.numberOfLines = 0
        label.font = UIFont.systemFontOfSize(13.0)
        label.text = short
        label.sizeToFit()
        
        var newFrame: CGRect = self.frame
        newFrame.size.height += label.frame.size.height - 16
        self.frame = newFrame
    }

}
