//
//  FeedBackViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 1/27/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol FeedBackViewControllerDelegate {
    func feedBackViewControllerDidDismiss(feedBackViewController: FeedBackViewController)
}

class FeedBackViewController: UIViewController, UIScrollViewDelegate, FeedBackTableViewCellDelegate {
    
    @IBOutlet weak var fakeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var tableViewTopSpaceConstant: UIView!    
    
    let headerViewNibName = "FeedBackTableViewCell"
    let reviewCellNibName = "ReviewTableViewCell"
    
    var tableHeaderView: FeedBackTableViewCell = FeedBackTableViewCell()
    
    var cellCount: Int = 20
    
    var delegate: FeedBackViewControllerDelegate?
    var sellerModel: SellerModel = SellerModel()
    
    var firstLoad: Bool = true
    
    //MARK: - 
    //MARK: - Life Cycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().statusBarStyle = .Default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.registerCellWithNibName(self.headerViewNibName)
        self.registerCellWithNibName(self.reviewCellNibName)
        
        self.tableView.contentInset = UIEdgeInsets(top: 200, left: 0, bottom: 0, right: 0)
        self.tableView.contentOffset = CGPoint(x: 0, y: -200)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: - 
    //MARK: - Register Cell With Nib Name
    func registerCellWithNibName(nibName: String) {
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: nibName)
    }
    
    func headerView() -> FeedBackTableViewCell {
        let headerView: FeedBackTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(self.headerViewNibName) as! FeedBackTableViewCell
        headerView.delegate = self
       
        headerView.setSellerRating(self.sellerModel.rating)
        headerView.scoreLabel.text = "\(self.sellerModel.rating)"
        headerView.numberOfPeopleLabel.text = "\(self.sellerModel.reviews.count)"
        
        return headerView
    }
    
    //MARK: -
    //MARK: UiTableView delegate methods
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sellerModel.reviews.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return self.reviewTableViewCellWithIndexPath(indexPath)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
  
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height {
            if !self.firstLoad {
                self.fakeView.backgroundColor = UIColor.whiteColor()
            } else {
                self.firstLoad = false
            }
        } else {
            self.fakeView.backgroundColor = UIColor.clearColor()
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView.contentOffset.y <= -350 {
            self.delegate?.feedBackViewControllerDidDismiss(self)
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    //MARK: -
    //MARK: - Feed Back Table View Cell Delegate
    func feedBackTableViewCell(feedBackTableViewCell: FeedBackTableViewCell, didTapCancel cancelButton: UIButton) {
        self.delegate?.feedBackViewControllerDidDismiss(self)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //MARK: - 
    //MARK: - Populate Data
    func populateData() {
        self.tableHeaderView = self.headerView()
        self.tableView.tableHeaderView = self.tableHeaderView
    }
    
    //MARK: - 
    //MARK: - Review Table View Cell With IndexPath
    func reviewTableViewCellWithIndexPath(indexPath: NSIndexPath) -> ReviewTableViewCell {
        let reviewCell: ReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("ReviewTableViewCell") as! ReviewTableViewCell
        let reviewModel: ProductReviewsModel = self.sellerModel.reviews[indexPath.row]
        
        reviewCell.displayPictureImageView.sd_setImageWithURL(NSURL(string: reviewModel.imageUrl)!, placeholderImage: UIImage(named: "dummy-placeholder"))
        reviewCell.messageLabel.text = reviewModel.review
        reviewCell.nameLabel.text = reviewModel.fullName
        reviewCell.setRating(reviewModel.ratingSellerReview)
        
        return reviewCell
    }
}
