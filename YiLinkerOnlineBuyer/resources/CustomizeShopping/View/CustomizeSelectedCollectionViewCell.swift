//
//  CustomizeCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol CustomizeSelectedCollectionViewCellDelegate {
    func customizeSelectedCollectionViewCell(deselectCategoryWithTitle title: String, attribute: UICollectionViewLayoutAttributes)
}

class CustomizeSelectedCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource, CustomizeShoppingFlowLayoutDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var titles: [String] = []
    var flowLayout: CustomizeShoppingFlowLayout = CustomizeShoppingFlowLayout()
    var selectedCategoryTitle: String = ""
    
    var delegate: CustomizeSelectedCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        flowLayout.itemSize = CGSizeMake(50, 50)
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10)
        flowLayout.delegate = self
        self.collectionView.collectionViewLayout = flowLayout
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.registerCell()
    }
    
    func registerCell() {
        let cellNib: UINib = UINib(nibName: Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier, bundle:nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.titles.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CustomizeShoppingCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier, forIndexPath: indexPath) as! CustomizeShoppingCollectionViewCell
        cell.layer.cornerRadius = cell.frame.size.width / 2
        cell.backgroundColor = Constants.Colors.selectedGreenColor
        cell.categoryTitleLabel.textColor = UIColor.whiteColor()
        cell.categoryTitleLabel.text = self.titles[indexPath.row]
        return cell
    }
    
    func addItemWithAttributes(attribute: UICollectionViewLayoutAttributes, title: String) {
        self.flowLayout.currentDeletedAttribute = attribute
        self.flowLayout.rowOfItemAdded = self.titles.count
        let indexPath: NSIndexPath = NSIndexPath(forItem: self.titles.count, inSection: 0)
        self.titles.append(title)
        self.addCellInIndexPath(indexPath)
    }
    
    func addCellInIndexPath(indexPath: NSIndexPath) {
        self.collectionView.performBatchUpdates({ () -> Void in
            self.collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
            }, completion: { (Bool) -> Void in
                self.collectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.Bottom, animated: true)
        })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedCategoryTitle = self.titles[indexPath.row]
        self.titles.removeAtIndex(indexPath.row)
        self.flowLayout.deletedIndexPath = indexPath
        self.deleteCellInIndexPath(indexPath)
    }
    
    func deleteCellInIndexPath(indexPath: NSIndexPath) {
        self.collectionView.performBatchUpdates({ () -> Void in
            self.collectionView!.deleteItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
            }, completion: { (Bool) -> Void in
        })
    }

    func customizeShoppingFlowLayout(deselectCategoryWithAttributes attributes: UICollectionViewLayoutAttributes) {
        self.delegate!.customizeSelectedCollectionViewCell(deselectCategoryWithTitle: self.selectedCategoryTitle, attribute: attributes)
    }

}
