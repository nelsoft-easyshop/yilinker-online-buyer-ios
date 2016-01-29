//
//  ProductAttributeTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol CartProductAttributeTableViewCellDelegate {
    func selectedAttribute(attributeId: String)
    func deselectedAttribute(attributeId: String)
}

class CartProductAttributeTableViewCell: UITableViewCell {
    
    var delegate: CartProductAttributeTableViewCellDelegate?
    
    @IBOutlet weak var attributeLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    var filter: FilterAttributeModel!
    var productAttribute: ProductAttributeModel!
    var selectedAttributes: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    
    func passModel(model: ProductAttributeModel, selectedAttributes: [String]){
        productAttribute = model
        filter = FilterAttributeModel(title: model.attributeName, selectedIndex: 0, attributes: uniq(model.valueName))
        self.selectedAttributes = selectedAttributes
        initializeScrollView()
    }
    
    func initializeScrollView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        
        attributeLabel.text = filter.title
        
        var x: CGFloat = 0
        var y: CGFloat = 8
        var contentWidth = 0
        var cellHeight: CGFloat = 34
        var width = (screenWidth / 2) - 24
        
        let subviews = self.scrollView.subviews
        for subview in subviews{
            subview.removeFromSuperview()
        }
        
        for var i = 0; i < filter.attributes.count; i++ {
            
            if i % 2 == 0 {
                x = 0
            } else {
                x = width + 8
            }
            
            if i != 0 {
                if i % 2 == 0 {
                    y += 8 + cellHeight
                }
            }
            
            
            
            var button = UIButton(frame: CGRectMake(x, y, CGFloat(width), cellHeight))
            button.setTitle(filter.attributes[i] as String, forState: .Normal)
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
            button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            button.layer.borderWidth = 1.2
            button.layer.borderColor = UIColor.darkGrayColor().CGColor
            button.layer.cornerRadius = button.frame.height/2
            button.backgroundColor = UIColor.whiteColor()
            button.tag = i
            button.addTarget(self, action: "clickedAttribute:", forControlEvents: .TouchUpInside)
            
            if contains(selectedAttributes, filter.attributes[i]){
                SelectButton(button)
            } else {
                DeselectButton(button)
            }
            scrollView.addSubview(button)
        }
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.height, height: (y + cellHeight + 8))
        heightConstraint.constant = (y + cellHeight + 8)
    }
    
    func uniq<S : SequenceType, T : Hashable where S.Generator.Element == T>(source: S) -> [T] {
        var buffer = [T]()
        var added = Set<T>()
        for elem in source {
            if !added.contains(elem) {
                buffer.append(elem)
                added.insert(elem)
            }
        }
        return buffer
    }
    
    func clickedAttribute(sender: UIButton!) {
        
        if sender.selected {
            DeselectButton(sender)
            delegate?.deselectedAttribute(filter.attributes[sender.tag])
        } else {
            for view in scrollView.subviews as! [UIView]{
                if let button = view as? UIButton {
                    DeselectButton(button)
                    delegate?.deselectedAttribute(filter.attributes[button.tag])
                }
            }
            SelectButton(sender)
            
            delegate?.selectedAttribute(filter.attributes[sender.tag])
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
    
    func enableButton(button: UIButton) {
        button.alpha = 1.0
        button.userInteractionEnabled = true
    }
    
    func disableButton(button: UIButton) {
        button.alpha = 0.25
        button.userInteractionEnabled = false
    }
    
}
