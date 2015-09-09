//
//  ResolutionCenterModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by @EasyShop.ph on 9/8/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

typealias ResolutionCenterData = (resolutionId: String, status: String, date: String, type: String, complainantRemarks: String, csrRemarks: String)

class ResolutionCenterModel {
    let resolutionData: ResolutionCenterData
    
    init(resolutionData: ResolutionCenterData) {
        self.resolutionData = resolutionData
    }
    
    class func parseDataWithDictionary(dictionary: AnyObject) -> ResolutionCenterModel {
        return ResolutionCenterModel(resolutionData:("1234","Open","13/14/15","Seller","Something wrong happened","Yup it was very wrong!!!"))
    }
}