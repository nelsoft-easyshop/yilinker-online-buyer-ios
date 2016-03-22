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
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    var appVersion: String  = ""
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var logoHeightConstraint: NSLayoutConstraint!
    
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
        
        self.versionLabel.text = "v \(self.appVersion)"
        self.emailTextButton.titleLabel?.text = StringHelper.localizedStringWithKey("HELP_EMAIL")
        self.callTextButton.titleLabel?.text = StringHelper.localizedStringWithKey("HELP_CALL")
        self.titleLabel.text = StringHelper.localizedStringWithKey("HELP_FOR_CUSTOMER_SERVICE")
        self.sendFeedbackButton.setTitle(StringHelper.localizedStringWithKey("HELP_SEND_FEEDBACK"), forState: .Normal)
        
        self.sendFeedbackButton.layer.cornerRadius = 5
        
        if IphoneType.isIphone4() {
            self.logoHeightConstraint.constant = 110
        } else if IphoneType.isIphone5() {
            self.logoHeightConstraint.constant = 160
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
    
    @IBAction func buttonAction(sender: AnyObject) {
        var url: String = ""
        if sender as! UIButton == emailTextButton || sender as! UIButton == emailIconButton {
            url = "mailto:support@yilinker.ph"
        } else if sender as! UIButton == callTextButton || sender as! UIButton == callIconButton {
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
    
}
