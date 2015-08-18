//
//  ProductAttributeViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol CartProductAttributeViewControllerDelegate {
    func pressedCancelAttribute(controller: CartProductAttributeViewController)
    func pressedDoneAttribute(controller: CartProductAttributeViewController)
}

class CartProductAttributeViewController: UIViewController, UITableViewDelegate, ProductAttributeTableViewCellDelegate {
    
    var manager = APIManager()
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availabilityStocksLabel: UILabel!
    @IBOutlet weak var stocksLabel: UILabel!
    @IBOutlet weak var decreaseButton: UIButton!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var delegate: CartProductAttributeViewControllerDelegate?
    
    var minimumStock = 1
    var maximumStock = 1
    var stocks: Int = 0
    
    var cartModel : CartModel?
    var productDetailModel: CartProductDetailsModel?
    var attributes: [ProductAttributeModel] = []
    var availableCombinations: [ProductAvailableAttributeCombinationModel] = []
    var selectedValue: [String] = []
    var selectedCombination: [Int] = []
    
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
    }
    
    func fireEditCartItem(url: String, quantity: Int!) {
        
        var params = Dictionary<String, String>()
        
        params["access_token"] = "access_token"
        params["productId"] = "\(cartModel?.productDetails.id)"
        params["unitId"] = "\(cartModel?.unitId)"
        params["quantity"] = "\(quantity)"
        
        showLoader()
        manager.GET(url, parameters: params, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
                self.dismissLoader()
                println(params)
                self.dismissViewControllerAnimated(true, completion: nil)
                if let delegate = self.delegate {
                    delegate.pressedDoneAttribute(self)
                }
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println("failed: \(error)")
                self.dismissLoader()
        })
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
        cell.setAttribute(name: attributes[indexPath.row].attributeName, values: attributes[indexPath.row].valueName, id: attributes[indexPath.row].valueId, selectedValue: selectedValue)
        
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
        self.dismissViewControllerAnimated(true, completion: nil)
        println(attributes.count)
        println(availableCombinations.count)
        if let delegate = self.delegate {
            delegate.pressedCancelAttribute(self)
        }
    }
    
    @IBAction func doneAction(sender: AnyObject!) {
        fireEditCartItem("https://demo3526363.mockable.io/api/v1/auth/cart/updateCartItem", quantity: stocks)
    }
    
    // MARK: - Methods
    
    func passModel(#cartModel: CartModel, combinationModel: [ProductAvailableAttributeCombinationModel], selectedValue: NSArray, quantity: Int) {
        setDetail("\(cartModel.productDetails.image)", title: cartModel.productDetails.title, price: cartModel.productDetails.newPrice)
        self.cartModel = cartModel
        self.attributes = cartModel.productDetails.attributes as [ProductAttributeModel]
        self.availableCombinations = combinationModel
        self.selectedValue = selectedValue as! [String]
        self.selectedCombination = combinationModel[0].combination
        self.maximumStock = combinationModel[0].quantity
        
        stocks = quantity
        
        checkStock(stocks)
    }
    
    func selectedAttribute(controller: ProductAttributeTableViewCell, attributeIndex: Int, attributeValue: String!, attributeId: Int) {
        stocks = 0
        checkStock(stocks)
        self.selectedValue[attributeIndex + 1] = String(attributeValue)
        self.selectedCombination[attributeIndex] = attributeId
        
        maximumStock = availableStock(selectedCombination)
        self.availabilityStocksLabel.text = "Available stocks : " + String(availableStock(selectedCombination))
        
        checkStock(stocks)
    }
    
    func availableStock(combination: NSArray) -> Int {
        
        for i in 0..<availableCombinations.count {
            println(selectedCombination)
            if availableCombinations[i].combination == selectedCombination {
                println("benga! > \(availableCombinations[i].quantity)")
                return availableCombinations[i].quantity
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
        
        if stocks == 0  && maximumStock != 0 {
            enableButton(increaseButton)
            disableButton(decreaseButton)
            stocksLabel.alpha = 1.0
        } else if stocks == 0  && maximumStock == 0{
            stocksLabel.alpha = 0.3
            disableButton(increaseButton)
        } else if stocks == maximumStock {
            stocksLabel.alpha = 1.0
            disableButton(increaseButton)
        } else if stocks == minimumStock {
            stocksLabel.alpha = 1.0
            disableButton(decreaseButton)
        } else if stocks > 0 || stocks < maximumStock {
            enableButton(increaseButton)
            enableButton(decreaseButton)
        }
    }
    
    func setDetail(image: String, title: String, price: Float) {
        
        productImageView.sd_setImageWithURL(NSURL(string: image), placeholderImage: UIImage(named: "dummy-placeholder"))
        nameLabel.text = title
        priceLabel.text = String(format: "P %.2f", price)
    }
    
    func disableButton(button: UIButton) {
        button.userInteractionEnabled = false
        button.alpha = 0.3
    }
    
    func enableButton(button: UIButton) {
        button.userInteractionEnabled = true
        button.alpha = 1
    }
    
    func dismissPresentedController(controller: ProductViewController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dimViewAction(gesture: UIGestureRecognizer) {
        cancelAction(nil)
    }
    
    //Loader function
    func showLoader() {
        SVProgressHUD.show()
        SVProgressHUD.setBackgroundColor(UIColor.whiteColor())
    }
    
    func dismissLoader() {
        SVProgressHUD.dismiss()
    }
}
