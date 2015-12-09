//
//  WebViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

struct WebviewStrings {
    static let flashSales = StringHelper.localizedStringWithKey("WEBVIEW_FLASH_SALES")
    static let dailyLogin = StringHelper.localizedStringWithKey("WEBVIEW_DAILY_LOGIN")
    static let categories = StringHelper.localizedStringWithKey("WEBVIEW_CATEGORIES")
    static let storeView = StringHelper.localizedStringWithKey("WEBVIEW_STORE_VIEW")
}

enum WebviewSource {
    case FlashSale
    case DailyLogin
    case Category
    case StoreView
    case Default
}
class WebViewURL {
    static let baseUrl = APIEnvironment.baseUrl().stringByReplacingOccurrencesOfString("/api", withString: "/")
    static let flashSale: String = baseUrl + APIAtlas.flashSale
    static let dailyLogin: String = APIEnvironment.baseUrl() + "/v1/auth/" + APIAtlas.dailyLogin
    static let category: String = baseUrl + APIAtlas.category
    static let storeView: String = baseUrl + APIAtlas.storeView
}

class WebViewController: UIViewController, UIWebViewDelegate, EmptyViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    var urlString: String = ""
    
    var emptyView: EmptyView?
    
    var webviewSource = WebviewSource.Default
    var isFromFab: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.webView.scrollView.bounces = false
        
        if self.urlString.isEmpty {
            loadWebview()
        } else if self.urlString == WebViewURL.flashSale {
            webviewSource = WebviewSource.FlashSale
            loadWebview()
        } else if self.urlString == WebViewURL.dailyLogin {
            webviewSource = WebviewSource.DailyLogin
            loadWebview()
        } else if self.urlString == WebViewURL.category {
            webviewSource = WebviewSource.Category
            loadWebview()
        } else if self.urlString == WebViewURL.storeView {
            webviewSource = WebviewSource.StoreView
            loadWebview()
        } else {
            self.loadUrlWithUrlString(self.urlString)
        }
        
        self.backButton()
        
    }
    
    //MARK: - Load URL with URL String
    func  loadUrlWithUrlString(string: String) {
        let url = NSURL(string: string)!
        let requestObj = NSURLRequest(URL: url)
        self.webView.loadRequest(requestObj)
    }
    
    func  loadWebview() {
        var tempUrl: String = ""
        switch webviewSource {
        case .FlashSale:
            tempUrl = WebViewURL.flashSale
            self.title = WebviewStrings.flashSales
        case .DailyLogin:
            tempUrl = WebViewURL.dailyLogin + "?access_token=\(SessionManager.accessToken())"
            self.title = WebviewStrings.dailyLogin
        case .Category:
            tempUrl = WebViewURL.category
            self.title = WebviewStrings.categories
        case .StoreView:
            tempUrl = WebViewURL.storeView
            self.title = WebviewStrings.storeView
        case .Default:
            self.addEmptyView()
        default:
            print("Default")
        }
        
        self.loadUrlWithUrlString(tempUrl)
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
        webView.hidden = false
        self.showNetworkStatusIndicator(false)
        webView.stringByEvaluatingJavaScriptFromString("document.body.style.webkitTouchCallout='none';")
        
        if webviewSource == WebviewSource.DailyLogin {
            let html: String = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")!
            
            if html.contains("error") {
                webView.hidden = true
                self.requestRefreshToken()
            }
        }
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        self.showNetworkStatusIndicator(true)
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        
        var url: NSURL = request.URL!
        var urlString: String = url.absoluteString!
        
        switch webviewSource {
        case .FlashSale:
            if urlString == WebViewURL.flashSale {
                return true
            } else {
                //Put redirection to native view controller here. . . . .
                
                let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
                productViewController.tabController = self.tabBarController as! CustomTabBarController
                productViewController.productId = flashSaleLinkTap(urlString)
                self.navigationController?.pushViewController(productViewController, animated: true)
                return false
            }
            
        case .DailyLogin:
            if urlString == WebViewURL.dailyLogin + "?access_token=\(SessionManager.accessToken())" {
                return true
            } else {
                return false
            }
        case .Category:
            if urlString == WebViewURL.category {
                return true
            } else {
                var resultController = ResultViewController(nibName: "ResultViewController", bundle: nil)
                resultController.passModel(SearchSuggestionModel(suggestion: "", imageURL: "", searchUrl: urlString))
                self.navigationController?.pushViewController(resultController, animated:true);
                return false
            }
        case .StoreView:
            if urlString == WebViewURL.storeView {
                return true
            } else {
                //Put redirection to native view controller here. . . . .
                return false
            }
        case .Default:
            return true
        default:
            return true
        }
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
        
        if isFromFab {
            backButton.hidden = true
        }
        
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    //MARK: - Back
    func back() {
//        if self.webView.canGoBack {
//            self.webView.goBack()
//        } else {
            self.navigationController!.popViewControllerAnimated(true)
//        }
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

    //MARK: - Flash Sales
    func flashSaleLinkTap(url: String) -> String {
        
        var productUrl: String = ""
        
        let html = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")
        let doc = TFHpple(HTMLData: html?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
        var elements = doc.searchWithXPathQuery("//a[@class='btn promo-instance-product-status btn-inactive']")
        
        for element in elements as! [TFHppleElement] {
            if url.contains(element.objectForKey("href")) {
                productUrl = element.objectForKey("data-product-id")
                break
            }
        }
        return productUrl
    }
    
    func requestRefreshToken() {
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID(),
            "client_secret": Constants.Credentials.clientSecret(),
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        
        manager.POST(APIAtlas.refreshTokenUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            
                self.loadWebview()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
        })
    }
}
