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
    
    func isAphaOnly() -> Bool {
        let passwordRegEx = "[A-Za-z]*"
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        
        return passwordTest.evaluateWithObject(self.text)
    }
    
    func isNumericOnly() -> Bool {
        let passwordRegEx = "[0-9]*"
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
    
    func required() {
        self.text = "\(self.text!)*"
        var myMutableString = NSMutableAttributedString(string: self.text!)
        let stringCount: Int = count(self.text!)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: stringCount - 1,length:1))
        self.attributedText = myMutableString
    }
}

extension UITextView {
    func required() {
        self.text = "\(self.text!)*"
        var myMutableString = NSMutableAttributedString(string: self.text!)
        let stringCount: Int = count(self.text!)
        myMutableString.addAttribute(NSForegroundColorAttributeName, value: UIColor.redColor(), range: NSRange(location: stringCount - 1,length:1))
        self.attributedText = myMutableString
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
        
        let cancelAction = UIAlertAction(title: RegisterModalStrings.yes, style: .Cancel) { (action) in
            actionHandler(isYes: true)
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: RegisterModalStrings.no, style: .Default) { (action) in
             actionHandler(isYes: false)
        }
        alertController.addAction(OKAction)
        
        viewController.presentViewController(alertController, animated: true) {
            // ...
        }
    }
    
    class func showAlertTwoButtonsWithTitle(title: String, message: String, positiveString: String, negativeString: String, viewController: UIViewController, actionHandler: (isYes: Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: negativeString, style: .Cancel) { (action) in
            actionHandler(isYes: false)
        }
        
        alertController.addAction(cancelAction)
        
        let OKAction = UIAlertAction(title: positiveString, style: .Default) { (action) in
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
    
    func subractDate(endDate : NSDate) -> Int {
        let calendar = NSCalendar.currentCalendar()
        let flags = NSCalendarUnit.CalendarUnitDay
        let components = calendar.components(flags, fromDate: self, toDate: endDate, options: nil)
        return components.day
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
    
    func localized(lang:String) ->String {
        
        let path = NSBundle.mainBundle().pathForResource(lang, ofType: "lproj")
        let bundle = NSBundle(path: path!)
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
    
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
        let nameRegex = "^[a-zA-Z0-9-_., ]*$"
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
        var tempString: String = self.stringByReplacingOccurrencesOfString(",", withString: "")
        
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        stringNumber = "\(formatter.stringFromNumber((tempString as NSString).doubleValue)!)"

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

        stringNumber = self.stringByReplacingOccurrencesOfString(",", withString: "")
        
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
        let off: String = StringHelper.localizedStringWithKey("OFF_LOCALIZE_KEY")
        if self.toDouble() != nil {
            let stringNum: String = "\(round(self.toDouble()!))% \(off)"
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
    
    func formatToTwoDecimalNoTrailling() -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return "\(formatter.stringFromNumber((self as NSString).doubleValue)!)"
    }
    
    func formatToNoTrailling() -> String {
        let formatter = NSNumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return "\(formatter.stringFromNumber((self as NSString).doubleValue)!)"
    }
    
    func printableAscii() -> String {
        return String(bytes: filter(self.utf8){$0 >= 32}, encoding: NSUTF8StringEncoding) ?? ""
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

extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController where top.view.window != nil {
                return topViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}

extension UIDevice {
    public var deviceCode: String {
        var sysInfo: [CChar] = Array(count: sizeof(utsname), repeatedValue: 0)
        
        let code = sysInfo.withUnsafeMutableBufferPointer {
            (inout ptr: UnsafeMutableBufferPointer<CChar>) -> String in
            uname(UnsafeMutablePointer<utsname>(ptr.baseAddress))
            let machinePtr = ptr.baseAddress.advancedBy(Int(_SYS_NAMELEN * 4))
            return String.fromCString(machinePtr)!
        }
        
        return code
    }
    
    public var deviceModel: String {
        
        var model : String
        let deviceCode = UIDevice().deviceCode
        switch deviceCode {
            
        case "iPod1,1":                                 model = "iPod Touch 1G"
        case "iPod2,1":                                 model = "iPod Touch 2G"
        case "iPod3,1":                                 model = "iPod Touch 3G"
        case "iPod4,1":                                 model = "iPod Touch 4G"
        case "iPod5,1":                                 model = "iPod Touch 5G"
            
        case "iPhone1,1":                               model = "iPhone 2G"
        case "iPhone1,2":                               model = "iPhone 3G"
        case "iPhone2,1":                               model = "iPhone 3GS"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     model = "iPhone 4"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     model = "iPhone 4"
        case "iPhone4,1":                               model = "iPhone 4S"
        case "iPhone5,1", "iPhone5,2":                  model = "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  model = "iPhone 5C"
        case "iPhone6,1", "iPhone6,2":                  model = "iPhone 5S"
        case "iPhone7,2":                               model = "iPhone 6"
        case "iPhone7,1":                               model = "iPhone 6 Plus"
        case "iPhone8,1":                               model = "iPhone 6S"
        case "iPhone8,2":                               model = "iPhone 6S Plus"
            
            
        case "iPad1,1":                                 model = "iPad 1"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":model = "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           model = "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           model = "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           model = "iPad Air"
        case "iPad5,1", "iPad5,3", "iPad5,4":           model = "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           model = "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           model = "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           model = "iPad Mini 3"
            
        case "i386", "x86_64":                          model = "Simulator"
        default:                                        model = deviceCode //If unkhnown
        }
        
        return model
    }
}