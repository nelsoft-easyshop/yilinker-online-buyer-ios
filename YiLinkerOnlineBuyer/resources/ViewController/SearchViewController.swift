//
//  SearchViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by @EasyShop.ph on 8/11/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchSelections: UITableView!
    
    let categoryView = DummyViewController()
    
    var dataSelections : [(text: String, image: String)] = []
    let allData : [(text: String, image: String)] =
       [("mobile", "MobileImage")
        , ("iPhone mobile", "iPhoneImage")
        , ("mobile store", "MobileStoreImage")]
    let browseForCategoryRow : (text: String, image: String) =
        ("Browse for Category", "SearchBrowseCategory")
    

    // Why is this needed? -Edward
    let viewControllerIndex = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Connect all delegate prototypes
        self.searchBar.delegate = self
        self.searchSelections.dataSource = self
        self.searchSelections.delegate = self
        
        // Do any additional setup after loading the view.
        let titleDict = [NSForegroundColorAttributeName: UIColor.whiteColor()]
            as [NSObject : AnyObject]
        self.navigationController!.navigationBar.titleTextAttributes = titleDict

        // Remove trailing cells
        self.searchSelections.tableFooterView = UIView(frame: CGRectZero)
        self.searchSelections.backgroundColor = //UIColor.lightGrayColor()
            searchSelections.dequeueReusableCellWithIdentifier("Cell")?.backgroundColor
        
        // Remove NavigationBar shadow
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        
        if(self.dataSelections.isEmpty) {
            dataSelections.append( browseForCategoryRow )
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        self.dataSelections = self.allData.filter({ (rowData) -> Bool in
            let nsText: NSString = rowData.text
            let range = nsText.rangeOfString(searchText,
                options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if self.dataSelections.isEmpty || self.dataSelections.last!.text != self.browseForCategoryRow.text {
            dataSelections.append(browseForCategoryRow)
        }

        self.searchSelections.reloadData()
    }
    
    // Mark: - UITableViewDataSource methods
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSelections.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = searchSelections.dequeueReusableCellWithIdentifier("Cell") as! SearchTableViewCell
        
        cell.lookupText?.text = self.dataSelections[indexPath.row].text
        cell.lookupImage?.image = UIImage(named: self.dataSelections[indexPath.row].image)
        return cell
    }
    
    // Mark: - UITableViewDelegate methods
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog( "Clicked Link!" )
        let clickedCell = searchSelections.dequeueReusableCellWithIdentifier("Cell") as! SearchTableViewCell
        self.categoryView.title = "Dummy Category"
        self.categoryView.view.backgroundColor = UIColor.greenColor()
        self.navigationController?.pushViewController(categoryView, animated:true);
    }
    
    // Mark: JSON 
    func fireGetHomePageData() {
        /*let dictionary: NSDictionary = ParseLocalJSON.fileName("home")*/
        let manager = APIManager.sharedInstance
        
//        manager.GET("http://demo9190076.mockable.io/yilinker/home", parameters: nil, success: {
//            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
//            self.populateHomePageWithDictionary(responseObject as! NSDictionary)
//            }, failure: {
//                (task: NSURLSessionDataTask!, error: NSError!) in
//        })
        
    }

    
    // MARK: - Navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        if let tappedCell = sender as? SearchTableViewCell {
//            if tappedCell.lookupText == lastElement.text {
//                segue.destinationViewController = UIViewController()
////            let i = redditListTableView.indexPathForCell(cell)!.row
////            if segue.identifier == "toRestaurant" {
////                let vc = segue.destinationViewController as RestaurantViewController
////                vc.data = currentResponse[i] as NSDictionary
////            }
//        }
//    }
    
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
