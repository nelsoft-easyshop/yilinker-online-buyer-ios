//
//  SearchViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let manager = APIManager.sharedInstance
    
    var searchTask: NSURLSessionDataTask?
    
    let viewControllerIndex = 1
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var tableData: [SearchSuggestionModel] = []
    
    var searchLocalizeString: String = ""
    var browseLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeLocalizedString()
        self.initializeViews()
        self.addBrowseCategory()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - Initializations
    func initializeViews() {
        // Connect all delegate prototypes
        self.searchBar.delegate = self
        self.searchResultTableView.dataSource = self
        self.searchResultTableView.delegate = self
        
        // Do any additional setup after loading the view.
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            as [NSObject : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict
        
        // Remove trailing cells
        self.searchResultTableView.tableFooterView = UIView(frame: CGRectZero)
        
        // Remove NavigationBar shadow
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        //Register Nib to Tableview
        var nib = UINib(nibName: "SearchSuggestionTableViewCell", bundle: nil)
        self.searchResultTableView.registerNib(nib, forCellReuseIdentifier: "SearchSuggestionTableViewCell")
        
        //Add scopebar
        let sellerLocalizeString: String = StringHelper.localizedStringWithKey("SELLER_LOCALIZE_KEY")
        let productLocalizeString: String = StringHelper.localizedStringWithKey("PRODUCT_LOCALIZE_KEY")
        self.searchBar.scopeButtonTitles = [productLocalizeString, sellerLocalizeString]
        
        UITextField.my_appearanceWhenContainedIn(SearchViewController.self).tintColor = Constants.Colors.grayLine
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Panton-Regular", size: 21)!]
        
        self.title = searchLocalizeString
    }
    
    func initializeLocalizedString() {
        self.searchLocalizeString = StringHelper.localizedStringWithKey("SEARCH_LOCALIZE_KEY")
        self.browseLocalizeString = StringHelper.localizedStringWithKey("BROWSECATEGORY_LOCALIZE_KEY")
    }
    
    
    //MARK: - API Request
    func fireSearch(queryString: String){
        if (self.searchTask != nil) {
            self.searchTask?.cancel()
            self.searchTask = nil
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        
        self.searchTask = WebServiceManager.fireSearcProducthWithUrl(APIAtlas.searchUrl, queryString: queryString, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            if successful {
                if  let dictionary: NSDictionary = responseObject as? NSDictionary {
                    if let isSuccessful: Bool = dictionary["isSuccessful"] as? Bool{
                        if isSuccessful {
                            self.tableData.removeAll(keepCapacity: false)
                            if let value: AnyObject = responseObject["data"] {
                                for subValue in value as! NSArray {
                                    let model: SearchSuggestionModel = SearchSuggestionModel.parseDataFromDictionary(subValue as! NSDictionary)
                                    
                                    self.tableData.append(model)
                                }
                                self.searchResultTableView.reloadData()
                            }
                            self.addBrowseCategory()
                        }
                    }
                } else {
                    UIAlertController.displaySomethingWentWrongError(self)
                }
            } else {
                if requestErrorType == .ResponseError {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .PageNotFound {
                    Toast.displayToastWithMessage("Page not found.", duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else if requestErrorType == .Cancel {
                } else {
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                }
            }
        })
    }
    
    //MARK: - Util Functions
    
    //Add Browse category in the table view
    func addBrowseCategory() {
        var temp: SearchSuggestionModel = SearchSuggestionModel(suggestion: browseLocalizeString, imageURL: "SearchBrowseCategory", searchUrl: "") as SearchSuggestionModel
        
        self.tableData.append(temp)
        self.searchResultTableView.reloadData()
    }
}

//MARK: - Delegates and Data Source
//MARK: - UITableViewDataSource methods
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchResultTableView.dequeueReusableCellWithIdentifier("SearchSuggestionTableViewCell") as! SearchSuggestionTableViewCell
        
        var tempModel: SearchSuggestionModel = tableData[indexPath.row]
        
        cell.suggestionTextLabel?.text = tempModel.suggestion
        if tempModel.suggestion.contains(browseLocalizeString) {
            cell.suggestionImageView.image = UIImage(named: "SearchBrowseCategory")
        } else {
            cell.suggestionImageView.sd_setImageWithURL(NSURL(string: tempModel.imageURL), placeholderImage: UIImage(named: "dummy-placeholder"))
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var tempModel: SearchSuggestionModel = tableData[indexPath.row]
        
        if tempModel.suggestion.contains(browseLocalizeString) {
            self.navigationController?.navigationBarHidden = false
            let webViewController: WebViewController = WebViewController(nibName: "WebViewController", bundle: nil)
            webViewController.webviewSource = WebviewSource.Category
            self.navigationController!.pushViewController(webViewController, animated: true)
        } else {
            var resultController = ResultViewController(nibName: "ResultViewController", bundle: nil)
            resultController.passModel(tableData[indexPath.row])
            self.navigationController?.pushViewController(resultController, animated:true);
        }
        
        self.searchBar.resignFirstResponder()
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        self.searchBar.resignFirstResponder()
    }
}

//MARK: - UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate{
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        // Show Scope bar with cancel
        self.searchBar.showsScopeBar = true
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.selectedScopeButtonIndex == 0 {
            if count(searchText) > 1 {          //Request only when the characters of queryString is greater than 1
                self.fireSearch(searchText)
            } else {
                self.tableData.removeAll(keepCapacity: false)
                self.addBrowseCategory()
                self.searchResultTableView.reloadData()
            }
        }
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.showsScopeBar = false
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if (self.searchTask != nil) {
            self.searchTask?.cancel()
            searchTask = nil
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        self.searchBar.resignFirstResponder()
        let newString = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        var resultController = ResultViewController(nibName: "ResultViewController", bundle: nil)
        
        if searchBar.selectedScopeButtonIndex == 0 {
            resultController.isSellerSearch = false
            resultController.passModel(SearchSuggestionModel(suggestion: searchBar.text, imageURL: "", searchUrl: "\(APIAtlas.searchBuyer)\(newString)"))
        } else {
            resultController.isSellerSearch = true
            resultController.passModel(SearchSuggestionModel(suggestion: searchBar.text, imageURL: "", searchUrl: "\(APIAtlas.searchSeller)\(newString)"))
        }
        
        self.navigationController?.pushViewController(resultController, animated:true);
        
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    
    // Scope 0 = Buyer
    // Scope 1 = Seller
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.tableData.removeAll(keepCapacity: false)
        self.searchResultTableView.reloadData()
        if selectedScope == 0 {
            if count(searchBar.text) > 1 {          //Request only when the characters of queryString is greater than 1
                self.fireSearch(searchBar.text)
            } else {
                self.tableData.removeAll(keepCapacity: false)
                self.addBrowseCategory()
                self.searchResultTableView.reloadData()
            }
        }
    }

}