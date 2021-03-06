//
//  HomePageModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/27/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HomePageModel: NSObject {
    var message: String = ""
    var isSuccessful: Bool = false
    var data: [AnyObject] = []
    
    override init() {
        
    }
    
    init(message: String, isSuccessful: Bool, data: [AnyObject]) {
        self.message = message
        self.isSuccessful = isSuccessful
        self.data = data
    }
    
    class func parseDataFromDictionary(dictionary: NSDictionary) -> HomePageModel {
        var message: String = ""
        var isSuccessful: Bool = false
        var data: [AnyObject] = []
        println(dictionary)
        var arrays: [NSDictionary] = []
        arrays = dictionary["data"] as! [NSDictionary]

        for sectionDictionary in arrays {
            let layoutId: Int = sectionDictionary["layoutId"] as! Int

            if layoutId == 1 {
                data.append(LayoutOneModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 2 {
                data.append(LayoutTwoModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 3 {
                data.append(LayoutThreeModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 4 {
                data.append(LayoutFourModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 5 {
                data.append(LayoutFiveModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 6 {
                data.append(LayoutSixModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 7 {
                data.append(LayoutSevenModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 8 {
                data.append(LayoutEightModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 9 {
                data.append(LayoutNineModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 10 {
                data.append(LayoutTenModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 11 {
                data.append(LayoutElevenModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 12 {

                var first = LayoutTwelveModel.parseDataFromDictionary(sectionDictionary)
                if let temps = sectionDictionary["data"] as? [NSDictionary] {
                    if temps.count != 0 {
                        var second = LayoutTwelveModel.parseDataFromDictionary(temps[0])
                        second.layoutId = first.layoutId
                        second.sectionTitle = first.sectionTitle
                        second.isViewMoreAvailable = first.isViewMoreAvailable
                        second.viewMoreTarget = first.viewMoreTarget
                        data.append(second)
                    }
                
                    if temps.count > 1 {
                        data.append(LayoutThirteenModel.parseDataFromDictionary(temps[1]))
                    }
                }
            } else if layoutId == 13 {
//                data.append(LayoutThirteenModel.parseDataFromDictionary(sectionDictionary))
            } else if layoutId == 14 {
                data.append(LayoutFourteenModel.parseDataFromDictionary(sectionDictionary))
            }
        }
        
        if let temp = dictionary["message"] as? String {
            message = temp
        }
        
        if let temp = dictionary["isSuccessful"] as? Bool {
            isSuccessful = temp
        }
        
        return HomePageModel(message: message, isSuccessful: isSuccessful, data: data)
    }
}
