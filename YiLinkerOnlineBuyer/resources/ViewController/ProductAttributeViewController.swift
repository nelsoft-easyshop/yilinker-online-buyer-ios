//
//  ProductAttributeViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductAttributeViewControllerDelegate {
    func dissmissAttributeViewController(controller: ProductAttributeViewController, type: String)
}

class ProductAttributeViewController: UIViewController, UITableViewDelegate, ProductAttributeTableViewCellDelegate {

    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availabilityStocksLabel: UILabel!
    @IBOutlet weak var stocksLabel: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var buyItNowView: UIView!
    @IBOutlet weak var checkoutButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var buyItNowLabel: UILabel!
    
    var delegate: ProductAttributeViewControllerDelegate?
    
    var minimumStock = 1
    var maximumStock = 1
    var stocks: Int = 0
    
    var productDetailsModel: ProductDetailsModel!
    var attributes: [ProductAttributeModel] = []
    var availableCombinations: [ProductAvailableAttributeCombinationModel] = []
    var selectedValue: [String] = []
    var selectedId: [String] = []
    
    var selectedCombination: [String] = []
    var combinationString: String = ""
    
    var screenWidth: CGFloat = 0.0
    var seeMoreLabel = UILabel()
    var setTitle: String = ""
    
    var tabController = CustomTabBarController()
    
    var accessToken = ""
    var quantity: Int = 1
    var unitId: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stocksLabel.layer.borderWidth = 1.2
        stocksLabel.layer.borderColor = UIColor.grayColor().CGColor
        stocksLabel.layer.cornerRadius = 5
        
        let nib = UINib(nibName: "ProductAttributeTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "AttributeTableCell")
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: "dimViewAction:")
        self.dimView.addGestureRecognizer(tap)
        self.dimView.backgroundColor = .clearColor()
        
        setBorderOf(view: addToCartButton, width: 1, color: .grayColor(), radius: 3)
        setBorderOf(view: buyItNowView, width: 1, color: .grayColor(), radius: 3)
        setBorderOf(view: checkoutButton, width: 1, color: .grayColor(), radius: 3)
        
        buyItNowView.addGestureRecognizer(tapGesture("buyItNowAction:"))
        
        priceLabel.textColor = Constants.Colors.productPrice
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
//        if setTitle == "cart" {
//            
//            seeMoreLabel = UILabel(frame: CGRectMake(0, 0, buyItNowView.frame.size.width, buyItNowView.frame.size.height))
//            seeMoreLabel.text = "PROCEED TO\nCHECKOUT"
//        } else if setTitle == "buy" {
//            self.checkoutButton.hidden = false
//        } else {
//            seeMoreLabel = UILabel(frame: CGRectMake((buyItNowView.frame.size.width / 2) - 60, 0, 90, buyItNowView.frame.size.height))
//            seeMoreLabel.frame.origin.x = 0
//            seeMoreLabel.frame.size.width = buyItNowView.frame.size.width
//            seeMoreLabel.text = "BUY IT NOW"
//            
//            var seeMoreImageView = UIImageView(frame: CGRectMake(seeMoreLabel.frame.size.width, (seeMoreLabel.frame.size.height / 2) - 6, 13, 13))
//            seeMoreImageView.image = UIImage(named: "buy")
//            //            seeMoreLabel.addSubview(seeMoreImageView)
//        }
//        
//        seeMoreLabel.numberOfLines = 2
//        seeMoreLabel.textColor = .whiteColor()
//        seeMoreLabel.textAlignment = .Center
//        seeMoreLabel.font = UIFont.boldSystemFontOfSize(13.0)
//        self.buyItNowView.addSubview(seeMoreLabel)
        
