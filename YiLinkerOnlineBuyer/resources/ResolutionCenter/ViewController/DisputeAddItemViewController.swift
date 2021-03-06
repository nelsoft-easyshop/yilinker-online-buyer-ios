//
//  AddItemViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

protocol DisputeAddItemViewControllerDelegate {
    func addTransactionProducts(productIds: [String], productNames: [String])
}

class DisputeAddItemViewController: UIViewController {
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var transactionId: String = ""
    var transactionDetailsModel: TransactionDetailsModel!
    var productIDs: [String] = []
    var productNames: [String] = []
    
    var selectedTransactionIDIndex: [Int] = []
    
    var yiHud: YiHUD?
    var delegate: DisputeAddItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        customizedNavigationBar()
        customizedViews()
        let nib = UINib(nibName: "DisputeAddItemTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DisputeAddItemTableViewCell")
        
        requestGetProductList(self.transactionId)
    }
    
    // MARK: - Methods
    
    func customizedNavigationBar() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.title = "Add Item"
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationController?.navigationBar.barTintColor = Constants.Colors.appTheme
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Stop, target: self, action: "closeAction")
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(named: "check-dispute"), style: .Plain, target: self, action: "checkAction"), navigationSpacer]
    }
    
    func customizedViews() {
        self.searchBarTextField.layer.cornerRadius = searchBarTextField.frame.size.height / 2
        
        var searchImage = UIImageView(image: UIImage(named: "search"))
        searchImage.frame = CGRectMake(0.0, 0.0,40.0, 40.0)
        searchImage.contentMode = UIViewContentMode.Center
        searchBarTextField.leftView = searchImage
        searchBarTextField.leftViewMode = UITextFieldViewMode.Always
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
    }
    
    // MARK: - Actions
    
    func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func checkAction() {

        if self.selectedTransactionIDIndex.count != 0 {
            for i in 0..<self.selectedTransactionIDIndex.count {
                productIDs.append(self.transactionDetailsModel.orderProductId[self.selectedTransactionIDIndex[i]])
                productNames.append(self.transactionDetailsModel.productName[self.selectedTransactionIDIndex[i]])
            }
            delegate?.addTransactionProducts(productIDs, productNames: productNames)
        }
        
        closeAction()
    }
    
    //MARK: -
    //MARK: - Show HUD
    func showHUD() {
        self.yiHud = YiHUD.initHud()
        self.yiHud!.showHUDToView(self.view)
    }
    
    // MARK: - Requests
    
    func requestGetProductList(transactionId: String) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let url: String = APIAtlas.transactionDetails + "\(SessionManager.accessToken())&transactionId=\(transactionId)"
        let urlEncoded = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)

        WebServiceManager.fireGetProductListWithUrl(urlEncoded!, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                self.transactionDetailsModel = TransactionDetailsModel.parseDataFromDictionary(responseObject as! NSDictionary)
                self.tableView.reloadData()
                self.yiHud?.hide()
            } else {
                self.yiHud?.hide()
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken(transactionId)
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
                    Toast.displayToastWithMessage(Constants.Localized.someThingWentWrong, duration: 1.5, view: self.view)
                }
            }
        })
    }
    
    func fireRefreshToken(id: String) {
        
        self.showHUD()
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.requestGetProductList(id)
            } else {
                //Forcing user to logout.
                UIAlertController.displayAlertRedirectionToLogin(self, actionHandler: { (sucess) -> Void in
                    
                })
            }
        })
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.transactionDetailsModel != nil {
            return self.transactionDetailsModel.productName.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: DisputeAddItemTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("DisputeAddItemTableViewCell") as! DisputeAddItemTableViewCell
        cell.selectionStyle = .None
        
        cell.setProductImage(self.transactionDetailsModel.productImage[indexPath.row])
        cell.itemNameLabel.text = self.transactionDetailsModel.productName[indexPath.row]
        cell.vendorLabel.text = self.transactionDetailsModel.sellerStore[0]
        
        if (find(selectedTransactionIDIndex, indexPath.row) != nil) {
            cell.updateStatusImage(true)
        } else {
            cell.updateStatusImage(false)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: DisputeAddItemTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! DisputeAddItemTableViewCell

        if cell.addImageView?.image == UIImage(named: "addItem") {
            cell.updateStatusImage(true)
            selectedTransactionIDIndex.append(indexPath.row)
//            selectedItemIDs.append(self.productModel.products[indexPath.row].id)
        } else {
            cell.updateStatusImage(false)
            selectedTransactionIDIndex = selectedTransactionIDIndex.filter({$0 != indexPath.row})
//            selectedItemIDs = selectedItemIDs.filter({$0 != self.productModel.products[indexPath.row].id})
        }

    }
    

}
