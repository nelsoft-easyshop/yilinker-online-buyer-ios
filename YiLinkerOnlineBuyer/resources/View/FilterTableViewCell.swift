//
//  FilterTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol FilterTableViewCellDelegate {
    func clickedAttributeAtIndex(index: Int, attributeNameIndex: Int)
}

class FilterTableViewCell: UITableViewCell {
    
    var delegate: FilterTableViewCellDelegate?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var filter: FilterAttributeModel!
    var attributeNameIndex: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func passModel(model: FilterAttributeModel, attributeNameIndex: Int) {
        filter = model
        self.attributeNameIndex = attributeNameIndex
        initializeScrollView()
    }
    
    func initializeScrollView() {
        titleLabel.text = filter.title
        
        let subviews = self.scrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
        
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
            button.tag = i
            
            x += width + 10
            scrollView.addSubview(button)
            
            if i == filter.selectedIndex {
                clickedAttribute(button)
            }
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(x), height: scrollView.frame.size.height)
    }
    
    
    func clickedAttribute(sender: UIButton!) {
        delegate?.clickedAttributeAtIndex(sender.tag, attributeNameIndex: attributeNameIndex)

        if sender.selected {
            //DeselectButton(sender)
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
