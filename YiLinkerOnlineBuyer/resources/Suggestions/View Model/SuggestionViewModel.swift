//
//  SuggestionViewModel.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 3/17/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import Foundation

public class SuggestionViewModel {
    
    public var title: String = ""
    public var description: String = ""
    public var phoneModel: String = ""
    public var osVersion: String = ""
    public var osName: String = ""
    
    let notificationCenter = NSNotificationCenter.defaultCenter()
    var errorNotification: NSNotification?
    var statusNotification: NSNotification?
    var saveFeedbackNotification: NSNotification?
   
    public init() {
        self.phoneModel = UIDevice().deviceModel
        self.osVersion = UIDevice.currentDevice().systemVersion
        self.osName = "iOS"
        
    }
    
    //MARK: - Validations
    func validateTitle() -> Bool {
        return self.title.isNotEmpty() ? true : false
    }
    
    func validateDescription() -> Bool {
        return self.description.isNotEmpty() ? true : false
    }
    
    //MARK: - Save Button Handler
    func handleSavePressed() {
        if !self.validateTitle() {
            self.errorNotification = NSNotification(name: SuggestionNotifications.validationErrorNotification, object: SuggestionStrings.titleRequiredError)
            notificationCenter.postNotification(self.errorNotification!)
        } else if !self.validateDescription() {
            self.errorNotification = NSNotification(name: SuggestionNotifications.validationErrorNotification, object: SuggestionStrings.descriptionRequiredError)
            notificationCenter.postNotification(self.errorNotification!)
        } else {
            self.fireSaveFeedback()
        }
    }
    
    //MARK: -
    //MARK: - API Requests
    
    //MARK: - Save Feedback
    func fireSaveFeedback() {
        statusNotification = NSNotification(name: SuggestionNotifications.statusChangedNotification, object: true)
        notificationCenter.postNotification(statusNotification!)
        
        WebServiceManager.fireSaveFeedBackWithUrl(APIAtlas.mobileFeedBack(), title: self.title, description: self.description, phoneModel: self.phoneModel, osVersion: self.osVersion, osName: self.osName, access_token: SessionManager
            .accessToken()) { (successful, responseObject, requestErrorType) -> Void in
            
            self.statusNotification = NSNotification(name: SuggestionNotifications.statusChangedNotification, object: false)
            self.notificationCenter.postNotification(self.statusNotification!)
            println(responseObject)
            if successful {
                self.saveFeedbackNotification = NSNotification(name: SuggestionNotifications.saveFeedbackNotification, object: responseObject)
                println(responseObject)
                self.notificationCenter.postNotification(self.saveFeedbackNotification!)
            } else {
                
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    self.errorNotification = NSNotification(name: SuggestionNotifications.validationErrorNotification, object: errorModel.message)
                    self.notificationCenter.postNotification(self.errorNotification!)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
                } else {
                    if requestErrorType == .PageNotFound {
                        //Page not found
                        self.errorNotification = NSNotification(name: SuggestionNotifications.validationErrorNotification, object: Constants.Localized.pageNotFound)
                    } else if requestErrorType == .NoInternetConnection {
                        //No internet connection
                        self.errorNotification = NSNotification(name: SuggestionNotifications.validationErrorNotification, object: Constants.Localized.noInternetErrorMessage)
                    } else if requestErrorType == .RequestTimeOut {
                        //Request timeout
                        self.errorNotification = NSNotification(name: SuggestionNotifications.validationErrorNotification, object: Constants.Localized.noInternetErrorMessage)
                    } else if requestErrorType == .UnRecognizeError {
                        //Unhandled error
                        self.errorNotification = NSNotification(name: SuggestionNotifications.validationErrorNotification, object: Constants.Localized.error)
                    }
                    
                    self.notificationCenter.postNotification(self.errorNotification!)
                }
            }
        }
    }
    
    //MARK: - Fire Refresh Token
    func fireRefreshToken() {
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireSaveFeedback()
            } else {
                let accessTokenErrorNotification = NSNotification(name: SuggestionNotifications.refreshTokenErrorNotification, object: nil)
                self.notificationCenter.postNotification(accessTokenErrorNotification)
            }
        })
    }
    
}
