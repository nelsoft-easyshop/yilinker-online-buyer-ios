//
//  ProductReviewFooterTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductReviewFooterTableViewCellDelegate{
    func sendAction(sender: AnyObject, rate: Int, review: String)
}


class ProductReviewFooterTableViewCell: UITableViewCell {
    
    var delegate: ProductReviewFooterTableViewCellDelegate?
    
    var rate: Int = 0
    
    @IBOutlet weak var reviewTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var star1Button: UIButton!
    @IBOutlet weak var star2Button: UIButton!
    @IBOutlet weak var star3Button: UIButton!
    @IBOutlet weak var star4Button: UIButton!
    @IBOutlet weak var star5Button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initializeViews()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func initializeViews() {
        star1Button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        star2Button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        star3Button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        star4Button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        star5Button.imageView?.contentMode = UIViewContentMode.ScaleAspectFill
    }
    
    @IBAction func sendAction(sender: AnyObject) {
        delegate?.sendAction(self, rate: rate, review: reviewTextField.text)
    }
        
    @IBAction func starButtonAction(sender: AnyObject) {
        if sender as! NSObject == star1Button {
            rate = 1
        } else if sender as! NSObject == star2Button {
            rate = 2
        } else if sender as! NSObject == star3Button {
            rate = 3
        } else if sender as! NSObject == star4Button {
            rate = 4
        } else if sender as! NSObject == star5Button {
            rate = 5
        }
        setStarButton()
    }
    
    func setStarButton() {
        star1Button.setImage(UIImage(named: "rating"), forState: UIControlState.Normal)
        star2Button.setImage(UIImage(named: "rating"), forState: UIControlState.Normal)
        star3Button.setImage(UIImage(named: "rating"), forState: UIControlState.Normal)
        star4Button.setImage(UIImage(named: "rating"), forState: UIControlState.Normal)
        star5Button.setImage(UIImage(named: "rating"), forState: UIControlState.Normal)
        
        if rate > 0 {
            star1Button.setImage(UIImage(named: "rating2"), forState: UIControlState.Normal)
        }
        if rate > 1 {
            star2Button.setImage(UIImage(named: "rating2"), forState: UIControlState.Normal)
        }
        if rate > 2 {
            star3Button.setImage(UIImage(named: "rating2"), forState: UIControlState.Normal)
        }
        if rate > 3 {
            star4Button.setImage(UIImage(named: "rating2"), forState: UIControlState.Normal)
        }
        if rate > 4 {
            star5Button.setImage(UIImage(named: "rating2"), forState: UIControlState.Normal)
        }
    }

}
