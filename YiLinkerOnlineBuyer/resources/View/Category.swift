//
//  Category.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

extension UITextField {
    func addToolBarWithTarget(target: AnyObject, next: Selector, previous: Selector, done: Selector) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.Black
        toolBar.barTintColor = Constants.Colors.appTheme
        toolBar.tintColor = UIColor.whiteColor()
        
        let doneItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: target, action: done)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        let previousItem = UIBarButtonItem(image: UIImage(named: "previous"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: target, action: previous)
        
        let nextItem = UIBarButtonItem(image: UIImage(named: "next"), landscapeImagePhone: nil, style: UIBarButtonItemStyle.Plain, target: target, action: next)
        
        var toolbarButtons = [previousItem, nextItem,flexibleSpace, doneItem]
        
        //Put the buttons into the ToolBar and display the tool bar
        toolBar.setItems(toolbarButtons, animated: false)
        
        self.inputAccessoryView = toolBar

    }
    
    func isValidEmail() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self.text)
    }
    
    func isAlphaNumeric() -> Bool {
        let passwordRegEx = "[A-Za-z0-9_]*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    
        return passwordTest.evaluateWithObject(self.text)
    }
    
    func isGreaterThanEightCharacters() -> Bool {
        var result: Bool = false
        if count(self.text) >= 8 {
            result = true
        }
        
        return result
    }
    
    func isNotEmpty() -> Bool {
        var result: Bool = false
        if count(self.text) != 0 {
            result = true
        }
        return result
    }
    
    func isGreaterThanOrEqualEightCharacters() -> Bool {
        var result: Bool = true
        if count(self.text) < 11 {
            result = false
        }
        return true
    }

    
    
}


extension UIAlertController {
    
    class func displayErrorMessageWithTarget(target: AnyObject, errorMessage: String) {
        let alert = UIAlertController(title: "Ooops", message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func displayErrorMessageWithTarget(target: AnyObject, errorMessage: String, title: String) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func displayNoInternetConnectionError(target: AnyObject) {
        let alert = UIAlertController(title: "No Internet Connection", message: "Please check your internet connection.", preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
}