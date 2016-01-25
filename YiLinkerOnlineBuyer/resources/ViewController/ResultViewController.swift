//
//  ResultViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/18/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

enum ResultViewType {
    case List
    case Grid
    case Seller
}

struct ResultViewLocalizedString {
    static let resultsLocalizeString: String = StringHelper.localizedStringWithKey("RESULTS_LOCALIZE_KEY")
    static let listLocalizeString: String = StringHelper.localizedStringWithKey("LIST_LOCALIZE_KEY")
    static let gridMessageLocalizeString: String = StringHelper.localizedStringWithKey("GRID_LOCALIZE_KEY")
    static let oldToNewLocalizeString: String = StringHelper.localizedStringWithKey("OLDTONEW_LOCALIZE_KEY")
    static let newToOldLocalizeString: String = StringHelper.localizedStringWithKey("NEWTOOLD_LOCALIZE_KEY")
    static let AToZLocalizeString: String = StringHelper.localizedStringWithKey("ATOZ_LOCALIZE_KEY")
    static let ZToALocalizeString: String = StringHelper.localizedStringWithKey("ZTOA_LOCALIZE_KEY")
    static let filterLocalizeString: String = StringHelper.localizedStringWithKey("FILTER_LOCALIZE_KEY")
    static let sortLocalizeString: String = StringHelper.localizedStringWithKey("SORT_LOCALIZE_KEY")
}

class ResultViewController: UIViewController {
    
    //Cell Identifier
    let reuseIdentifierGrid: String = "ProductResultGridCollectionViewCell"
    let reuseIdentifierList: String = "ProductResultListCollectionViewCell"
    let reuseIdentifierSeller: String = "SellerResultCollectionViewCell"
    
    //IB Views
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var sortPickerTableView: UITableView!
    @IBOutlet weak var dimView: UIView!                         //Dim View for the ActionView
    @IBOutlet weak var resultCollectionView: UICollectionView!
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var viewTypeView: UIView!
    @IBOutlet weak var viewTypeImageView: UIImageView!
    
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var sortLabel: UILabel!
    @IBOutlet weak var viewTypeLabel: UILabel!
    @IBOutlet weak var actionView: UIView!
    
    @IBOutlet weak var actionViewHeight: NSLayoutConstraint!
    
    //Util Views
    var fullDimView: UIView?    //Dim view for filter
    var hud: MBProgressHUD?
    
    //View attribute
    var pageTitle: String = ""
    var isSellerSearch: Bool = false
    var categoryName: String = ""
    
    //Tap gesture for the action views
    var sortTapGesture: UITapGestureRecognizer!
    var filterTapGesture: UITapGestureRecognizer!
    var viewTypeTapGesture: UITapGestureRecognizer!
    
    //Variable for determining what cell will be shown in the collectionview
    var resultViewType: ResultViewType = ResultViewType.Grid
    
    //Variable for determining what kind of result will be shown
    var targetType: TargetType?
    
    //Data to be shown in the result collection view
    var productCollectionViewData: [SearchResultModel] = []
    var sellerCollectionViewData: [SearchSellerModel] = []
    
    //Data to be shown in the sortPickerTableView
    var sortTableViewData: [String] = [
        ResultViewLocalizedString.oldToNewLocalizeString,   //Old to New
        ResultViewLocalizedString.newToOldLocalizeString,   //New to Old
        ResultViewLocalizedString.AToZLocalizeString,       //Alphabetically A-Z
        ResultViewLocalizedString.ZToALocalizeString]       //Alphabetically Z-A
    
    //Sort Parameters selector
    let sortParameter: [String] = [
        "sortType=BYDATE&sortDirection=ASC"             //Old to New
        ,"sortType=BYDATE&sortDirection=DESC"           //New to Old
        ,"sortType=ALPHABETICAL&sortDirection=ASC"      //Alphabetically A-Z
        ,"sortType=ALPHABETICAL&sortDirection=DESC"]    //Alphabetically Z-A
    
