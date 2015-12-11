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
    func pressedDoneAttribute(controller: CartProductAttributeViewController, productID: Int, unitID: Int, itemID: Int, quantity: Int)
}

class CartProductAttributeViewController: UIViewController, UITableViewDelegate, CartProductAttributeTableViewCellDelegate {
    
    var manager = APIManager()
    
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityTextLabel: UILabel!
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
    
    var availableLocalizeString: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stocksLabel.layer.borderWidth = 1.2
        stocksLabel.layer.borderColor = UIColor.grayColor().CGColor
        stocksLabel.layer.cornerRadius = 5
        
        let nib = UINib(nibName: "CartProductAttributeTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "CartProductAttributeTableViewCell")
        
//        let tap = UITapGestureRecognizer()
//        tap.numberOfTapsRequired = 1
//        tap.addTarget(self, action: "dimViewAction:")
//        self.dimView.addGestureRecognizer(tap)
        self.dimView.backgroundColor = .clearColor()
        
        initializeLocalizedString()
    }
    
    func initializeLocalizedString() {
        let cancelLocalizeString: String = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
        doneButton.setTitle(cancelLocalizeString, forState: UIControlState.Normal)
        
        let doneLocalizeString: String = StringHelper.localizedStringWithKey("DONE_LOCALIZE_KEY")
        doneButton.setTitle(doneLocalizeString, forState: UIControlState.Normal)
        
        let quantityLocalizeString: String = StringHelper.localizedStringWithKey("ENTER_QUANTITY_LOCALIZE_KEY")
        quantityTextLabel.text = quantityLocalizeString
        
        availableLocalizeString = StringHelper.localizedStringWithKey("AVAILABLE_STOCKS_LOCALIZE_KEY")
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetailModel!.attributes.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CartProductAttributeTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("CartProductAttributeTableViewCell") as! CartProductAttributeTableViewCell
        
        var productAttribute: ProductAttributeModel = productDetailModel!.attributes[indexPath.row]
        cell.delegate = self
        cell.passModel(productAttribute, selectedAttributes: selectedCombinations)
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
        if self.selectedCombinations.count !=  selectedProductUnit.combinationNames.count {
            let alertController = UIAlertController(title: ProductStrings.alertCannotProcceed, message: ProductStrings.alertComplete, preferredStyle: .Alert)
            let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
            alertController.addAction(defaultAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else {
            if self.stocks == 0 {
                let alertController = UIAlertController(title: ProductStrings.alertFailed, message: ProductStrings.alertOutOfStock, preferredStyle: .Alert)
                let defaultAction = UIAlertAction(title: ProductStrings.alertOk, style: .Default, handler: nil)
                alertController.addAction(defaultAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
                var productID = productDetailModel?.id.toInt()!
                var itemID = productDetailModel?.itemId
                delegate?.pressedDoneAttribute(self, productID: productID!, unitID: selectedProductUnit.productUnitId.toInt()!, itemID: itemID!, quantity: stocks)
            }
        }
    }
    
    // MARK: - Methods
    
    func passModel(#cartModel: CartProductDetailsModel, selectedProductUnits: ProductUnitsModel) {
        productDetailModel = cartModel
        
        self.maximumStock = selectedProductUnits.quantity
        if maximumStock < 0 {
            maximumStock = 0
        }
        
        stocks = cartModel.quantity
        checkStock(stocks)
        selectedProductUnit = selectedProductUnits
        self.availabilityStocksLabel.text = availableLocalizeString + ": " + String(maximumStock)
        
        selectedCombinations = selectedProductUnit.combinationNames
        
        if productDetailModel!.images.count != 0 && selectedProductUnit!.imageIds.count != 0 {
            for tempImage in productDetailModel!.images {
                if tempImage.id == selectedProductUnit!.imageIds[0] {
                    setDetail(tempImage.fullImageLocation, title: productDetailModel!.title, price: selectedProductUnit.discountedPrice)
                }
            }
        } else {
            setDetail("dummy-placeholder", title: productDetailModel!.title, price: selectedProductUnit.discountedPrice)
        }
        
        getAvailableCombinations()
    }
    
    func selectedAttribute(attributeId: String){
        if !contains(selectedCombinations, attributeId) {
            selectedCombinations.append(attributeId)
            updateDetails(checkSelectedIfAvailable(selectedCombinations))
        }
        tableView.reloadData()
    }
    
    func deselectedAttribute(attributeId: String) {
        for var i = 0; i < selectedCombinations.count; i++ {
            if selectedCombinations[i] == attributeId {
                selectedCombinations.removeAtIndex(i)
                break
            }
        }
        updateDetails(checkSelectedIfAvailable(selectedCombinations))
        tableView.reloadData()
    }
    
    func getAvailableCombinations() {
        for var i = 0; i < productDetailModel!.productUnits.count; i++ {
            unitIDs.append(productDetailModel!.productUnits[i].productUnitId)
            availableCombinations[productDetailModel!.productUnits[i].productUnitId] = productDetailModel!.productUnits[i].combinationNames
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
            
            if productDetailModel!.images.count != 0 && selectedProductUnit!.imageIds.count != 0 {
                for tempImage in productDetailModel!.images {
                    if tempImage.id == selectedProductUnit!.imageIds[0] {
                        setDetail(tempImage.fullImageLocation, title: productDetailModel!.title, price: selectedProductUnit.discountedPrice)
                    }
                }
            } else {
                setDetail("dummy-placeholder", title: productDetailModel!.title, price: selectedProductUnit.discountedPrice)
            }
            
            priceLabel.text = selectedProductUnit.discountedPrice.formatToPeso()
            self.maximumStock = selectedProductUnit.quantity
            if maximumStock <= 0 {
                maximumStock = 0
                stocks = 0
            } else {
                stocks = 1
            }
            
            checkStock(stocks)
            self.availabilityStocksLabel.text = availableLocalizeString + ": " + String(maximumStock)
            
        } else {
            priceLabel.text = "0".formatToTwoDecimal()
            self.maximumStock = 0
            stocks = 0
            checkStock(stocks)
            self.availabilityStocksLabel.text = availableLocalizeString + ": " + String(0)
        }
        
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
        priceLabel.text = price.formatToPeso()
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
