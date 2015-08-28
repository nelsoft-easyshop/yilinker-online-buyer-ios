//
//  CartViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate, CartProductAttributeViewControllerDelegate, EmptyViewDelegate {
    
    var manager = APIManager()
    
    @IBOutlet var cartTableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var cartCounterLabel: UILabel!
    
    @IBOutlet var checkoutButton: UIButton!
    
    var tableData: [CartProductDetailsModel] = []
    var selectedValue: [String] = []
    
    //formatter of Text to remove trailing decimal
    let formatter = NSNumberFormatter()
    
     var emptyView: EmptyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = APIManager.sharedInstance
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        cartTableView.delegate = self
        cartTableView.dataSource = self
        
        cartTableView.tableFooterView = UIView()
        
        var nib = UINib(nibName: "CartTableViewCell", bundle: nil)
        cartTableView.registerNib(nib, forCellReuseIdentifier: "CartTableViewCell")
        
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        if emptyView != nil {
            emptyView?.hidden = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
        
        getCartData()
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
    }
    
    //REST API request
    //
    
    func getCartData() {
        tableData = []
        cartTableView.reloadData()
        cartCounterLabel.text = ""
        
        if Reachability.isConnectedToNetwork() {
            requestProductDetails(APIAtlas.cartUrl, params: NSDictionary(dictionary: ["access_token": SessionManager.accessToken()]))
        } else {
            addEmptyView()
        }
    }
    
    func fireDeleteCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken("getCart", url: url, params: params)
            } else {
                self.populateTableView(responseObject)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.showAlert("Error", message: "Something went wrong. . .")
                self.dismissLoader()
        })
    }
    
    func fireAddToCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken("editToCart", url: url, params: params)
            }
            self.dismissLoader()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.showAlert("Error", message: "Something went wrong. . .")
                self.dismissLoader()
        })
    }
    
    func requestProductDetails(url: String, params: NSDictionary!) {
        showLoader()
        
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in print(responseObject as! NSDictionary)
            if responseObject.objectForKey("error") != nil {
                self.requestRefreshToken("getCart", url: url, params: params)
            } else {
                self.populateTableView(responseObject)
            }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.showAlert("Error", message: "Something went wrong. . .")
                self.updateCounterLabel()
                self.dismissLoader()
        })
    }
    
    func populateTableView(responseObject: AnyObject) {
        tableData.removeAll(keepCapacity: false)
        if let value: AnyObject = responseObject["data"] {
            for subValue in value["items"] as! NSArray {
                println(subValue)
                let model: CartProductDetailsModel = CartProductDetailsModel.parseDataWithDictionary(subValue as! NSDictionary)
                
                self.tableData.append(model)
            }
            self.cartTableView.reloadData()
        }
        self.updateCounterLabel()
        self.calculateTotalPrice()
        self.dismissLoader()
    }
    
    func updateCounterLabel() {
        if tableData.count < 2 {
            cartCounterLabel.text = "You have \(tableData.count) item in your cart"
        } else {
            cartCounterLabel.text = "You have \(tableData.count) items in your cart"
        }
    }
    
    
    //Loader function
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }
    
    func calculateTotalPrice() {
        var totalPrice: Double = 0.0
        for tempModel in tableData {
            if tempModel.selected {
                for tempProductUnit in tempModel.productUnits {
                     if tempModel.unitId == tempProductUnit.productUnitId {
                        let discountedPrice = (tempProductUnit.discountedPrice as NSString).doubleValue
                        let quantity = Double(tempModel.quantity)
                        totalPrice = totalPrice + (quantity * discountedPrice)
                    }
                }
            }
        }
        totalPriceLabel.text = "P \(formatter.stringFromNumber(totalPrice)!)"
    }
    
    

    // MARK: - Table View Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell 	{
        var cell:CartTableViewCell = self.cartTableView.dequeueReusableCellWithIdentifier("CartTableViewCell") as! CartTableViewCell
        //Set cell data
        var tempModel: CartProductDetailsModel = tableData[indexPath.row]
        
        cell.checkBox.selected = false
        cell.checkBox.backgroundColor = UIColor.whiteColor()
        cell.checkBox.layer.borderWidth = 1
        cell.checkBox.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        for tempProductUnit in tempModel.productUnits {
            if tempModel.unitId == tempProductUnit.productUnitId {
                if tempProductUnit.imageIds.count == 0 {
                    cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempModel.image), placeholderImage: UIImage(named: "dummy-placeholder"))
                } else {
                    cell.productItemImageView.sd_setImageWithURL(NSURL(string: tempProductUnit.imageIds[0]), placeholderImage: UIImage(named: "dummy-placeholder"))
                }
                
                var tempAttributesText: String = ""
                for tempId in tempProductUnit.combination {
                    for tempAttributes in tempModel.attributes {
                        if let index = find(tempAttributes.valueId, tempId) {
                            if tempAttributesText.isEmpty {
                                tempAttributesText = tempAttributes.valueName[index]
                            } else {
                                tempAttributesText += " | " + tempAttributes.valueName[index]
                            }
                        }
                    }
                }
                cell.productDetailsLabel?.text = tempAttributesText
                cell.productPriceLabel.text = "P " + tempProductUnit.discountedPrice + " x \(tempModel.quantity)"
            }
        }
        
        cell.productNameLabel.text = tempModel.title
        
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 105
    }
    
    // MARK: - Wishlist Table View Delegate
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: scrollView)
    }
    
    // MARK: - Wishlist Table View Delegate
    func deleteButtonActionForIndex(sender: AnyObject){
        if Reachability.isConnectedToNetwork() {
            var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
            var rowOfTheCell: Int = pathOfTheCell.row
            
            let tempModel: CartProductDetailsModel = tableData[rowOfTheCell]
            
            var params: NSDictionary = ["access_token": SessionManager.accessToken(),
                "productId": tempModel.id,
                "unitId": tempModel.unitId,
                "quantity": 0,
            ]
            fireDeleteCartItem(APIAtlas.updateCartUrl, params: params)
        } else {
            showAlert("Connection Unreachable", message: "Cannot retrieve data. Please check your internet connection.")
        }
    }
    
    func seeMoreAttribute(index: Int) {
        
        var tempModel: CartProductDetailsModel = tableData[index]
        var selectedProductUnits: ProductUnitsModel?
        
        for tempProductUnit in tempModel.productUnits {
            if tempModel.unitId == tempProductUnit.productUnitId {
                selectedProductUnits = tempProductUnit
            }
        }

        
        println(selectedValue)
        
        var attributeModal = CartProductAttributeViewController(nibName: "CartProductAttributeViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.backgroundColor = UIColor.clearColor()
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
        attributeModal.passModel(cartModel: tempModel, selectedProductUnits: selectedProductUnits!)
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            self.navigationController?.navigationBar.alpha = 0.0
        })
        
    }
    
    func editButtonActionForIndex(sender: AnyObject){
        /*
        if Reachability.isConnectedToNetwork() {
            var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
            var rowOfTheCell: Int = pathOfTheCell.row
            
            let tempModel: CartProductDetailsModel = tableData[rowOfTheCell]
            
            var params: NSDictionary = ["access_token": SessionManager.accessToken(),
                "wishlist": "true",
                "productId": tempModel.id,
                "unitId": tempModel.unitId,
                "quantity": tempModel.quantity
            ]
            
            fireAddToCartItem(APIAtlas.updateCartUrl, params: params)
        } else {
            showAlert("Connection Unreachable", message: "Cannot retrieve data. Please check your internet connection.")
        }*/
        
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row

        seeMoreAttribute(rowOfTheCell)
    }
    
    func checkBoxButtonActionForIndex(sender: AnyObject, state: Bool){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        tableData[rowOfTheCell].selected = state

        calculateTotalPrice()
    }
    
    func swipeViewDidScroll(sender: AnyObject) {
        NSNotificationCenter.defaultCenter().postNotificationName("SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification", object: self)
    }
    
    // MARK: - Cart Product Attribute View Controller Delegate
    func pressedCancelAttribute(controller: CartProductAttributeViewController) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.navigationController?.navigationBar.alpha = 1.0
        })
    }
    
    func pressedDoneAttribute(controller: CartProductAttributeViewController) {
        UIView.animateWithDuration(0.3, animations: {
            self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            self.dimView.alpha = 0
            self.navigationController?.navigationBar.alpha = 1.0
        })
    }
    
    func didTapReload() {
        emptyView?.hidden = true
        getCartData()
    }
    
    func addEmptyView() {
        if self.emptyView == nil {
            self.emptyView = UIView.loadFromNibNamed("EmptyView", bundle: nil) as? EmptyView
            self.emptyView?.frame = self.view.frame
            self.emptyView!.delegate = self
            self.view.addSubview(self.emptyView!)
        } else {
            self.emptyView!.hidden = false
        }
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            alertController.dismissViewControllerAnimated(true, completion: nil)
            
            let appDelegate: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.changeRootToHomeView()
        }
        
        alertController.addAction(OKAction)
        
        self.presentViewController(alertController, animated: true) {
            
        }
    }
    
    func requestRefreshToken(type: String, url: String, params: NSDictionary!) {
        let url: String = "http://online.api.easydeal.ph/api/v1/login"
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID,
            "client_secret": Constants.Credentials.clientSecret,
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SVProgressHUD.dismiss()
            
            if (responseObject["isSuccessful"] as! Bool) {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                
                if type == "getCart" {
                    self.requestProductDetails(url, params: params)
                } else if type == "editToCart" {
                    self.fireAddToCartItem(url, params: params)
                } else if type == "deleteWishlist" {
                    self.fireDeleteCartItem(url, params: params)
                }
            } else {
                self.showAlert("Error", message: responseObject["message"] as! String)
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                self.showAlert("Something went wrong", message: "")
                
        })
    }

    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
}
