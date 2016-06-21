//
//  CustomizeShoppingTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CustomizeShoppingTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var cellCount: Int = 30
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerNib()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println(cellCount)
        return self.cellCount
    }
    
    func registerNib() {
        let nib: UINib = UINib(nibName: Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CustomizeShoppingCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier(Constants.CustomizeShopping.customizeShoppingNibNameAndIdentifier, forIndexPath: indexPath) as! CustomizeShoppingCollectionViewCell
        cell.layer.cornerRadius = cell.frame.size.width / 2

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.deleteCellInIndexPath(indexPath)
    }
    
    func deleteCellInIndexPath(indexPath: NSIndexPath) {
        self.cellCount--
        self.collectionView!.deleteItemsAtIndexPaths([NSIndexPath(forItem: indexPath.row, inSection: indexPath.section)])
    }
    
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
