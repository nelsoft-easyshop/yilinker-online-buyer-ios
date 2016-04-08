//
//  ProductViewController2.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 4/6/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductViewController2: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, ProductHeaderTableViewCellDataSource, ProductHeaderTableViewCellDelegate {
    
    @IBOutlet weak var topSpaceConstraint: NSLayoutConstraint!
    
    let NAVBAR_CHANGE_POINT: CGFloat = 50
    
    @IBOutlet weak var tableView: UITableView!
    
    
    var productHeaderView: ProductHeaderTableViewCell = ProductHeaderTableViewCell()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tableView.delegate = self
        self.scrollViewDidScroll(self.tableView)
        self.navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.tableView.delegate = nil
        self.navigationController!.navigationBar.lt_reset()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.topSpaceConstraint.constant = -70
        self.navigationController?.navigationBar.lt_setBackgroundColor(UIColor.clearColor())
    
        self.navigationBarItemsWithColor(UIColor.darkGrayColor())
        
        self.registerNibWithNibName(ProductHeaderTableViewCell.nibNameAndIdentifier())
        
        
        self.tableView.tableHeaderView = self.headerView()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 
    //MARK: - Header View
    func headerView() -> ProductHeaderTableViewCell {
        self.productHeaderView = self.tableView.dequeueReusableCellWithIdentifier(ProductHeaderTableViewCell.nibNameAndIdentifier()) as! ProductHeaderTableViewCell
        self.productHeaderView.delegate = self
        self.productHeaderView.dataSource = self

        return self.productHeaderView
    }
    
    //MARK: - 
    //MARK: - Register Nib
    func registerNibWithNibName(nibName: String) {
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: nibName)
    }
    
    //MARK: - 
    //MARK: - Navigation Bar Items
    func navigationBarItemsWithColor(color: UIColor) {
        var shareProductButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "share"), style: .Plain, target: self, action: "shareProduct")
        shareProductButton.tintColor = color
        
        var messageSellerButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "msg"), style: .Plain, target: self, action: "messageSeller")
        messageSellerButton.tintColor = color
        
        var wishlistButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "wishlist"), style: .Plain, target: self, action: "addToWishList")
        wishlistButton.tintColor = color
        
        self.navigationItem.rightBarButtonItems = [shareProductButton, messageSellerButton, wishlistButton]
        
        var backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-white"), style: .Plain, target: self, action: "back")
        backButton.tintColor = color
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        
        navigationSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
        
    }
    
    //MARK: - 
    //MARK: - Navigation Bar Rounded Items
    func navigationBarRoundedItems() {
        let shareProductButton: UIButton = self.buttonItemWithImage("share", action: "shareProduct")
        let shareButtonItem: UIBarButtonItem = self.convertButtonToButtonItem(shareProductButton)
        
        let messageSellerButton: UIButton = self.buttonItemWithImage("msg", action: "messageSeller")
        let messageSellerButtonItem: UIBarButtonItem = self.convertButtonToButtonItem(messageSellerButton)
        
        let wishlistButton: UIButton = self.buttonItemWithImage("wishlist", action: "addToWishList")
        let wishlistButtonItem: UIBarButtonItem = self.convertButtonToButtonItem(wishlistButton)
        
        let backButton: UIButton = self.buttonItemWithImage("back-white", action: "back")
        let backButtonItem: UIBarButtonItem = self.convertButtonToButtonItem(backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        
        navigationSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButtonItem]
        self.navigationItem.rightBarButtonItems = [shareButtonItem, messageSellerButtonItem, wishlistButtonItem]
    }
    
    //MARK: -
    //MARK: - Add To Wish List
    func addToWishList() {
        
    }
    
    //MARK: -
    //MARK: - MessageSeller
    func messageSeller() {
        
    }
    
    //MARK: -
    //MARK: - Share Product
    func shareProduct() {
        
    }
    
    //MARK: -
    //MARK: -  Back
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    //MARK: - 
    //MARK: - Table View Data Source
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    //MARK: - 
    //MARK: - Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        var color: UIColor = Constants.Colors.appTheme
        
        var offsetY: CGFloat = scrollView.contentOffset.y
        
        if offsetY > NAVBAR_CHANGE_POINT {
            var alpha: CGFloat = min(1, 1 - ((NAVBAR_CHANGE_POINT + 64 - offsetY) / 64))
            self.navigationController!.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(alpha))
            self.navigationBarItemsWithColor(UIColor.whiteColor())
        }
        else {
            self.navigationController!.navigationBar.lt_setBackgroundColor(color.colorWithAlphaComponent(0))
            self.navigationBarRoundedItems()
        }

    }
    
    //MARK: - 
    //MARK: - Bar Button Item
    func buttonItemWithImage(imageName: String, action: Selector) -> UIButton {
        var image: UIImage = UIImage(named: imageName)!
        var buttonFrame: CGRect = CGRectMake(0, 0, 40, 40)
        var button: UIButton = UIButton(frame: buttonFrame)
        button.setImage(image, forState: .Normal)
        button.backgroundColor = HexaColor.colorWithHexa(0xE1E1E1)
        button.layer.cornerRadius = 20
        
        button.tintColor = UIColor.darkGrayColor()
        button.imageEdgeInsets = UIEdgeInsetsMake(30, 30, 30, 30)
        button.addTarget(self, action: action, forControlEvents: UIControlEvents.TouchUpInside)
        return button
    }
    
    //MARK: - 
    //MARK: - Convert Button To Button Item
    func convertButtonToButtonItem(button: UIButton) -> UIBarButtonItem {
        return UIBarButtonItem(customView: button)
    }
    
    
    //MARK: -
    //MARK: - Product Header Table View Cell Delegate
    func productHeaderTableViewCell(productHeaderTableViewCell: ProductHeaderTableViewCell, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func productHeaderTableViewCell(productHeaderTableViewCell: ProductHeaderTableViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell {
        
        return self.fullImageCollectionViewCellWithIndexPath(indexPath, fullImageCollectionView: productHeaderTableViewCell.collectionView)
    }
    
    func cellItemWidth(productHeaderTableViewCell: ProductHeaderTableViewCell) -> CGFloat {
        self.view.layoutIfNeeded()
        return self.view.frame.size.width
    }
    
    //MARK: -
    //MARK: - Product Header Table View Cell Delegate
    func productHeaderTableViewCell(productHeaderTableViewCell: ProductHeaderTableViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    //MARK: -
    //MARK: - Full Image Collection View Cell
    func fullImageCollectionViewCellWithIndexPath(indexPath: NSIndexPath, fullImageCollectionView: UICollectionView) -> FullImageCollectionViewCell {
        let fullImageCollectionViewCell: FullImageCollectionViewCell = fullImageCollectionView.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
        
            fullImageCollectionViewCell.target = ""
            fullImageCollectionViewCell.targetType = ""
            
            fullImageCollectionViewCell.itemProductImageView.sd_setImageWithURL(StringHelper.convertStringToUrl("https://s-media-cache-ak0.pinimg.com/736x/08/f8/14/08f81496669ebebac4494a4c06fd6d8e.jpg"), placeholderImage: UIImage(named: "dummy-placeholder"), completed: { (downloadedImage, NSError, SDImageCacheType, NSURL) -> Void in
                if let imageView = fullImageCollectionViewCell.itemProductImageView {
                    if downloadedImage != nil {
                        imageView.fadeInImageWithImage(downloadedImage)
                    }
                }
            })
        
        return fullImageCollectionViewCell
    }
}
