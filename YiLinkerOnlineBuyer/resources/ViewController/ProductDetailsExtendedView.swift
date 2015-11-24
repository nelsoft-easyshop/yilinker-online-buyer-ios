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
    var url: String = ""
    var delegate: ProductDetailsExtendedViewDelegate?
    
    override func awakeFromNib() {
        webView.scrollView.backgroundColor = .clearColor()
        webView.backgroundColor = .clearColor()
        webView.scrollView.showsVerticalScrollIndicator = false
        
        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.yilinker.com/")!))
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
        
        if (scrollOffset >= 0) {
            
        } else if (scrollOffset + scrollViewHeight <= scrollContentSizeHeight) {
            self.frame.origin.y = scrollOffset * -1
        }
        
        if scrollView == self.webView.scrollView {
            if self.scrolledPastBottomThresholdInTableView(self.webView.scrollView) {
                dismissMe()
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y <= -100 {
            dismissMe()
        }
    }
    
    
    func scrolledPastBottomThresholdInTableView(scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.y <= -100
    }
    
    func dismissMe() {
        webView.scrollView.delegate = nil
        UIView.animateWithDuration(0.3, animations: {
            self.frame.origin.y = self.frame.size.height
            }, completion: { (value: Bool) in
                self.delegate?.closedExtendedDetails()
        })
    }
    
}
