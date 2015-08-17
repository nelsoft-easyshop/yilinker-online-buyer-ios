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
    var selectedID: [String] = []
    var selectedCombination: [String] = []
    
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
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ProductAttributeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("AttributeTableCell") as! ProductAttributeTableViewCell
        
        cell.delegate = self
        cell.passAvailableCombination(availableCombinations)
        cell.tag = indexPath.row
        cell.setAttribute(self.productDetailsModel.attributes[indexPath.row], selectedValue: selectedValue, width: self.view.frame.size.width)
//        cell.setAttribute(name: attributes[indexPath.row].attributeName, values: attributes[indexPath.row].valueName, id: attributes[indexPath.row].valueId, selectedValue: selectedValue, width: screenWidth)
        
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
    
    func passModel(#productDetailsModel: ProductDetailsModel, selectedValue: NSArray) {
        setDetail("http://shop.bench.com.ph/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/Y/W/YWH0089BU4.jpg", title: productDetailsModel.title, price: productDetailsModel.productUnits[0].price)
        self.productDetailsModel = productDetailsModel
        self.attributes = productDetailsModel.attributes as [ProductAttributeModel]
//        self.availableCombinations = combinationModel
        self.selectedValue = selectedValue as! [String]
        self.selectedCombination = productDetailsModel.productUnits[0].combination
        self.maximumStock = productDetailsModel.productUnits[0].quantity
        
        self.availabilityStocksLabel.text = "Available stocks : \(productDetailsModel.productUnits[0].quantity)"
        
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
        println(selectedCombination)
        maximumStock = availableStock(selectedCombination)
        
        self.availabilityStocksLabel.text = "Available stocks : " + String(maximumStock)
        
        if self.maximumStock != 0 {
            stocks = 1
            checkStock(stocks)
        } else if self.maximumStock == 0 {
            checkStock(0)
        } else {
            println("----ProductAttributeViewController")
        }
    }
    
    func availableStock(combination: NSArray) -> Int {
        
        for i in 0..<self.productDetailsModel.productUnits.count {
            if selectedCombination == self.productDetailsModel.productUnits[i].combination {
                println("benga! > \(self.productDetailsModel.productUnits[i].quantity)")
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
        
        println(stocks)
        
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
        
//        else if stocks == maximumStock {
//            stocksLabel.alpha = 1.0
//            disableButton(increaseButton)
//        } else if stocks == minimumStock {
//            stocksLabel.alpha = 1.0
//            disableButton(decreaseButton)
//        } else if stocks > 0 && stocks < maximumStock {
//            stocksLabel.alpha = 1.0
//            enableButton(increaseButton)
//            enableButton(decreaseButton)
//        }
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
    
    @IBAction func addToCartAction(sender: AnyObject) {
        
        let url: String = "api/v1/auth/cart/updateCartItem"
        
        let params: NSDictionary = ["accessToken": "access token here",
                                         "unitId": "unit id here",
                                  "combinationId": "combination id here",
                                       "quantity": "quantity here"]
        
        println(params)
        
        requestAddCartItem(APIAtlas.productPageUrl, params: nil)
    }
    
    @IBAction func doneAction(sender: AnyObject) {
        println(selectedValue)
        hideSelf("done")
    }
    
    @IBAction func checkoutAction(sender: AnyObject) {
        println("CHECKOUT")
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

    func requestAddCartItem(url: String, params: NSDictionary!) {
        SVProgressHUD.show()
        let manager = APIManager.sharedInstance
        
        manager.GET(APIAtlas.productPageUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            SVProgressHUD.dismiss()
            println("product success")
            
            if let badgeValue = (self.tabController.tabBar.items![4] as! UITabBarItem).badgeValue?.toInt() {
                (self.tabController.tabBar.items![4] as! UITabBarItem).badgeValue = String(badgeValue + 1)
            } else {
                (self.tabController.tabBar.items![4] as! UITabBarItem).badgeValue = "1"
            }
            
            self.hideSelf("cart")
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                SVProgressHUD.dismiss()
                println("product failed")
        })
    }
    
    func hideSelf(action: String) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let delegate = self.delegate {
            delegate.dissmissAttributeViewController(self, type: action)
        }
    }
    
}
