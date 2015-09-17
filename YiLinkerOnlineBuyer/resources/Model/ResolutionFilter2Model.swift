//
//  ResolutionFilter2Model.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ResolutionFilter2Model: NSObject {
    
    var date: String = ""
    var check: Bool = false
    
    init(date: String, check: Bool){
        self.date = date
        self.check = check
    }
   
}
