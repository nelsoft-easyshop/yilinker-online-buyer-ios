//
//  FollowedSellerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class FollowedSellerViewController: UIViewController, EmptyViewDelegate {

    @IBOutlet weak var tableView: UITableView!

    var emptyView: EmptyView?
    var followedSellerModel: FollowedSellerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "FollowedSellerTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "FollowedSellerIdentifier")
        
        requestReviewDetails()
        
        customizedNavigationBar()
    }
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        
        self.title = "Followed Seller"
        
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-white"), style: UIBarButtonItemStyle.Plain, target: self, action: "backAction")
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if followedSellerModel != nil {
            return followedSellerModel.id.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FollowedSellerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("FollowedSellerIdentifier") as! FollowedSellerTableViewCell
        
        cell.selectionStyle = .None
        
        cell.nameLabel.text = followedSellerModel.fullName[indexPath.row]
        cell.specialtyLabel.text = String("Specialty: ") + followedSellerModel.specialty[indexPath.row]
        cell.setPicture(followedSellerModel.profileImageUrl[indexPath.row])
//        cell.setRating(followedSellerModel.ratings[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let seller = SellerViewController(nibName: "SellerViewController", bundle: nil)
//        self.presentViewController(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(seller, animated: true)
    }
    
    // MARK: - Request
    
    func requestReviewDetails() {
        SVProgressHUD.show()
        
        let manager = APIManager.sharedInstance
        let url = "http://online.api.easydeal.ph/api/v1/auth/getFollowedSellers"
        let params = ["access_token": "MDNlMTE2M2ExMzBiNWZlMDliZDVhOGQ5MWYxZjE0ODFiMGVkYWM0NDhlMDkwNzBmOWEzMWJjNTYzMGQ3NDIzZQ",
            "page": "1", "limit": "99"]
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.followedSellerModel = FollowedSellerModel.parseDataWithDictionary(responseObject)
            self.tableView.reloadData()
            SVProgressHUD.dismiss()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.addEmptyView()
                SVProgressHUD.dismiss()
        })
    }
    
    // MARK: - Empty View
    
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.emptyView?.frame = self.view.frame
        self.emptyView!.delegate = self
        self.view.addSubview(self.emptyView!)
    }
    
    func didTapReload() {
        requestReviewDetails()
        self.emptyView?.removeFromSuperview()
    }
    
}
