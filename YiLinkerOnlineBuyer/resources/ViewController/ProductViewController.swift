//
//  ProductViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductViewControllerDelegate {
    func pressedDimViewFromProductPage(controller: ProductViewController)
}

class ProductViewController: UIViewController, ProductImagesViewDelegate, ProductDescriptionViewDelegate, ProductReviewFooterViewDelegate, ProductSellerViewDelegate, ProductReviewViewControllerDelegate, ProductAttributeViewControllerDelegate, EmptyViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyItNowView: UIView!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var buttonSubContainer: UIView!
    
    var headerView: UIView!
    var footerView: UIView!
    
    var productImagesView: ProductImagesView!
    var productDetailsView: UIView!
    var productAttributeView: UIView!
    var productDescriptionView: ProductDescriptionView!
    var productReviewHeaderView: ProductReviewHeaderView!
    var productReviewFooterView: ProductReviewFooterView!
    var productSellerView: ProductSellerView!
    
    let manager = APIManager.sharedInstance
    
    var productDetailsModel: ProductDetailsModel!
    var attributes: [ProductAttributeModel] = []
    var combinations: [ProductAvailableAttributeCombinationModel] = []
    var productReviewModel: ProductReviewModel!
    var productSellerModel: ProductSellerModel!
    
    var selectedName: [String] = []
    var selectedValue: [String] = []
    var selectedId: [String] = []

    var unitId: String = "1"
    var productId: String = "0"
    
    var newFrame: CGRect!
    var visibility = 0.0
    var lastContentOffset: CGFloat = 0.0
    
    var productRequest = false
    var reviewRequest = false
    var sellerRequest = false
    
    var productSuccess = false
    var reviewSuccess = false
    var sellerSuccess = false
    
    var delegate: ProductViewControllerDelegate?
    
    var emptyView: EmptyView?
    
    let productUrl = "http://online.api.easydeal.ph/api/v1/product/getProductDetail?productId=12"
    let reviewUrl = "http://online.api.easydeal.ph/api/v1/product/getProductReviews"
    let sellerUrl = "http://online.api.easydeal.ph/api/v1/user/getStoreInfo"
    
    var tabController = CustomTabBarController()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "reviewIdentifier")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
        setBorderOf(view: addToCartButton, width: 1, color: .grayColor(), radius: 3)
        setBorderOf(view: buyItNowView, width: 1, color: .grayColor(), radius: 3)
        
        requestProductDetails(productUrl, params: nil)
        requestReviewDetails(reviewUrl, params: ["productId": "12"])
        
        buyItNowView.addGestureRecognizer(tapGesture("buyItNowAction:"))
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.barTintColor = .whiteColor()
        self.navigationController?.navigationBar.tintColor = .grayColor()
        if self.productDetailsModel == nil {
            configureNavigationBar()
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController?.navigationBar.alpha = 1.0
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent        
        SVProgressHUD.dismiss()
        
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Table View Data Source and Delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productReviewModel != nil && productReviewModel.reviews.count > 1 {
            return 2
        } else if productReviewModel != nil && productReviewModel.reviews.count < 2 {
            return productReviewModel.reviews.count
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("reviewIdentifier") as! ReviewTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None

        cell.nameLabel.text = productReviewModel.reviews[indexPath.row].fullName
        cell.setDisplayPicture(productReviewModel.reviews[indexPath.row].profileImageUrl)
        cell.setRating(productReviewModel.reviews[indexPath.row].rating)
        cell.messageLabel.text = productReviewModel.reviews[indexPath.row].review
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if cell.respondsToSelector("setSeparatorInset:") {
            cell.separatorInset = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setLayoutMargins:") {
            cell.layoutMargins = UIEdgeInsetsZero
        }
        if cell.respondsToSelector("setPreservesSuperviewLayoutMargins:") {
            cell.preservesSuperviewLayoutMargins = false
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        if self.lastContentOffset > scrollView.contentOffset.y && scrollView.contentOffset.y <= 140.0 { // hide
            if visibility >= 0.0 && visibility <= 1.0 {
                visibility -= Double(scrollView.contentOffset.y / 14) * 0.005
            }
        } else if self.lastContentOffset < scrollView.contentOffset.y && scrollView.contentOffset.y >= 140.0 { // show
            if  visibility <= 1.0 && visibility >= 0.0 {
                visibility += Double(scrollView.contentOffset.y / 14) * 0.005
            }
        }
        
        if visibility > 1.0 {
            visibility = 1.0
        } else if visibility < 0.0 {
            visibility = 0.0
        }
        
        // reached top or bottom
        
        if scrollView.contentOffset.y <= 0.0 {
            visibility = 0.0
        } else if scrollView.contentOffset.y + scrollView.frame.size.height == scrollView.contentSize.height {
            visibility = 1.0
        }
        
        self.navigationController?.navigationBar.alpha = CGFloat(visibility)
        self.lastContentOffset = scrollView.contentOffset.y
    }
    
    // MARK: - Init Views
    
    func getHeaderView() -> UIView {
        if self.headerView == nil {
            self.headerView = UIView(frame: CGRectZero)
            self.headerView.autoresizesSubviews = false
        }
        return self.headerView
    }
    
    func getFooterView() -> UIView {
        if self.footerView == nil {
            self.footerView = UIView(frame: CGRectZero)
            self.footerView.autoresizesSubviews = false
        }
        return self.footerView
    }
    
    func getProductImagesView() -> ProductImagesView {
        if self.productImagesView == nil {
            self.productImagesView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 0) as! ProductImagesView
            self.productImagesView.frame.size.width = self.view.frame.size.width
            self.productImagesView.frame.size.height = self.view.frame.size.height - 114
        }
        return self.productImagesView
    }
    
    func getProductDetailsView() -> UIView {
        if self.productDetailsView == nil {
            self.productDetailsView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 25))
            self.productDetailsView.backgroundColor = UIColor.whiteColor()
        }
        return self.productDetailsView
    }
    
    func getProductAttributeView() -> UIView {
        if self.productAttributeView == nil {
            self.productAttributeView = UIView(frame: CGRectMake(0, 41, self.view.frame.size.width, 50))
            self.productAttributeView.backgroundColor = .whiteColor()
            
            var titleLabel = UILabel(frame: CGRectMake(8, 0, self.productAttributeView.frame.size.width - 16, 40))
            titleLabel.text = "Details"
            titleLabel.font = UIFont.systemFontOfSize(16.0)
            titleLabel.textColor = UIColor.darkGrayColor()
            titleLabel.userInteractionEnabled = true
            
            var tap = UITapGestureRecognizer()
            tap.numberOfTapsRequired = 1
            tap.addTarget(self, action: "gotoAttributes:")
            titleLabel.addGestureRecognizer(tap)
            
            var arrowImageView = UIImageView(frame: CGRectMake(self.productAttributeView.frame.size.width - 20, 11.5, 9, 17))
            arrowImageView.image = UIImage(named: "right-gray")
            
            var separatorView = UIView(frame: CGRectMake(0, 41, self.view.frame.size.width, 1))
            separatorView.backgroundColor = .lightGrayColor()
            
            self.productAttributeView.addSubview(titleLabel)
            self.productAttributeView.addSubview(arrowImageView)
            self.productAttributeView.addSubview(separatorView)
        }
        return self.productAttributeView
    }
    
    func getProductDescriptionView() -> ProductDescriptionView {
        if self.productDescriptionView == nil {
            self.productDescriptionView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 1) as! ProductDescriptionView
            self.productDescriptionView.frame.size.width = self.view.frame.size.width
            
            var seeMoreLabel = UILabel(frame: CGRectMake(0, 0, 90, 41))
            seeMoreLabel.text = "SEE MORE"
            seeMoreLabel.textColor = .blueColor()
            seeMoreLabel.font = UIFont.systemFontOfSize(15.0)
            seeMoreLabel.textAlignment = .Center
            
            var seeMoreImageView = UIImageView(frame: CGRectMake(seeMoreLabel.frame.size.width, (seeMoreLabel.frame.size.height / 2) - 6, 8, 12))
            seeMoreImageView.image = UIImage(named: "seeMore")
            seeMoreLabel.addSubview(seeMoreImageView)
            
            seeMoreLabel.center.x = self.view.center.x - 5
            self.productDescriptionView.seeMoreView.addSubview(seeMoreLabel)
        }
        return self.productDescriptionView
    }
    
    func getProductReviewHeaderView() -> ProductReviewHeaderView {
        if self.productReviewHeaderView == nil {
            self.productReviewHeaderView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 2) as! ProductReviewHeaderView
            self.productReviewHeaderView.frame.size.width = self.view.frame.size.width
        }
        return self.productReviewHeaderView
    }
    
    func getProductReviewFooterView() -> ProductReviewFooterView {
        if self.productReviewFooterView == nil {
            self.productReviewFooterView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 3) as! ProductReviewFooterView
            self.productReviewFooterView.frame.size.width = self.view.frame.size.width
            
            var seeMoreLabel = UILabel(frame: self.productReviewFooterView.frame)
            seeMoreLabel.frame.size.width = 90
            seeMoreLabel.text = "SEE MORE"
            seeMoreLabel.textColor = .blueColor()
            seeMoreLabel.font = UIFont.systemFontOfSize(15.0)
            seeMoreLabel.textAlignment = .Center
            
            var seeMoreImageView = UIImageView(frame: CGRectMake(seeMoreLabel.frame.size.width, (seeMoreLabel.frame.size.height / 2) - 6, 8, 12))
            seeMoreImageView.image = UIImage(named: "seeMore")
            seeMoreLabel.addSubview(seeMoreImageView)
            
            seeMoreLabel.center.x = self.view.center.x - 5
            self.productReviewFooterView.addSubview(seeMoreLabel)
        }
        return self.productReviewFooterView
    }
    
    func getProductSellerView() -> ProductSellerView {
        if self.productSellerView == nil {
            self.productSellerView = XibHelper.puffViewWithNibName("ProductViewsViewController", index: 4) as! ProductSellerView
            self.productSellerView.frame.size.width = self.view.frame.size.width
        }
        return self.productSellerView
    }
    
    // MARK: - Requests
    
    func requestProductDetails(url: String, params: NSDictionary!) {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        
        manager.GET(self.productUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.productDetailsModel = ProductDetailsModel.parseDataWithDictionary(responseObject)
            self.productId = self.productDetailsModel.id

            self.attributes = self.productDetailsModel.attributes
            self.requestSellerDetails(self.sellerUrl, params: ["userId": self.productDetailsModel.sellerId])
            
            self.productRequest = true
            self.productSuccess = true
            self.checkRequests()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("product failed")
                self.productRequest = true
                self.productSuccess = false
                self.checkRequests()
        })
    }
    
    func requestReviewDetails(url: String, params: NSDictionary!) {
        manager.POST(self.reviewUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.productReviewModel = ProductReviewModel.parseDataWithDictionary(responseObject)
            self.reviewRequest = true
            self.reviewSuccess = true
            self.checkRequests()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("review failed")
                self.reviewRequest = true
                self.reviewSuccess = false
                self.checkRequests()
        })
    }
    
    func requestSellerDetails(url: String, params: NSDictionary!) {
        
        manager.POST(self.sellerUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.productSellerModel = ProductSellerModel.parseDataWithDictionary(responseObject)
            self.sellerRequest = true
            self.sellerSuccess = true
            self.checkRequests()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("seller failed")
                self.sellerRequest = true
                self.sellerSuccess = false
                self.checkRequests()
        })
    }
    
    func requestUpdateWishlistItem() {
        
        SVProgressHUD.show()
        let manager = APIManager.sharedInstance
        let params = ["access_token": SessionManager.accessToken(),
            "productId": self.productId,
            "unitId": self.unitId,
            "quantity": "1",
            "wishlist": "true"]

        manager.POST("http://online.api.easydeal.ph/api/v1/auth/cart/updateCartItem", parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            var data: NSDictionary = responseObject["data"] as! NSDictionary
            var items: NSArray = data["items"] as! NSArray
            
            if (responseObject["isSuccessful"] as! Bool) {
                self.addWishlistBadge(items.count)
                self.showAlert(title: nil, message: "This item has been added to your wishlist")
            } else {
                self.showAlert(title: "Error", message: responseObject["message"] as! String)
            }
            
            SVProgressHUD.dismiss()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.requestRefreshToken()
                } else {
                    println(error)
                    SVProgressHUD.dismiss()
                }
        })
    }
    
    func requestRefreshToken() {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SVProgressHUD.dismiss()
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            self.requestUpdateWishlistItem()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert(title: "Something went wrong", message: nil)
                
        })
    }
    
    // MARK: - Methods
    
    func configureNavigationBar() {
        self.navigationController?.navigationBar.alpha = 0
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.Default
        self.navigationController?.navigationBar.barTintColor = .whiteColor()
        self.navigationController?.navigationBar.tintColor = .grayColor()
        
        //        let close = UIBarButtonItem(image: img.image, style: .Plain, target: self, action: "barCloseAction")
        let close = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "barCloseAction")
        let wishlist = UIBarButtonItem(image: UIImage(named: "wishlist"), style: .Plain, target: self, action: "barWishlistAction")
        let rate = UIBarButtonItem(image: UIImage(named: "rating"), style: .Plain, target: self, action: "barRateAction")
        let message = UIBarButtonItem(image: UIImage(named: "msg"), style: .Plain, target: self, action: "barMessageAction")
        let share = UIBarButtonItem(image: UIImage(named: "share"), style: .Plain, target: self, action: "barShareAction")
        let negativeSpacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        negativeSpacer.width = -10
        
        self.navigationItem.setLeftBarButtonItem(close, animated: false)
        self.navigationItem.setRightBarButtonItems([share, negativeSpacer, message, negativeSpacer, rate, negativeSpacer, wishlist], animated: true)
    }
    
    func setUpViews() {
        self.setPosition(self.productDetailsView, from: self.productImagesView)
        self.setPosition(self.productAttributeView, from: self.productDetailsView)
        self.setPosition(self.productDescriptionView, from: self.productAttributeView)
        self.setPosition(self.productReviewHeaderView, from: self.productDescriptionView)
        self.setPosition(self.productSellerView, from: self.productReviewFooterView)
        
        newFrame = self.headerView.frame
        newFrame.size.height = CGRectGetMaxY(self.productReviewHeaderView.frame)
        self.headerView.frame = newFrame
        
        newFrame = self.footerView.frame
        newFrame.size.height = CGRectGetMaxY(self.productSellerView.frame)
        self.footerView.frame = newFrame
        
        self.tableView.tableFooterView = nil
        self.tableView.tableFooterView = self.footerView
        self.tableView.tableHeaderView = nil
        self.tableView.tableHeaderView = self.headerView
    }
    
    func setPosition(view: UIView!, from: UIView!) {
        newFrame = view.frame
        newFrame.origin.y = CGRectGetMaxY(from.frame) + 20
        view.frame = newFrame
    }
    
    func setBorderOf(#view: AnyObject, width: CGFloat, color: UIColor, radius: CGFloat) {
        view.layer.borderWidth = width
        view.layer.borderColor = color.CGColor
        view.layer.cornerRadius = radius
    }
    
    func loadViewsWithDetails() {
        
        self.tableView.hidden = false
        self.buttonsContainer.hidden = false
        
        self.getHeaderView().addSubview(self.getProductImagesView())
        self.getHeaderView().addSubview(self.getProductDetailsView())
        self.getHeaderView().addSubview(self.getProductAttributeView())
        self.getHeaderView().addSubview(self.getProductDescriptionView())
        self.getHeaderView().addSubview(self.getProductReviewHeaderView())
        
        self.getFooterView().addSubview(self.getProductReviewFooterView())
        self.getFooterView().addSubview(self.getProductSellerView())
        
        self.productImagesView.setDetails(self.productDetailsModel, unitId: unitId.toInt()!, width: self.view.frame.size.width)
        //        self.setDetails(productDetailsModel.details)
        self.setDetails(["Free Shipping"])
        self.setAttributes(self.productDetailsModel.attributes, productUnits: self.productDetailsModel.productUnits, unitId: "1", quantity: 0)
        self.productDescriptionView.setDescription(productDetailsModel.shortDescription, full: productDetailsModel.fullDescription)
        
        self.productReviewHeaderView.setRating(self.productReviewModel.ratingAverage)
        self.tableView.reloadData()
        
        self.productSellerView.setSellerDetails(self.productSellerModel)
        
        setUpViews()
        
        self.productImagesView.delegate = self
        self.productDescriptionView.delegate = self
        self.productReviewFooterView.delegate = self
        self.productSellerView.delegate = self
        
        SVProgressHUD.dismiss()
    }
    
    func setDetails(list: NSArray) {
        var topMargin: CGFloat = 0
        
        for i in 0..<list.count {
            
            topMargin = CGFloat(i * 25) + 10
            
            var label = UILabel(frame: CGRectMake(43, topMargin, self.productDetailsView.frame.size.width - 50, 25))
            label.text = list[i] as? String
            label.textColor = Constants.Colors.productDetails
            label.font = UIFont(name: label.font.fontName, size: 13)
            
            topMargin = CGFloat(i * 25) + 14
            
            var imageView = UIImageView(frame: CGRectMake(17, topMargin, 17, 17))
            imageView.image = UIImage(named: "check")
            
            self.productDetailsView.addSubview(imageView)
            self.productDetailsView.addSubview(label)
        }
        
        newFrame = self.productDetailsView.frame
        newFrame.size.height = CGFloat(self.productDetailsView.frame.size.height * CGFloat(list.count)) + 20
        self.productDetailsView.frame = newFrame
    }
    
    func setAttributes(attributes: [ProductAttributeModel], productUnits: [ProductUnitsModel], unitId: String, quantity: Int) {
        
        for view in self.productAttributeView.subviews {
            if view is UILabel {
                let label: UILabel = view as! UILabel
                if label.text != "Details" {
                    view.removeFromSuperview()
                }
            }
        }
        
        selectedName = []
        selectedValue = []
        selectedId = []
        //        selectedName.append("Quantity")
        //        selectedValue.append(String(combinationModel[0].quantity) + "x")
        
        let index: Int = unitId.toInt()! - 1
        println(index)
        for i in 0..<attributes.count {
            for j in 0..<attributes[i].valueId.count {
                if productUnits[index].combination[i] == attributes[i].valueId[j] {
                    selectedName.append(attributes[i].attributeName)
                    selectedId.append(attributes[i].valueId[j])
                    selectedValue.append(attributes[i].valueName[j])
                }
            }
        }
        
        var tempSelectedName: [String] = ["Quantity"]
        var tempSelectedValue: [String] = [String(quantity) + "x"]
        var tempSelectedId: [String] = [""]
        
        for i in 0..<self.selectedName.count {
            tempSelectedName.append(selectedName[i])
            tempSelectedValue.append(selectedValue[i])
        }
        
        if quantity == 0 {
            createAttributesLabel(selectedName.count, name: selectedName, value: selectedValue)
        } else if quantity > 0 {
            createAttributesLabel(selectedName.count + 1, name: tempSelectedName, value: tempSelectedValue)
        } else {
            println("ProductViewController - setAttributes")
        }
    }
    
    func createAttributesLabel(numberOfAttributes: Int, name: NSArray, value: NSArray) {
        var topMargin: CGFloat = 0
        var leftMargin: CGFloat = 0
        var reseter: Int = 0
        var counter: Int = 1
        var labelWidth = (self.view.frame.size.width / 3)
        
        for i in 0..<numberOfAttributes {
            if i % 3 == 0 && i != 0 {
                topMargin += 23
                reseter = 0
                counter += 1
            }
            
            leftMargin = CGFloat(reseter * Int(labelWidth))
            reseter += 1
            
            var attributesLabel = UILabel(frame: CGRectMake(leftMargin + 10, topMargin + 50, labelWidth - 12, 23))
            attributesLabel.font = UIFont.systemFontOfSize(14.0)
            attributesLabel.textColor = .grayColor()
            
            var attributedCategory = NSMutableAttributedString(string: "\(name[i]): ")
            var font = [NSFontAttributeName : UIFont.boldSystemFontOfSize(14.0)]
            var attributeItem = NSMutableAttributedString(string: value[i] as! String, attributes: font)
            attributedCategory.appendAttributedString(attributeItem)
            
            attributesLabel.attributedText = attributedCategory
            
            self.productAttributeView.addSubview(attributesLabel)
        }
        
        newFrame = self.productAttributeView.frame
        newFrame.size.height = CGFloat(counter * 23) + 60 //60 = height of header + 10 for bottom margin
        self.productAttributeView.frame = newFrame
        
        setUpViews()
    }
    
    func checkRequests() {
        
        if productSuccess && reviewSuccess && sellerSuccess {
            self.loadViewsWithDetails()
        } else if productRequest && reviewRequest && sellerRequest {
            if productSuccess == false || reviewSuccess == false || sellerSuccess == false {
                addEmptyView()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.emptyView!.delegate = self
        self.view.addSubview(self.emptyView!)
    }
    
    func addWishlistBadge(items: Int) {
        let badgeValue = (self.tabController.tabBar.items![3] as! UITabBarItem).badgeValue?.toInt()
        (self.tabController.tabBar.items![3] as! UITabBarItem).badgeValue = String(items)
    }

    // MARK: - Product View Delegate
    
    func close(controller: ProductImagesView) {
        self.barCloseAction()
    }
    
    func wishlist(controller: ProductImagesView) {
        self.barWishlistAction()
    }
    
    func rate(controller: ProductImagesView) {
        self.barRateAction()
    }
    
    func message(controller: ProductImagesView) {
        self.barMessageAction()
    }
    
    func share(controller: ProductImagesView) {
        self.barShareAction()
    }
    
    func seeMoreAttribute(title: String) {
        var attributeModal = ProductAttributeViewController(nibName: "ProductAttributeViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.backgroundColor = UIColor.clearColor()
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        attributeModal.passModel(productDetailsModel: productDetailsModel, selectedValue: selectedValue, selectedId: selectedId, unitId: unitId.toInt()!)
        attributeModal.setTitle = title
        attributeModal.tabController = self.tabController
        attributeModal.screenWidth = self.view.frame.width
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
            self.dimView.layer.zPosition = 2
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    // MARK: - Product Description Delegate
    
    func seeMoreDescription(controller: ProductDescriptionView) {
        let description = ProductDescriptionViewController(nibName: "ProductDescriptionViewController", bundle: nil)
        description.url = self.productDetailsModel.fullDescription
        self.tabBarController?.presentViewController(description, animated: true, completion: nil)
    }
    
    // MARK: - Product Attribute Delegate
    
    func dissmissAttributeViewController(controller: ProductAttributeViewController, type: String) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
            self.navigationController?.navigationBar.alpha = CGFloat(self.visibility)
            }, completion: { finished in
                if type == "cart" {
                    self.showAlert(title: nil, message: "This item has been added to your cart.")
                    self.loadViewsWithDetails()
                } else if type == "done" {
//                    self.showAlert(type)
                }
            })

    }
    
    func doneActionPassDetailsToProductView(controller: ProductAttributeViewController, unitId: String, quantity: Int, selectedId: NSArray) {
        self.unitId = unitId
        self.selectedId = selectedId as! [String]
        self.setAttributes(self.productDetailsModel.attributes, productUnits: self.productDetailsModel.productUnits, unitId: unitId, quantity: quantity)
    }

    func gotoCheckoutFromAttributes(controller: ProductAttributeViewController) {
        if SessionManager.isLoggedIn() {
            let checkout = CheckoutContainerViewController(nibName: "CheckoutContainerViewController", bundle: nil)
            let navigationController: UINavigationController = UINavigationController(rootViewController: checkout)
            navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
            self.tabBarController?.presentViewController(navigationController, animated: true, completion: nil)
        } else {
            let checkout = GuestCheckoutContainerViewController(nibName: "GuestCheckoutContainerViewController", bundle: nil)
            //self.navigationController?.pushViewController(checkout, animated: true)
            let navigationController: UINavigationController = UINavigationController(rootViewController: checkout)
            navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
            self.tabBarController?.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    // MARK: - Product Review Delegate
    
    func pressedCancelReview(controller: ProductReviewViewController) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
            self.navigationController?.navigationBar.alpha = CGFloat(self.visibility)
        })
    }
    
    func seeMoreReview(controller: ProductReviewFooterView) {
        var reviewModal = ProductReviewViewController(nibName: "ProductReviewViewController", bundle: nil)
        reviewModal.delegate = self
        reviewModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        reviewModal.providesPresentationContextTransitionStyle = true
        reviewModal.definesPresentationContext = true
        reviewModal.view.backgroundColor = UIColor.clearColor()
        reviewModal.view.frame.origin.y = reviewModal.view.frame.size.height
        reviewModal.passModel(self.productReviewModel)
        self.tabBarController?.presentViewController(reviewModal, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
            self.dimView.layer.zPosition = 2
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.93)
            self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    // MARK: - Product Seller Delegate
    
    func seeMoreSeller(controller: ProductSellerView) {
        let seller = SellerViewController(nibName: "SellerViewController", bundle: nil)
        self.navigationController?.pushViewController(seller, animated: true)
    }
    
    // MARK: Actions
    
    @IBAction func addToCartAction(sender: AnyObject) {
        seeMoreAttribute("cart")
        
    }
    
    func buyItNowAction(gesture: UIGestureRecognizer) {
        seeMoreAttribute("buy")
    }
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func tapGesture(action: Selector) -> UITapGestureRecognizer {
        var tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        
        return tap
    }
    
    func gotoAttributes(gesture: UIGestureRecognizer) {
        seeMoreAttribute("")
    }
    
    func didTapReload() {
        self.requestProductDetails(productUrl, params: nil)
        self.requestReviewDetails(reviewUrl, params: nil)
        self.emptyView?.removeFromSuperview()
    }
    
    // MARK: - Navigation Bar Actions

    func barCloseAction() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    func barWishlistAction() {
        if SessionManager.isLoggedIn() {
            requestUpdateWishlistItem()
        } else {
            showAlert(title: "Failed", message: "Please logged-in to add item in your wishlist.")
        }
    }

    func barRateAction() {
        showAlert(title: "Coming Soon", message: nil)
    }

    func barMessageAction() {
        showAlert(title: "Go to Messaging", message: nil)
    }

    func barShareAction() {
        var sharingItems = [AnyObject]()
        sharingItems.append("Sample Caption" + "\n")
        sharingItems.append(NSURL(string: "http://online.api.easydeal.ph/")!)
        
        let shareViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(shareViewController, animated: true, completion: nil)
    }
    
}