//
//  Toast.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 10/27/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class Toast: NSObject {
    class func displayToastWithMessage(message: String, duration: NSTimeInterval, view: UIView) {
        view.makeToast(message, duration: duration, position: CSToastPositionTop, style: CSToastManager.sharedStyle())
    }
    
    class func displayToastWithMessage(message: String, view: UIView) {
        view.makeToast(message, duration: 1.5, position: CSToastPositionTop, style: CSToastManager.sharedStyle())
    }
}
