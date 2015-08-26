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
        
//        self.navigationItem.setLeftBarButtonItem(UIBarButtonItem(image: UIImage(named: "back-white"), style: UIBarButtonItemStyle.Plain, target: self, action: "back-Action"), animated: true)
    }
    
    // MARK: - Methods
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if followedSellerModel != nil {
            return followedSellerModel.fullName.count
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
        self.navigationController?.pushViewController(seller, animated: true)
    }
    
    // MARK: - Request
    
    func requestReviewDetails() {
        SVProgressHUD.show()
        
        let manager = APIManager.sharedInstance
        let url = "http://online.api.easydeal.ph/api/v1/auth/getFollowedSellers"
        let params = ["page": "1", "limit": "99", "access_token": "MDVkZTBmNjRmYmI3YTJjMTE0MDIzZDM0NmU4MzBiZmNmNDQ0YmZhMDU1ZTNmMjc5NGU0NDg3ZGZiZDgzOWYxMg"]
        
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
        self.emptyView!.delegate = self
        self.view.addSubview(self.emptyView!)
    }
    
    func didTapReload() {
        requestReviewDetails()
        self.emptyView?.removeFromSuperview()
    }
    
}
