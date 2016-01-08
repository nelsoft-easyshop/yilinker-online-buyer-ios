//
//  ProductExtendedView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 1/7/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductExtendedViewDelegate {
    func pullAction(controller: ProductExtendedView)
}

class ProductExtendedView: UIView {

    @IBOutlet weak var webView: UIWebView!
    
    var delegate: ProductExtendedViewDelegate?
    
    override func awakeFromNib() {
        var refreshController:UIRefreshControl = UIRefreshControl()
        
        refreshController.bounds = CGRectMake(0, 50, refreshController.bounds.size.width, refreshController.bounds.size.height) // Change position of refresh view
        refreshController.addTarget(self, action: Selector("refreshWebView:"), forControlEvents: UIControlEvents.ValueChanged)
        refreshController.attributedTitle = NSAttributedString(string: "Pull down to refresh...")
        webView.scrollView.addSubview(refreshController)
    }
    
    func setDescription(htmlString: String) {
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    func refreshWebView(refresh: UIRefreshControl){
        delegate?.pullAction(self)
        refresh.endRefreshing()
    }

}
