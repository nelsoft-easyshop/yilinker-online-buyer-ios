//
//  ProductDetailsExtendedViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductDetailsExtendedViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.backgroundColor = .greenColor()
        webView.loadHTMLString(url, baseURL: nil)
        webView.scrollView.delegate = self
        
        self.view.window?.frame.origin.y = 100
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        var scrollViewHeight: CGFloat = scrollView.frame.size.height
        var scrollContentSizeHeight: CGFloat = scrollView.contentSize.height
        var scrollOffset: CGFloat = scrollView.contentOffset.y
        
        if (scrollOffset == 0) {
//            self.view.window?.frame.origin.y = scrollOffset * -1
        } else if (scrollOffset + scrollViewHeight == scrollContentSizeHeight) {
//            self.view.window?.frame.origin.y = scrollOffset * -1
        }
    }
    
}
