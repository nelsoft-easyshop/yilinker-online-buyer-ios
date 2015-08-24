//
//  FilterTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var filter: FilterAttributeModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func passModel(model: FilterAttributeModel) {
        filter = model
        initializeScrollView()
    }
    
    func initializeScrollView() {
        titleLabel.text = filter.title
        
        var x: Int = 0
        var contentWidth = 0
        println(filter.attributes.count)
        for var i = 0; i < filter.attributes.count; i++ {
            var width = (count(filter.attributes[i]) * 10) + 20
            
            var button = UIButton(frame: CGRectMake(CGFloat(x), CGFloat(10), CGFloat(width), scrollView.frame.height/1.5))
            button.setTitle(filter.attributes[i] as String, forState: .Normal)
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
            button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            button.layer.borderWidth = 1.2
            button.layer.borderColor = UIColor.darkGrayColor().CGColor
            button.layer.cornerRadius = button.frame.height/2
            button.backgroundColor = UIColor.whiteColor()
            button.addTarget(self, action: "clickedAttribute:", forControlEvents: .TouchUpInside)
            
            x += width + 10
            scrollView.addSubview(button)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(x), height: scrollView.frame.size.height)
    }
    
    
    func clickedAttribute(sender: UIButton!) {
        
        if sender.selected {
            DeselectButton(sender)
            
        } else {
            for view in scrollView.subviews as! [UIView]{
                if let button = view as? UIButton {
                    DeselectButton(button)
                }
            }
            SelectButton(sender)
        }
    }
    
    func DeselectButton(button: UIButton) {
        button.selected = false
        button.layer.borderColor = UIColor.darkGrayColor().CGColor
        button.backgroundColor = UIColor.whiteColor()
        button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
    }
    
    func SelectButton(button: UIButton) {
        button.selected = true
        button.layer.borderColor = UIColor.purpleColor().CGColor
        button.backgroundColor = UIColor.purpleColor()
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    }
}
