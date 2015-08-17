//
//  ProfileModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/15/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProfileModel: NSObject {
    var imageURL: NSURL?
    var lastName: String = ""
    var firstName: String = ""
    var mobileNumber: String = ""
    var addressFirst: String = ""
    var addressSecond: String = ""
    var emailAddress: String = ""
    
    init(imageURL: NSURL, lastName: String, firstName: String, mobileNumber: String, addressFirst: String, addressSecond: String = "", emailAddress: String = "") {
        self.imageURL = imageURL
        self.lastName = lastName
        self.firstName = firstName
        self.mobileNumber = mobileNumber
        self.addressFirst = addressFirst
        self.addressSecond = addressSecond
        self.emailAddress = emailAddress
    }
   
}
