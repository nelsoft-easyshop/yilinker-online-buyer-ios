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
    func doneActionPassDetailsToProductView(controller: ProductAttributeViewController, unitId: String, quantity: Int, selectedId: NSArray)
    func gotoCheckoutFromAttributes(controller: ProductAttributeViewController)
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
    
    var availableCombination: [String] = []
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
    var unitId: String = ""
    
    var hud: MBProgressHUD?
    
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
        cell.passProductDetailModel(self.productDetailsModel)
        cell.tag = indexPath.row
        println(selectedValue)
        listAvailableCombinations()
        cell.setAttribute(self.productDetailsModel.attributes[indexPath.row], availableCombination: self.availableCombination, selectedValue: self.selectedValue, selectedId: self.selectedId, width: self.view.frame.size.width)
        
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
    
    @IBAction func doneAction(sender: AnyObject) {
        var selectionComplete: Bool = true
        
        for i in 0..<self.selectedId.count {
            if selectedId[i] == "-1" {
                selectionComplete = false
            }
        }
        
        if selectionComplete {
            hideSelf("done")
            if let delegate = self.delegate {
                let quantity: Int = stocksLabel.text!.toInt()!
                println(unitId)
                delegate.doneActionPassDetailsToProductView(self, unitId: unitId, quantity: quantity, selectedId: selectedId)
            }
        } else {
            hideSelf("cancel")
        }
        
    }
    
    @IBAction func checkoutAction(sender: AnyObject) {
        hideSelf("buy")
        if let delegate = self.delegate {
            delegate.gotoCheckoutFromAttributes(self)
        }
    }
    
    @IBAction func addToCartAction(sender: AnyObject) {
        
        var selectionComplete: Bool = true
        
        for i in 0..<self.selectedId.count {
            if selectedId[i] == "-1" {
                selectionComplete = false
            }
        }
        
        if selectionComplete {
            let url: String = APIAtlas.updateCart()
            let quantity: Int = stocksLabel.text!.toInt()!
            
            let params: NSDictionary = ["access_token": SessionManager.accessToken(),
                "productId": self.productDetailsModel.id,
                "unitId": unitId,
                "quantity": String(quantity)]
            
            println(params)
            
            requestAddCartItem(url, params: params)
            
        } else {
            let alertController = UIAlertController(title: "Error", message: "Please complete the attributes.", preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func dimViewAction(gesture: UIGestureRecognizer) {
        cancelAction(nil)
    }
    
    func buyItNowAction(gesture: UIGestureRecognizer) {
        
        var selectionComplete: Bool = true
        
        for i in 0..<self.selectedId.count {
            if selectedId[i] == "-1" {
                selectionComplete = false
            }
        }
        
        hideSelf("buy")
        delegate!.gotoCheckoutFromAttributes(self)

    }
    
    // MARK: - Methods
    
    func listAvailableCombinations() {
        self.availableCombination = []
        let not = "[^,]*"
        var regex: String = ""
        
        regex += "("
        
        for i in 0..<self.selectedCombination.count {
            if self.selectedCombination[i].toInt() != -1 {
                regex += self.selectedCombination[i]
                if i != self.selectedCombination.count - 1 {
                    regex += "_"
                }
            }
            
            if i != self.selectedCombination.count - 1 {
                regex += not
            }
        }
        
        regex += ")"
        println(regex)
        
        let re = NSRegularExpression(pattern: regex, options: nil, error: nil)!
        let matches = re.matchesInString(combinationString, options: nil, range: NSRange(location: 0, length: count(combinationString.utf16)))
        
        println("number of matches: \(matches.count)")
        
        for match in matches as! [NSTextCheckingResult] {
            let substring = (combinationString as NSString).substringWithRange(match.rangeAtIndex(1))
            if substring != "" {
                self.availableCombination.append(substring)
                // compare
                // get the id
            }
        }
        
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
    
    func hideSelf(action: String) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let delegate = self.delegate {
            delegate.dissmissAttributeViewController(self, type: action)
        }
    }
    
    func tapGesture(action: Selector) -> UITapGestureRecognizer {
        var tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        
        return tap
    }
    
    func setBorderOf(#view: AnyObject, width: CGFloat, color: UIColor, radius: CGFloat) {
        view.layer.borderWidth = width
        view.layer.borderColor = color.CGColor
        view.layer.cornerRadius = radius
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
    
    func requestAddCartItem(url: String, params: NSDictionary!) {
        self.showHUD()
        let manager = APIManager.sharedInstance
        manager.POST(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.hud?.hide(true)
            
            if responseObject.isKindOfClass(NSDictionary) {
                
                if let tempVar = responseObject["isSuccessful"] as? Bool {
                    if tempVar {
                        var data: NSDictionary = responseObject["data"] as! NSDictionary
                        var items: NSArray = data["items"] as! NSArray
                        SessionManager.setCartCount(data["total"] as! Int)
                        (self.tabController.tabBar.items![4] as! UITabBarItem).badgeValue = String(SessionManager.cartCount())
                        self.hideSelf("cart")
                        
                    } else {
                        if let tempVar = responseObject["message"] as? String {
                            let alertController = UIAlertController(title: "Error", message: tempVar, preferredStyle: .Alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                if task.statusCode == 401 {
                    self.requestRefreshToken()
                } else {
                    println(error)
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
            
            self.hud?.hide(true)
            
            if responseObject.isKindOfClass(NSDictionary) {
                
                if let tempVar = responseObject["isSuccessful"] as? Bool {
                    if tempVar {
                        SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                        
                        let url: String = "http://online.api.easydeal.ph/api/v1/auth/cart/updateCartItem"
                        let quantity: String = String(stringInterpolationSegment: self.stocksLabel.text?.toInt())
                        
                        let params: NSDictionary = ["access_token": SessionManager.accessToken(),
                            "productId": self.productDetailsModel.id,
                            "unitId": String(self.unitId.toInt()! + 1),
                            "quantity": quantity]
                        self.requestAddCartItem(url, params: params)
                    } else {
                        self.hud?.hide(true)
                        if let tempVar = responseObject["message"] as? String {
                            let alertController = UIAlertController(title: "Error", message: tempVar, preferredStyle: .Alert)
                            let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            alertController.addAction(defaultAction)
                            self.presentViewController(alertController, animated: true, completion: nil)
                        }
                    }
                }
            }
            
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                self.hud?.hide(true)
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                
                let alertController = UIAlertController(title: "Something Went Wrong", message: nil, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
        })
    }
    
    // MARK: - Delegates
    
    func passModel(#productDetailsModel: ProductDetailsModel, selectedValue: NSArray, selectedId: NSArray, unitIdIndex: Int, quantity: Int) {
        
        setDetail("", title: productDetailsModel.title, price: productDetailsModel.productUnits[unitIdIndex].price)
        self.productDetailsModel = productDetailsModel
        self.attributes = productDetailsModel.attributes as [ProductAttributeModel]
        self.selectedId = selectedId as! [String]
        self.selectedValue = selectedValue as! [String]
        self.unitId = productDetailsModel.productUnits[unitIdIndex].productUnitId
        self.selectedCombination = productDetailsModel.productUnits[unitIdIndex].combination
        
        self.maximumStock = productDetailsModel.productUnits[unitIdIndex].quantity
        self.availabilityStocksLabel.text = "Available stocks : \(productDetailsModel.productUnits[unitIdIndex].quantity)"
        
        convertCombinationToString()
        println(combinationString)
        
        if self.maximumStock != 0 {
            stocks = quantity
            checkStock(stocks)
        } else if self.maximumStock == 0 {
            checkStock(0)
        } else {
            println("----ProductAttributeViewController")
        }
    }
    
    func pressedDimViewFromProductPage(controller: ProductViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectedAttribute(controller: ProductAttributeTableViewCell, attributeIndex: Int, attributeValue: String!, attributeId: Int) {
        self.selectedId[attributeIndex] = String(attributeId)
        self.selectedValue[attributeIndex] = String(attributeValue)
        self.selectedCombination[attributeIndex] = String(attributeId)
        
        for i in 0..<self.productDetailsModel.productUnits.count {
            if self.productDetailsModel.productUnits[i].combination == selectedId {
                unitId = self.productDetailsModel.productUnits[i].productUnitId
            }
        }
        
        maximumStock = availableStock(selectedCombination)
        self.availabilityStocksLabel.text = "Available stocks : " + String(maximumStock)
        
        listAvailableCombinations()
        println(self.availableCombination)
        self.tableView.reloadData()
        
        if self.maximumStock != 0 {
            stocks = 1
            checkStock(stocks)
        } else if self.maximumStock == 0 {
            checkStock(0)
        } else {
            println("----ProductAttributeViewController")
        }
    }
    
}
