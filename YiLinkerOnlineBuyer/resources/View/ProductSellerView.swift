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
}

class ProductSellerView: UIView, UICollectionViewDataSource {

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
    
    var delegate: ProductSellerViewDelegate?
    
    override func awakeFromNib() {
        self.collectionView.dataSource = self
        
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
        return images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductSellerViewCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("productSellerIdentifier", forIndexPath: indexPath) as! ProductSellerViewCollectionViewCell
        
        cell.setImage(images[indexPath.row] as! String)
        
        return cell
    }
    
    // MARK: - Action
    
    func seeMoreAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.seeMoreSeller(self)
        }
    }

    func setSellerDetails(model: ProductSellerModel) {
        let imageUrl: NSURL = NSURL(string: "http://3.bp.blogspot.com/-GL0l-yLVbL4/UFbUqpSg-5I/AAAAAAAAap8/jszopPjpVDg/s1600/bench_logo.gif")!
        displayPictureImageView.sd_setImageWithURL(imageUrl, placeholderImage: UIImage(named: "dummy-placeholder"))
        self.nameLabel.text = model.name
        self.subInfoLabel.text = "Specialty: " + model.specialty
        
        self.images = model.images
        if model.images.count == 1 || model.images[0] as! String == "" {
            self.images = ["http://shop.bench.com.ph/media/catalog/product/cache/1/thumbnail/70x81/9df78eab33525d08d6e5fb8d27136e95/Y/J/YJT0003BU4_5.jpg",
                "http://shop.bench.com.ph/media/catalog/product/cache/1/small_image/184x215/9df78eab33525d08d6e5fb8d27136e95/Y/J/YJT0003BU2_7.jpg",
                "http://shop.bench.com.ph/media/catalog/product/cache/1/small_image/184x215/9df78eab33525d08d6e5fb8d27136e95/Y/J/YJT0003PI2_6.jpg",
                "http://shop.bench.com.ph/media/catalog/product/cache/1/small_image/184x215/9df78eab33525d08d6e5fb8d27136e95/Y/T/YTJ0128GY4_5.jpg"]
        }
        self.collectionView.reloadData()

    }
    
}
