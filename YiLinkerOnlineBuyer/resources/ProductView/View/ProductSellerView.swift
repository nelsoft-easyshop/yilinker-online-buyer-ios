//
//  ProductSellerView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductSellerViewDelegate {
    func seeMoreSeller(controller: ProductSellerView)
    func gotoSellerProduct(controller: ProductSellerView, id: String)
}

class ProductSellerView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var sellerLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var displayPictureImageView: UIImageView!
    @IBOutlet weak var badge1ImageView: UIImageView!
    @IBOutlet weak var badge2ImageView: UIImageView!
    @IBOutlet weak var badge3ImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subInfoLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var images: NSArray = []
    var ids: [String] = []
    
    var delegate: ProductSellerViewDelegate?
    
    override func awakeFromNib() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        self.displayPictureImageView.layer.cornerRadius = self.displayPictureImageView.frame.size.width / 2
        self.displayPictureImageView.clipsToBounds = true
        
        var nib = UINib(nibName: "ProductSellerViewCollectionViewCell", bundle:nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "productSellerIdentifier")
        
        var tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: "seeMoreAction:")
        self.sellerLabel.addGestureRecognizer(tap)
    }

    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if images.count != 0 {
            return images.count
        } else {
            return 5
        }
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductSellerViewCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("productSellerIdentifier", forIndexPath: indexPath) as! ProductSellerViewCollectionViewCell
        
        if images.count != 0 {
            cell.setImage(images[indexPath.row] as! String)
        }
        
        return cell
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.gotoSellerProduct(self, id: ids[indexPath.row])
    }
    
    // MARK: - Action
    
    func seeMoreAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.seeMoreSeller(self)
        }
    }

    func setSellerDetails(model: ProductSellerModel) {

        self.nameLabel.text = model.storeName
        self.subInfoLabel.text = StringHelper.localizedStringWithKey("SPECIALTY_LOCALIZE_KEY") + ": " + model.specialty
        displayPictureImageView.sd_setImageWithURL(NSURL(string: model.profilePhoto), placeholderImage: UIImage(named: "dummy-placeholder"))
        self.images = model.images
        self.ids = model.productId
        
        self.collectionView.reloadData()

    }
    
}
