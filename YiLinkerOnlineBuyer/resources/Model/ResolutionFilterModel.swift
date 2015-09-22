//
//  ResolutionFilterModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 9/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ResolutionFilterModel: NSObject {
   
    var title: String = ""
    var resolutionFilter: [ResolutionFilter2Model] = []
    
    init(title: String, resolutionFilter: [ResolutionFilter2Model]) {
        self.title = title
        self.resolutionFilter = resolutionFilter
    }
    
}
