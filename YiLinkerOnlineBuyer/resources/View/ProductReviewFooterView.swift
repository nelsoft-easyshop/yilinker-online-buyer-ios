//
//  ProductReviewFooterView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductReviewFooterViewDelegate {
    func seeMoreReview(controller: ProductReviewFooterView)
}

class ProductReviewFooterView: UIView {

    @IBOutlet weak var seeMoreView: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var delegate: ProductReviewFooterViewDelegate?
    
    override func awakeFromNib() {

        var tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: "seeMoreAction:")
        
        self.addGestureRecognizer(tap)
    }

    func seeMoreAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.seeMoreReview(self)
        }
    }
    
}
