//
//  DeliveryLogsSectionModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 10/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class DeliveryLogsSectionModel: NSObject {
    var date: String = ""
    var deliveryLogs: [DeliveryLogsItemModel] = []
    
    init(date: String, deliveryLogs: [DeliveryLogsItemModel]) {
        self.date = date
        self.deliveryLogs = deliveryLogs
    }
}