    //Parameters
    var baseSearchURL: String = ""      //Base url without the parameters
    var sortType: String = ""
    var maxPrice: Double = 0            //Max price from the server
    var minPrice: Double = 0            //Min price from the server
    var selectedMaxPrice: Double = 0    //Selected max price by the user
    var selectedMinPrice: Double = 0    //Selected min price by the user
    var page: Int = 1                   //Page used for the pagination
    let perPage: Int = 15               //Number of results in each page
    var filtersString: [String] = []    //Generated string based the filter attributes
    var selectedSortTypeIndex: Int = -1
    var filterAtributes: [FilterAttributeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initializeViews()
        self.addBNavBarBackButton()
        self.registerNibs()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.initializeDimView()
        
        if !self.isSellerSearch {
            self.initializeTapGestures()
        } else {
            self.actionViewHeight.constant = 0
        }
        
        if self.targetType == TargetType.TodaysPromo {
            self.baseSearchURL = APIAtlas.todaysPromo
            //todo fire search
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: - Initializations
    func initializeViews() {
        //Add Nav Bar
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        //Set page title's font to Panton
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSForegroundColorAttributeName: UIColor.whiteColor(),
                NSFontAttributeName: UIFont(name: "Panton-Regular", size: 21)!]
        
        //Set Page title
        if self.pageTitle.isEmpty {
            self.title = ResultViewLocalizedString.resultsLocalizeString
        } else {
            self.title = pageTitle
        }
        
        //Hide dimview
        dimView.alpha = 0
        dimView.hidden = true
        self.initializeDimView()
        
        self.noResultLabel.hidden = true
    }
    
    func initializeDimView() {
        fullDimView = UIView(frame: UIScreen.mainScreen().bounds)
        fullDimView?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        self.navigationController?.view.addSubview(fullDimView!)
        fullDimView?.hidden = true
        fullDimView?.alpha = 0
    }
    
    func registerNibs() {
        var nib = UINib(nibName: "SortTableViewCell", bundle: nil)
        self.sortPickerTableView.registerNib(nib, forCellReuseIdentifier: "SortTableViewCell")

        var cellNibGrid = UINib(nibName: reuseIdentifierGrid, bundle: nil)
        self.resultCollectionView?.registerNib(cellNibGrid, forCellWithReuseIdentifier: reuseIdentifierGrid)
        
        var cellNibList = UINib(nibName: reuseIdentifierList, bundle: nil)
        self.resultCollectionView?.registerNib(cellNibList, forCellWithReuseIdentifier: reuseIdentifierList)
        
        var cellNib = UINib(nibName: reuseIdentifierSeller, bundle: nil)
        self.resultCollectionView?.registerNib(cellNib, forCellWithReuseIdentifier: reuseIdentifierSeller)
    }
    
    func addBNavBarBackButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func initializeTapGestures() {
        // Add tap event to Sort View
        sortTapGesture = UITapGestureRecognizer(target:self, action:"tapSortViewAction")
        sortView.addGestureRecognizer(sortTapGesture)
        
        // Add tap event to Sort View
        filterTapGesture = UITapGestureRecognizer(target:self, action:"tapFilterViewAction")
        filterView.addGestureRecognizer(filterTapGesture)
        
        // Add tap event to Sort View
        viewTypeTapGesture = UITapGestureRecognizer(target:self, action:"tapViewTypeViewAction")
        viewTypeView.addGestureRecognizer(viewTypeTapGesture)
    }
    
    //MARK: - Fucntions Pass Details
    func passCategoryID(id: Int) {
        self.baseSearchURL = "\(APIAtlas.productList)?categoryIds=\(id)"
        //Todo fire search
    }
    
    func passCustomCategoryID(id: Int) {
        self.baseSearchURL = "\(APIAtlas.productList)?customCategoryId=\(id)"
        //Todo fire search
    }
    
    func passSellerID(id: String) {
        self.baseSearchURL = "\(APIAtlas.productList)?sellerIds=\(id)"
        //Todo fire search
    }
    
    func passModel(searchSuggestion: SearchSuggestionModel) {
        if self.isSellerSearch {
            self.resultViewType = .Seller
        } else {
            self.resultViewType = .Grid
        }
        
        self.baseSearchURL = searchSuggestion.searchUrl
        self.fireSearch()
    }
    
    //MARK: - Tap Gesture Action Selector
    
    func tapSortViewAction() {
        if self.dimView.hidden {
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
        if self.filterAtributes.count != 0 {
            self.filterView.alpha = 1
            var attributeModal = FilterViewController(nibName: "FilterViewController", bundle: nil)
            attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
            attributeModal.providesPresentationContextTransitionStyle = true
            attributeModal.definesPresentationContext = true
            attributeModal.delegate = self
            attributeModal.passFilter(self.filterAtributes, maxPrice: self.maxPrice, minPrice: self.minPrice)
            attributeModal.maxPrice = self.maxPrice
            attributeModal.minPrice = self.minPrice
            attributeModal.selectedMaxPrice = self.selectedMaxPrice
            attributeModal.selectedMinPrice = self.selectedMinPrice
            self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
            
            self.fullDimView!.hidden = false
            UIView.animateWithDuration(0.3, animations: {
                self.fullDimView!.alpha = 1
                }, completion: { finished in
            })
        }
        
        if !self.dimView.hidden {
            self.tapSortViewAction()
        }
    }
    
    func tapViewTypeViewAction() {
        self.changeViewType()
        
        if !self.dimView.hidden {
            self.tapSortViewAction()
        }
    }
    
    //MARK: - API Requests
    func fireSearch() {
        self.showLoader()
        let url = self.generateSearchURL()
        
        WebServiceManager.fireGetProductSellerListWithUrl(url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            println(responseObject)
            self.dismissLoader()
            if successful {
                if self.isSellerSearch {
                    if (self.sellerCollectionViewData.count % 15) == 0 {
                        self.populateSellerCollectionView(responseObject)
                        self.page++
                    } else {
                        let noMoreLocalizeString: String = StringHelper.localizedStringWithKey("NOMORERESULTS_LOCALIZE_KEY")
                        let resultsLocalizeString: String = StringHelper.localizedStringWithKey("RESULTS_LOCALIZE_KEY")
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: noMoreLocalizeString, title: resultsLocalizeString)
                    }
                } else {
                    if (self.productCollectionViewData.count % 15) == 0 {
                        self.populateProductCollectionView(responseObject)
                        self.page++
                    } else {
                        let noMoreLocalizeString: String = StringHelper.localizedStringWithKey("NOMORERESULTS_LOCALIZE_KEY")
                        let resultsLocalizeString: String = StringHelper.localizedStringWithKey("RESULTS_LOCALIZE_KEY")
                        UIAlertController.displayErrorMessageWithTarget(self, errorMessage: noMoreLocalizeString, title: resultsLocalizeString)
                    }
                }
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    Toast.displayToastWithMessage(Constants.Localized.error, duration: 1.5, view: self.view)
                }
            }
        })
    }
    
    //MARK: - Util Functions
    
    func generateSearchURL() -> String {
        var url: String = self.baseSearchURL
        if self.selectedSortTypeIndex != -1 {
            url = "\(self.baseSearchURL)&\(self.sortParameter[self.selectedSortTypeIndex])"
        }
        
        if self.filtersString.count > 0 {
            url += "&"
            for var i = 0; i < self.filtersString.count; i++ {
                url += self.filtersString[i]
                if (i + 1) != self.filtersString.count {
                    url += "&"
                }
            }
        }
        
        if self.selectedMaxPrice != 0  && self.selectedMinPrice != 0 {
            url += "&priceFrom=\(self.selectedMinPrice)&priceTo=\(self.selectedMaxPrice)"
        }
        
        if page != 0 {
            url += "&page=\(self.page)"
        }
        
        url += "&perPage=\(self.perPage)"
        
        return url
    }
    func populateProductCollectionView(responseObject: AnyObject) {
        self.noResultLabel.hidden = true
        if let value: NSDictionary = responseObject["data"] as? NSDictionary{
            
            for subValue in value["products"] as! NSArray {
                let model: SearchResultModel = SearchResultModel.parseDataWithDictionary(subValue as! NSDictionary)
                self.productCollectionViewData.append(model)
            }
            
            if let aggregations: AnyObject = value["aggregations"] {
                if aggregations as! NSObject != NSNull() {
                    if let subValue: AnyObject = aggregations["maxPrice"] {
                        if subValue as! NSObject != NSNull() {
                            if self.maxPrice == 0{
                                self.maxPrice = subValue as! Double
                                self.selectedMaxPrice = self.maxPrice
                            }
                        }
                    }
                    
                    if let subValue: AnyObject = aggregations["minPrice"] {
                        if subValue as! NSObject != NSNull() {
                            if self.maxPrice == 0{
                                self.minPrice = subValue as! Double
                                self.selectedMinPrice = self.minPrice
                            }
                        }
                    }
                    
                    if let attributes: AnyObject = aggregations["attributes"] {
                        if self.filterAtributes.count == 0 {
                            self.filterAtributes.removeAll(keepCapacity: false)
                            if attributes as! NSObject != NSNull() {
                                for attribute in attributes as! NSArray {
                                    self.filterAtributes.append(FilterAttributeModel.parseDataWithDictionary(attribute as! NSDictionary))
                                }
                            }
                        }
                    }
                }
            }
            
            if self.filterAtributes.count != 0 && self.maxPrice > 0{
                self.filterView.alpha = 1
            } else {
                self.filterView.alpha = 0.5
            }
            
            self.resultCollectionView.reloadSections(NSIndexSet(index: 0))
        }
        self.dismissLoader()
        
        if self.productCollectionViewData.count == 0 {
            self.noResultLabel.hidden = false
        }
    }
    
    func populateSellerCollectionView(responseObject: AnyObject) {
        self.noResultLabel.hidden = true
        for subValue in responseObject["data"]  as! NSArray {
            println(subValue)
            let model: SearchSellerModel = SearchSellerModel.parseDataWithDictionary(subValue as! NSDictionary)
            self.sellerCollectionViewData.append(model)
        }
        
        
        self.dismissLoader()
        self.resultCollectionView.reloadData()
        if self.sellerCollectionViewData.count == 0 {
            noResultLabel.hidden = false
        }
    }
    
    func changeViewType() {
        
        if self.isSellerSearch {
            self.resultViewType = .Seller
            self.viewTypeImageView.image = UIImage(named: "grid")
            self.viewTypeLabel.text = ResultViewLocalizedString.gridMessageLocalizeString
        } else {
            switch self.resultViewType {
            case .Grid :
                self.resultViewType = .List
                self.viewTypeImageView.image = UIImage(named: "grid")
                self.viewTypeLabel.text = ResultViewLocalizedString.gridMessageLocalizeString
            case .List :
                self.resultViewType = .Grid
                self.viewTypeImageView.image = UIImage(named: "list")
                self.viewTypeLabel.text = ResultViewLocalizedString.listLocalizeString
            case .Seller:
                println("Default")
            }
        }
        
        self.resultCollectionView?.reloadData()
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
    
    func hideDimView() {
        UIView.animateWithDuration(0.3, animations: {
            self.fullDimView!.alpha = 0
            }, completion: { finished in
                self.fullDimView!.hidden = true
        })
    }
}

