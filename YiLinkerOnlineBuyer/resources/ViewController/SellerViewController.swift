//
//  SellerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/17/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, SellerTableHeaderViewDelegate, ProductsTableViewCellDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var sellerModel: SellerModel?
    var followSellerModel: FollowedSellerModel?
    let sellerTableHeaderView: SellerTableHeaderView = SellerTableHeaderView.loadFromNibNamed("SellerTableHeaderView", bundle: nil) as! SellerTableHeaderView
    var is_successful: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backButton()
        self.tableView.estimatedRowHeight = 112.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.registerNib()
      
        self.titleView()
        self.fireSeller()
        
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
    }
    
    func populateData() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clearColor()
        self.headerView()
        self.tableView.reloadData()
    }
    
    func titleView() {
        let label: UILabel = UILabel(frame: CGRectMake(0, 0, 100, 50))
        label.text = "Vendor Page"
        label.textAlignment = NSTextAlignment.Center
        label.textColor = UIColor.whiteColor()
        self.navigationItem.titleView = label
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    
    func headerView() {
        
        sellerTableHeaderView.delegate = self
        
        sellerTableHeaderView.coverPhotoImageView.sd_setImageWithURL(self.sellerModel!.coverPhoto, placeholderImage: UIImage(named: "dummy-placeholder"))
        
        if self.is_successful {
            self.sellerTableHeaderView.followButton.layer.borderColor = Constants.Colors.grayLine.CGColor
            self.sellerTableHeaderView.followButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            self.sellerTableHeaderView.followButton.backgroundColor = UIColor.clearColor()
            self.sellerTableHeaderView.followButton.setTitle("FOLLOWING", forState: UIControlState.Normal)
        } else if !(self.is_successful){
            self.sellerTableHeaderView.followButton.backgroundColor = Constants.Colors.appTheme
            self.sellerTableHeaderView.followButton.borderColor = UIColor.clearColor()
            self.sellerTableHeaderView.followButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.sellerTableHeaderView.followButton.setTitle("FOLLOW", forState: UIControlState.Normal)
        }
        
        let imageView: UIImageView = UIImageView(frame: CGRectMake(0, 0, sellerTableHeaderView.profileImageView.frame.width, sellerTableHeaderView.profileImageView.frame.height))
        imageView.sd_setImageWithURL(self.sellerModel!.avatar, placeholderImage: UIImage(named: "dummy-placeholder"))
        
        sellerTableHeaderView.profileImageView.addSubview(imageView)
        sellerTableHeaderView.sellernameLabel.text = sellerModel!.store_name
        sellerTableHeaderView.addressLabel.text = sellerModel!.store_address
        
        self.tableView.tableHeaderView = sellerTableHeaderView
        self.tableView.reloadData()
    }
    
    func registerNib() {
        let sellerNib: UINib = UINib(nibName: Constants.Seller.aboutSellerTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(sellerNib, forCellReuseIdentifier: Constants.Seller.aboutSellerTableViewCellNibNameAndIdentifier)
        
        let productsNib: UINib = UINib(nibName: Constants.Seller.productsTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(productsNib, forCellReuseIdentifier: Constants.Seller.productsTableViewCellNibNameAndIdentifier)
        
        let generalRatingNib: UINib = UINib(nibName: Constants.Seller.generalRatingTableViewCellNibNameAndIndentifier, bundle: nil)
        self.tableView.registerNib(generalRatingNib, forCellReuseIdentifier: Constants.Seller.generalRatingTableViewCellNibNameAndIndentifier)
        
        let reviewNib: UINib = UINib(nibName: Constants.Seller.reviewNibName, bundle: nil)
        self.tableView.registerNib(reviewNib, forCellReuseIdentifier: Constants.Seller.reviewIdentifier)
        
        let seeMoreNib: UINib = UINib(nibName: Constants.Seller.seeMoreTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(seeMoreNib, forCellReuseIdentifier: Constants.Seller.seeMoreTableViewCellNibNameAndIdentifier)
    }
    
    func fireSeller() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["userId" : "1"];
        manager.POST(APIAtlas.getSellerInfo, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.sellerModel = SellerModel.parseSellerDataFromDictionary(responseObject as! NSDictionary)
                self.populateData()
                self.is_successful == self.sellerModel?.is_allowed
                SVProgressHUD.dismiss()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                self.is_successful == self.sellerModel?.is_allowed

        })
    }
    
    func fireFollowSeller() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["sellerId" : 1, "access_token" : SessionManager.accessToken()];
        manager.POST(APIAtlas.followSeller, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(responseObject as! NSDictionary)
            //self.populateData()
            self.is_successful = true
            self.sellerTableHeaderView.followButton.tag = 1
            println("result after ff: \(self.is_successful)")
            println("button after ff: \(self.sellerTableHeaderView.followButton.selected)")
            println(self.followSellerModel?.message)
            
            SVProgressHUD.dismiss()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                
                //let dictionary: NSDictionary =(data, options: nil, error: nil)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 400 {
                    let data = error.userInfo as! Dictionary<String, AnyObject>
                    self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(error.userInfo as! Dictionary<String, AnyObject>)
                    println(self.followSellerModel?.message)
                    self.is_successful = true
                    self.sellerTableHeaderView.followButton.tag = 1
                    println("result after ff error block: \(self.is_successful)")
                    println("button after ff error block: \(self.sellerTableHeaderView.followButton.highlighted)")
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    self.is_successful = false
                    self.sellerTableHeaderView.followButton.tag = 2
                }
        })
       
    }
    
    func fireUnfollowSeller() {
        
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["sellerId" : "1", "access_token" : SessionManager.accessToken()];
        
        manager.POST(APIAtlas.unfollowSeller, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(responseObject as! NSDictionary)
                //self.populateData()
                print(self.followSellerModel?.error_description)
                SVProgressHUD.dismiss()
                self.is_successful = false
                self.sellerTableHeaderView.followButton.tag = 2
                println("result after uff: \(self.is_successful)")
                println("button after uff: \(self.sellerTableHeaderView.followButton.highlighted)")
                println(self.followSellerModel?.isSuccessful)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 400 {
                    let data = error.userInfo as! Dictionary<String, AnyObject>
                    self.followSellerModel = FollowedSellerModel.parseFollowSellerDataWithDictionary(error.userInfo as! Dictionary<String, AnyObject>)
                    print(self.followSellerModel?.message)
                    self.is_successful = false
                    self.sellerTableHeaderView.followButton.tag = 2
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                    self.is_successful = false
                    self.sellerTableHeaderView.followButton.tag = 2
                }
        })
    }
    
    func backButton() {
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.sellerModel!.reviews.count + 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let aboutSellerTableViewCell: AboutSellerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Seller.aboutSellerTableViewCellNibNameAndIdentifier) as! AboutSellerTableViewCell
//                aboutSellerTableViewCell.aboutLabel.text = self.sellerModel!.sellerAbout
            aboutSellerTableViewCell.aboutLabel.text = self.sellerModel?.store_description
            
            return aboutSellerTableViewCell
        } else if indexPath.section == 1 {
            let productsTableViewCell: ProductsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Seller.productsTableViewCellNibNameAndIdentifier) as! ProductsTableViewCell
                productsTableViewCell.productModels = sellerModel!.products
                productsTableViewCell.delegate = self
            return productsTableViewCell
        } else if indexPath.section == 2 {
            let generalRatingTableViewCell: GeneralRatingTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Seller.generalRatingTableViewCellNibNameAndIndentifier) as! GeneralRatingTableViewCell
            
            generalRatingTableViewCell.setRating(self.sellerModel!.ratingAndFeedback)
            return generalRatingTableViewCell
        } else {
            let index: Int = indexPath.section - 3
            let reviewCell: ReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.Seller.reviewIdentifier) as! ReviewTableViewCell
            
            let reviewModel: ProductReviewsModel = self.sellerModel!.reviews[index]
