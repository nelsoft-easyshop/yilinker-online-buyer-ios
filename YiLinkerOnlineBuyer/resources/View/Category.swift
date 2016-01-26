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
    
    func addToolBarWithTarget(target: AnyObject, done: Selector) {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.barStyle = UIBarStyle.Black
        toolBar.barTintColor = Constants.Colors.appTheme
        toolBar.tintColor = UIColor.whiteColor()
        
        let doneItem = UIBarButtonItem(title: Constants.Localized.done, style: UIBarButtonItemStyle.Done, target: target, action: done)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        
        
        var toolbarButtons = [flexibleSpace, doneItem]
        
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
    
    func boldFont() {
        let currentFont: UIFont = self.font
        self.font = UIFont.boldSystemFontOfSize(currentFont.pointSize)
        
    }
    
    func unboldFont() {
        let currentFont: UIFont = self.font
        self.font = UIFont.systemFontOfSize(currentFont.pointSize)
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

extension UIImageView {
    func fadeInImageWithImage(image: UIImage) {
        self.alpha = 0
        UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.alpha = 1
            }, completion: nil)
    }
}

extension UIImage {
    func normalizedImage() -> UIImage {
        
        if (self.imageOrientation == UIImageOrientation.Up) {
            return self
        }
        
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale);
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)
        self.drawInRect(rect)
        
        var normalizedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
    
    func resize(scale:CGFloat)-> UIImage {
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: size.width*scale, height: size.height*scale)))
        imageView.contentMode = UIViewContentMode.ScaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
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
    
    class func displayAlertRedirectionToLogin(target: AnyObject, actionHandler: (sucess: Bool) -> Void) {
        let alertController: UIAlertController = UIAlertController(title: Constants.Localized.error, message: "Cannot verify your account please login.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let login: UIAlertAction = UIAlertAction(title: "Login", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in
            actionHandler(sucess: true)
        })
        
        alertController.addAction(login)
        target.presentViewController(alertController, animated: true, completion: nil)
    }
    
    class func showAlertYesOrNoWithTitle(title: String, message: String, viewController: UIViewController, actionHandler: (isYes: Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: RegisterModalStrings.no, style: .Cancel) { (action) in
            actionHandler(isYes: false)
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: RegisterModalStrings.yes, style: .Default) { (action) in
             actionHandler(isYes: true)
        }
        alertController.addAction(OKAction)
        
        viewController.presentViewController(alertController, animated: true) {
            // ...
        }
    }
}


extension UIView {
    class func loadFromNibNamed(nibNamed: String, bundle: NSBundle? = nil) -> UIView? {
        return UINib(
            nibName: nibNamed,
            bundle: bundle
            ).instantiateWithOwner(nil, options: nil)[0] as? UIView
    }
    
    func blurView() {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = CGRectMake(0, 0, screenSize.width + 50, screenSize.height + 50)
        self.addSubview(blurEffectView)
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
    
//    func differenceInMinutesWithCurrentDate() -> Double {
//        return (self.timeIntervalSinceNow / 60)
//    }
    
    func differenceInMinutesWithCurrentDate() -> Double {
        return ((NSDate().timeIntervalSinceDate(self)) / 60)
    }
    
    func formatDateToString(desiredFormat: String) -> String {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = desiredFormat
        return dateFormatter.stringFromDate(self)
    }
}

extension Double {
    func formatToNoDecimal() -> String {
        var stringNumber: String = ""
        
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        stringNumber = formatter.stringFromNumber(self)!
        
        return stringNumber
    }

}

extension String {
    
    func toDouble() -> Double? {
        return NSNumberFormatter().numberFromString(self)?.doubleValue
    }
    
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
        var stringNumber: String = ""
        
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        stringNumber = "\(formatter.stringFromNumber((self as NSString).doubleValue)!)"

        if self.rangeOfString("₱") != nil{
            return stringNumber
        } else {
            return "₱ \(stringNumber)"
        }
    }
    
    func addPesoSign() -> String {
        return "₱ \(self)"
    }
    
    func formatToPeso() -> String {
        var numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        var stringNumber: String = ""

        stringNumber = self
        
        if self.rangeOfString(",") != nil {
            if numberFormatter.stringFromNumber(0) != "0" {
                stringNumber = numberFormatter.stringFromNumber(0)!
            }
        }
        
        if self.rangeOfString("₱") != nil {
            return stringNumber
        } else {
            return "₱ \(stringNumber)"
        }
    }
    
    func stringCharacterAtIndex(index: Int) -> String {
       return "\(Array(self)[index])"
    }
    
    func formatToPercentage() -> String {
        if self.toDouble() != nil {
            let stringNum: String = "\(round(self.toDouble()!))% OFF"
            return stringNum.stringByReplacingOccurrencesOfString(".0", withString: "")
        } else {
            return ""
        }
        
    }
    
    func indexOfCharacter(char: Character) -> Int {
        if let idx = find(self, char) {
            return distance(self.startIndex, idx)
        }
        return -1
    }
    
    func formatStringToDate(format: String) -> NSDate {
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.dateFromString(self)!
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