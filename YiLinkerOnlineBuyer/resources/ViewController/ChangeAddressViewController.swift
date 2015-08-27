//
//  ChangeAddressViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ChangeAddressViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, ChangeAddressCollectionViewCellDelegate, ChangeAddressFooterCollectionViewCellDelegate, AddAddressTableViewControllerDelegate, EmptyViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
   
    var cellCount: Int = 0
    var selectedIndex: Int = 0
    
    var getAddressModel: GetAddressesModel!
    var emptyView: EmptyView?
    
    let manager = APIManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGetAddressess()
        
        self.titleView()
        self.backButton()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width - 20, height: 79)
        layout.minimumLineSpacing = 20
        layout.footerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 41)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        self.regsiterNib()
    }
    
    func titleView() {
        self.title = "Change Address"
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
        
        var checkButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        checkButton.frame = CGRectMake(0, 0, 25, 25)
        checkButton.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        checkButton.setImage(UIImage(named: "check-white"), forState: UIControlState.Normal)
        var customCheckButton:UIBarButtonItem = UIBarButtonItem(customView: checkButton)
        
        let navigationSpacer2: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer2.width = -10

        self.navigationItem.rightBarButtonItems = [navigationSpacer2, customCheckButton]
    }
    
    func back() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func done() {
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func regsiterNib() {
        let changeAddressNib: UINib = UINib(nibName: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(changeAddressNib, forCellWithReuseIdentifier: Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier)
        
        let collectionViewFooterNib: UINib = UINib(nibName: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(collectionViewFooterNib, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier)
        self.collectionView.registerNib(collectionViewFooterNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier)
    }

    // MARK: - Collection View Data Source and Delegates
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cellCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ChangeAddressCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressCollectionViewCell
        
        cell.addressLabel.text = self.getAddressModel.listOfAddress[indexPath.row].streetName
        
        if indexPath.row == self.selectedIndex {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = Constants.Colors.selectedGreenColor.CGColor
            cell.checkBoxButton.setImage(UIImage(named: "checkBox"), forState: UIControlState.Normal)
            cell.checkBoxButton.backgroundColor = Constants.Colors.selectedGreenColor
        } else {
            cell.checkBoxButton.setImage(nil, forState: UIControlState.Normal)
            cell.checkBoxButton.layer.borderWidth = 1
            cell.checkBoxButton.layer.borderColor = UIColor.lightGrayColor().CGColor
            cell.checkBoxButton.backgroundColor = UIColor.clearColor()
            
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGrayColor().CGColor
        }
        
        cell.layer.cornerRadius = 5
        cell.delegate = self

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedIndex = indexPath.row
        self.collectionView.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footerView: ChangeAddressFooterCollectionViewCell = self.collectionView?.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: Constants.Checkout.changeAddressFooterCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressFooterCollectionViewCell
        
        footerView.delegate = self
        
        return footerView
    }
    
    // MARK: - Other Delegates
    
    func changeAddressCollectionViewCell(deleteAddressWithCell cell: ChangeAddressCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        requestDeleteAddress(self.getAddressModel.listOfAddress[indexPath.row].userAddressId, index: indexPath)
    }

    func changeAddressFooterCollectionViewCell(didSelecteAddAddress cell: ChangeAddressFooterCollectionViewCell) {
        /*let indexPath: NSIndexPath = NSIndexPath(forItem: self.cellCount, inSection: 0)
        self.addCellInIndexPath(indexPath)*/
        
        let addAddressTableViewController: AddAddressTableViewController = AddAddressTableViewController(nibName: "AddAddressTableViewController", bundle: nil)
        addAddressTableViewController.delegate = self
        self.navigationController!.pushViewController(addAddressTableViewController, animated: true)
    }
    
    func addAddressTableViewController(didAddAddressSucceed addAddressTableViewController: AddAddressTableViewController) {
        let indexPath: NSIndexPath = NSIndexPath(forItem: self.cellCount, inSection: 0)
        self.addCellInIndexPath(indexPath)
    }
    
    // MARK: - Actions
    
    func addCellInIndexPath(indexPath: NSIndexPath) {
        self.cellCount++
        self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
    }
    
    func deleteCellInIndexPath(indexPath: NSIndexPath) {
        if cellCount != 0 {
            self.cellCount = self.cellCount - 1
        }
        
        self.collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
    }
    
    // MARK: - Methods
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addEmptyView() {
        self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
        self.emptyView?.frame = self.view.frame
        self.emptyView!.delegate = self
        self.view.addSubview(self.emptyView!)
    }
    
    func didTapReload() {
        requestGetAddressess()
        self.emptyView?.removeFromSuperview()
    }
    
    // MARK: - Requests
    
    func requestGetAddressess() {
        SVProgressHUD.show()
        
        let url = "http://online.api.easydeal.ph/api/v1/auth/address/getUserAddresses"
        let params = ["access_token": "YTI0MTRmOGE1YjcxYzY1MDg2OTAwNjUyNjY5M2RjYmFmYmI1MGRhMGVjZDM1MTlmNTkyNjU4NTExOTdlMTE2Mw"]
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.getAddressModel = GetAddressesModel.parseDataWithDictionary(responseObject)
            self.cellCount = self.getAddressModel.listOfAddress.count
            self.collectionView.reloadData()
            SVProgressHUD.dismiss()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken("get", deleteId: nil, deleteIndex: nil)
                } else {
                    self.addEmptyView()
                    SVProgressHUD.dismiss()
                }
        })
    }
    
    func requestDeleteAddress(addressId: Int, index: NSIndexPath) {
        SVProgressHUD.show()
        
        let url = "http://online.api.easydeal.ph/api/v1/auth/address/deleteUserAddress"
        let params = ["access_token": "YTI0MTRmOGE1YjcxYzY1MDg2OTAwNjUyNjY5M2RjYmFmYmI1MGRhMGVjZDM1MTlmNTkyNjU4NTExOTdlMTE2Mw",
        "userAddressId": String(addressId)]
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if (responseObject["isSuccessful"] as! Bool) {
                self.showAlert(title: "Address successfully deleted.", message: nil)
                self.deleteCellInIndexPath(index)
            } else {
                self.showAlert(title: responseObject["message"] as! String, message: nil)
            }
            
            SVProgressHUD.dismiss()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken("delete", deleteId: addressId, deleteIndex: index)
                } else {
                    self.addEmptyView()
                    SVProgressHUD.dismiss()
                }
        })
    }
    
    func requestRefreshToken(type: String, deleteId: Int!, deleteIndex: NSIndexPath!) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if type == "get" {
                self.requestGetAddressess()
            } else if type == "delete" {
                self.requestDeleteAddress(deleteId, index: deleteIndex)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let alertController = UIAlertController(title: "Something went wrong", message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
}