//            reviewCell.displayPictureImageView.sd_setImageWithURL(NSURL(string: reviewModel.imageUrl)!, placeholderImage: UIImage(named: "dummy-placeholder"))
//            reviewCell.messageLabel.text = reviewModel.message
//            reviewCell.nameLabel.text = reviewModel.name
            reviewCell.messageLabel.text = reviewModel.review
            reviewCell.nameLabel.text = reviewModel.fullName
            reviewCell.setRating(reviewModel.rating)
            return reviewCell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 || section >= 3 {
            return 0
        } else {
            return 10
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 174
        } else if indexPath.section == 2 {
            return 41
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //Seller View Delegate
    func sellerTableHeaderViewDidViewFeedBack() {
        println("view feedback")
        var attributeModal = ViewFeedBackViewController(nibName: "ViewFeedBackViewController", bundle: nil)
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
    }
    
    func sellerTableHeaderViewDidFollow() {
        //println("follow")
        
        sellerTableHeaderView.delegate = self
        println("result: \(self.is_successful)")
        println("button: \(self.sellerTableHeaderView.followButton.selected)")
        if self.is_successful {
            self.sellerTableHeaderView.followButton.tag = 1
        } else {
            self.sellerTableHeaderView.followButton.tag = 2
        }
        if self.sellerTableHeaderView.followButton.tag == 1 {
            self.sellerTableHeaderView.followButton.tag = 2
            self.sellerTableHeaderView.followButton.backgroundColor = Constants.Colors.appTheme
            self.sellerTableHeaderView.followButton.borderColor = UIColor.clearColor()
            self.sellerTableHeaderView.followButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            
             self.sellerTableHeaderView.followButton.setTitle("FOLLOW", forState: UIControlState.Normal)
            fireUnfollowSeller()
        } else {
            self.sellerTableHeaderView.followButton.tag = 1
            self.sellerTableHeaderView.followButton.layer.borderColor = Constants.Colors.grayLine.CGColor
            self.sellerTableHeaderView.followButton.setTitleColor(UIColor.grayColor(), forState: UIControlState.Normal)
            self.sellerTableHeaderView.followButton.backgroundColor = UIColor.clearColor()

            self.sellerTableHeaderView.followButton.setTitle("FOLLOWING", forState: UIControlState.Normal)
            fireFollowSeller()
        }
        
    }
    
    func sellerTableHeaderViewDidMessage() {
        println("message")
    }
    
    func sellerTableHeaderViewDidCall() {
        println("call")
    }
    
    func productstableViewCellDidTapMoreProductWithTarget(target: String) {
        println("Target: \(target)")
        self.redirectToResultView("target")
    }
    
    func productstableViewCellDidTapProductWithTarget(target: String, type: String) {
        self.redirectToProductpageWithProductID("1")
    }
    
    func redirectToProductpageWithProductID(productID: String) {
        let productViewController: ProductViewController = ProductViewController(nibName: "ProductViewController", bundle: nil)
        self.navigationController?.pushViewController(productViewController, animated: true)
    }
    
    func redirectToResultView(target: String) {
        let resultViewController: ResultViewController = ResultViewController(nibName: "ResultViewController", bundle: nil)
        self.navigationController!.pushViewController(resultViewController, animated: true)
    }
}
