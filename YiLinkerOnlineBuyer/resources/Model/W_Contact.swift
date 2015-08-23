//
//  W_Contact.swift
//  Messaging
//
//  Created by Dennis Nora on 8/15/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class W_Contact: NSObject {

    var full_name  : String
    var user_id   : NSNumber
    var profile_image_url: String
    
    init(full_name : String, user_id : NSNumber, profile_image_url : String){
        self.full_name = full_name
        self.user_id = user_id
        self.profile_image_url = profile_image_url
    }
    
    override init(){
        self.full_name = ""
        self.user_id = 0
        self.profile_image_url = ""
    }
    
    func testData() -> Array<W_Contact>{
        return [
            W_Contact(full_name : "Jan Dennis Nora", user_id : 1, profile_image_url: "http://someurl/api/method"),
            W_Contact(full_name : "Janine Anne Go", user_id : 2, profile_image_url: "http://someurl/api/method"),
            W_Contact(full_name : "Aimarie Collao", user_id : 3, profile_image_url: "http://someurl/api/method")
        ]
    }
    
}
