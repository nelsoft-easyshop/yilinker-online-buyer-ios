//
//  TextViewAutoHeight.swift
//  YiLinkerOnlineBuyer
//
//  Created by Dennis Nora on 9/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TextViewAutoHeight: UITextView {

    //MARK: attributes
    
    var  maxHeight:CGFloat?
    var  heightConstraint:NSLayoutConstraint?
    
    //MARK: initialize
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpInit()
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setUpInit()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpInit()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setUpConstraint()
    }
    
    //MARK: private
    
    private func setUpInit() {
        for constraint in self.constraints() {
            if constraint.firstAttribute == NSLayoutAttribute.Height {
                self.heightConstraint = constraint as? NSLayoutConstraint;
                break;
            }
        }
        
    }
    
    private func setUpConstraint() {
        var finalContentSize:CGSize = self.contentSize
        finalContentSize.width  += (self.textContainerInset.left + self.textContainerInset.right ) / 2.0
        finalContentSize.height += (self.textContainerInset.top  + self.textContainerInset.bottom) / 2.0
        
        fixTextViewHeight(finalContentSize)
    }
    
    private func fixTextViewHeight(finalContentSize:CGSize) {
        if let maxHeight = self.maxHeight {
            var  customContentSize = finalContentSize;
            
            customContentSize.height = min(customContentSize.height, CGFloat(maxHeight))
            
            self.heightConstraint?.constant = customContentSize.height;
            
            if finalContentSize.height <= CGRectGetHeight(self.frame) {
                let textViewHeight = (CGRectGetHeight(self.frame) - self.contentSize.height * self.zoomScale)/2.0
                
                self.contentOffset = CGPointMake(0, -(textViewHeight < 0.0 ? 0.0 : textViewHeight))
                
            }
        }
    }
    
}
