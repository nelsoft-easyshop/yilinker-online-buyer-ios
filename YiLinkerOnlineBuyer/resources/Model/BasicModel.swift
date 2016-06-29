//
//  BasicModel.swift
//  
//
//  Created by Alvin John Garcia Tandoc on 20/04/2016.
//
//

import UIKit

class BasicModel: NSObject {
    var isSuccessful: Bool = false
    var dataAnyObject: AnyObject = ""
    
    init(isSuccessful: Bool, dataAnyObject: AnyObject) {
        self.isSuccessful = isSuccessful
        self.dataAnyObject = dataAnyObject
    }
    
    class func parseDataFromResponseObjec(responseObject: AnyObject) -> BasicModel {
        var isSuccessful: Bool = false
        var dataAnyObject: AnyObject = ""
        
        let dictionary: NSDictionary = responseObject as! NSDictionary
        
        isSuccessful = ParseHelper.bool(dictionary, key: "isSuccessful", defaultValue: false)

        if let temp = dictionary["data"] as? NSDictionary {
            dataAnyObject = temp
        }
        
        if let temp = dictionary["data"] as? [NSDictionary] {
            dataAnyObject = temp
        }
        
        return BasicModel(isSuccessful: isSuccessful, dataAnyObject: dataAnyObject)
    }
}
