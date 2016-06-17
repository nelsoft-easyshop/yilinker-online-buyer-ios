//
//  XibHelper.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 7/31/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct XibHelper {
    static func puffViewWithNibName(nibName: String!, index: Int) -> UIView {
        var views: NSArray = NSBundle.mainBundle().loadNibNamed(nibName, owner: nil, options: nil)
        return views.objectAtIndex(index) as! UIView
    }
}