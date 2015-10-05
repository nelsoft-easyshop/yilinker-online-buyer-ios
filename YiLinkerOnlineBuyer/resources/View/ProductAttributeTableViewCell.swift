//
//  ProductAttributeTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductAttributeTableViewCellDelegate {
    func selectedAttribute(controller: ProductAttributeTableViewCell, attributeIndex: Int, attributeValue: String!, attributeId: Int)
}

class ProductAttributeTableViewCell: UITableViewCell {

    @IBOutlet weak var attributeLabel: UILabel!

    var scroll: UIScrollView!
    var myIndex: Int!
    var selectedAttributeIndex = 0
    var aSelected: String = ""
    
    var attributesId: [String] = []
    var attributesName: [String] = []
    var selectedId: [String] = []
    var selectedValue: [String] = []
    var selectedAttributes: [String] = []
    
    var availableCombinationString: String = ""
    
    var delegate: ProductAttributeTableViewCellDelegate?
    
    var productDetailModel: ProductDetailsModel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - Methods

    func setAttribute( model: ProductAttributeModel, availableCombination: NSArray, selectedValue: NSArray, selectedId: NSArray, width: CGFloat) {
        attributeLabel.text = ProductStrings.select + " \(model.attributeName)"
        
        self.attributesId = []
        self.attributesId = model.valueId
        self.attributesName = []
        self.attributesName = model.valueName
        
        availableCombinationString = ""
        for i in 0..<availableCombination.count {
            availableCombinationString += availableCombination[i] as! String
        }
        
        addScrollViewWithAttributes(model.valueName, availableCombination: availableCombination, selectedValue: selectedValue, selectedId: selectedId, width: width)
    }
    
    func passProductDetailModel(model: ProductDetailsModel) {
        self.productDetailModel = model
    }
    
    func addScrollViewWithAttributes(attributes: NSArray, availableCombination: NSArray, selectedValue: NSArray, selectedId: NSArray, width: CGFloat) {
        
        for view in self.subviews {
            if view.isKindOfClass(UIScrollView) {
                view.removeFromSuperview()
            }
        }
        
        scroll = UIScrollView(frame: CGRectMake(0, self.frame.size.height - 70, width, 70))
        var spacingX: CGFloat = 0.0
        
        println(availableCombinationString)
        var leftMargin: Int = 10
        
        for i in 0..<attributes.count {
            let buttonTitle: String = attributes[i] as! String
            var buttonWidth: Int = (count(buttonTitle) * 10) + 20
            
            var button = UIButton(frame: CGRectMake(CGFloat(leftMargin), (scroll.frame.size.height / 2) - 15, CGFloat(buttonWidth), 30))
            button.setTitle(buttonTitle, forState: .Normal)
            button.titleLabel?.font = UIFont.boldSystemFontOfSize(15.0)
            button.setTitleColor(UIColor.darkGrayColor(), forState: .Normal)
            button.layer.borderWidth = 1.2
            button.layer.borderColor = UIColor.darkGrayColor().CGColor
            button.layer.cornerRadius = 15
            button.backgroundColor = UIColor.whiteColor()
            button.addTarget(self, action: "clickedAttriubte:", forControlEvents: .TouchUpInside)
            button.tag = attributesId[i].toInt()!
            
            leftMargin += buttonWidth + 10
//            //>>>>
//            button.sizeToFit()
//            button.frame.size.width += CGFloat(30)
//            if spacingX != 0.0 {
//                spacingX += button.frame.size.width
//            }
//            spacingX += 10.0
//            button.frame.origin.x += CGFloat(spacingX)
//            //<<<<

            if availableCombinationString.rangeOfString(attributesId[i]) == nil {
                self.disableButton(button)
            }
            
            for a in 0..<selectedId.count {
                if attributesId[i] == selectedId[a] as! String {
                    button.selected = true
                    button.layer.borderColor = Constants.Colors.appTheme.CGColor
                    button.backgroundColor = Constants.Colors.appTheme
                    button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                    
                    var tempy: CGFloat = scroll.frame.size.height
                    var tempx: CGFloat = scroll.frame.size.width
                    var zoomRect: CGRect = CGRectMake((tempx/2)-160, (tempy/2)-240, scroll.frame.size.width, scroll.frame.size.height)
                    scroll.scrollRectToVisible(zoomRect, animated: false)
                }
            }
            
            scroll.addSubview(button)
        }
        
        scroll.contentSize = CGSize(width: CGFloat((110 * attributes.count) + 10), height: scroll.frame.size.height)
        self.addSubview(scroll)
    }
    
    func formatCombination(combinations: NSArray) -> String {
        var formatCombination = ""
        
        for i in 0..<combinations.count {
            formatCombination += combinations[i] as! String
            if i != combinations.count - 1 {
                formatCombination += "_"
            }
        }
        
        return formatCombination
    }
    
    func clickedAttriubte(sender: UIButton!) {
        println("button id: \(sender.tag)")
        
        if sender.selected { // Unselect
            DeselectButton(sender)
            if let delegate = self.delegate {
                delegate.selectedAttribute(self, attributeIndex: self.tag, attributeValue: "", attributeId: -1)
            }
        } else {
            for view in scroll.subviews as! [UIView]{
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
        button.layer.borderColor = Constants.Colors.appTheme.CGColor
        button.backgroundColor = Constants.Colors.appTheme
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        if let delegate = self.delegate {
            delegate.selectedAttribute(self, attributeIndex: self.tag, attributeValue: button.titleLabel?.text!, attributeId: button.tag)
        }
        
    }
    
    func enableButton(button: UIButton) {
        button.alpha = 1.0
        button.userInteractionEnabled = true
    }
    
    func disableButton(button: UIButton) {
        button.alpha = 0.3
        button.userInteractionEnabled = false
    }
}
