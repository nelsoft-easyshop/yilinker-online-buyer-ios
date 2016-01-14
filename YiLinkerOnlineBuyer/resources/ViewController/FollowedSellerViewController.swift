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
        
        customizedNavigationBar()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if followedSellerModel != nil {
            if followedSellerModel.id.count == 0 {
                self.showHUD()
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = true
            }
        } else {
            self.showHUD()
        }
        
        if Reachability.isConnectedToNetwork() {
            requestFollowedSelers()
        } else {
            addEmptyView()
        }
    }
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        let backButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "back-white"), style: UIBarButtonItemStyle.Plain, target: self, action: "backAction")
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -10
        self.navigationItem.leftBarButtonItems = [navigationSpacer, backButton]
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        self.emptyLabel.text = StringHelper.localizedStringWithKey("FOLLOWED_SELLERS_EMPTY_LOCALIZE_KEY")
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
        WebServiceManager.fireFollwedSellersWithUrl(APIAtlas.getFollowedSellers, page: "1", limit: "999", accessToken: SessionManager.accessToken(), actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.hud?.hide(true)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.followedSellerModel = FollowedSellerModel.parseDataWithDictionary(responseObject)
                
                if self.followedSellerModel.id.count != 0 {
                    self.tableView.reloadData()
                } else {
                    self.emptyLabel.hidden = false
                }
            } else {
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.requestRefreshToken()
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
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
    }
    
    func requestRefreshToken() {
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.hud?.hide(true)
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestFollowedSelers()
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    SessionManager.logout()
                    FBSDKLoginManager().logOut()
                    GPPSignIn.sharedInstance().signOut()
                    let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegate.startPage()
                })
            }
        })
    }
    
    // MARK: - Empty View
    
    func addEmptyView() {
        self.hud?.hide(true)
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.view.frame
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    func didTapReload() {
        if Reachability.isConnectedToNetwork() {
            self.emptyView?.hidden = true
            requestFollowedSelers()
        } else {
            addEmptyView()
        }
    }
    
}