//MARK: - Data source and Delegate
//MARK: -  UICollectionViewDataSource and UICollectionViewDelegate
extension ResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.isSellerSearch {
            return self.sellerCollectionViewData.count
        } else {
            return self.productCollectionViewData.count
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        switch self.resultViewType {
        case .Grid :
            let cell: ProductResultGridCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierGrid, forIndexPath: indexPath) as! ProductResultGridCollectionViewCell
            var tempModel: SearchResultModel = self.productCollectionViewData[indexPath.row]
            cell.setProductImage(tempModel.imageUrl)
            cell.setProductName(tempModel.productName)
            cell.setOriginalPrice(tempModel.originalPrice.formatToPeso())
            cell.setNewPrice(tempModel.newPrice.formatToPeso())
            cell.setDiscount("\(tempModel.discount)")
            return cell
        case .List :
            let cell: ProductResultListCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierList, forIndexPath: indexPath) as! ProductResultListCollectionViewCell
            var tempModel: SearchResultModel = self.productCollectionViewData[indexPath.row]
            cell.setProductImage(tempModel.imageUrl)
            cell.setProductName(tempModel.productName)
            cell.setOriginalPrice(tempModel.originalPrice.formatToPeso())
            cell.setNewPrice(tempModel.newPrice.formatToPeso())
            cell.setDiscount("\(tempModel.discount)")
            return cell

        case .Seller:
            let cell: SellerResultCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifierSeller, forIndexPath: indexPath) as! SellerResultCollectionViewCell
            var tempModel: SearchSellerModel = self.sellerCollectionViewData[indexPath.row]
            cell.sellerNameLabel.text = tempModel.storeName
            cell.specialtyLabel.text = tempModel.specialty
            cell.sellerImageView.sd_setImageWithURL(NSURL(string: tempModel.image), placeholderImage: UIImage(named: "dummy-placeholder"))
            cell.descriptionLabel.text = tempModel.productDescription
            
            for subValue in tempModel.products {
                cell.productIds.append(subValue.productId)
                
                if !subValue.image.isEmpty {
                    cell.productImages.append(subValue.image)
                } else {
                    cell.productImages.append(" ")
                }
            }
            return cell
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        switch self.resultViewType {
        case .Grid :
            return CGSize(width: ((screenWidth / 2) - 0.5), height: 185)
        case .List :
            return CGSize(width: screenWidth, height: 120)
        case .Seller:
            return CGSize(width: screenWidth, height: 225)
        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.isSellerSearch {
            let sellerViewController: SellerViewController = SellerViewController(nibName: "SellerViewController", bundle: nil)
            sellerViewController.sellerId = self.sellerCollectionViewData[indexPath.row].userId
            self.navigationController!.pushViewController(sellerViewController, animated: true)
        } else {
            let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
            productViewController.tabController = self.tabBarController as! CustomTabBarController
            productViewController.productId = self.productCollectionViewData[indexPath.row].id
            self.navigationController?.pushViewController(productViewController, animated: true)
        }
    }
}


