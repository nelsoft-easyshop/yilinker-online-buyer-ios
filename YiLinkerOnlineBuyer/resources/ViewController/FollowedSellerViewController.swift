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

    @IBOutlet weak var emptyLabel: UILabel!
    var hud: MBProgressHUD?
    var emptyView: EmptyView?
    var followedSellerModel: FollowedSellerModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "FollowedSellerTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "FollowedSellerIdentifier")
        
        if Reachability.isConnectedToNetwork() {
            requestFollowedSelers()
        } else {
            addEmptyView()
        }
        
        customizedNavigationBar()
    }
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-white"), style: UIBarButtonItemStyle.Plain, target: self, action: "backAction")
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    func backAction() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func showHUD() {
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
        
        cell.nameLabel.text = followedSellerModel.storeName[indexPath.row]
        cell.specialtyLabel.text = String(StringHelper.localizedStringWithKey("SPECIALTY_LOCALIZE_KEY") + ": ") + followedSellerModel.specialty[indexPath.row]
        cell.setPicture(followedSellerModel.profileImageUrl[indexPath.row])
        cell.setRating(followedSellerModel.rating[indexPath.row])
        
        return cell
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let seller = SellerViewController(nibName: "SellerViewController", bundle: nil)
        seller.sellerId = self.followedSellerModel.id[indexPath.row]
        self.navigationController?.pushViewController(seller, animated: true)
    }
    
    // MARK: - Request
    
    func requestFollowedSelers() {
        self.showHUD()
        
        let manager = APIManager.sharedInstance
        let params = ["access_token": SessionManager.accessToken(),
            "page": "1", "limit": "999"]
        
        manager.POST(APIAtlas.getFollowedSellers, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.followedSellerModel = FollowedSellerModel.parseDataWithDictionary(responseObject)
            
            if self.followedSellerModel.id.count != 0 {
                self.tableView.reloadData()
            } else {
                self.emptyLabel.hidden = false
            }
            self.hud?.hide(true)
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken()
                } else {
                    self.addEmptyView()
                    self.hud?.hide(true)
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
            
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestFollowedSelers()

            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let alertController = UIAlertController(title: ProductStrings.alertWentWrong, message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
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
        if Reachability.isConnectedToNetwork() {
            requestFollowedSelers()
        } else {
            addEmptyView()
        }
        self.emptyView?.removeFromSuperview()
    }
    
}
