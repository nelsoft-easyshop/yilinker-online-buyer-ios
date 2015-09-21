//
//  AddItemViewController.swift
//  YiLinkerOnlineSeller
//
//  Created by Rj Constantino on 9/1/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class DisputeAddItemViewController: UIViewController {
    
    @IBOutlet weak var searchBarTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var transactionId: String = ""
    var transactionDetailsModel: TransactionDetailsModel!
    
    var hud: MBProgressHUD?
    
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
        
//        if selectedItemIDs.count != 0 {
//            for i in 0..<self.productModel.products.count {
//                if contains(self.selectedItemIDs, self.productModel.products[i].id) {
//                    selectedProductsModel.append(self.productModel.products[i])
//                }
//            }
//            delegate?.addProductItems(self.productModel, itemIndexes: selectedItemIDsIndex, products: selectedProductsModel)
//        }
        
        closeAction()
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
    
    // MARK: - Requests
    
    func requestGetProductList(transactionId: String) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let url: String = APIAtlas.transactionDetails + "\(SessionManager.accessToken())&transactionId=\(transactionId)"
        let urlEncoded = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)

        manager.GET(urlEncoded!, parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.transactionDetailsModel = TransactionDetailsModel.parseDataFromDictionary(responseObject as! NSDictionary)
            self.tableView.reloadData()
            self.hud?.hide(true)
            }, failure: { (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                println(error.userInfo)
                
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
        
//        cell.setProductImage(self.transactionDetailsModel.productImage[indexPath.row])
//        cell.itemNameLabel.text = self.transactionDetailsModel.productName[indexPath.row]
//        cell.itemNameLabel.text = self.transactionDetailsModel.productName[indexPath.row].name
        
//        if (find(selectedItemIDs, productModel.products[indexPath.row].id) != nil) {
//            cell.updateStatusImage(true)
//        } else {
//            cell.updateStatusImage(false)
//        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: DisputeAddItemTableViewCell = self.tableView.cellForRowAtIndexPath(indexPath) as! DisputeAddItemTableViewCell

        if cell.addImageView?.image == UIImage(named: "addItem") {
            cell.updateStatusImage(true)
//            selectedItemIDs.append(self.productModel.products[indexPath.row].id)
        } else {
            cell.updateStatusImage(false)
//            selectedItemIDs = selectedItemIDs.filter({$0 != self.productModel.products[indexPath.row].id})
        }

    }
    

}
