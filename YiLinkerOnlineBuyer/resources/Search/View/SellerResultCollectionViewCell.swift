//
//  SellerResultCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/18/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class SellerResultCollectionViewCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var sellerNameLabel: UILabel!
    @IBOutlet weak var specialtyLabel: UILabel!
    @IBOutlet weak var sellerImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var verifySellerView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var productIds: [String] = []
    var productImages: [String] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        intializeViews()
        regsterNib()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func intializeViews() {
        sellerImageView.layer.cornerRadius = sellerImageView.frame.size.height / 2
        followButton.layer.cornerRadius = followButton.frame.size.height / 2
        followButton.hidden = true
    }
    
    func regsterNib() {
        let cellNib: UINib = UINib(nibName: "FullImageCollectionViewCell", bundle: nil)
        self.collectionView.registerNib(cellNib, forCellWithReuseIdentifier: "FullImageCollectionViewCell")
        self.collectionView.backgroundColor = UIColor.clearColor()
        self.collectionView.reloadData()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productIds.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: FullImageCollectionViewCell = self.collectionView?.dequeueReusableCellWithReuseIdentifier("FullImageCollectionViewCell", forIndexPath: indexPath) as! FullImageCollectionViewCell
        
        cell.itemProductImageView.sd_setImageWithURL(NSURL(string: productImages[indexPath.row]), placeholderImage: UIImage(named: "dummy-placeholder"))
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        println(productIds[indexPath.row])
    }
}
