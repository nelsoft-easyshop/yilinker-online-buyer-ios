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
    var titles: [String] = ["Category 1", "Category 2", "Category 3", "Category 4", "Category 5", "Category 6", "Category 7", "Category 8", "Category 9", "Category 10", "Category 11", "Category 12", "Category 13", "Category 14", "Category 15", "Category 16", "Category 17", "Category 18", "Category 19", "Category 20"]
    var selectedCollectionViewCell: CustomizeSelectedCollectionViewCell = CustomizeSelectedCollectionViewCell()
    var customizeLayout: CustomizeShoppingCollectionViewLayout?
    
    var selectedCategoryTitle: String = ""
    var firstIndexPath: NSIndexPath?
    var addedTitle: String = ""
    var isAddingCell: Bool = false
    
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
        return self.titles.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CustomizeShoppingCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier, forIndexPath: indexPath) as! CustomizeShoppingCollectionViewCell
        cell.layer.cornerRadius = cell.frame.size.width / 2
        cell.categoryTitleLabel.text = self.titles[indexPath.row]
        
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
            self.selectedCategoryTitle = self.titles[indexPath.row]
            self.titles.removeAtIndex(indexPath.row)
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
        self.titles.insert(title, atIndex: 0)
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
    }
    
}
