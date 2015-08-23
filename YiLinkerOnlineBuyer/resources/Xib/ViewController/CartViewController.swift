//
//  CartViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CartViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CartTableViewCellDelegate, CartProductAttributeViewControllerDelegate {
    
    var manager = APIManager()
    
    @IBOutlet var cartTableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    
    @IBOutlet var totalPriceLabel: UILabel!
    @IBOutlet var cartCounterLabel: UILabel!
    
    @IBOutlet var checkoutButton: UIButton!
    
    var tableData: [CartModel] = []
    var selectedValue: [String] = []
    
    //formatter of Text to remove trailing decimal
    let formatter = NSNumberFormatter()
    
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
        
        populateWishListTableView()
    }
    
    @IBAction func buttonClicked(sender: AnyObject) {
    }
    
    func fireDeleteCartItem(url: String, params: NSDictionary!) {
        showLoader()
        manager.DELETE(url, parameters: params, success: {
                (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                print(responseObject as! NSDictionary)
                self.updateCounterLabel()
                self.dismissLoader()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
                self.dismissLoader()
        })
    }
    
    func requestProductDetails(url: String, params: NSDictionary!) {
        showLoader()
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            //print(responseObject as! NSDictionary)
            
            if let value: AnyObject = responseObject["data"] {
                for subValue in value["cartItems"] as! NSArray {
                    
                    let model: CartModel = CartModel.parseDataWithDictionary(subValue as! NSDictionary)
                    
                    self.tableData.append(model)
                }
                self.cartTableView.reloadData()
            }
            self.updateCounterLabel()
            self.dismissLoader()
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
                self.dismissLoader()
        })
    }
    
    func fireDeleteCartItem(url: String, index: Int!) {
        
        var params = Dictionary<String, String>()
        
        var cartModelTemp = tableData[index]
        
        params["access_token"] = "access_token"
        params["productId"] = "\(cartModelTemp.productDetails.id)"
        params["unitId"] = "\(cartModelTemp.unitId)"
        params["quantity"] = "\(0)"
        
        showLoader()
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.dismissLoader()
            self.populateWishListTableView()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
                self.dismissLoader()
        })
    }
    
    func seeMoreAttribute(index: Int) {
        
        var tempModel: CartModel = tableData[index]
        
        selectedValue = []
        selectedValue.append(String(tempModel.productDetails.combinations[0].quantity) + "x")
        
        var tempAttributeId: [Int] = []
        var tempAttributeName: [String] = []
        
//        for tempAttribute in tempModel.productDetails.attributes{
//            tempAttributeId += tempAttribute.valueId
//            tempAttributeName += tempAttribute.valueName
//        }
        
        for tempId in tempModel.selectedAttributes {
            if let index = find(tempAttributeId, tempId) {
                selectedValue.append(tempAttributeName[index])
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
        attributeModal.passModel(cartModel: tableData[index], combinationModel: tempModel.productDetails.combinations, selectedValue: selectedValue, quantity: tempModel.quantity)
        //        self.navigationController?.presentViewController(attributeModal, animated: true, completion: nil)
        self.tabBarController?.presentViewController(attributeModal, animated: true, completion: nil)
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView.alpha = 0.5
            self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            self.navigationController?.navigationBar.alpha = 0.0
        })

    }
    
    //Loader function
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }
    
    // MARK: Methods Updating Values
    func populateWishListTableView () {
        tableData = []
        requestProductDetails(APIAtlas.cartUrl, params: nil)
    }
    
    func updateCounterLabel() {
        if tableData.count < 2 {
            cartCounterLabel.text = "You have \(tableData.count) item in your cart"
        } else{
            cartCounterLabel.text = "You have \(tableData.count) items in your cart"
        }
    }
    
    func calculateTotalPrice() {
        var totalPrice: Double = 0.0
        for tempModel in tableData {
            if tempModel.selected {
                totalPrice += (Double(tempModel.productDetails.newPrice) * Double(tempModel.quantity))
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
        var tempModel: CartModel = tableData[indexPath.row]
        cell.productNameLabel.text = tempModel.productDetails.title
        cell.productItemImageView.sd_setImageWithURL(tempModel.productDetails.image, placeholderImage: UIImage(named: "dummy-placeholder"))   //no image yet in API
        println("\(tempModel.productDetails.image)")
        var tempAttributesText: String = ""
        var tempAttributeId: [Int] = []
        var tempAttributeName: [String] = []
        
//        for tempAttribute in tempModel.productDetails.attributes{
//            tempAttributeId += tempAttribute.valueId
//            tempAttributeName += tempAttribute.valueName
//        }
        
        for tempId in tempModel.selectedAttributes {
            if let index = find(tempAttributeId, tempId) {
                if tempAttributesText.isEmpty {
                    tempAttributesText = tempAttributeName[index]
                } else {
                    tempAttributesText += " | " + tempAttributeName[index]
                }
                
            }
        }
        cell.productDetailsLabel?.text = tempAttributesText
        
        cell.productPriceLabel.text = "P\(formatter.stringFromNumber(tempModel.productDetails.newPrice)!) x\(tempModel.quantity)"
        
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
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        fireDeleteCartItem("https://demo3526363.mockable.io/api/v1/auth/cart/updateCartItem", index: rowOfTheCell)
    }
    
    func editButtonActionForIndex(sender: AnyObject){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        seeMoreAttribute(rowOfTheCell)
    }
    
    func checkBoxButtonActionForIndex(sender: AnyObject, state: Bool){
        var pathOfTheCell: NSIndexPath = cartTableView.indexPathForCell(sender as! UITableViewCell)!
        var rowOfTheCell: Int = pathOfTheCell.row
        
        var tempModel: CartModel = tableData[rowOfTheCell]
        tempModel.selected = state

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
        
        populateWishListTableView()
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