//MARK: -  UITableViewDataSource and UITableViewDelegate
extension ResultViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sortTableViewData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SortTableViewCell", forIndexPath: indexPath) as! SortTableViewCell
        cell.detailsLabel?.text = self.sortTableViewData[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0
            }, completion: { finished in
                self.dimView.hidden = true
        })
        
        //Todo when clicked
        self.selectedSortTypeIndex = indexPath.row
        self.page = 1
        self.productCollectionViewData.removeAll(keepCapacity: false)
        self.resultCollectionView.reloadData()
        self.fireSearch()
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
            self.fireSearch()
        }
    }
}

//MARK: - FilterViewControllerDelegate
extension ResultViewController: FilterViewControllerDelegate {
    func resetFilterViewControllerAction() {
        
    }
    
    func cancelFilterViewControllerAction() {
        //TOdo hide dimview
         self.hideDimView()
    }
    
    func applyFilterViewControllerAction(maxPrice: Double, minPrice: Double, filters: NSDictionary) {
        //TOdo hide dimview
        //Set data
        self.hideDimView()
        self.selectedMaxPrice = maxPrice
        self.selectedMinPrice = minPrice
        
        self.page = 1
        self.productCollectionViewData.removeAll(keepCapacity: false)
        self.resultCollectionView.reloadData()
        self.filtersString = []
        for (key, value) in filters {
            if value as! String != "All" {
                self.filtersString.append("attributes[]=\(key)|\(value)")
            }
        }
        
        self.fireSearch()
    }
}