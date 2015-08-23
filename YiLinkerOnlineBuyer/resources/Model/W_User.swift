//
//  W_User.swift
//  Messaging
//
//  Created by Dennis Nora on 8/10/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class W_User: NSObject {
    
    var full_name  : NSString
    var user_id   : NSString
    var profile_image_url : NSString
    
    init(full_name : NSString, user_id : NSString, profile_image_url : NSString){
        self.full_name = full_name
        self.user_id = user_id
        self.profile_image_url = profile_image_url
    }
    
    override init(){
        self.full_name = ""
        self.user_id = ""
        self.profile_image_url = ""
    }
    
}
