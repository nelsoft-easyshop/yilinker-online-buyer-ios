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
    
    //Variable for determining what kind of result will be shown
    var targetType: TargetType?
    
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var sortPickerTableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var viewTypeView: UIView!
    @IBOutlet weak var viewTypeImageView: UIImageView!
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var viewTypeLabel: UILabel!
    
    var collectionViewData: [SearchResultModel] = []
    var sortData: [String] = []
    var sortParameter: [String] =
        [ "sortType=BYDATE&sortDirection=ASC"
         ,"sortType=BYDATE&sortDirection=DESC"
         ,"sortType=ALPHABETICAL&sortDirection=ASC"
         ,"sortType=ALPHABETICAL&sortDirection=DESC"]
    
    var filterAtributes: [FilterAttributeModel] = []

    typealias InitialSearchParameters = (targetUrl: String, parameters: NSDictionary!)
    var initialParameters: InitialSearchParameters? = nil

    var searchSuggestion: SearchSuggestionModel!
    
    var fullDimView: UIView?
    
    var hud: MBProgressHUD?
    
    var totalResultCount: Int = -1
    
    var page:Int = 0
    
    var requestSuggestionSearchUrl: String = ""
    var maxPrice: Double = 0
    var minPrice: Double = 0
    
    var errorLocalizeString: String  = ""
    var somethingWrongLocalizeString: String = ""
    var connectionLocalizeString: String = ""
    var connectionMessageLocalizeString: String = ""
    var listLocalizeString: String = ""
    var gridMessageLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.initializeViews()
        self.initializeLocalizedString()
        self.registerNibs()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        fullDimView = UIView(frame: self.view.bounds)
        fullDimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(fullDimView!)
        //self.view.addSubview(dimView!)
        fullDimView?.hidden = true
        fullDimView?.alpha = 0

        
        self.navigationController?.navigationBar.alpha = 1
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    func passSearchKey(key: String) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeLocalizedString() {
        //Initialized Localized String
        errorLocalizeString = StringHelper.localizedStringWithKey("ERROR_LOCALIZE_KEY")
        somethingWrongLocalizeString = StringHelper.localizedStringWithKey("SOMETHINGWENTWRONG_LOCALIZE_KEY")
        connectionLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONUNREACHABLE_LOCALIZE_KEY")
        connectionMessageLocalizeString = StringHelper.localizedStringWithKey("CONNECTIONERRORMESSAGE_LOCALIZE_KEY")
        listLocalizeString = StringHelper.localizedStringWithKey("LIST_LOCALIZE_KEY")
        gridMessageLocalizeString = StringHelper.localizedStringWithKey("GRID_LOCALIZE_KEY")
        
        let oldToNewLocalizeString: String = StringHelper.localizedStringWithKey("OLDTONEW_LOCALIZE_KEY")
        let newToOldLocalizeString: String = StringHelper.localizedStringWithKey("NEWTOOLD_LOCALIZE_KEY")
        let AToZLocalizeString: String = StringHelper.localizedStringWithKey("ATOZ_LOCALIZE_KEY")
        let ZToALocalizeString: String = StringHelper.localizedStringWithKey("ZTOA_LOCALIZE_KEY")
        let filterLocalizeString: String = StringHelper.localizedStringWithKey("SORT_LOCALIZE_KEY")
        let sortLocalizeString: String = StringHelper.localizedStringWithKey("FILTER_LOCALIZE_KEY")
        
        sortData.append(oldToNewLocalizeString)
        sortData.append(newToOldLocalizeString)
        sortData.append(AToZLocalizeString)
        sortData.append(ZToALocalizeString)
        sortPickerTableView.reloadData()
        
        filterLabel.text = filterLocalizeString
        sortLabel.text = sortLocalizeString
        viewTypeLabel.text = listLocalizeString
    }

    func initializeViews() {
        
        var nib = UINib(nibName: "SortTableViewCell", bundle: nil)
        sortPickerTableView.registerNib(nib, forCellReuseIdentifier: "SortTableViewCell")
        
        //Add Nav Bar
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        let resultsLocalizeString: String = StringHelper.localizedStringWithKey("RESULTS_LOCALIZE_KEY")
        self.title = resultsLocalizeString
        
        // Back Button
        let backButton = UIBarButtonItem(title:" ", style:.Plain, target: self, action:"goBack")
        backButton.image = UIImage(named: "back-white")
        //backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
        
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
        
        //self.view.layoutIfNeeded()
        fullDimView = UIView(frame: self.view.bounds)
        fullDimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(fullDimView!)
        //self.view.addSubview(dimView!)
        fullDimView?.hidden = true
        fullDimView?.alpha = 0

        noResultLabel.hidden = true
    }
    
    func goBack(){
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func registerNibs() {
        var cellNibGrid = UINib(nibName: reuseIdentifierGrid, bundle: nil)
        self.resultCollectionView?.registerNib(cellNibGrid, forCellWithReuseIdentifier: reuseIdentifierGrid)
        
        var cellNibList = UINib(nibName: reuseIdentifierList, bundle: nil)
        self.resultCollectionView?.registerNib(cellNibList, forCellWithReuseIdentifier: reuseIdentifierList)
        
        var cellNib = UINib(nibName: reuseIdentifierSeller, bundle: nil)
        self.resultCollectionView?.registerNib(cellNib, forCellWithReuseIdentifier: reuseIdentifierSeller)
    }
    
    func passCategoryID(id: Int) {
        if Reachability.isConnectedToNetwork() {
            requestSuggestionSearchUrl = "\(APIAtlas.productList)?categoryId=\(id)"
            requestSearchDetails("\(APIAtlas.productList)?categoryId=\(id)", params: nil)
        } else {
            showAlert(connectionLocalizeString, message: connectionMessageLocalizeString)
        }
    }
    
    func passModel(searchSuggestion: SearchSuggestionModel) {
        self.searchSuggestion = searchSuggestion
        
        if Reachability.isConnectedToNetwork() {
            requestSuggestionSearchUrl = searchSuggestion.searchUrl
           requestSearchDetails(requestSuggestionSearchUrl, params: nil)
        } else {
            showAlert(connectionLocalizeString, message: connectionMessageLocalizeString)
        }
    }
    
    func requestSearchDetails(url: String, params: NSDictionary!) {
        println("URL \(url)\nPARAMS:\(params)")
        if collectionViewData.count != (totalResultCount + 15){
            println("\(collectionViewData.count) \(totalResultCount)")
            
            page++
            
            if( initialParameters == nil ) {
                initialParameters = (targetUrl: url, parameters: params)
            }
            
            showLoader()
            
            manager.GET(url, parameters: params, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
                
                println(responseObject)
                if responseObject.objectForKey("error") != nil {
                    self.requestRefreshToken(url, params: params)
                } else {
                    self.populateTableView(responseObject)
                }
                }, failure: {
                    (task: NSURLSessionDataTask!, error: NSError!) in
                    self.showAlert(self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                    println(error)
                    self.dismissLoader()
            })
        } else {
            let noMoreLocalizeString: String = StringHelper.localizedStringWithKey("NOMORERESULTS_LOCALIZE_KEY")
            let resultsLocalizeString: String = StringHelper.localizedStringWithKey("RESULTS_LOCALIZE_KEY")
            showAlert(resultsLocalizeString, message: noMoreLocalizeString)
        }
    }
    
    // MARK: Methods Updating Values
    
    func populateTableView(responseObject: AnyObject) {
        if let value: NSDictionary = responseObject["data"] as? NSDictionary{
            
            if let value: AnyObject = value["totalResultCount"] {
                if value as! NSObject != NSNull() {
                    totalResultCount = value as! Int
                }
            }
            
            for subValue in value["products"] as! NSArray {
                println(subValue)
                let model: SearchResultModel = SearchResultModel.parseDataWithDictionary(subValue as! NSDictionary)
                
                self.collectionViewData.append(model)
            }
            
            if let aggregations: AnyObject = value["aggregations"] {
                if aggregations as! NSObject != NSNull() {
                    
                    if let subValue: AnyObject = aggregations["maxPrice"] {
                        if subValue as! NSObject != NSNull() {
                            maxPrice = subValue as! Double
                        }
                    }
                    
                    if let subValue: AnyObject = aggregations["minPrice"] {
                        if subValue as! NSObject != NSNull() {
                            minPrice = subValue as! Double
                        }
                    }
                    
                    if let attributes: AnyObject = aggregations["attributes"] {
                        filterAtributes.removeAll(keepCapacity: false)
                        if attributes as! NSObject != NSNull() {
                            for attribute in attributes as! NSArray {
                                filterAtributes.append(FilterAttributeModel.parseDataWithDictionary(attribute as! NSDictionary))
                            }
                        }
                    }
                }
            }
            
            self.resultCollectionView.reloadSections(NSIndexSet(index: 0))
        }
        self.dismissLoader()
        
        if self.collectionViewData.count == 0 {
            noResultLabel.hidden = false
        }
    }

    
    //Loader function
    func showLoader() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.view.addSubview(self.hud!)
        self.hud?.show(true)
    }
    
    func dismissLoader() {
        self.hud?.hide(true)
    }

    func changeViewType() {
        if type == grid {
            type = list
            viewTypeImageView.image = UIImage(named: "grid")
            viewTypeLabel.text = gridMessageLocalizeString
        } else if type == list {
            type = grid
            viewTypeImageView.image = UIImage(named: "list")
            viewTypeLabel.text = listLocalizeString
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
        attributeModal.passFilter(filterAtributes, maxPrice: maxPrice, minPrice: minPrice)
        attributeModal.maxPrice = maxPrice
        attributeModal.minPrice = minPrice
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        self.fullDimView!.hidden = false
        UIView.animateWithDuration(0.3, animations: {
            self.fullDimView!.alpha = 1
            }, completion: { finished in
        })

    }
    
    func tapViewTypeViewAction() {
        self.changeViewType()
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
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
            cell.setDiscount("\(tempModel.discount)")
            return cell
        } else if type == list {
            let cell: ProductResultListCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierList, forIndexPath: indexPath) as! ProductResultListCollectionViewCell
            var tempModel: SearchResultModel = collectionViewData[indexPath.row]
            cell.setProductImage(tempModel.imageUrl)
            cell.setProductName(tempModel.productName)
            cell.setOriginalPrice(tempModel.originalPrice)
            cell.setNewPrice(tempModel.newPrice)
            cell.setDiscount("\(tempModel.discount)")
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
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        productViewController.tabController = self.tabBarController as! CustomTabBarController
        productViewController.productId = collectionViewData[indexPath.row].id
        
        println("ID \(collectionViewData[indexPath.row].id)")
        self.navigationController?.pushViewController(productViewController, animated: true)
    }

    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortData.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SortTableViewCell", forIndexPath: indexPath) as! SortTableViewCell
    
        cell.detailsLabel?.text = sortData[indexPath.row]
    
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
        })

        page = 0
        collectionViewData.removeAll(keepCapacity: false)
        resultCollectionView.reloadData()
        if Reachability.isConnectedToNetwork() {
            let sortParameterSelection = sortParameter[indexPath.row]
            if initialParameters != nil && initialParameters!.targetUrl != "" {
                requestSuggestionSearchUrl = "\(initialParameters!.targetUrl)&\(sortParameterSelection)"
                NSLog(requestSuggestionSearchUrl)
                requestSearchDetails(requestSuggestionSearchUrl, params: initialParameters!.parameters)
            }/* else {
                let requestSoloSearchUrl = "\(APIAtlas.productList)?\(sortParameterSelection)"
                NSLog(requestSoloSearchUrl)
                requestSearchDetails(requestSoloSearchUrl, params: nil)
            } */
            resultCollectionView.setContentOffset(CGPointZero, animated: true)
        } else {
            showAlert(connectionLocalizeString, message: connectionMessageLocalizeString)
        }
    }
    
    func scrollViewDidEndDragging(aScrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offset: CGPoint = aScrollView.contentOffset
        var bounds: CGRect = aScrollView.bounds
        var size: CGSize = aScrollView.contentSize
        var inset: UIEdgeInsets = aScrollView.contentInset
        var y: CGFloat = offset.y + bounds.size.height - inset.bottom
        var h: CGFloat = size.height
        var reload_distance: CGFloat = 10
        var temp: CGFloat = h + reload_distance
        if y > temp {
            if page == 0{
                page++
            }
            requestSearchDetails(requestSuggestionSearchUrl, params: NSDictionary(dictionary: ["page": page]))
        }
    }
    
    // MARK: - FilterViewControllerDelegate
    func resetFilterViewControllerAction() {
        
    }
    
    func cancelFilterViewControllerAction() {
        hideDimView()
    }
    
    func applyFilterViewControllerAction(maxPrice: Double, minPrice: Double, filters: NSDictionary) {
        hideDimView()
        page = 0
        collectionViewData.removeAll(keepCapacity: false)
        resultCollectionView.reloadData()
        requestSearchDetails(requestSuggestionSearchUrl, params: NSDictionary(dictionary: [
            "priceFrom": minPrice,
            "priceTo": maxPrice,
            "filters": [filters]]))
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let okLocalizeString: String = StringHelper.localizedStringWithKey("OKBUTTON_LOCALIZE_KEY")
        let OKAction = UIAlertAction(title: "okLocalizeString", style: .Default) { (action) in
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
                self.showAlert(self.errorLocalizeString, message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert(self.errorLocalizeString, message: self.somethingWrongLocalizeString)
                
        })
    }
}
