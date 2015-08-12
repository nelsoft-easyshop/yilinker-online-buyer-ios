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
        return 14
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductSellerViewCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("productSellerIdentifier", forIndexPath: indexPath) as! ProductSellerViewCollectionViewCell
        
        if images.count == 0 {
            cell.setImage(UIImage(named: "beats\(indexPath.row + 1)"))
        } else {
            //set image here
        }
        
        return cell
    }
    
    // MARK: - Action
    
    func seeMoreAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.seeMoreSeller(self)
        }
    }
    
    func setSellerDetails(logo: String, name: String, specialty: String, description: String, contactNo: String, images: NSArray) {
        
        //set logo here
        self.nameLabel.text = name
        self.subInfoLabel.text = "Specialty: " + specialty
        
        self.images = images
        self.collectionView.reloadData()
    }
    
}
