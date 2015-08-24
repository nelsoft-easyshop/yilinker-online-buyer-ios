//
//  PaymentWebViewViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol PaymentWebViewViewControllerDelegate {
    func paymentWebViewController(paymentDidSucceed paymentWebViewController: PaymentWebViewViewController)
    func paymentWebViewController(paymentDidNotSucceed paymentWebViewController: PaymentWebViewViewController)
    func paymentWebViewController(paymentDidCancel paymentWebViewController: PaymentWebViewViewController)
}


class PaymentWebViewViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var url: NSURL = NSURL(string: "")!
    var delegate: PaymentWebViewViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton()
        let request = NSURLRequest(URL: url)
        self.webView.loadRequest(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10
        
        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func back() {
        self.delegate!.paymentWebViewController(paymentDidCancel: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done() {
        self.delegate!.paymentWebViewController(paymentDidSucceed: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
