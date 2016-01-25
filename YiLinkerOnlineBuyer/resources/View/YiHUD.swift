//
//  YiHUD.swift
//  YiHUD
//
//  Created by Alvin John Tandoc on 1/25/16.
//  Copyright (c) 2016 YiAyOS. All rights reserved.
//

import UIKit

class YiHUD: UIView {
    
   class func initHud() -> YiHUD {
        let yiHUD: YiHUD = XibHelper.puffViewWithNibName("YiHUD", index: 0) as! YiHUD
        return yiHUD
    }
    
    func showHUDToView(view: UIView) {
        var isAdded: Bool = false
        
        for subView in view.subviews {
            if subView.isKindOfClass(YiHUD) {
                isAdded = true
                break
            }
        }
        
        self.layer.zPosition = 1000
        
        if !isAdded {
            view.addSubview(self)
        }

        self.center = view.convertPoint(view.center, fromView: self)
    }
    
    func hide() {
        self.removeFromSuperview()
    }
    
    override func awakeFromNib() {
        let bounds = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        //draw a rect in circle form
        // Create CAShapeLayerS
        let rectShape = CAShapeLayer()
        rectShape.bounds = bounds
        rectShape.position = self.center
        rectShape.cornerRadius = bounds.width / 2
        self.layer.addSublayer(rectShape)
        
        // Apply effects here
        // 1
        rectShape.path = UIBezierPath(ovalInRect: rectShape.bounds).CGPath
        
        rectShape.lineWidth = 2.0
        rectShape.strokeColor = Constants.Colors.appTheme.CGColor
        rectShape.fillColor = UIColor.clearColor().CGColor
        
        //value is 0 to 1. This animation of the stroke. if you set a higher end value the stroke will be last long
        // 2
        rectShape.strokeStart = 0
        rectShape.strokeEnd = 0.2
        
        //value is 0 to 1. This is the rotation of the path in the view.
        // 3
        let start = CABasicAnimation(keyPath: "strokeStart")
        start.toValue = 1
        let end = CABasicAnimation(keyPath: "strokeEnd")
        end.toValue = 1

        // 4
        let group = CAAnimationGroup()
        group.animations = [start, end]
        group.duration = 1.5
        group.autoreverses = true
        group.repeatCount = HUGE // repeat forver
        rectShape.addAnimation(group, forKey: nil)
    }

}
