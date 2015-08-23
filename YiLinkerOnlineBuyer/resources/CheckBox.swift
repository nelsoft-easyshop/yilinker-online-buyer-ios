//
//  CheckBox.swift
//  Messaging
//
//  Created by Dennis Nora on 8/23/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class CheckBox: UIButton {

    var status : Bool = false
    var checkedColorWay = UIColor(red: 84/255, green:
        182/255, blue:
        167/255, alpha: 1.0).CGColor
    var uncheckedColorWay = UIColor(red: 102/255, green:
        102/255, blue:
        102/255, alpha: 1.0).CGColor
    
    override func awakeFromNib() {
        unCheckedAppearance()
    }
    
    func unCheckedAppearance(){
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = uncheckedColorWay
        self.backgroundColor = UIColor.whiteColor()
        self.imageView!.image = nil
    }
    
    func checkedAppearance(){
        self.layer.cornerRadius = 5.0
        self.layer.masksToBounds = true
        self.layer.borderWidth = 1.0
        self.layer.borderColor = checkedColorWay
        self.layer.backgroundColor = checkedColorWay
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        if(status){
            status = false
        } else {
            status = true
        }
        self.changeAppearance()
        super.touchesEnded(touches, withEvent: event)
    }
    
    func setChecked(status : Bool){
        self.status = status
        if (self.status){
            self.checkedAppearance()
        } else {
            self.unCheckedAppearance()
        }
    }
    
    func changeAppearance(){
        if(status){
            checkedAppearance()
        } else {
            unCheckedAppearance()
        }
    
    }

}
