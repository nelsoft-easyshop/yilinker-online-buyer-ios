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
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if followedSellerModel != nil {
            return followedSellerModel.names.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FollowedSellerTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("FollowedSellerIdentifier") as! FollowedSellerTableViewCell
        
        cell.selectionStyle = .None
        
        cell.nameLabel.text = followedSellerModel.names[indexPath.row]
        cell.specialtyLabel.text = String("Specialty: ") + followedSellerModel.specialty[indexPath.row]
        cell.setPicture(followedSellerModel.images[indexPath.row])
        cell.setRating(followedSellerModel.ratings[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let alertController = UIAlertController(title: followedSellerModel.names[indexPath.row],
            message: String("Specialty: ") + followedSellerModel.specialty[indexPath.row], preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Request
    
    func requestReviewDetails() {
        SVProgressHUD.show()
        
        let manager = APIManager.sharedInstance
        manager.GET("https://demo3526363.mockable.io/follwedSeller", parameters: nil, success: {
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
