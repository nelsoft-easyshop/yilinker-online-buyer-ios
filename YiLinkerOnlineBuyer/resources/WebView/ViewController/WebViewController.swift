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
    static let newItems = StringHelper.localizedStringWithKey("WEBVIEW_NEW_ITEMS")
    static let hotItems = StringHelper.localizedStringWithKey("WEBVIEW_HOT_ITEMS")
    static let todaysPromo = StringHelper.localizedStringWithKey("TODAYS_PROMO_HIDDEN_LOCALIZE_KEY")
    static let yilinker = StringHelper.localizedStringWithKey("WEBVIEW_YILINKER")
    static let please = StringHelper.localizedStringWithKey("WEBVIEW_PLEASE")
}

enum WebviewSource {
    case FlashSale
    case DailyLogin
    case Category
    case StoreView
    case ProductList
    case Others
}
class WebViewURL {
    static let baseUrl = APIEnvironment.baseUrl().stringByReplacingOccurrencesOfString("/api", withString: "/")
    static let flashSale: String = baseUrl + APIAtlas.flashSale
    static let dailyLogin: String = APIEnvironment.baseUrl() + "/v1/auth/" + APIAtlas.dailyLogin
    static let category: String = baseUrl + APIAtlas.category
    static let storeView: String = baseUrl + APIAtlas.storeView
    static let productList: String = baseUrl + APIAtlas.mobileProductList
}

class WebViewController: UIViewController, UIWebViewDelegate, EmptyViewDelegate {
    
    let USERID: String = "userId"
    let PRODUCTID: String = "productId"
    let CATEGORYID: String = "categoryId"
    let GET_PRODUCT_LIST: String = "getProductList"
    
    @IBOutlet weak var webView: UIWebView!
    var urlString: String = ""
    
    @IBOutlet weak var errorView: UIView!
    var emptyView: EmptyView?
    @IBOutlet weak var pleaseLabel: UILabel!
    
    var webviewSource = WebviewSource.Others
    var isFromFab: Bool = false
    var pageTitle: String = ""
    
    var hud: MBProgressHUD?
    
    var isBackButtonVisible: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        self.webView.scrollView.bounces = false
        errorView.hidden = true
        self.backButton()
        self.edgesForExtendedLayout = UIRectEdge.None
        self.pleaseLabel.text = WebviewStrings.please
        
        self.checkCurrentURL()
        
        if pageTitle.isEmpty {
            self.title = WebviewStrings.yilinker
        } else{
            self.title = pageTitle
        }
        
