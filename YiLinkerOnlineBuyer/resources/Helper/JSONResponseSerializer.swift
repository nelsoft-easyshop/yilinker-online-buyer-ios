//
//  JSONResponseSerializer.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/31/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

//
//  JSONResponseSerializer.swift
//  YiLinkerOnlineSeller
//
//  Created by Alvin John Tandoc on 8/28/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class JSONResponseSerializer: AFJSONResponseSerializer {
    override func responseObjectForResponse(response: NSURLResponse?, data: NSData?, error: NSErrorPointer) -> AnyObject? {

        var json: NSMutableDictionary = NSMutableDictionary()
        
        if let val =  super.responseObjectForResponse(response, data: data, error: error) as? NSMutableDictionary {
            json = val
        }
        
        if (error.memory != nil) {
            var errorValue = error.memory!
            var userInfo: NSDictionary = errorValue.userInfo!
            var copy: NSMutableDictionary = userInfo.mutableCopy() as! NSMutableDictionary
            copy["data"] = json
            
            error.memory = NSError(domain: errorValue.domain, code: errorValue.code, userInfo: json as [NSObject : AnyObject])
            
        }
        
        return json
    }
}
