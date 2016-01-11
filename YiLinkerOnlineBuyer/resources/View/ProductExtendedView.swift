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
    }
    
    func setDescription(htmlString: String) {
        webView.loadHTMLString(htmlString, baseURL: nil)
    }

}
