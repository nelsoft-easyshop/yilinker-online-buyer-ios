//
//  ProductViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductViewControllerDelegate {
    func dismissPresentedController(controller: ProductViewController)
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
    
    let manager = APIManager()
    
    var productDetailsModel: ProductDetailsModel!
    var attributes: [ProductAttributeModel] = []
    var combinations: [ProductAvailableAttributeCombinationModel] = []
    var productReviewModel: ProductReviewModel!
    var productSellerModel: ProductSellerModel!
    
    var selectedName: [String] = []
    var selectedValue: [String] = []
    
    var newFrame: CGRect!
    var visibility = 0.0
    var lastContentOffset: CGFloat = 0.0
    
    var reviewRequest = false
    var sellerRquest = false
    var productSuccess = false
    var reviewSuccess = false
    var sellerSuccess = false
    
    var delegate: ProductViewControllerDelegate?
    
    var emptyView: EmptyView?
    
    let productUrl = "https://demo1928934.mockable.io/yi/getproductDetails?productId=1000"
    let reviewUrl = "https://demo5885209.mockable.io/api/v1/product/getReviews?productId=1000"
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "reviewIdentifier")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
//        self.getHeaderView().addSubview(self.getProductImagesView())
//        self.getHeaderView().addSubview(self.getProductDetailsView([]))
//        self.getHeaderView().addSubview(self.getProductAttributeView())
//        self.getHeaderView().addSubview(self.getProductDescriptionView())
//        self.getHeaderView().addSubview(self.getProductReviewHeaderView())
//        
//        self.getFooterView().addSubview(self.getProductReviewFooterView())
//        self.getFooterView().addSubview(self.getProductSellerView())
//        
//        setUpViews()
        
