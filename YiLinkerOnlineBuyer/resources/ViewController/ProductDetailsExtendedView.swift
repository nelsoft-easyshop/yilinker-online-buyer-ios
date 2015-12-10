//
//  ProductDetailsExtendedView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductDetailsExtendedViewDelegate {
    func closedExtendedDetails()
}

class ProductDetailsExtendedView: UIView, UIScrollViewDelegate, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var closeButton: UIButton!
    
    var url: String = ""
    var delegate: ProductDetailsExtendedViewDelegate?
    
    override func awakeFromNib() {
        webView.scrollView.backgroundColor = .clearColor()
        webView.backgroundColor = .clearColor()
        webView.scrollView.showsVerticalScrollIndicator = false
        self.activityIndicator.stopAnimating()
        self.webView.scrollView.showsHorizontalScrollIndicator = false
        
//        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.yilinker.com")!))
    }

    func loadUrl(url: String) {
        webView.loadHTMLString(url, baseURL: nil)
    }
    
    func setDelegate() {
        webView.delegate = self
        self.webView.scrollView.delegate = self
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        self.activityIndicator.stopAnimating()
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollViewHeight: CGFloat = scrollView.frame.size.height
        var scrollContentSizeHeight: CGFloat = scrollView.contentSize.height
        var scrollOffset: CGFloat = scrollView.contentOffset.y
        self.closeButton.hidden = true
        if scrollOffset >= 0 {
            if (scrollView.contentSize.height - self.frame.size.height < scrollView.contentOffset.y) {
                self.frame.origin.y = ((scrollOffset - scrollView.contentSize.height) * -1) - self.frame.size.height
            }
        } else if (scrollOffset + scrollViewHeight <= scrollContentSizeHeight) {
            self.frame.origin.y = scrollOffset * -1
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.closeButton.hidden = false
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= -100 {
            dismissMe("down")
        } else if scrollView.contentOffset.y > (scrollView.contentSize.height - self.frame.size.height) + 100 {
            dismissMe("top")
        }
    }
    
    func scrolledPastBottomThresholdInTableView(scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.y <= -100
    }
    
    func dismissMe(direction: String) {
        webView.scrollView.delegate = nil
        UIView.animateWithDuration(0.3, animations: {

            if direction == "down" {
                self.frame.origin.y = self.frame.size.height
            } else if direction == "top" {
                self.frame.origin.y = self.frame.size.height * -1
            }

            }, completion: { (value: Bool) in
                self.delegate?.closedExtendedDetails()
                self.frame.origin.y = self.frame.size.height + 100
        })
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        UIApplication.sharedApplication().statusBarHidden = false
        dismissMe("down")
    }
    
}