        if setTitle == "cart" {
            buyItNowLabel.text = "PROCEED TO\n CHECKOUT"
        } else if setTitle == "buy" {
            checkoutButton.hidden = false
        } else {
            
        }
    }
    
    func convertCombinationToString() {
        
        for i in 0..<self.productDetailsModel.productUnits.count {
            for j in 0..<self.productDetailsModel.productUnits[i].combination.count {
                self.combinationString += self.productDetailsModel.productUnits[i].combination[j]
                if j != self.productDetailsModel.productUnits[i].combination.count - 1{
                    self.combinationString += "_"
                }
            }
            self.combinationString += ","
        }
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductAttributeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AttributeTableCell") as! ProductAttributeTableViewCell
        
        cell.delegate = self
        cell.passAvailableCombination(availableCombinations)
        cell.tag = indexPath.row
        println(selectedValue)
        cell.setAttribute(self.productDetailsModel.attributes[indexPath.row], selectedValue: selectedValue, selectedId: selectedId, width: self.view.frame.size.width)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println(indexPath.row)
    }
    
    // MARK: - Actions
    
    @IBAction func decreaseAction(sender: AnyObject) {
        self.stocks -= 1
        checkStock(self.stocks)
    }
    
    @IBAction func increaseAction(sender: AnyObject) {
        self.stocks += 1
        checkStock(self.stocks)
    }
    
    @IBAction func cancelAction(sender: AnyObject!) {
        hideSelf("cancel")
    }
    
    // MARK: - Methods
    
    func passModel(#productDetailsModel: ProductDetailsModel, selectedValue: NSArray, selectedId: NSArray) {
        setDetail("http://shop.bench.com.ph/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/Y/W/YWH0089BU4.jpg", title: productDetailsModel.title, price: productDetailsModel.productUnits[0].price)
        self.productDetailsModel = productDetailsModel
        self.attributes = productDetailsModel.attributes as [ProductAttributeModel]
        self.selectedId = selectedId as! [String]
        self.selectedValue = selectedValue as! [String]
        
        self.selectedCombination = productDetailsModel.productUnits[0].combination
        
        self.maximumStock = productDetailsModel.productUnits[0].quantity
        self.availabilityStocksLabel.text = "Available stocks : \(productDetailsModel.productUnits[0].quantity)"
        
        convertCombinationToString()
        println(combinationString)
        
        if self.maximumStock != 0 {
            stocks = 1
            checkStock(stocks)
        } else if self.maximumStock == 0 {
            checkStock(0)
        } else {
            println("----ProductAttributeViewController")
        }
    }
    
    func selectedAttribute(controller: ProductAttributeTableViewCell, attributeIndex: Int, attributeValue: String!, attributeId: Int) {
        self.selectedValue[attributeIndex] = String(attributeValue)
        self.selectedCombination[attributeIndex] = String(attributeId)
        println(selectedValue)
        maximumStock = availableStock(selectedCombination)
        self.availabilityStocksLabel.text = "Available stocks : " + String(maximumStock)

        listAvailableCombinations()
        
        if self.maximumStock != 0 {
            stocks = 1
            checkStock(stocks)
        } else if self.maximumStock == 0 {
            checkStock(0)
        } else {
            println("----ProductAttributeViewController")
        }
    }
    
    func listAvailableCombinations() {
        println(selectedCombination)
    }
    
    func availableStock(combination: NSArray) -> Int {
        
        for i in 0..<self.productDetailsModel.productUnits.count {
            if selectedCombination == self.productDetailsModel.productUnits[i].combination {
                println("PRODUCT UNIT ID : \(self.productDetailsModel.productUnits[i].productUnitId)")
                return self.productDetailsModel.productUnits[i].quantity
            }
        }
        return 0
    }
    
    func checkStock(stocks: Int) {
        
        if stocks < 10 {
            stocksLabel.text = "0\(String(stringInterpolationSegment: stocks))"
        } else {
            stocksLabel.text = String(stringInterpolationSegment: stocks)
        }
        
        if stocks == 0 {
            disableButton(increaseButton)
            disableButton(decreaseButton)
            stocksLabel.alpha = 0.3
        } else if stocks == maximumStock {
            stocksLabel.alpha = 1.0
            disableButton(increaseButton)
        } else if stocks == minimumStock {
            stocksLabel.alpha = 1.0
            disableButton(decreaseButton)
            enableButton(increaseButton)
        } else if stocks > 0 && stocks < maximumStock {
            stocksLabel.alpha = 1.0
            enableButton(increaseButton)
            enableButton(decreaseButton)

        }
        
    }
    
    func setDetail(image: String, title: String, price: String) {
        
        productImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
        nameLabel.text = title
        priceLabel.text = price
    }
    
    func disableButton(button: UIButton) {
        button.userInteractionEnabled = false
        button.alpha = 0.3
    }
    
    func enableButton(button: UIButton) {
        button.userInteractionEnabled = true
        button.alpha = 1
    }
    
    func pressedDimViewFromProductPage(controller: ProductViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dimViewAction(gesture: UIGestureRecognizer) {
        cancelAction(nil)
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        println(selectedValue)
        hideSelf("done")
    }
    
    @IBAction func checkoutAction(sender: AnyObject) {
        println("CHECKOUT")
    }
    
    @IBAction func addToCartAction(sender: AnyObject) {
        
        let url: String = "http://online.api.easydeal.ph/api/v1/auth/cart/updateCartItem"
        let quantity = stocksLabel.text?.toInt()
        let params: NSDictionary = ["access_token": "NDEwMDZkYmQ2ZmU5YmVjMTRkNmM1NjI4NWMyMTM2MTcwMmRmZGM5OWExNTQ2YTAwNjU1ZGE5NTcyYmNjZTNjZQ",
                                       "productId": "1",
                                          "unitId": "1",
                                        "quantity": "10"]
        
        println(params)
        
        requestAddCartItem(url, params: params)
    }
    
    func requestAddCartItem(url: String, params: NSDictionary!) {
        SVProgressHUD.show()
        let manager = APIManager.sharedInstance
        
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SVProgressHUD.dismiss()
            
            if responseObject.isKindOfClass(NSDictionary) {
                
                if let tempVar = responseObject["isSuccessful"] as? Bool {
                    if tempVar {
                        self.hideSelf("cart")
                        self.addBadge()
                    } else {
                        if let tempVar = responseObject["message"] as? String {
                            println(tempVar)
                        }
                    }
                }
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                println(task.statusCode)
                
                println("update cart failed")
                println(error)
        })
    }
    
    func hideSelf(action: String) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let delegate = self.delegate {
            delegate.dissmissAttributeViewController(self, type: action)
        }
    }
    
    func addBadge() {
        if let badgeValue = (self.tabController.tabBar.items![4] as! UITabBarItem).badgeValue?.toInt() {
            (self.tabController.tabBar.items![4] as! UITabBarItem).badgeValue = String(badgeValue + 1)
        } else {
            (self.tabController.tabBar.items![4] as! UITabBarItem).badgeValue = "1"
        }
    }
    
    func tapGesture(action: Selector) -> UITapGestureRecognizer {
        var tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        
        return tap
    }
    
    func buyItNowAction(gesture: UIGestureRecognizer) {
        println("checkout")
    }
    
    func setBorderOf(#view: AnyObject, width: CGFloat, color: UIColor, radius: CGFloat) {
        view.layer.borderWidth = width
        view.layer.borderColor = color.CGColor
        view.layer.cornerRadius = radius
    }
    
}
