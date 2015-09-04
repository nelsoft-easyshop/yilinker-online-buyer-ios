//
//  ResultViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/18/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource, FilterViewControllerDelegate {
    
    let manager = APIManager.sharedInstance
    
    let grid:String = "GRID"
    let list:String = "LIST"
    let seller:String = "SELLER"
    
    let reuseIdentifierGrid: String = "ProductResultGridCollectionViewCell"
    let reuseIdentifierList: String = "ProductResultListCollectionViewCell"
    let reuseIdentifierSeller: String = "SellerResultCollectionViewCell"
    var type: String = "GRID"
    
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var sortPickerTableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var viewTypeView: UIView!
    
    var collectionViewData: [SearchResultModel] = []
    var sortData: [String] = ["Old to new", "New to old", "A to Z", "Z to A"]

    var searchSuggestion: SearchSuggestionModel!
    
    var fullDimView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.registerNibs()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initializeViews() {
        
        var nib = UINib(nibName: "SortTableViewCell", bundle: nil)
        sortPickerTableView.registerNib(nib, forCellReuseIdentifier: "SortTableViewCell")
        
        //Add Nav Bar
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
    
        // Add tap event to Sort View
        var sort = UITapGestureRecognizer(target:self, action:"tapSortViewAction")
        sortView.addGestureRecognizer(sort)
        
        // Add tap event to Sort View
        var filter = UITapGestureRecognizer(target:self, action:"tapFilterViewAction")
        filterView.addGestureRecognizer(filter)

        // Add tap event to Sort View
        var viewType = UITapGestureRecognizer(target:self, action:"tapViewTypeViewAction")
        viewTypeView.addGestureRecognizer(viewType)
        
        //hide dimview
        dimView.alpha = 0
        dimView.hidden = true
        
        fullDimView = UIView(frame: self.view.bounds)
        fullDimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(fullDimView!)
        //self.view.addSubview(dimView!)
        fullDimView?.hidden = true
        fullDimView?.alpha = 0

        
        noResultLabel.hidden = true
    }
    
    func registerNibs() {
        var cellNibGrid = UINib(nibName: reuseIdentifierGrid, bundle: nil)
        self.resultCollectionView?.registerNib(cellNibGrid, forCellWithReuseIdentifier: reuseIdentifierGrid)
        
        var cellNibList = UINib(nibName: reuseIdentifierList, bundle: nil)
        self.resultCollectionView?.registerNib(cellNibList, forCellWithReuseIdentifier: reuseIdentifierList)
        
        var cellNib = UINib(nibName: reuseIdentifierSeller, bundle: nil)
        self.resultCollectionView?.registerNib(cellNib, forCellWithReuseIdentifier: reuseIdentifierSeller)
    }
    
    func passModel(searchSuggestion: SearchSuggestionModel) {
        self.searchSuggestion = searchSuggestion
        
        if Reachability.isConnectedToNetwork() {
           requestSearchDetails(searchSuggestion.searchUrl, params: nil)
        } else {
            showAlert("Connection Unreachable", message: "Cannot retrieve data. Please check your internet connection.")
        }
    }
    
    func requestSearchDetails(url: String, params: NSDictionary!) {
        showLoader()
        
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken(url, params: params)
            } else {
                self.populateTableView(responseObject)
            }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.showAlert("Error", message: "Something went wrong. . .")
                self.dismissLoader()
        })
    }
    
    // MARK: Methods Updating Values
    
    func populateTableView(responseObject: AnyObject) {
        collectionViewData.removeAll(keepCapacity: false)
        if let value: AnyObject = responseObject["data"] {
            for subValue in value["products"] as! NSArray {
                println(subValue)
                let model: SearchResultModel = SearchResultModel.parseDataWithDictionary(subValue as! NSDictionary)
                
                self.collectionViewData.append(model)
            }
            self.resultCollectionView.reloadData()
        }
        self.dismissLoader()
        
        if self.collectionViewData.count == 0 {
            noResultLabel.hidden = false
        }
    }

    
    
    //Loader function
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }

    func changeViewType() {
        if type == grid {
            type = list
        } else if type == list {
            type = seller
        } else {
            type = grid
        }
        self.resultCollectionView?.reloadData()
    }
    
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.fullDimView!.alpha = 0
            }, completion: { finished in
                self.fullDimView!.hidden = true
        })
    }
    
    // Tap Gesture Action
    func tapSortViewAction() {
        println("Sort Tapped!")
        if dimView.hidden {
            UIView.animateWithDuration(0.3, animations: {
                self.dimView.hidden = false
                self.dimView.alpha = 1.0
            })
        } else {
            UIView.animateWithDuration(0.3, animations: {
                 self.dimView.alpha = 0
                }, completion: { finished in
                    self.dimView.hidden = true
            })
        }
    }
    
    func tapFilterViewAction() {
        println("Filter Tapped!")
        var attributeModal = FilterViewController(nibName: "FilterViewController", bundle: nil)
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.delegate = self
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        self.fullDimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.fullDimView!.alpha = 1
            }, completion: { finished in
        })

    }
    
    func tapViewTypeViewAction() {
        println("View Type Tapped!")
        self.changeViewType()
        
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        //#warning Incomplete method implementation -- Return the number of sections
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //#warning Incomplete method implementation -- Return the number of items in the section
        return collectionViewData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if type == grid {
            let cell: ProductResultGridCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierGrid, forIndexPath: indexPath) as! ProductResultGridCollectionViewCell
            var tempModel: SearchResultModel = collectionViewData[indexPath.row]
            cell.setProductImage(tempModel.imageUrl)
            cell.setProductName(tempModel.productName)
            cell.setOriginalPrice(tempModel.originalPrice)
            cell.setNewPrice(tempModel.newPrice)
            return cell
        } else if type == list {
            let cell: ProductResultListCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierList, forIndexPath: indexPath) as! ProductResultListCollectionViewCell
            var tempModel: SearchResultModel = collectionViewData[indexPath.row]
            cell.setProductImage(tempModel.imageUrl)
            cell.setProductName(tempModel.productName)
            cell.setOriginalPrice(tempModel.originalPrice)
            cell.setNewPrice(tempModel.newPrice)
            return cell
        } else{
            let cell: SellerResultCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierSeller, forIndexPath: indexPath) as! SellerResultCollectionViewCell
            return cell
        }
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        if type == grid {
            return CGSize(width: ((screenWidth / 2) - 0.5), height: 185)
        } else if type == list {
            return CGSize(width: screenWidth, height: 120)
        } else {
            return CGSize(width: screenWidth, height: 225)
        }
    }
    // MARK: UICollectionViewDelegate
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return sortData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SortTableViewCell", forIndexPath: indexPath) as! SortTableViewCell
    
    // Configure the cell...
        cell.detailsLabel?.text = sortData[indexPath.row]
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
        })
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - FilterViewControllerDelegate
    func resetFilterViewControllerAction() {
        
    }
    
    func cancelFilterViewControllerAction() {
        hideDimView()
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
    
    func requestRefreshToken(url: String, params: NSDictionary!) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SVProgressHUD.dismiss()
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestSearchDetails(url, params: params)
            } else {
                self.showAlert("Error", message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert("Something went wrong", message: "")
                
        })
    }


}
