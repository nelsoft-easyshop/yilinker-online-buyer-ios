//
//  ChangeAddressViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ChangeAddressViewControllerDelegate {
    func changeAddressViewController(didSelectAddress address: String)
}

class ChangeAddressViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate, ChangeAddressCollectionViewCellDelegate, ChangeAddressFooterCollectionViewCellDelegate, AddAddressTableViewControllerDelegate, EmptyViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
   
    var cellCount: Int = 0
    var selectedIndex: Int = 10000
    
    var getAddressModel: GetAddressesModel!
    var emptyView: EmptyView?
    
    let manager = APIManager.sharedInstance
    
    var delegate: ChangeAddressViewControllerDelegate?
    
    var yiHud: YiHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestGetAddressess()
        
        self.titleView()
        self.backButton()
        //self.view.layoutIfNeeded()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        layout.footerReferenceSize = CGSizeMake(self.collectionView.frame.size.width, 41)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = self
        collectionView.delegate = self
        self.regsiterNib()
    }
    
    //MARK: -
    //MARK: - Show HUD
    func showHUD() {
        self.yiHud = YiHUD.initHud()
        self.yiHud!.showHUDToView(self.view)
    }
    
    func titleView() {
        self.title = AddressStrings.changeAddress
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
        self.done()
    }
    
    func done() {
        if let cell: ChangeAddressCollectionViewCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: self.selectedIndex, inSection: 0)) as? ChangeAddressCollectionViewCell {
            let cell: ChangeAddressCollectionViewCell = self.collectionView.cellForItemAtIndexPath(NSIndexPath(forItem: self.selectedIndex, inSection: 0)) as! ChangeAddressCollectionViewCell
            self.delegate!.changeAddressViewController(didSelectAddress: cell.addressLabel.text!)
            self.navigationController!.popViewControllerAnimated(true)
        } else {
            self.navigationController!.popViewControllerAnimated(true)
        }
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
        return self.cellCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell : ChangeAddressCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(Constants.Checkout.changeAddressCollectionViewCellNibNameAndIdentifier, forIndexPath: indexPath) as! ChangeAddressCollectionViewCell
        cell.titleLabel.text = self.getAddressModel.listOfAddress[indexPath.row].title
        cell.addressLabel.text = self.getAddressModel.listOfAddress[indexPath.row].fullLocation
        
        if  indexPath.row == self.selectedIndex {
            cell.layer.borderWidth = 1
            cell.layer.borderColor = Constants.Colors.selectedGreenColor.CGColor
            cell.checkBoxButton.setImage(UIImage(named: "checkBox"), forState: UIControlState.Normal)
            cell.checkBoxButton.backgroundColor = Constants.Colors.selectedGreenColor
            SessionManager.setFullAddress(self.getAddressModel.listOfAddress[indexPath.row].fullLocation)
            SessionManager.setLang("\(self.getAddressModel.listOfAddress[indexPath.row].latitude)")
            SessionManager.setLong("\(self.getAddressModel.listOfAddress[indexPath.row].longitude)")
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
        let addAddressTableViewController: AddAddressTableViewController = AddAddressTableViewController(nibName: "AddAddressTableViewController", bundle: nil)
        addAddressTableViewController.delegate = self
        addAddressTableViewController.addressModel = self.getAddressModel.listOfAddress[indexPath.row].copy()
        addAddressTableViewController.isEdit = true
        addAddressTableViewController.isEdit2 = true
        self.navigationController!.pushViewController(addAddressTableViewController, animated: true)
    }
    
    //Set Default Address
    func changeAddressCollectionViewCell(didSelectDefaultAtCell cell: ChangeAddressCollectionViewCell) {
        let indexPath: NSIndexPath = self.collectionView.indexPathForCell(cell)!
        let addressId: String = "\(self.getAddressModel.listOfAddress[indexPath.row].userAddressId))"
        self.fireSetDefaultAddressWithAddressId(addressId, indexPath: indexPath)
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
        let addAddressTableViewController: AddAddressTableViewController = AddAddressTableViewController(nibName: "AddAddressTableViewController", bundle: nil)
        addAddressTableViewController.delegate = self
        addAddressTableViewController.isEdit = false
        addAddressTableViewController.isEdit2 = false
        self.navigationController!.pushViewController(addAddressTableViewController, animated: true)
    }
    
    func addAddressTableViewController(didAddAddressSucceed addAddressTableViewController: AddAddressTableViewController) {
        self.requestGetAddressess()
    }
    
    // MARK: - Actions
    
    func addCellInIndexPath(indexPath: NSIndexPath) {
        self.cellCount++
        self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
    }
    
    func deleteCellInIndexPath(indexPath: NSIndexPath) {
        if indexPath.row != self.selectedIndex {
            if cellCount != 0 {
                self.cellCount = self.cellCount - 1
            }
            
            self.collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
            self.requestGetAddressess()
        } else {
            UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Can't delete primary address.")
        }
       
    }
    
    // MARK: - Methods
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
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
        self.showHUD()
        
        let params = ["access_token": SessionManager.accessToken()]
        
        manager.POST(APIAtlas.addressesUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.getAddressModel = GetAddressesModel.parseDataWithDictionary(responseObject)
            self.cellCount = self.getAddressModel.listOfAddress.count
            
            for (index, address) in enumerate(self.getAddressModel.listOfAddress) {
                if address.isDefault {
                    self.selectedIndex = index
                }
            }
            
            self.collectionView.reloadData()
            self.yiHud?.hide()
            
            if self.getAddressModel.listOfAddress.count == 1 {
                self.fireSetDefaultAddressWithAddressId("\(self.getAddressModel.listOfAddress[0].userAddressId)", indexPath: NSIndexPath(forItem: 0, inSection: 0)!)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 401 {
                    self.requestRefreshToken(AddressRefreshType.Get, uid: 0, indexPath: nil)
                } else if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: errorModel.title)
                } else {
                    self.addEmptyView()
                }
                
                self.yiHud?.hide()
        })
    }
    
    func requestDeleteAddress(addressId: Int, index: NSIndexPath) {
        self.showHUD()
        
        let params = ["access_token": SessionManager.accessToken(),
        "userAddressId": String(addressId)]
        
        manager.POST(APIAtlas.deleteAddressUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if (responseObject["isSuccessful"] as! Bool) {
                self.deleteCellInIndexPath(index)
            } else {
                self.showAlert(title: responseObject["message"] as! String, message: nil)
            }
            
            self.yiHud?.hide()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.requestRefreshToken(AddressRefreshType.Delete, uid:addressId, indexPath: index)
                } else if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: errorModel.title)
                } else {
                    self.addEmptyView()
                }
                
                self.yiHud?.hide()
        })
    }
    
    func requestRefreshToken(type: AddressRefreshType, uid: Int, indexPath: NSIndexPath!) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID(),
            "client_secret": Constants.Credentials.clientSecret(),
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        let manager = APIManager.sharedInstance
        self.showHUD()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
            if type == AddressRefreshType.Get {
                self.requestGetAddressess()
            } else if type == AddressRefreshType.Delete {
                self.requestDeleteAddress(uid, index: indexPath)
            } else if type == AddressRefreshType.SetDefault {
                self.fireSetDefaultAddressWithAddressId("\(uid)", indexPath: indexPath)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.yiHud?.hide()
                let alertController = UIAlertController(title: Constants.Localized.someThingWentWrong, message: "", preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
        })
    }
    
    func fireSetDefaultAddressWithAddressId(addressId: String, indexPath: NSIndexPath) {
        self.showHUD()
        let params = ["access_token": SessionManager.accessToken(),
            "userAddressId": addressId]
        
        manager.POST(APIAtlas.setDefaultAddressUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            if (responseObject["isSuccessful"] as! Bool) {
                let addressModel: AddressModelV2 = AddressModelV2.parseAddressFromDictionary(responseObject["data"] as! NSDictionary)
                
                SessionManager.setAddressId(addressModel.userAddressId)
                SessionManager.setFullAddress(addressModel.fullLocation)
                
                SessionManager.setLang(addressModel.latitude)
                SessionManager.setLong(addressModel.longitude)
                
                SessionManager.setCity(addressModel.city)
                SessionManager.setProvince(addressModel.province)
                
                self.selectedIndex = indexPath.row
                self.collectionView.reloadData()
            } else {
                self.showAlert(title: responseObject["message"] as! String, message: nil)
            }
            
            self.yiHud?.hide()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                self.yiHud?.hide()
                
                if task.statusCode == 401 {
                    self.requestRefreshToken(AddressRefreshType.SetDefault, uid:addressId.toInt()!, indexPath: nil)
                }  else if error.userInfo != nil {
                    let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: errorModel.title)
                } else {
                    self.addEmptyView()
                }
                
                self.yiHud?.hide()
        })
        
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSize(width: self.view.frame.size.width - 20, height: 90)
    }
}
