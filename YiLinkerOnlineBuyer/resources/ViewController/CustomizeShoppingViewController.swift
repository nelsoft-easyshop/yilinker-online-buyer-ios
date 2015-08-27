//
//  CustomizeShoppingViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/12/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CustomizeShoppingViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CustomizeShoppingCollectionViewLayoutDelegate, UICollectionViewDataSource, UICollectionViewDelegate, CustomizeSelectedCollectionViewCellDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var menuRoundedView: DynamicRoundedView!
    @IBOutlet weak var categoriesButton: DynamicRoundedButton!
    @IBOutlet weak var sellerButton: DynamicRoundedButton!
    @IBOutlet weak var promosButton: DynamicRoundedButton!
    @IBOutlet weak var OthersButton: DynamicRoundedButton!
    
    var cellCount: Int = 20
   
    var categoryTitles: [String] = ["Category 1", "Category 2", "Category 3", "Category 4", "Category 5", "Category 6", "Category 7", "Category 8", "Category 9", "Category 10", "Category 11", "Category 12", "Category 13", "Category 14", "Category 15", "Category 16", "Category 17", "Category 18", "Category 19", "Category 20"]
    
    var sellerTitles: [String] = ["Seller 1", "Seller 2", "Seller 3", "Seller 4", "Seller 5", "Seller 6", "Seller 7", "Seller 8", "Seller 9", "Seller 10", "Seller 11", "Seller 12", "Seller 13", "Seller 14", "Seller 15", "Seller 16", "Seller 17", "Seller 18", "Seller 19", "Seller 20"]
    
    var promoTitles: [String] = ["Promo 1", "Promo 2", "Promo 3", "Promo 4", "Promo 5", "Promo 6", "Promo 7", "Promo 8", "Promo 9", "Promo 10", "Promo 11", "Promo 12", "Promo 13", "Promo 14", "Promo 15", "Promo 16", "Promo 17", "Promo 18", "Promo 19", "Promo 20"]
    
    var otherTitles: [String] = ["Other 1", "Other 2", "Other 3", "Other 4", "Other 5", "Other 6", "Other 7", "Other 8", "Other 9", "Other 10", "Other 11", "Other 12", "Other 13", "Other 14", "Other 15", "Other 16", "Other 17", "Other 18", "Other 19", "Other 20"]
    
    
    var selectedCollectionViewCell: CustomizeSelectedCollectionViewCell = CustomizeSelectedCollectionViewCell()
    var customizeLayout: CustomizeShoppingCollectionViewLayout?
    
    var selectedCategoryTitle: String = ""
    var firstIndexPath: NSIndexPath?
    var addedTitle: String = ""
    var isAddingCell: Bool = false
    
    var customizeShopingType: CustomizeShoppingType = CustomizeShoppingType.Categories
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.title = "Customize Shopping"

        if IphoneType.isIphone4() {
            selectedCollectionViewCell = XibHelper.puffViewWithNibName(Constants.CustomizeShopping.customizeSelectedNibNameAndIdentifier, index: 1) as! CustomizeSelectedCollectionViewCell
            self.tableViewHeightConstraint.constant = 40
        } else {
            selectedCollectionViewCell = XibHelper.puffViewWithNibName(Constants.CustomizeShopping.customizeSelectedNibNameAndIdentifier, index: 0) as! CustomizeSelectedCollectionViewCell
        }
        
        self.customizeLayout = self.collectionView.collectionViewLayout as? CustomizeShoppingCollectionViewLayout
        self.customizeLayout!.delegate = self
        self.collectionView.layer.zPosition = 0
        self.tableView.layer.zPosition = 100
        
        let footerView: UIView = UIView(frame: CGRectZero)
        self.tableView.tableFooterView = footerView
        
        self.selectedCollectionViewCell.layer.zPosition = 10
        selectedCollectionViewCell.delegate = self
        self.tableView.tableHeaderView = selectedCollectionViewCell
        self.registerCell()
    }
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: CustomizeShoppingTableViewCell = self.tableView.dequeueReusableCellWithIdentifier(Constants.CustomizeShopping.customizeShoppingTableViewCellNibNameAndIdentifier) as! CustomizeShoppingTableViewCell
        
        return cell
    }
    
    func registerCell() {
        let nib: UINib = UINib(nibName: Constants.CustomizeShopping.customizeShoppingTableViewCellNibNameAndIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: Constants.CustomizeShopping.customizeShoppingTableViewCellNibNameAndIdentifier)
        
        let nib2: UINib = UINib(nibName: Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(nib2, forCellWithReuseIdentifier: Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.customizeShopingType == CustomizeShoppingType.Categories {
            return self.categoryTitles.count
        } else if self.customizeShopingType == CustomizeShoppingType.Seller {
            return self.sellerTitles.count
        } else if self.customizeShopingType == CustomizeShoppingType.Promos {
            return self.promoTitles.count
        } else {
            return self.otherTitles.count
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CustomizeShoppingCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier, forIndexPath: indexPath) as! CustomizeShoppingCollectionViewCell
        cell.layer.cornerRadius = cell.frame.size.width / 2
        
        if self.customizeShopingType == CustomizeShoppingType.Categories {
            cell.categoryTitleLabel.text = self.categoryTitles[indexPath.row]
        } else if self.customizeShopingType == CustomizeShoppingType.Seller {
            cell.categoryTitleLabel.text = self.sellerTitles[indexPath.row]
        } else if self.customizeShopingType == CustomizeShoppingType.Promos {
            cell.categoryTitleLabel.text = self.promoTitles[indexPath.row]
        } else {
            cell.categoryTitleLabel.text = self.otherTitles[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if self.isAddingCell {
            self.collectionView.performBatchUpdates({ () -> Void in
                self.isAddingCell = false
                self.addCell(self.addedTitle)
                }, completion: { (Bool) -> Void in
            })
        } else {
            let cell: CustomizeShoppingCollectionViewCell = self.collectionView.cellForItemAtIndexPath(indexPath) as! CustomizeShoppingCollectionViewCell
            self.customizeLayout!.selectedIndexPath = indexPath
            self.deleteCellInIndexPath(indexPath)
        }

    }
    
    func deleteCellInIndexPath(indexPath: NSIndexPath) {
        self.collectionView.performBatchUpdates({ () -> Void in
            
            if self.customizeShopingType == CustomizeShoppingType.Categories {
                self.selectedCategoryTitle = self.categoryTitles[indexPath.row]
                self.categoryTitles.removeAtIndex(indexPath.row)
            } else if self.customizeShopingType == CustomizeShoppingType.Seller {
                self.selectedCategoryTitle = self.sellerTitles[indexPath.row]
                self.sellerTitles.removeAtIndex(indexPath.row)
            } else if self.customizeShopingType == CustomizeShoppingType.Promos {
                self.selectedCategoryTitle = self.promoTitles[indexPath.row]
                self.promoTitles.removeAtIndex(indexPath.row)
            } else {
                self.selectedCategoryTitle = self.otherTitles[indexPath.row]
                self.otherTitles.removeAtIndex(indexPath.row)
            }
            self.collectionView!.deleteItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
        }, completion: { (Bool) -> Void in
            self.customizeLayout!.invalidateLayout()
        })
    }
    
    func customizeShoppingCollectionViewLayout(didAddItemWithAttribute attribute: UICollectionViewLayoutAttributes) {
        selectedCollectionViewCell.addItemWithAttributes(attribute, title: self.selectedCategoryTitle)
    }
    
    func customizeSelectedCollectionViewCell(deselectCategoryWithTitle title: String, attribute: UICollectionViewLayoutAttributes) {
        self.addedTitle = title
        self.customizeLayout!.addedAttribute = attribute
        self.customizeLayout!.showAddAnimation = true
        var timer = NSTimer.scheduledTimerWithTimeInterval(0.0, target: self, selector: Selector("sample"), userInfo: nil, repeats: false)
        self.isAddingCell = true
    }
    
    func addCell(title: String) {
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        
        if self.customizeShopingType == CustomizeShoppingType.Categories {
              self.categoryTitles.insert(title, atIndex: 0)
        } else if self.customizeShopingType == CustomizeShoppingType.Seller {
            self.sellerTitles.insert(title, atIndex: 0)
        } else if self.customizeShopingType == CustomizeShoppingType.Promos {
            self.promoTitles.insert(title, atIndex: 0)
        } else {
            self.otherTitles.insert(title, atIndex: 0)
        }
        
        self.collectionView.insertItemsAtIndexPaths([indexPath])
    }

    func sample() {
        let indexPath: NSIndexPath = NSIndexPath(forItem: 0, inSection: 0)
        self.collectionView.delegate!.collectionView!(self.collectionView!, didSelectItemAtIndexPath: indexPath)
    }
    
    
    @IBAction func clickCategory(sender: UIButton) {
        sender.backgroundColor = Constants.Colors.selectedGreenColor
        
        for button in self.menuRoundedView.subviews as! [UIButton] {
            if !button.isEqual(sender) {
                button.backgroundColor = UIColor.clearColor()
            }
        }
        
        if sender.isEqual(self.categoriesButton) {
            self.customizeShopingType = CustomizeShoppingType.Categories
        } else if sender.isEqual(self.sellerButton) {
            self.customizeShopingType = CustomizeShoppingType.Seller
        } else if sender.isEqual(self.promosButton) {
            self.customizeShopingType = CustomizeShoppingType.Promos
        } else {
            self.customizeShopingType = CustomizeShoppingType.Others
        }
        
        self.collectionView.reloadData()
    }
    
}
