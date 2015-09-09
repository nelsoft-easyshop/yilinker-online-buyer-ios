//
//  NewSellerScrollableCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol NewSellerScrollableCollectionViewCellDelegate {
    func didSelectSellerCellWithTarget(target: String, targetType: String, userId: Int)
}

class NewSellerScrollableCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var sellerModels: [SellerModel]!
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
        return self.sellerModels.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let scrollableProductCollectionViewCell: NewSellerCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("NewSellerCollectionViewCell", forIndexPath: indexPath) as! NewSellerCollectionViewCell
        let sellerModel: SellerModel = self.sellerModels[indexPath.row]
       
        scrollableProductCollectionViewCell.sellerImageView.sd_setImageWithURL(sellerModel.avatar, placeholderImage: UIImage(named: "dummy-placeholder"))
        scrollableProductCollectionViewCell.sellerNameLabel.text = sellerModel.name
        
        return scrollableProductCollectionViewCell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let homeProductModel: SellerModel = self.sellerModels[indexPath.row]
        self.delegate?.didSelectSellerCellWithTarget(homeProductModel.target, targetType: "", userId: homeProductModel.userId)
    }

}
