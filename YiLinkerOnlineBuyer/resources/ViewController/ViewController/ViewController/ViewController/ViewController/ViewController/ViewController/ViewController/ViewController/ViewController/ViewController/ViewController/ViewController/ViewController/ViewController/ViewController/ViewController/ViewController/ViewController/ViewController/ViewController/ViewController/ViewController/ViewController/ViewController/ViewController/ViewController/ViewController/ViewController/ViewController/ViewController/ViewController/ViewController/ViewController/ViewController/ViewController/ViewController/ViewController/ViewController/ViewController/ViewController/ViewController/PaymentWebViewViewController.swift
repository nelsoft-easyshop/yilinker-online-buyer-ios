//
//  PaymentWebViewViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol PaymentWebViewViewControllerDelegate {
    func paymentWebViewController(paymentDidSucceed paymentWebViewController: PaymentWebViewViewController, paymentSuccessModel: PaymentSuccessModel)
    func paymentWebViewController(paymentDidNotSucceed paymentWebViewController: PaymentWebViewViewController)
    func paymentWebViewController(paymentDidCancel paymentWebViewController: PaymentWebViewViewController)
}


class PaymentWebViewViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    
    var pesoPayModel: PesoPayModel!
    var delegate: PaymentWebViewViewControllerDelegate?
    var hud: MBProgressHUD?
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
    
    func back() {
        self.delegate!.paymentWebViewController(paymentDidCancel: self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func done(referenceNumber: String) {
        self.fireOverView(referenceNumber)
    }
    
    //MARK: Webview Delegate
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var isContinue: Bool = true
        var url: NSURL = request.mainDocumentURL!
        if "\(url)".contains("checkout/overview?Ref=") && "\(url)" != "\(self.pesoPayModel.paymentUrl)" {
            var stringUrl: String = "\(url)"
            let array: [String] = stringUrl.componentsSeparatedByString("Ref=")
            
            let referenceNumber: String = array[1]
            self.done(referenceNumber)
            isContinue = false
        } else if url == self.pesoPayModel.cancelUrl {
            self.dismissViewControllerAnimated(true, completion: nil)
            isContinue = false
        } else if url == self.pesoPayModel.failUrl {
            self.dismissViewControllerAnimated(true, completion: nil)
            isContinue = false
        } else {
            self.showHUD()
        }
        
        return isContinue
    }
    
    
    func fireOverView(transactionId: String) {
        self.showHUD()
        let manager: APIManager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token": SessionManager.accessToken(), "transactionId": transactionId]
        manager.POST(APIAtlas.overViewUrl, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.hud?.hide(true)
            println(responseObject)
            let paymentSuccessModel: PaymentSuccessModel = PaymentSuccessModel.parseDataWithDictionary(responseObject as! NSDictionary)
            if paymentSuccessModel.isSuccessful {
                self.delegate?.paymentWebViewController(paymentDidSucceed: self, paymentSuccessModel: paymentSuccessModel)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.fireRefreshToken(transactionId)
                }
                
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                self.hud?.hide(true)
        })
    }
    
    func fireRefreshToken(transactionId: String) {
        self.showHUD()
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireOverView(transactionId)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let alertController = UIAlertController(title: "Something went wrong", message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                self.hud?.hide(true)
        })
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.hud?.hide(true)
    }
}
