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
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var twitterButton: UIButton!
    @IBOutlet weak var instagramButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeViews()
        self.initializeNavigationBar()
    }
    
    func initializeViews() {
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = .None
        }
        
        
        emailTextButton.titleLabel?.text = StringHelper.localizedStringWithKey("HELP_EMAIL")
        callTextButton.titleLabel?.text = StringHelper.localizedStringWithKey("HELP_CALL")
        titleLabel.text = StringHelper.localizedStringWithKey("HELP_FOR_CUSTOMER_SERVICE")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    
    
}
