//
//  NewSellerScrollableCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol NewSellerScrollableCollectionViewCellDelegate {
    func didSelectSellerCellWithTarget(target: String, targetType: String)
}

class NewSellerScrollableCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var productModels: [HomePageProductModel]!
    var delegate: NewSellerScrollableCollectionViewCellDelegate?
  
    override func awakeFromNib() {
        super.awakeFromNib()
        let cellNib: UINib = UINib(nibName: "NewSellerCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "NewSellerCollectionViewCell")
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
        let scrollableProductCollectionViewCell: NewSellerCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("NewSellerCollectionViewCell", forIndexPath: indexPath) as! NewSellerCollectionViewCell
        let homeProductModel: HomePageProductModel = self.productModels[indexPath.row] 
        scrollableProductCollectionViewCell.sellerImageView.sd_setImageWithURL(homeProductModel.imageURL, placeholderImage: UIImage(named: "dummy-placeholder"))
        scrollableProductCollectionViewCell.sellerNameLabel.text = homeProductModel.name

        return scrollableProductCollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let homeProductModel: HomePageProductModel = self.productModels[indexPath.row]
        self.delegate?.didSelectSellerCellWithTarget(homeProductModel.target, targetType: homeProductModel.targetType)
    }

}
