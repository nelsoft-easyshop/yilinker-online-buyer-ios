//
//  TransactionProductImagesView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionProductImagesView: UIView, UICollectionViewDataSource {
    
    // Collection view
    @IBOutlet weak var collectionView: UICollectionView!
    
    // Labels
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Global variables
    var imageUrl: String = ""

    override func awakeFromNib() {
        
        self.registerNib()
        self.collectionView.dataSource = self
    }
    
    // MARK: Private methods
    // MARK: Register collection view cell
    func registerNib() {
        var nib = UINib(nibName: "ProductSellerViewCollectionViewCell", bundle:nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "productSellerIdentifier")
    }
    
    // MARK: - Collection View Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductSellerViewCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("productSellerIdentifier", forIndexPath: indexPath) as! ProductSellerViewCollectionViewCell
        cell.setImage(self.imageUrl)
        
        return cell
    }

}
