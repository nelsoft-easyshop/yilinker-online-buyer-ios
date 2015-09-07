//
//  SearchViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let manager = APIManager.sharedInstance
    
    var searchTask: NSURLSessionDataTask?
    
    let viewControllerIndex = 1
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchResultTableView: UITableView!
    
    var tableData: [SearchSuggestionModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
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
        searchResultTableView.registerNib(nib, forCellReuseIdentifier: "SearchSuggestionTableViewCell")
        
        addBrowseCategory()
    }
    
    func requestSearch(url: String, params: NSDictionary!) {
        
        if (self.searchTask != nil) {
            searchTask?.cancel()
            searchTask = nil
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
        }
        
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        searchTask = manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
            } else {
                self.populateTableView(responseObject)
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error)
                
                if (task.response as? NSHTTPURLResponse != nil) {
                    let response: NSHTTPURLResponse  = task.response as! NSHTTPURLResponse
                    
                    let statusCode: Int = response.statusCode
                    println("STATUS CODE \(statusCode)")
                    if(statusCode != -999) {
                        self.showAlert("Error", message: "Something went wrong. . .")
                        UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                    } else {
                        self.requestSearch(url, params: params)
                    }
                }
        })
        
        
    }
    
    //        func requestSearch(url: String, params: NSDictionary!) {
    //            UIApplication.sharedApplication().networkActivityIndicatorVisible = true
    //            manager.operationQueue.cancelAllOperations()
    //            manager.GET(url, parameters: params, success: {
    //                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
    //                if responseObject.objectForKey("error") != nil {
    //                } else {
    //                    self.populateTableView(responseObject)
    //                }
    //                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    //                }, failure: {
    //                    (task: NSURLSessionDataTask!, error: NSError!) in
    //                    println(error)
    //                    self.showAlert("Error", message: "Something went wrong. . .")
    //                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
    //            })
    //        }
    
    func populateTableView(responseObject: AnyObject) {
        tableData.removeAll(keepCapacity: false)
        if let value: AnyObject = responseObject["data"] {
            for subValue in value as! NSArray {
                let model: SearchSuggestionModel = SearchSuggestionModel.parseDataFromDictionary(subValue as! NSDictionary)
                
                self.tableData.append(model)
            }
            self.searchResultTableView.reloadData()
        }
        
        if tableData.count == 0 {
            showAlert("Search", message: "No result found.")
        }
        
        addBrowseCategory()
    }
    
    func addBrowseCategory() {
        var temp: SearchSuggestionModel = SearchSuggestionModel(suggestion: "Browse by Category", imageURL: "SearchBrowseCategory", searchUrl: "") as SearchSuggestionModel
        
        tableData.append(temp)
        self.searchResultTableView.reloadData()
    }
    
    // Mark: - UISearchBarDelegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        // Show Scope bar with cancel
        self.searchBar.showsScopeBar = true
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if count(searchText) > 1 {
            if Reachability.isConnectedToNetwork(){
                requestSearch(APIAtlas.searchUrl, params: NSDictionary(dictionary: ["queryString" : searchText]))
            }  else {
                showAlert("Connection Unreachable", message: "Cannot retrieve data. Please check your internet connection.")
            }
        } else {
            tableData.removeAll(keepCapacity: false)
            addBrowseCategory()
            searchResultTableView.reloadData()
        }
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.showsScopeBar = false
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        let newString = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        var resultController = ResultViewController(nibName: "ResultViewController", bundle: nil)
        resultController.passModel(SearchSuggestionModel(suggestion: searchBar.text, imageURL: "", searchUrl: "http://online.api.easydeal.ph/api/v1/product/getProductList?query=\(newString)"))
        self.navigationController?.pushViewController(resultController, animated:true);
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    // Mark: - UITableViewDataSource methods
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
        if tempModel.imageURL == "SearchBrowseCategory" {
            cell.suggestionImageView.image = UIImage(named: "SearchBrowseCategory")
        } else {
            cell.suggestionImageView.sd_setImageWithURL(NSURL(string: tempModel.imageURL), placeholderImage: UIImage(named: "dummy-placeholder"))
        }
        
        return cell
    }
    
    // Mark: - UITableViewDelegate methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var resultController = ResultViewController(nibName: "ResultViewController", bundle: nil)
        resultController.passModel(tableData[indexPath.row])
        self.navigationController?.pushViewController(resultController, animated:true);
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
}
