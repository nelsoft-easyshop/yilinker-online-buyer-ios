//
//  Delay.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 10/27/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class Delay: NSObject {
    class func delayWithDuration(duration: Double, completionHandler: (success: Bool) -> Void) {
        let delay = duration * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            completionHandler(success: true)
        }
    }
}
