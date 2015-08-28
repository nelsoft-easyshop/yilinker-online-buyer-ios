//
//  ProductReviewHeaderView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductReviewHeaderView: UIView {

    @IBOutlet weak var rate1: UIImageView!
    @IBOutlet weak var rate2: UIImageView!
    @IBOutlet weak var rate3: UIImageView!
    @IBOutlet weak var rate4: UIImageView!
    @IBOutlet weak var rate5: UIImageView!
    
    override func awakeFromNib() {
        
    }
    
    func setRating(rate: Int) {
        
        if rate > 4 {
            rateImage(rate5)
        }
        
        if rate > 3 {
            rateImage(rate4)
        }
        
        if rate > 2 {
            rateImage(rate3)
        }
        
        if rate > 1  {
            rateImage(rate2)
        }
        
        if rate > 0 {
            rateImage(rate1)
        }
        
    }
    
    func rateImage(ctr: UIImageView) {
        ctr.image = UIImage(named: "rating2")
    }

}
