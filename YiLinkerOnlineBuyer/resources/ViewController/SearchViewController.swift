//
//  SearchViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {

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
        
        if(self.tableData.isEmpty) {
            var temp: SearchSuggestionModel = SearchSuggestionModel(suggestion: "Browse by Category", imageURL: "SearchBrowseCategory") as SearchSuggestionModel
            
            tableData.append(temp)
            self.searchResultTableView.reloadData()
        }

    }
    
    // Mark: - UISearchBarDelegate
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        // Show Scope bar with cancel
        self.searchBar.showsScopeBar = true
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBarShouldEndEditing(searchBar: UISearchBar) -> Bool {
        self.searchBar.showsScopeBar = false
        self.searchBar.sizeToFit()
        self.searchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchResultTableView.reloadData()
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
        var tempModel: SearchSuggestionModel = tableData[indexPath.row]
        println(tempModel.suggestion)
        println(tempModel.imageURL)

    }

}
