//
//  HelpWhatsNewViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/5/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class HelpWhatsNewViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var whatsNewTitleLabel: UILabel!
    @IBOutlet weak var whatsNewLabel: UILabel!
    
    var hud: YiHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Intialize
        //Avoid overlapping of tab bar and navigation bar to the mainview
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        self.whatsNewTitleLabel.text = StringHelper.localizedStringWithKey("HELP_WHATS_NEW")
        self.title = StringHelper.localizedStringWithKey("HELP_WHATS_NEW")
        self.addBackButton()
        
        self.fireGetAppDetails()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Add cutomize back button to the navigation bar
    func addBackButton() {
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
    
    // MARK: - Loader function
    func showLoader() {
        self.hud = YiHUD.initHud()
        self.hud?.showHUDToView(self.view)
    }
    
    func dismissLoader() {
        self.hud?.hide()
    }
    
    func fireGetAppDetails() {
        self.showLoader()
        WebServiceManager.fireLookupAppDetailsWithUrl(APIAtlas.appLookupUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            println(responseObject)
            
            if successful {
                let appDetails = AppDetailsModel.parseDataWithDictionary(responseObject as! NSDictionary)
                self.whatsNewLabel.text = appDetails.releaseNotes
            }
            
            self.dismissLoader()
        })
    }
    
}
