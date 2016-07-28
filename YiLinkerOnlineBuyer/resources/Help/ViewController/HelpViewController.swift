//
//  HelpViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HelpViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var callLabel: UILabel!
    @IBOutlet weak var emailTextButton: UIButton!
    @IBOutlet weak var callTextButton: UIButton!
    @IBOutlet weak var emailIconButton: UIButton!
    @IBOutlet weak var callIconButton: UIButton!
    @IBOutlet weak var sendFeedbackButton: UIButton!
    @IBOutlet weak var checkUpdatesButton: UIButton!
    @IBOutlet weak var whatsNewButton: UIButton!
    
    @IBOutlet weak var callTextButton2: UIButton!
    @IBOutlet weak var callTextButton3: UIButton!
    @IBOutlet weak var callIconButton2: UIButton!
    @IBOutlet weak var callIconButton3: UIButton!

    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    var appVersion: String  = ""
    var itunesAppVersion: String  = ""
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    
    var hud: YiHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.appVersion = (NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String)
        
        self.initializeViews()
        self.initializeNavigationBar()
    }
    
    func initializeViews() {
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = .None
        }
        
        self.setVersion(self.appVersion)
        self.emailTextButton.titleLabel?.text = StringHelper.localizedStringWithKey("HELP_EMAIL")
        self.callTextButton.titleLabel?.text = StringHelper.localizedStringWithKey("HELP_CALL")
        self.titleLabel.text = StringHelper.localizedStringWithKey("HELP_FOR_CUSTOMER_SERVICE")
        self.sendFeedbackButton.setTitle(StringHelper.localizedStringWithKey("HELP_SEND_FEEDBACK"), forState: .Normal)
        self.checkUpdatesButton.setTitle(StringHelper.localizedStringWithKey("HELP_CHECK_FOR_UPDATES"), forState: .Normal)
        self.whatsNewButton.setTitle(StringHelper.localizedStringWithKey("HELP_WHATS_NEW"), forState: .Normal)
        
        self.sendFeedbackButton.layer.cornerRadius = 5
        self.checkUpdatesButton.layer.cornerRadius = 5
        self.whatsNewButton.layer.cornerRadius = 5
        
        if IphoneType.isIphone4() {
            self.logoHeightConstraint.constant = 70
        } else if IphoneType.isIphone5() {
            self.logoHeightConstraint.constant = 120
        } else if IphoneType.isIphone6() {
            self.logoHeightConstraint.constant = 190
        } else if IphoneType.isIphone6Plus() {
            self.logoHeightConstraint.constant = 220
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeNavigationBar() {
        let reportTitleString = StringHelper.localizedStringWithKey("HELP_LOCALIZE_KEY")
        self.title = reportTitleString
        
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func setVersion(version: String) {
        self.versionLabel.text = "YiLinker Buyer v\(self.appVersion)"
    }
    
    // MARK: - Loader function
    func showLoader() {
        self.hud = YiHUD.initHud()
        self.hud?.showHUDToView(self.view)
    }
    
    func dismissLoader() {
        self.hud?.hide()
    }
    
    @IBAction func buttonAction(sender: AnyObject) {
        var url: String = ""
        if sender as! UIButton == emailTextButton || sender as! UIButton == emailIconButton {
            url = "mailto:support@yilinker.ph"
        } else if sender as! UIButton == callTextButton || sender as! UIButton == callIconButton {
            url = "tel://+639288694075"
        } else if sender as! UIButton == callTextButton2 || sender as! UIButton == callIconButton2 {
            url = "tel://+639183457698"
        } else if sender as! UIButton == callTextButton3 || sender as! UIButton == callIconButton3 {
            url = "tel://+639777265481"
        }
    
        UIApplication.sharedApplication().openURL(NSURL(string:url)!)
    }
    
    @IBAction func socialButtonAction(sender: AnyObject) {
        var url: String = ""
        if sender as! UIButton == facebookButton {
            url = "https://www.facebook.com/YilinkerPH"
        } else if sender as! UIButton == twitterButton {
            url = "https://twitter.com/yilinkerph"
        } else if sender as! UIButton == instagramButton {
            url = "https://instagram.com/yilinkerph/"
        }
        UIApplication.sharedApplication().openURL(NSURL(string:url)!)
    }
    
    
    @IBAction func sendFeedbackAction(sender: UIButton) {
        var suggestionsViewController = SuggestionViewController(nibName: "SuggestionViewController", bundle: nil)
        self.navigationController?.pushViewController(suggestionsViewController, animated:true)
    }
    
    @IBAction func checkForUpdatesAction(sender: UIButton) {
        self.fireGetAppDetails()
    }
    
    @IBAction func whatsNewAction(sender: UIButton) {
        var whatsNewViewController = HelpWhatsNewViewController(nibName: "HelpWhatsNewViewController", bundle: nil)
        self.navigationController?.pushViewController(whatsNewViewController, animated:true)
    }
    
    
    func fireGetAppDetails() {
        self.showLoader()
        WebServiceManager.fireLookupAppDetailsWithUrl(APIAtlas.appLookupUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            println(responseObject)
            
            if successful {
                let appDetails = AppDetailsModel.parseDataWithDictionary(responseObject as! NSDictionary)
                self.itunesAppVersion = appDetails.version
                
                if self.itunesAppVersion != self.appVersion {
                    UIAlertController.showAlertTwoButtonsWithTitle("Application Update", message: "New update available", positiveString: "Update", negativeString: "Cancel", viewController: self, actionHandler: { (isYes) -> Void in
                        if isYes {
                            UIApplication.sharedApplication().openURL(NSURL(string: APIAtlas.appItunesURL)!)
                        }
                    })
                } else {
                    Toast.displayToastWithMessage("Application is up to date.", duration: 1.5, view: self.view)
                }
            }
            
            self.dismissLoader()
        })
    }
}
