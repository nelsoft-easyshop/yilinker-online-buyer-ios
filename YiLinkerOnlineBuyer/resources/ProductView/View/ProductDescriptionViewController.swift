//
//  ProductDescriptionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductDescriptionViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webView.loadHTMLString(url, baseURL: nil)
        
        self.navigationController?.navigationBar.barTintColor = .whiteColor()
        self.navigationController?.navigationBar.tintColor = .grayColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.grayColor()]
//        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
//        self.navigationController?.navigationBar.tintColor = .whiteColor()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")

        self.webView.frame = self.view.bounds
        self.webView.scalesPageToFit = true
    }

    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
