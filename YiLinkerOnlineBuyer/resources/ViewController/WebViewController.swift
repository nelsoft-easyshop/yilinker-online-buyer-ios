//
//  WebViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate, EmptyViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var urlString: String = ""
    
    var emptyView: EmptyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.loadUrlWithUrlString(self.urlString)
        self.backButton()
    }
    
    //MARK: - Load URL with URL String
    func  loadUrlWithUrlString(string: String) {
        let url = NSURL(string: string)!
        let requestObj = NSURLRequest(URL: url)
        self.webView.loadRequest(requestObj)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Web View Delegate
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.showNetworkStatusIndicator(false)
        self.addEmptyView()
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        self.showNetworkStatusIndicator(false)
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.showNetworkStatusIndicator(true)
    }
    
    //MARK: - Show Network Status Indicator
    func showNetworkStatusIndicator(isShow: Bool) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = isShow
    }

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
    
    //MARK: - Back
    func back() {
        if self.webView.canGoBack {
            self.webView.goBack()
        } else {
            let alertController = UIAlertController(title: "YiLinker", message: "Are you sure you want to leave this page?", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
                // cancel action
            }
            
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
                self.navigationController!.popViewControllerAnimated(true)
            }
            
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
        
            }
            
        }
    }
    
    //MARK: - Add Empty View
    func addEmptyView() {
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.webView.layoutIfNeeded()
            self.emptyView!.frame = self.webView.frame
            self.emptyView!.backgroundColor = UIColor.whiteColor()
            self.emptyView!.delegate = self
            self.webView.addSubview(emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    //MARK: - Empty View Delegate
    func didTapReload() {
        self.emptyView!.hidden = true
        self.webView.reload()
    }
}
