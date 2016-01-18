//
//  PaymentWebViewViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol PaymentWebViewViewControllerDelegate {
    func paymentWebViewController(paymentDidNotSucceed paymentWebViewController: PaymentWebViewViewController)
    func paymentWebViewController(paymentDidCancel paymentWebViewController: PaymentWebViewViewController)
}


class PaymentWebViewViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var counter: Int = 0
    var pesoPayModel: PesoPayModel!
    var delegate: PaymentWebViewViewControllerDelegate?
    var hud: MBProgressHUD?
    
    //MARK: -
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.showHUD()
        self.backButton()
        let request = NSURLRequest(URL: self.pesoPayModel.paymentUrl)
        self.webView.loadRequest(request)
        self.webView.delegate = self
        self.webView.scalesPageToFit = true

        self.title = "Credit Card"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: -
    //MARK: - Back Button
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    //MARK: -
    //MARK: - Show HUD
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    //MARK: -
    //MARK: - Back
    func back() {
        self.delegate!.paymentWebViewController(paymentDidCancel: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: -
    //MARK: - Done
    func done(referenceNumber: String) {
        var checkoutNavigation: UINavigationController = self.presentingViewController as! UINavigationController
        let checkoutContainerViewController: CheckoutContainerViewController = checkoutNavigation.viewControllers[0] as! CheckoutContainerViewController
        checkoutContainerViewController.fireOverView(referenceNumber, modalViewController: self)
    }
    
    //MARK: -
    //MARK: - Webview Delegate
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var isContinue: Bool = true
        var url: NSURL = request.mainDocumentURL!
        println(counter)
        if counter != 0 {
            println("cancel url: \(self.pesoPayModel.cancelUrl)")
            if "\(url)".contains("checkout/overview?Ref=") && "\(url)" != "\(self.pesoPayModel.paymentUrl)" {
                var stringUrl: String = "\(url)"
                let array: [String] = stringUrl.componentsSeparatedByString("Ref=")
                
                let referenceNumber: String = array[1]
                self.done(referenceNumber)
                isContinue = false
            } else if "\(url)".contains("\(pesoPayModel.cancelUrl)") && "\(url)" != "\(self.pesoPayModel.cancelUrl)" {
                counter = 0
                self.dismissViewControllerAnimated(true, completion: nil)
                isContinue = false
            } else if url == self.pesoPayModel.failUrl {
                counter = 0
                self.dismissViewControllerAnimated(true, completion: nil)
                isContinue = false
            } else {
                self.showHUD()
            }
        } else {
            counter++
        }
        
        return isContinue
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.hud?.hide(true)
    }
}
