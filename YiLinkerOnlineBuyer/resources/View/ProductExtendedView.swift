//
//  ProductExtendedView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 1/7/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductExtendedView: UIView {

    @IBOutlet weak var webView: UIWebView!
    
    override func awakeFromNib() {
        self.webView.frame = self.bounds
        self.webView.scalesPageToFit = true
    }
    
    func setDescription(htmlString: String) {
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
}