//        self.productImagesView.delegate = self
//        self.productDescriptionView.delegate = self
//        self.productReviewFooterView.delegate = self
//        self.productSellerView.delegate = self

        //
        
        setBorderOf(view: addToCartButton, width: 1, color: .grayColor(), radius: 3)
        setBorderOf(view: buyItNowView, width: 1, color: .grayColor(), radius: 3)
        
        requestProductDetails(productUrl, params: nil)
        requestReviewDetails(reviewUrl, params: nil)
        
        buyItNowView.addGestureRecognizer(tapGesture("buyItNowAction:"))
    }
    
    override func viewWillAppear(animated: Bool) {
        configureNavigationBar()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.alpha = 1.0
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        
        SVProgressHUD.dismiss()
    }
    
    func requestProductDetails(url: String, params: NSDictionary!) {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.clearColor())
        
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.productDetailsModel = ProductDetailsModel.parseDataWithDictionary(responseObject)
            self.attributes = self.productDetailsModel.attributes
            self.combinations = self.productDetailsModel.combinations
            self.populateDetails()
            
            let seller = "https://demo5885209.mockable.io/api/v1/seller/getDetails?sellerId=111"
            self.requestSellerDetails(seller, params: nil)
            
            self.productSuccess = true
            println("product success")
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("product failed")
                self.productSuccess = false
        })
    }
    
    func requestReviewDetails(url: String, params: NSDictionary!) {
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in

            self.productReviewModel = ProductReviewModel.parseDataWithDictionary(responseObject)
            self.reviewRequest = true
            self.reviewSuccess = true
            self.checkRequests()
            println("review success")
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("review failed")
                self.reviewRequest = true
                self.reviewSuccess = false
                self.checkRequests()
        })
    }
    
    func requestSellerDetails(url: String, params: NSDictionary!) {
        
        manager.GET(url, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.productSellerModel = ProductSellerModel.parseDataWithDictionary(responseObject)
            self.sellerRquest = true
            self.sellerSuccess = true
            self.checkRequests()
            println("seller success")
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("seller failed")
                self.sellerRquest = true
                self.sellerSuccess = false
                self.checkRequests()
        })
    }
    
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
        var betweenSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Action, target: nil, action: nil)
        
        wishlist.imageInsets = UIEdgeInsetsMake(0, 0, 0, -75)
        rate.imageInsets = UIEdgeInsetsMake(0, 0, 0, -50)
        message.imageInsets = UIEdgeInsetsMake(0, 0, 0, -25)
        
        self.navigationItem.setLeftBarButtonItem(close, animated: false)
        self.navigationItem.setRightBarButtonItems([share, message, rate, wishlist], animated: true)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if productReviewModel != nil {
            return 2
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("reviewIdentifier") as! ReviewTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
//        cell.frame.size.width = 320
        
        cell.setName(productReviewModel.reviews[indexPath.row].name)
        cell.setDisplayPicture(productReviewModel.reviews[indexPath.row].imageUrl)
        cell.setMessage(productReviewModel.reviews[indexPath.row].message)
        cell.setRating(productReviewModel.reviews[indexPath.row].rating)
        
        return cell
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
        }
        return self.productImagesView
    }
    
    func getProductDetailsView(list: NSArray!) -> UIView {
        if self.productDetailsView == nil {
            self.productDetailsView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, 25))
            self.productDetailsView.backgroundColor = UIColor.whiteColor()
        }
        return self.productDetailsView
    }
    
    func getProductAttributeView() -> UIView {
        if self.productAttributeView == nil {
            println(self.view.frame.size.width)
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
            arrowImageView.image = UIImage(named: "right")
            
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
    
    // MARK: - Functions
    
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
    
    // MARK: - Product View Delegates
    
    func close(controller: ProductImagesView) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func wishlist(controller: ProductImagesView) {
        showAlert("Wishlist")
    }
    
    func rate(controller: ProductImagesView) {
        showAlert("Rate")
    }
    
    func message(controller: ProductImagesView) {
        showAlert("Message")
    }
    
    func seeMoreAttribute(bool: Bool, title: String) {
        var attributeModal = ProductAttributeViewController(nibName: "ProductAttributeViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.backgroundColor = UIColor.clearColor()
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        attributeModal.passModel(productDetailsModel: productDetailsModel, combinationModel: productDetailsModel.combinations, selectedValue: selectedValue)
        attributeModal.showCartCheckout(bool, title: title)
//        self.navigationController?.presentViewController(attributeModal, animated: true, completion: nil)
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
            self.dimView.layer.zPosition = 2
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    func seeMoreDescription(controller: ProductDescriptionView) {
        let description = ProductDescriptionViewController(nibName: "ProductDescriptionViewController", bundle: nil)
        description.url = self.productDetailsModel.fullDescription
//        self.presentViewController(description, animated: true, completion: nil)
        self.tabBarController?.presentViewController(description, animated: true, completion: nil)
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
//        self.navigationController?.presentViewController(reviewModal, animated: true, completion: nil)
        self.tabBarController?.presentViewController(reviewModal, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
            self.dimView.layer.zPosition = 2
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.93)
            self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    func seeMoreSeller(controller: ProductSellerView) {
        showAlert("Go to Seller Page!")
    }
    
    func share(controller: ProductImagesView) {
        shareTextImageAndURL(sharingText: "Sample Text", sharingImage: UIImage(named: "s61"), sharingURL: NSURL(fileURLWithPath: "http://www.Easyshop.ph"))
    }
    
    func shareTextImageAndURL(#sharingText: String?, sharingImage: UIImage?, sharingURL: NSURL?) {
        var sharingItems = [AnyObject]()
        
        if let text = sharingText {
            sharingItems.append(text)
        }
        if let image = sharingImage {
            sharingItems.append(image)
        }
        if let url = sharingURL {
            sharingItems.append(url)
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }
    
    func pressedCancelAttribute(controller: ProductAttributeViewController) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
            self.navigationController?.navigationBar.alpha = CGFloat(self.visibility)
        })
    }
    func pressedDoneAttribute(controller: ProductAttributeViewController) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
            self.navigationController?.navigationBar.alpha = CGFloat(self.visibility)
        })
    }
    
    func pressedCancelReview(controller: ProductReviewViewController) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.dimView.layer.zPosition = -1
            self.navigationController?.navigationBar.alpha = CGFloat(self.visibility)
        })
    }
    
    func populateDetails() {
//        println("POPULATING PRODUCT DETAILS")
//        self.productImagesView.setDetails(productDetailsModel.title, price: productDetailsModel.newPrice, images: [])
//        self.setDetails(productDetailsModel.details)
//        self.setAttributes(productDetailsModel.attributes, combinationModel: productDetailsModel.combinations)
//        self.productDescriptionView.setDescription(productDetailsModel.shortDescription, full: productDetailsModel.fullDescription)
    }
    
    func populateReviews() {
//        println("POPULATING PRODUCT REVIEWS")
//        self.productReviewHeaderView.setRating(self.productReviewModel.rating)
//        self.tableView.reloadData()
    }
    
    func populateSeller() {
        println("POPULATING DETAILS")
        
    }
    
    func loadViewsWithDetails() {
        
        self.buttonsContainer.hidden = false
        
        self.getHeaderView().addSubview(self.getProductImagesView())
        self.getHeaderView().addSubview(self.getProductDetailsView([]))
        self.getHeaderView().addSubview(self.getProductAttributeView())
        self.getHeaderView().addSubview(self.getProductDescriptionView())
        self.getHeaderView().addSubview(self.getProductReviewHeaderView())
        
        self.getFooterView().addSubview(self.getProductReviewFooterView())
        self.getFooterView().addSubview(self.getProductSellerView())
        
        self.productImagesView.setDetails(productDetailsModel.title, price: productDetailsModel.newPrice, images: [])
        self.setDetails(productDetailsModel.details)
        self.setAttributes(productDetailsModel.attributes, combinationModel: productDetailsModel.combinations)
        self.productDescriptionView.setDescription(productDetailsModel.shortDescription, full: productDetailsModel.fullDescription)
        
        self.productReviewHeaderView.setRating(self.productReviewModel.rating)
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
    
    func setAttributes(attributes: [ProductAttributeModel], combinationModel: [ProductAvailableAttributeCombinationModel]) {
        
        var topMargin: CGFloat = 0
        var leftMargin: CGFloat = 0
        var reseter: Int = 0
        var counter: Int = 1
        var labelWidth = (self.view.frame.size.width / 3)
        
        selectedName = []
        selectedValue = []
        selectedName.append("Quantity")
        selectedValue.append(String(combinationModel[0].quantity) + "x")
        
        for i in 0..<attributes.count {
            for j in 0..<attributes[i].valueId.count {
                if combinationModel[0].combination[i] == attributes[i].valueId[j] {
                    selectedName.append(attributes[i].attributeName)
                    selectedValue.append(attributes[i].valueName[j])
                }
            }
        }
        
        for i in 0..<selectedName.count {
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
            
            var attributedCategory = NSMutableAttributedString(string: "\(selectedName[i]): ")
            var font = [NSFontAttributeName : UIFont.boldSystemFontOfSize(14.0)]
            var attributeItem = NSMutableAttributedString(string: selectedValue[i], attributes: font)
            attributedCategory.appendAttributedString(attributeItem)
            
            attributesLabel.attributedText = attributedCategory
            
            self.productAttributeView.addSubview(attributesLabel)
        }
        
        newFrame = self.productAttributeView.frame
        newFrame.size.height = CGFloat(counter * 23) + 60 //60 = height of header + 10 for bottom margin
        self.productAttributeView.frame = newFrame
    }
    
    // MARK: Actions
    
    @IBAction func addToCartAction(sender: AnyObject) {
        seeMoreAttribute(true, title: "ADD TO CART")
    }
    
    func buyItNowAction(gesture: UIGestureRecognizer) {
        seeMoreAttribute(false, title: "PROCEED TO CHECKOUT")
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
    
    func showAlert(text: String) {
        let alertController = UIAlertController(title: "YiLinker", message: text, preferredStyle: .Alert)
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
    
    // Navigation Bar Actions
    
    func barWishlistActon() {
        showAlert("Wishlist")
    }
    
    func gotoAttributes(gesture: UIGestureRecognizer) {
        seeMoreAttribute(true, title: "")
    }
    
    func checkRequests() {
        
        println(productSuccess)
        println(reviewSuccess)
        println(sellerSuccess)
        
        
        if productSuccess && reviewSuccess && sellerSuccess {
            self.loadViewsWithDetails()
        } else if reviewRequest && sellerRquest {
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
    
    func didTapReload() {
        self.requestProductDetails(productUrl, params: nil)
        self.requestReviewDetails(reviewUrl, params: nil)
        self.emptyView?.removeFromSuperview()
    }

    func barCloseAction() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    func barWishlistAction() {
        showAlert("Wishlist")
    }

    func barRateAction() {
        showAlert("Rate")
    }

    func barMessageAction() {
        showAlert("Message")
    }

    func barShareAction() {
        showAlert("Share")
    }
    
}
