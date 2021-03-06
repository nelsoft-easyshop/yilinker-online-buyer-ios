//
//  YiHUD.swift
//  YiHUD
//
//  Created by Alvin John Tandoc on 1/25/16.
//  Copyright (c) 2016 YiAyOS. All rights reserved.
//

import UIKit

class YiHUD: UIView {
    
    static let kHudTag: Int = 123456
    var isViewHidden: Bool = true
    
    @IBOutlet weak var dimView: UIView!
    //MARK: - 
    //MARK: - Awake Form Nib
    override func awakeFromNib() {
        let bounds = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.backgroundColor = UIColor.clearColor()
        self.dimView.backgroundColor = UIColor.blackColor()
        self.dimView.alpha = 0.7
        self.dimView.layer.cornerRadius = 7
    }
    
    //MARK: - 
    //MARK: - Init HUD
    class func initHud() -> YiHUD {
        let yiHUD: YiHUD = XibHelper.puffViewWithNibName("YiHUD", index: 0) as! YiHUD
        yiHUD.tag = YiHUD.kHudTag
        
        return yiHUD
    }
    
    //MARK: - 
    //MARK: - Show Hud To View
    func showHUDToView(view: UIView) {
        var isAdded: Bool = false
        
        for subView in view.subviews {
            if subView.isKindOfClass(YiHUD) || subView.tag ==  YiHUD.kHudTag {
                isAdded = true
                break
            }
        }
        
        self.layer.zPosition = 1000
        
        if !isAdded {
            view.addSubview(self)
        }
        
        view.layoutIfNeeded()
        self.center = view.center
        
        self.isViewHidden = false
    }
    
    //MARK: - 
    //MARK: - Hide
    func hide() {
        self.removeFromSuperview()
        self.isViewHidden = true
    }

}