        if isBackButtonVisible {
            self.backButton()
        }
    }
    
    //MARK: - Check type of URL to handle adding of access token in daily login and setting of page title.
    func checkCurrentURL() {
        if self.urlString.contains(APIAtlas.dailyLogin) {
            pageTitle = WebviewStrings.dailyLogin
            if SessionManager.isLoggedIn() {
                webviewSource = WebviewSource.DailyLogin
                self.urlString = "\(urlString)?access_token=\(SessionManager.accessToken())"
                loadUrl(self.urlString)
            } else {
                self.addEmptyView()
            }
        } else if self.urlString.contains(APIAtlas.flashSale) {
            pageTitle = WebviewStrings.flashSales
            loadUrl(self.urlString)
        } else if self.urlString.contains(APIAtlas.category) || webviewSource == WebviewSource.Category {
            webviewSource = WebviewSource.Category
            if self.urlString.isEmpty {
                self.urlString = WebViewURL.category
            }
            pageTitle = WebviewStrings.categories
            loadUrl(self.urlString)
        } else {
            webviewSource = WebviewSource.Others
            loadUrl(self.urlString)
        }
    }
    
    //MARK: - Load URL with URL String
    func loadUrl(url: String) {
        let urlTemp = NSURL(string: url)!
        let requestObj = NSURLRequest(URL: urlTemp)
        self.webView.loadRequest(requestObj)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    //MARK: - Web View Delegate
    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
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
        self.webView.hidden = true
    }
    
    func webView(webView: UIWebView, shouldStartLoadWithRequest request: NSURLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        var url: NSURL = request.URL!
        var urlAbsoluteString: String = url.absoluteString!
        
        if urlAbsoluteString.contains(USERID) {
            let id: String = self.linkTap(urlAbsoluteString)
            let sellerViewController: SellerViewController = SellerViewController(nibName: "SellerViewController", bundle: nil)
            sellerViewController.sellerId = (id as NSString).integerValue
            self.navigationController!.pushViewController(sellerViewController, animated: true)
            return false
        } else if urlAbsoluteString.contains(PRODUCTID) {
            let id: String = self.linkTap(urlAbsoluteString)
            let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
            productViewController.tabController = self.tabBarController as! CustomTabBarController
            productViewController.productId = id
            self.navigationController?.pushViewController(productViewController, animated: true)
            return false
        }  else if urlAbsoluteString.contains(GET_PRODUCT_LIST) {
            var resultController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            resultController.passModel(SearchSuggestionModel(suggestion: "", imageURL: "", searchUrl: urlAbsoluteString))
            self.navigationController?.pushViewController(resultController, animated:true);
            return false
        } else if urlAbsoluteString.contains(CATEGORYID) {
            var resultController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            resultController.pageTitle = self.getCategoryTitle(urlAbsoluteString)
//            resultController.passCategoryID(self.linkTap(urlAbsoluteString).toInt()!)
            resultController.passModel(SearchSuggestionModel(suggestion: "", imageURL: "", searchUrl: urlAbsoluteString))
            self.navigationController?.pushViewController(resultController, animated:true);
            return false
        } else {
            return true
        }
    }
    
    //MARK: - Show Network Status Indicator
    func showNetworkStatusIndicator(isShow: Bool) {
        if isShow {
            if self.hud != nil {
                self.hud!.hide(true)
                self.hud = nil
            }
            
            self.hud = MBProgressHUD(view: self.view)
            self.hud?.removeFromSuperViewOnHide = true
            self.hud?.dimBackground = false
            self.view.addSubview(self.hud!)
            self.hud?.show(true)
        } else {
            self.hud?.hide(true)
        }
    }
    
    //MARK: - Back
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //MARK: - Add Empty View
    func addEmptyView() {
        self.webView.hidden = true
        self.showNetworkStatusIndicator(false)
        errorView.hidden = false
    }
    
    //MARK: - Empty View Delegate
    func didTapReload() {
        self.emptyView!.hidden = true
        self.webView.reload()
    }
    
    //MARK: - Flash Sales
    func productLinkTap(url: String) -> String {
        var productID: String = ""
        
        let start = url.indexOfCharacter("=") + 1
        productID = url.substringFromIndex(advance(minElement(indices(url)), start))
        return productID
    }
    
    //MARK: - Store View
    func storeViewLinkTap(url: String) -> String {
        var storeID: String = ""
        
        if url.contains("getStoreInfo") {
            let start = url.indexOfCharacter("=") + 1
            if start != 0 {
                storeID = url.substringFromIndex(advance(minElement(indices(url)), start))
            }
        }
        return storeID
    }
    
    
    func linkTap(url: String) -> String {
        var idTemp: String = ""
        if url.contains(PRODUCTID) || url.contains(USERID) || url.contains(CATEGORYID) {
            let start = url.indexOfCharacter("=") + 1
            if start != 0 {
                idTemp = url.substringFromIndex(advance(minElement(indices(url)), start))
            }
        }
        return idTemp
    }
    
    //MARK: - Category Title
    func getCategoryTitle(url: String) -> String {
        var titleString: String = ""
        let html = webView.stringByEvaluatingJavaScriptFromString("document.documentElement.outerHTML")
        let doc = TFHpple(HTMLData: html?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false))
        var elements = doc.searchWithXPathQuery("//a")
        
        for element in elements as! [TFHppleElement] {
            print(url)
            print(APIEnvironment.baseUrl() + element.objectForKey("href"))
            if url == (APIEnvironment.baseUrl().stringByReplacingOccurrencesOfString("/api", withString: "") + element.objectForKey("href")) {
                if element.children.count != 0 {
                    if element.children.count > 3 {
                        if let tempElement = element.children[3] as? TFHppleElement {
                            if tempElement.children.count != 0 {
                                if let spanElement = tempElement.children[0] as? TFHppleElement {
                                    titleString = spanElement.text()
                                }
                            }
                        }
                    }
                }
                break
            }
        }
        return titleString
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
            self.checkCurrentURL()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
        })
    }
}