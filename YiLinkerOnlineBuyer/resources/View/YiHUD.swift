//
//  YiHUD.swift
//  YiHUD
//
//  Created by Alvin John Tandoc on 1/25/16.
//  Copyright (c) 2016 YiAyOS. All rights reserved.
//

import UIKit

class YiHUD: UIView {
    
    @IBOutlet weak var yiboImageView: UIImageView!
    
    //MARK: - 
    //MARK: - Awake Form Nib
    override func awakeFromNib() {
        let bounds = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        //draw a rect in circle form
        // Create CAShapeLayerS
        let rectShape = CAShapeLayer()
        rectShape.bounds = bounds
        rectShape.position = self.center
        rectShape.cornerRadius = bounds.width / 2
        
        
        // Apply effects here
        // 1
        rectShape.path = UIBezierPath(ovalInRect: rectShape.bounds).CGPath
        
        rectShape.lineWidth = 2.0
        rectShape.strokeColor = UIColor.whiteColor().CGColor
        rectShape.fillColor = UIColor.clearColor().CGColor
        
        //value is 0 to 1. This animation of the stroke. if you set a higher end value the stroke will be last long
        // 2
        rectShape.strokeStart = 0
        rectShape.strokeEnd = 0.1
        
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
        
        let rectShape2 = CAShapeLayer()
        rectShape2.bounds = bounds
        rectShape2.position = self.center
        rectShape2.cornerRadius = bounds.width / 2
        self.layer.addSublayer(rectShape2)
        self.layer.addSublayer(rectShape)
        
        // Apply effects here
        // 1
        rectShape2.path = UIBezierPath(ovalInRect: rectShape2.bounds).CGPath
        
        rectShape2.lineWidth = 2.5
        rectShape2.strokeColor = UIColor.grayColor().CGColor
        rectShape2.fillColor = UIColor.clearColor().CGColor
        
        self.pulseAnimation()
    }
    
    //MARK: - 
    //MARK: - Init HUD
    class func initHud() -> YiHUD {
        let yiHUD: YiHUD = XibHelper.puffViewWithNibName("YiHUD", index: 0) as! YiHUD
        return yiHUD
    }
    
    //MARK: - 
    //MARK: - Show Hud To View
    func showHUDToView(view: UIView) {
        var isAdded: Bool = false
        
        for subView in view.subviews {
            if subView.isKindOfClass(YiHUD) {
                isAdded = true
                break
            }
        }
        
        self.layer.zPosition = 1000
        self.layer.cornerRadius = self.frame.size.width / 2
        
        if !isAdded {
            view.addSubview(self)
        }
        
        self.center = view.convertPoint(view.center, fromView: self)
    }
    
    //MARK: - 
    //MARK: - Hide
    func hide() {
        self.removeFromSuperview()
    }
    
    //MARK: - 
    //MARK: - Pulse Animation
    func pulseAnimation() {
        let pulseAnimation = CABasicAnimation(keyPath: "opacity")
        pulseAnimation.duration = 0.5
        pulseAnimation.fromValue = 0.90
        pulseAnimation.toValue = 1
        pulseAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        pulseAnimation.autoreverses = true
        pulseAnimation.repeatCount = FLT_MAX
        self.yiboImageView.layer.addAnimation(pulseAnimation, forKey: nil)
    }

}
