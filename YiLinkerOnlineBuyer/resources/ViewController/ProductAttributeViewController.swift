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
    func doneActionPassDetailsToProductView(controller: ProductAttributeViewController, unitId: String, quantity: Int, selectedId: NSArray, images: [String])
    func gotoCheckoutFromAttributes(controller: ProductAttributeViewController, unitId: String, quantity: Int)
}

class ProductAttributeViewController: UIViewController, UITableViewDelegate, ProductAttributeTableViewCellDelegate {
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var enterQuantityLabel: UILabel!
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
    var imageUrls: [String] = []
    
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
    var price: String = ""
    
    var selectedAttributes: [String] = []
    
    var hud: MBProgressHUD?
    var isEditingAttributes: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        customizeViews()
        
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
//        println(selectedValue)
        listAvailableCombinations()
        cell.isEditingAttribute = isEditingAttributes
        cell.setAttribute(self.productDetailsModel.attributes[indexPath.row], availableCombination: self.availableCombination, selectedValue: self.selectedValue, selectedId: self.selectedId, width: self.view.frame.size.width, currentAttributes: self.selectedAttributes)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        println(indexPath.row)
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
        
        if self.selectedAttributes.contains("") {
            let alertController = UIAlertController(title: ProductStrings.alertCannotProcceed, message: ProductStrings.alertComplete, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            if self.quantity == 0 {
                let alertController = UIAlertController(title: ProductStrings.alertFailed, message: ProductStrings.alertOutOfStock, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                hideSelf("done")
                let quantity: Int = stocksLabel.text!.toInt()!
                delegate!.doneActionPassDetailsToProductView(self, unitId: unitId, quantity: quantity, selectedId: selectedId, images: self.imageUrls)
            }
        }
    }
    
    @IBAction func checkoutAction(sender: AnyObject) {
        hideSelf("buy")
        if let delegate = self.delegate {
             delegate.gotoCheckoutFromAttributes(self, unitId: self.unitId, quantity: quantity)
        }
    }
    
    @IBAction func addToCartAction(sender: AnyObject) {
        
        if self.selectedAttributes.contains("") {
            let alertController = UIAlertController(title: ProductStrings.alertCannotProcceed, message: ProductStrings.alertComplete, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            if self.quantity == 0 {
                let alertController = UIAlertController(title: ProductStrings.alertFailed, message: ProductStrings.alertOutOfStock, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                let url: String = APIAtlas.updateCart()
                let quantity: Int = stocksLabel.text!.toInt()!
                
                let params: NSDictionary = ["access_token": SessionManager.accessToken(),
                    "productId": self.productDetailsModel.id,
                    "unitId": unitId,
                    "quantity": String(quantity)]
                
                println(params)
                
                requestAddCartItem(url, params: params)
            }
        }
    }
    
    func dimViewAction(gesture: UIGestureRecognizer) {
//        cancelAction(nil)
    }
    
    func buyItNowAction(gesture: UIGestureRecognizer) {
        if self.quantity == 0 {
            let alertController = UIAlertController(title: ProductStrings.alertFailed, message: ProductStrings.alertOutOfStock, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            var selectionComplete: Bool = true
            
            for i in 0..<self.selectedId.count {
                if selectedId[i] == "-1" {
                    selectionComplete = false
                }
            }
            
            if selectionComplete {
                hideSelf("buy")
                let quantity: Int = stocksLabel.text!.toInt()!
                delegate!.gotoCheckoutFromAttributes(self, unitId: self.unitId, quantity: quantity)
            } else {
                let alertController = UIAlertController(title: ProductStrings.alertError, message: ProductStrings.alertComplete, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - Methods
    
    func customizeViews() {
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
        
        cancelButton.setTitle(ProductStrings.cancel, forState: .Normal)
        doneButton.setTitle(ProductStrings.done, forState: .Normal)
        enterQuantityLabel.text = ProductStrings.enterQuantity
        addToCartButton.setTitle(ProductStrings.addToCart, forState: .Normal)
        buyItNowLabel.text = ProductStrings.buytItNow
    }
    
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
        if regex == "()" {
            regex = "(" + not + ")"
        }
        
        let re = NSRegularExpression(pattern: regex, options: nil, error: nil)!
        let matches = re.matchesInString(combinationString, options: nil, range: NSRange(location: 0, length: count(combinationString.utf16)))
        
        for match in matches as! [NSTextCheckingResult] {
            let substring = (combinationString as NSString).substringWithRange(match.rangeAtIndex(1))
            if substring != "" {
                self.availableCombination.append(substring)
                // compare
                // get the id
            }
        }
        
    }
    
    func availableStock(unitId: String) -> Int {
        
        for productUnit in self.productDetailsModel.productUnits {
            if productUnit.productUnitId == unitId {
                return productUnit.quantity
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
        
        let priceWithoutComma = price.stringByReplacingOccurrencesOfString(",", withString: "")
        
        var priceDouble: Float = NSString(string: priceWithoutComma).floatValue
        var stockDouble: Float = NSString(string: self.stocksLabel.text!).floatValue
        
        priceLabel.text = "₱" + (priceDouble * stockDouble).string(2)
        
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
    
    func setDetail(#image: String, title: String, price: String) {
        
//        productImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
        nameLabel.text = title
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
        if self.quantity == 0 {
            let alertController = UIAlertController(title: ProductStrings.alertFailed, message: ProductStrings.alertOutOfStock, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
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
                                let alertController = UIAlertController(title: ProductStrings.alertError, message: tempVar, preferredStyle: .Alert)
                                let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
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
                        let alertController = UIAlertController(title: ProductStrings.alertWentWrong, message: nil, preferredStyle: .Alert)
                        let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
                        alertController.addAction(defaultAction)
                        self.presentViewController(alertController, animated: true, completion: nil)
                    }
            })
        }
        
    }
    
    func requestRefreshToken() {
        let params: NSDictionary = ["client_id": Constants.Credentials.clientID(),
            "client_secret": Constants.Credentials.clientSecret(),
            "grant_type": Constants.Credentials.grantRefreshToken,
            "refresh_token": SessionManager.refreshToken()]
        
        let manager = APIManager.sharedInstance
        manager.POST(APIAtlas.loginUrl, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            
            self.hud?.hide(true)
            
            if responseObject.isKindOfClass(NSDictionary) {
                
                if let tempVar = responseObject["isSuccessful"] as? Bool {
                    if tempVar {
                        SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                        
                        let url: String = APIAtlas.updateCart()
                        let quantity: String = String(stringInterpolationSegment: self.stocksLabel.text?.toInt())
                        
                        let params: NSDictionary = ["access_token": SessionManager.accessToken(),
                            "productId": self.productDetailsModel.id,
                            "unitId": String(self.unitId.toInt()! + 1),
                            "quantity": quantity]
                        self.requestAddCartItem(url, params: params)
                    } else {
                        self.hud?.hide(true)
                        if let tempVar = responseObject["message"] as? String {
                            let alertController = UIAlertController(title: ProductStrings.alertError, message: tempVar, preferredStyle: .Alert)
                            let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
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
                
                let alertController = UIAlertController(title: ProductStrings.alertWentWrong, message: nil, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
                
        })
    }
    
    // MARK: - Delegates
    
    func passModel(#productDetailsModel: ProductDetailsModel, selectedValue: NSArray, selectedId: NSArray, unitIdIndex: Int, quantity: Int, price: String, imageIndex: Int) {
        
        self.quantity = quantity
        
        self.attributes = productDetailsModel.attributes as [ProductAttributeModel]
        self.selectedId = selectedId as! [String]
        self.selectedValue = selectedValue as! [String]
        self.unitId = productDetailsModel.productUnits[unitIdIndex].productUnitId
        self.selectedCombination = productDetailsModel.productUnits[unitIdIndex].combination
        
        self.selectedAttributes = selectedValue as! [String]
        
//        setDetail(image: productDetailsModel.images[unitIdIndex].imageLocation, title: productDetailsModel.title, price: price)
        self.productDetailsModel = productDetailsModel
        self.nameLabel.text = productDetailsModel.title
        if productDetailsModel.productUnits[unitIdIndex].discount == 0 {
            self.price = productDetailsModel.productUnits[unitIdIndex].price
        } else {
            self.price = productDetailsModel.productUnits[unitIdIndex].discountedPrice
        }
        
        self.imageUrls = []
        for i in 0..<self.productDetailsModel.productUnits.count {
            if selectedCombination == self.productDetailsModel.productUnits[i].combination {
                if self.productDetailsModel.productUnits[i].imageIds.count != 0 {
                    for j in 0..<self.productDetailsModel.productUnits[i].imageIds.count {
                        for l in 0..<self.productDetailsModel.images.count {
                            if self.productDetailsModel.productUnits[i].imageIds[j] == self.productDetailsModel.images[l].id {
                                self.imageUrls.append(self.productDetailsModel.images[l].imageLocation)
                            }
                        }
                    }
                }
            }
        }
        
        if self.imageUrls.count != 0 {
            self.productImageView.sd_setImageWithURL(NSURL(string: self.imageUrls[0]), placeholderImage: UIImage(named: "dummy-placeholder"))
        }
        
        
        
        self.maximumStock = productDetailsModel.productUnits[unitIdIndex].quantity
        if productDetailsModel.productUnits[unitIdIndex].quantity == 0 {
            self.availabilityStocksLabel.text = ProductStrings.outOfStock
        } else {
            self.availabilityStocksLabel.text = ProductStrings.availableStocks + " : \(productDetailsModel.productUnits[unitIdIndex].quantity)"
        }
        
        convertCombinationToString()
        
        if self.maximumStock != 0 {
            stocks = quantity
            checkStock(stocks)
        } else if self.maximumStock == 0 {
            checkStock(0)
        } else {
            println("----ProductAttributeViewController")
        }
    }
    
    func passModel2(#productDetailsModel: ProductDetailsModel, selectedValue: [String], unitId: String, quantity: Int, price: String, imageIndex: Int) {
        self.productDetailsModel = productDetailsModel
        self.attributes = productDetailsModel.attributes as [ProductAttributeModel]
        self.selectedAttributes = selectedValue
        self.quantity = quantity
        self.unitId = unitId
        
        applyProductUnit(unitId)
    }
    
    func pressedDimViewFromProductPage(controller: ProductViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func selectedAttribute(controller: ProductAttributeTableViewCell, attributeIndex: Int, attributeValue: String!, attributeId: Int) {
        self.isEditingAttributes = true
        self.selectedId[attributeIndex] = String(attributeId)
        self.selectedValue[attributeIndex] = String(attributeValue)
        self.selectedCombination[attributeIndex] = String(attributeId)
        
        for i in 0..<self.productDetailsModel.productUnits.count {
            if self.productDetailsModel.productUnits[i].combination == selectedId {
                unitId = self.productDetailsModel.productUnits[i].productUnitId
                
                if self.productDetailsModel.productUnits[i].discountedPrice.floatValue == 0 {
                    self.price = productDetailsModel.productUnits[i].price
                } else {
                    self.price = productDetailsModel.productUnits[i].discountedPrice
                }
            }
        }
        
        var index: Int = 0
        self.imageUrls = []
        for i in 0..<self.productDetailsModel.productUnits.count {
            if selectedCombination == self.productDetailsModel.productUnits[i].combination {
                index = i
                if self.productDetailsModel.productUnits[i].imageIds.count != 0 {
                    for j in 0..<self.productDetailsModel.productUnits[i].imageIds.count {
                        for l in 0..<self.productDetailsModel.images.count {
                            if self.productDetailsModel.productUnits[i].imageIds[j] == self.productDetailsModel.images[l].id {
                                self.imageUrls.append(self.productDetailsModel.images[l].imageLocation)
                            }
                        }
                    }
                }
            }
        }
        
        if self.imageUrls.count != 0 {
            self.productImageView.sd_setImageWithURL(NSURL(string: self.imageUrls[0]), placeholderImage: UIImage(named: "dummy-placeholder"))
        }
        
//        maximumStock = availableStock(selectedCombination)
        self.availabilityStocksLabel.text = "Available stocks : " + String(maximumStock)
        
        listAvailableCombinations()

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
    
    func selectedAttribute2(controller: ProductAttributeTableViewCell, currentSelected: [String]) {
        self.selectedAttributes = currentSelected
        
        var ctr: Int = 0
        for i in 0..<self.attributes.count {
            if !self.attributes[i].choices.contains(self.selectedAttributes[i + 1]) {
                applyProductUnit("0")
                break
            } else { // if selected attributes is complete
                ctr++
                if self.attributes.count == ctr {
                    var selectedAttributeWOQ: [String] = self.selectedAttributes
                    selectedAttributeWOQ.removeAtIndex(0)
                    for productUnit in self.productDetailsModel.productUnits {
                        if productUnit.combinationNames == selectedAttributeWOQ {
                            unitId = productUnit.productUnitId
                            applyProductUnit(productUnit.productUnitId)
                        }
                    }
                }
            }
        }
        
        
        self.tableView.reloadData()
    }
    
    func applyProductUnit(unitId: String) {
        for productUnit in self.productDetailsModel.productUnits {
            if productUnit.productUnitId == unitId {
                if productUnit.discountedPrice.floatValue == 0 {
                    self.price = productUnit.price
                } else {
                    self.price = productUnit.discountedPrice
                }
            }
        }
        self.nameLabel.text = productDetailsModel.title
        var index: Int = 0
        self.imageUrls = []
        for productUnit in self.productDetailsModel.productUnits {
            if productUnit.productUnitId == unitId {
                if productUnit.imageIds.count != 0 {
                    for j in 0..<productUnit.imageIds.count {
                        for l in 0..<self.productDetailsModel.images.count {
                            if productUnit.imageIds[j] == self.productDetailsModel.images[l].id {
                                self.imageUrls.append(self.productDetailsModel.images[l].imageLocation)
                            }
                        }
                    }
                }
            }
        }
        
        if self.imageUrls.count != 0 {
            self.productImageView.sd_setImageWithURL(NSURL(string: self.imageUrls[0]), placeholderImage: UIImage(named: "dummy-placeholder"))
        }
        
        maximumStock = availableStock(unitId)
        self.availabilityStocksLabel.text = "Available stocks : " + String(maximumStock)
        
        if self.maximumStock != 0 {
            stocks = 1
            if self.quantity > 1 {
                stocks = self.quantity
            }
            checkStock(stocks)
        } else if self.maximumStock == 0 {
            checkStock(0)
        } else {
            println("----ProductAttributeViewController")
        }
        
        self.tableView.reloadData()
    }
    
}

extension Array {
    func contains<T where T : Equatable>(obj: T) -> Bool {
        return self.filter({$0 as? T == obj}).count > 0
    }
}
