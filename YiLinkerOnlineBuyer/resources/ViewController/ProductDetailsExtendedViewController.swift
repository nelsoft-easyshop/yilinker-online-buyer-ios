//
//  ProductDetailsExtendedViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductDetailsExtendedViewControllerDelegate {
    func closedExtendedDetails(controller: ProductDetailsExtendedViewController)
}

class ProductDetailsExtendedViewController: UIViewController, UIScrollViewDelegate, UIWebViewDelegate {

    var delegate: ProductDetailsExtendedViewControllerDelegate?
    @IBOutlet weak var webView: UIWebView!
    var url: String = ""
    var sampleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        // Do any additional setup after loading the view.
        webView.delegate = self
        webView.scrollView.delegate = self
//        webView.scrollView.bounces = false
        
        self.sampleView = UIView(frame: CGRectMake(0, 0, 50, 50))
        self.sampleView.backgroundColor = .redColor()
        self.sampleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "close:"))
//        self.view.addSubview(self.sampleView)
        
        webView.scrollView.backgroundColor = .clearColor()
        webView.backgroundColor = .clearColor()
        webView.scrollView.showsVerticalScrollIndicator = false

        webView.loadRequest(NSURLRequest(URL: NSURL(string: "https://www.yilinker.com/")!))
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    }
    
    func close(gesture: UIGestureRecognizer) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.view.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(0.0, self.view.frame.size.height)
            }, completion: { (value: Bool) in
                self.dismissViewControllerAnimated(false, completion: nil)
                self.delegate?.closedExtendedDetails(self)
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scrolling")
        var scrollViewHeight: CGFloat = scrollView.frame.size.height
        var scrollContentSizeHeight: CGFloat = scrollView.contentSize.height
        var scrollOffset: CGFloat = scrollView.contentOffset.y
        
        if (scrollOffset >= 0) {
//            self.view.frame.origin.y = scrollOffset * -1
            println(scrollOffset)
//            self.sampleView.frame.origin.y = scrollOffset * -1
//            self.webView.frame.origin.y = scrollOffset * -1
        } else if (scrollOffset + scrollViewHeight <= scrollContentSizeHeight) {
            self.view.frame.origin.y = scrollOffset * -1
//            self.sampleView.frame.origin.y = scrollOffset * -1
//            self.webView.frame.origin.y = scrollOffset * -1
            println(scrollOffset)
        }
        
        if scrollView == self.webView.scrollView {
            if self.scrolledPastBottomThresholdInTableView(self.webView.scrollView) {
//                dismissMe()
            }
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y <= -100 {
            dismissMe()
        }
    }
    
    
    func scrolledPastBottomThresholdInTableView(scrollView: UIScrollView) -> Bool {
        return scrollView.contentOffset.y <= -150//(scrollView.contentOffset.y - 30.0 >= (scrollView.contentSize.height - scrollView.frame.size.height))
    }
    
    func dismissMe() {
        webView.scrollView.delegate = nil
//        self.dismissViewControllerAnimated(true, completion: nil)
//        self.view.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
        UIView.animateWithDuration(0.3, animations: {
//            self.view.transform = CGAffineTransformMakeTranslation(0.0, self.view.frame.size.height)
            self.view.frame.origin.y = self.view.frame.size.height
            }, completion: { (value: Bool) in
                self.dismissViewControllerAnimated(false, completion: nil)
                self.delegate?.closedExtendedDetails(self)
        })
    }
    
}
