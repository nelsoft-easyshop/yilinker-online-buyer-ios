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
        
        let doneItem = UIBarButtonItem(title: Constants.Localized.done, style: UIBarButtonItemStyle.Done, target: target, action: done)
        
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
    
    func isValidPassword() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^(?=.*\\d)(?=.*[a-zA-Z])[^ ]{0,}$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self.text)
    }
    
    func isAlphaNumeric() -> Bool {
        let passwordRegEx = "[A-Za-z0-9_]*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
    
        return passwordTest.evaluateWithObject(self.text)
    }
    
    func isValidName() -> Bool {
        let nameRegex = "^[a-zA-Z ]*$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        return nameTest.evaluateWithObject(self.text)
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

extension UILabel {
    func required() {
        self.text = "\(self.text!)*"
        var myMutableString = NSMutableAttributedString(string: self.text!)
        let stringCount: Int = count(self.text!)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: stringCount - 1,length:1))
        self.attributedText = myMutableString
    }
}

extension UITextView {
    
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
}


extension UIAlertController {
    
    class func displayErrorMessageWithTarget(target: AnyObject, errorMessage: String) {
        let alert = UIAlertController(title: Constants.Localized.error, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func displayErrorMessageWithTarget(target: AnyObject, errorMessage: String, title: String) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func displayNoInternetConnectionError(target: AnyObject) {
        let alert = UIAlertController(title: Constants.Localized.noInternet, message: Constants.Localized.noInternetErrorMessage, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func displaySomethingWentWrongError(target: AnyObject) {
        let alert = UIAlertController(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong, preferredStyle: UIAlertControllerStyle.Alert)
        let OKAction = UIAlertAction(title: Constants.Localized.ok, style: .Default) { (action) in }
        alert.addAction(OKAction)
        target.presentViewController(alert, animated: true, completion: nil)
    }
}


extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle: NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
}


extension CAGradientLayer {
    func gradient() -> CAGradientLayer {
        let topColor = UIColor.clearColor()
        let bottomColor = UIColor.blackColor()
        
        let gradientColors: [CGColor] = [topColor.CGColor, bottomColor.CGColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        return gradientLayer
    }
}

extension NSDate {
    func isGreaterThanDate(dateToCompare : NSDate) -> Bool {
        var isGreater = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedDescending {
            isGreater = true
        }
        
        return isGreater
    }
    
    
    func isLessThanDate(dateToCompare : NSDate) -> Bool {
        var isLess = false
        if self.compare(dateToCompare) == NSComparisonResult.OrderedAscending {
            isLess = true
        }
        return isLess
    }
    
    
    
    func addDays(daysToAdd : Int) -> NSDate {
        var secondsInDays : NSTimeInterval = Double(daysToAdd) * 60 * 60 * 24
        var dateWithDaysAdded : NSDate = self.dateByAddingTimeInterval(secondsInDays)
        return dateWithDaysAdded
    }
    
    func addHours(hoursToAdd : Int) -> NSDate {
        var secondsInHours : NSTimeInterval = Double(hoursToAdd) * 60 * 60
        var dateWithHoursAdded : NSDate = self.dateByAddingTimeInterval(secondsInHours)
        return dateWithHoursAdded
    }
}

extension String {
   
    func isValidEmail() -> Bool {
        // println("validate calendar: \(testStr)")
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluateWithObject(self)
    }
    
    func isAlphaNumeric() -> Bool {
        let passwordRegEx = "[A-Za-z0-9_]*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluateWithObject(self)
    }
    
    func isValidName() -> Bool {
        let nameRegex = "^[a-zA-Z ]*$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", nameRegex)
        
        return nameTest.evaluateWithObject(self)
    }
    
    func isGreaterThanEightCharacters() -> Bool {
        var result: Bool = false
        if count(self) >= 8 {
            result = true
        }
        
        return result
    }
    
    func isNotEmpty() -> Bool {
        var result: Bool = false
        if count(self) != 0 {
            result = true
        }
        return result
    }
    
    func isGreaterThanOrEqualEightCharacters() -> Bool {
        var result: Bool = true
        if count(self) < 11 {
            result = false
        }
        return true
    }
    
    func contains(find: String) -> Bool {
        return self.rangeOfString(find) != nil
    }
    
    func formatToTwoDecimal() -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = .CurrencyStyle
        return "\(formatter.stringFromNumber((self as NSString).doubleValue)!)"
    }
    
    func formatToPeso() -> String {
        return "₱\(self)"
    }
}

extension NSURL {
    func getKeyVals() -> Dictionary<String, String>? {
        var results = [String:String]()
        var keyValues = self.query?.componentsSeparatedByString("&")
        if keyValues?.count > 0 {
            for pair in keyValues! {
                let kv = pair.componentsSeparatedByString("=")
                if kv.count > 1 {
                    results.updateValue(kv[1], forKey: kv[0])
                }
            }
            
        }

        return results
    }
    
    class func convertFromStringLiteral(value: String) -> Self {
        return self(string: value)!
    }
    
    class func convertFromExtendedGraphemeClusterLiteral(value: String) -> Self {
        return self(string: value)!
    }
    
}