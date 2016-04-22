//
//  CountryModel.swift
//  
//
//  Created by Alvin John Garcia Tandoc on 20/04/2016.
//
//

import UIKit

class CountryModel: NSObject {
   
    var countryID: Int = 0
    var name: String = ""
    var code: String = ""
    var domain: String = ""
    var areaCode: String = ""
    var isActive: Bool = false
    var flag: String = ""
    
    init(countryID: Int, name: String, code: String, domain: String, areaCode: String, isActive: Bool, flag: String) {
        self.countryID = countryID
        self.name = name
        self.code = code
        self.domain = domain
        self.areaCode = areaCode
        self.isActive = isActive
        self.flag = flag
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> CountryModel {
        
        var countryID: Int = 0
        var name: String = ""
        var code: String = ""
        var domain: String = ""
        var areaCode: String = ""
        var isActive: Bool = false
        var flag: String = ""
        
        countryID = ParseHelper.int(dictionary, key: "countryId", defaultValue: 0)
        name = ParseHelper.string(dictionary, key: "name", defaultValue: "")
        code = ParseHelper.string(dictionary, key: "code", defaultValue: "")
        domain = ParseHelper.string(dictionary, key: "domain", defaultValue: "")
        areaCode = ParseHelper.string(dictionary, key: "area_code", defaultValue: "")
        flag = ParseHelper.string(dictionary, key: "flag", defaultValue: "")
        isActive = ParseHelper.bool(dictionary, key: "isActive", defaultValue: false)
        
        return CountryModel(countryID: countryID, name: name, code: code, domain: domain, areaCode: areaCode, isActive: isActive, flag: flag)
    }
}
