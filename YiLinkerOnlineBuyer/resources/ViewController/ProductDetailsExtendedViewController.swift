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

class ProductDetailsExtendedViewController: UIViewController, UIScrollViewDelegate {

    var delegate: ProductDetailsExtendedViewControllerDelegate?
    @IBOutlet weak var webView: UIWebView!
    var url: String = ""
    var sampleView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.scrollView.delegate = self
//        webView.scrollView.bounces = false
        
        self.sampleView = UIView(frame: CGRectMake(0, 0, 50, 50))
        self.sampleView.backgroundColor = .redColor()
        self.sampleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "close:"))
        self.view.addSubview(self.sampleView)
        
        webView.scrollView.backgroundColor = .greenColor()
    }

    func close(gesture: UIGestureRecognizer) {
//        self.dismissViewControllerAnimated(true, completion: nil)
        
        self.view.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(0.0, self.view.frame.size.height)
            }, completion: { (value: Bool) in
                self.dismissViewControllerAnimated(false, completion: nil)
        })
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println("scrolling")
        var scrollViewHeight: CGFloat = scrollView.frame.size.height
        var scrollContentSizeHeight: CGFloat = scrollView.contentSize.height
        var scrollOffset: CGFloat = scrollView.contentOffset.y
        
        if (scrollOffset >= 0) {
            self.view.frame.origin.y = scrollOffset * -1
            println(scrollOffset)
            self.sampleView.frame.origin.y = scrollOffset * -1
            self.webView.frame.origin.y = scrollOffset * -1
        } else if (scrollOffset + scrollViewHeight <= scrollContentSizeHeight) {
            self.view.frame.origin.y = scrollOffset * -1
            self.sampleView.frame.origin.y = scrollOffset * -1
            self.webView.frame.origin.y = scrollOffset * -1
            println(scrollOffset)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        if scrollView.contentOffset.y <= -160 {
            self.view.transform = CGAffineTransformMakeTranslation(0.0, 0.0)
            UIView.animateWithDuration(0.3, animations: {
                self.view.transform = CGAffineTransformMakeTranslation(0.0, self.view.frame.size.height)
                }, completion: { (value: Bool) in
                    self.dismissViewControllerAnimated(false, completion: nil)
                    self.delegate?.closedExtendedDetails(self)
            })
        }
    }
    
}
