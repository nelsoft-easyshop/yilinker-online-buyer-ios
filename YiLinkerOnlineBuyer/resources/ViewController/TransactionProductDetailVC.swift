//
//  TransactionProductDetailVC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/23/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class TransactionProductDetailVC: UIViewController {

    @IBOutlet weak var productLabel: UILabel!
    @IBOutlet weak var productSubLabel: UILabel!
    
    var productImage = Array<String>()
    var productImageCellIdentifier = "productImageCell"
    @IBOutlet weak var productImageCollection: UICollectionView!
    
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var totalCostLabel: UILabel!
    
    struct productDetail {
        var detail : String
        var definition : String
    }

    var productDetails = Array<productDetail>()
    let productDetailCellIdentifier = "productDetailCell"
    @IBOutlet weak var productDetailsTable: UITableView!
    @IBOutlet weak var productDetailHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var productDescription: UITextView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productImage.append("person1.jpg")
        productImage.append("person2.jpg")
        productImage.append("person3.jpg")
        productImage.append("person1.jpg")
        productImage.append("person2.jpg")
        productImage.append("person3.jpg")
        productDetails.append(productDetail(detail: "SKU", definition: "ABCD-1234-5678-90122"))
        productDetails.append(productDetail(detail: "Brand", definition: "Beats Studio Version"))
        productDetails.append(productDetail(detail: "Weight (kg)", definition: "0.26"))
        productDetails.append(productDetail(detail: "Height (mm)", definition: "203mm"))
        productDetails.append(productDetail(detail: "Type of Jack", definition: "3.5mm"))
        
        self.productDetailsTable.scrollEnabled = false
        
        var newHeight = 44 * CGFloat(productDetails.count)
        self.productDetailsTable.frame.size.height = newHeight
        productDetailHeightConstraint.constant = newHeight
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TransactionProductDetailVC : UITableViewDataSource, UITableViewDelegate{
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productDetails.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(productDetailCellIdentifier) as! ProductDetailTVC
        
        cell.productDetailLabel.text = productDetails[indexPath.row].detail
        cell.productDefinitionLabel.text = productDetails[indexPath.row].definition
        
        return cell
    }
    
}

extension TransactionProductDetailVC : UICollectionViewDataSource, UICollectionViewDelegate{

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productImage.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(productImageCellIdentifier, forIndexPath: indexPath) as! ProductImageCVC
        
        cell.productImage.image = UIImage(named: productImage[indexPath.row])
        
        return cell
        
    }
    
}
