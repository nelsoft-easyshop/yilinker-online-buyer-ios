//
//  ScrollableCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/2/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ScrollableCollectionViewCellDelegate {
    func didSelectectCellWithTarget(target: String, targetType: String)
}

class ScrollableCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var productModels: [HomePageProductModel]!
    var delegate: ScrollableCollectionViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let cellNib: UINib = UINib(nibName: "ProductWithCenterNameCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "ProductWithCenterNameCollectionViewCell")
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productModels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let scrollableProductCollectionViewCell: ProductWithCenterNameCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("ProductWithCenterNameCollectionViewCell", forIndexPath: indexPath) as! ProductWithCenterNameCollectionViewCell
        let homeProductModel: HomePageProductModel = self.productModels[indexPath.row] 
        scrollableProductCollectionViewCell.productItemImageView.sd_setImageWithURL(homeProductModel.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
        scrollableProductCollectionViewCell.productNameLabel.text = homeProductModel.name
        
        if homeProductModel.name == "" {
            scrollableProductCollectionViewCell.productNameLabel.hidden = true
        }
        
        return scrollableProductCollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
         let homeProductModel: HomePageProductModel = self.productModels[indexPath.row]
        self.delegate?.didSelectectCellWithTarget(homeProductModel.target, targetType: homeProductModel.targetType)
    }
}
