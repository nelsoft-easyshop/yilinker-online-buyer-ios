//
//  IphoneType.swift
//  EasyDeal
//
//  Created by Alvin on 5/11/15.
//  Copyright (c) 2015 EasyDeal. All rights reserved.
//

import UIKit

class IphoneType: NSObject {
    
    class func isIphone4() -> Bool {
        let screenSize: CGRect = UIScreen.mainScreen().bounds

        if screenSize.height == 480 {
            return true
        } else {
            return false
        }
    }
    
    class func isIphone5() -> Bool {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if screenSize.height == 568 {
            return true
        } else {
            return false
        }
    }
    
    class func isIphone6() -> Bool {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if screenSize.height == 667 {
            return true
        } else {
            return false
        }
    }
    
    class func isIphone6Plus() -> Bool {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        if screenSize.height == 736 {
            return true
        } else {
            return false
        }
    }

}

