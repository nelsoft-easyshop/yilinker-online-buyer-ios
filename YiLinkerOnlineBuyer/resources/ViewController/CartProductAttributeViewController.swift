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

class CartProductAttributeViewController: UIViewController, UITableViewDelegate, CartProductAttributeTableViewCellDelegate {
    
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
    
    var productDetailModel: CartProductDetailsModel?
    var selectedProductUnit: ProductUnitsModel!
    
    var availableCombinations = [String: [String]]()
    
    var selectedCombinations: [String] = []
    
    var unitIDs: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stocksLabel.layer.borderWidth = 1.2
        stocksLabel.layer.borderColor = UIColor.grayColor().CGColor
        stocksLabel.layer.cornerRadius = 5
        
        let nib = UINib(nibName: "CartProductAttributeTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CartProductAttributeTableViewCell")
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: "dimViewAction:")
        self.dimView.addGestureRecognizer(tap)
        self.dimView.backgroundColor = .clearColor()
    }
    
    func fireEditCartItem(url: String, quantity: Int!) {
        
        var params = Dictionary<String, String>()
        
        params["access_token"] = SessionManager.accessToken()
        params["productId"] = "\(productDetailModel?.id)"
        params["unitId"] = "\(productDetailModel?.unitId)"
        params["quantity"] = "\(productDetailModel?.quantity)"
        
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
        return productDetailModel!.attributes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CartProductAttributeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CartProductAttributeTableViewCell") as! CartProductAttributeTableViewCell
        
        var productAttribute: ProductAttributeModel = productDetailModel!.attributes[indexPath.row]
        cell.delegate = self
        cell.passModel(productAttribute, selectedProductUnit: selectedProductUnit, availableCombination: availableCombinations, unitID: unitIDs)
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
        if let delegate = self.delegate {
            delegate.pressedCancelAttribute(self)
        }
    }
    
    @IBAction func doneAction(sender: AnyObject!) {
        fireEditCartItem("https://demo3526363.mockable.io/api/v1/auth/cart/updateCartItem", quantity: stocks)
    }
    
    // MARK: - Methods
    
    func passModel(#cartModel: CartProductDetailsModel, selectedProductUnits: ProductUnitsModel) {
        productDetailModel = cartModel
        setDetail(productDetailModel!.image, title: productDetailModel!.title, price: selectedProductUnits.discountedPrice)
        self.maximumStock = selectedProductUnits.quantity
        stocks = cartModel.quantity
        checkStock(stocks)
        selectedProductUnit = selectedProductUnits
        self.availabilityStocksLabel.text = "Available stocks : " + String(maximumStock)
        
        selectedCombinations = selectedProductUnit.combination
        
        getAvailableCombinations()
    }
    
    func selectedAttribute(attributeId: String){
        println(selectedCombinations)
        if !contains(selectedCombinations, attributeId) {
            selectedCombinations.append(attributeId)
            println(checkSelectedIfAvailable(selectedCombinations))
            updateDetails(checkSelectedIfAvailable(selectedCombinations))
        }
        println(selectedCombinations)
    }
    
    func deselectedAttribute(attributeId: String) {
        println(selectedCombinations)
        for var i = 0; i < selectedCombinations.count; i++ {
            if selectedCombinations[i] == attributeId {
                selectedCombinations.removeAtIndex(i)
                break
            }
        }
        updateDetails(checkSelectedIfAvailable(selectedCombinations))
        println(selectedCombinations)
    }
    
    func getAvailableCombinations() {
        for var i = 0; i < productDetailModel!.productUnits.count; i++ {
            unitIDs.append(productDetailModel!.productUnits[i].productUnitId)
            availableCombinations[productDetailModel!.productUnits[i].productUnitId] = productDetailModel!.productUnits[i].combination
        }
    }
    
    func checkSelectedIfAvailable(selectedValues: [String]) -> String {
        var checker: [Bool] = []
        for var i = 0; i < availableCombinations.count; i++ {
            let tempProductUnitId: String = self.productDetailModel!.productUnits[i].productUnitId
            if sorted(selectedValues, <) == sorted(availableCombinations[tempProductUnitId]!, <) {
                return tempProductUnitId
            }
        }
        return ""
    }
    
    func updateDetails(unitId: String) {
        if !unitId.isEmpty {
            for tempProductUnit in productDetailModel!.productUnits {
                if unitId == tempProductUnit.productUnitId {
                    selectedProductUnit = tempProductUnit
                }
            }
            
            self.maximumStock = selectedProductUnit.quantity
            stocks = productDetailModel!.quantity
            checkStock(stocks)
            self.availabilityStocksLabel.text = "Available stocks : " + String(maximumStock)
        } else {
            self.maximumStock = 0
            stocks = 0
            checkStock(stocks)
            self.availabilityStocksLabel.text = "Available stocks : " + String(0)
        }
        
    }
    
    func checkStock(stocks: Int) {
        
        if stocks < 10 {
            stocksLabel.text = "0\(String(stringInterpolationSegment: stocks))"
        } else {
            stocksLabel.text = String(stringInterpolationSegment: stocks)
        }
        
        if stocks == 1  && maximumStock != 0 {
            enableButton(increaseButton)
            disableButton(decreaseButton)
            stocksLabel.alpha = 1.0
        } else if stocks == 1  && maximumStock == 0{
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
