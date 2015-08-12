//
//  ProductImagesView.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/3/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductImagesViewDelegate {
    func close(controller: ProductImagesView)
    func wishlist(controller: ProductImagesView)
    func rate(controller: ProductImagesView)
    func message(controller: ProductImagesView)
    func share(controller: ProductImagesView)
    
}

class ProductImagesView: UIView, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var closeContainerView: UIView!
    @IBOutlet weak var wishlistContainerView: UIView!
    @IBOutlet weak var rateContainerView: UIView!
    @IBOutlet weak var messageContainerView: UIView!
    @IBOutlet weak var shareContainerView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    var images: NSArray = []
    
    var delegate: ProductImagesViewDelegate?
    
    override func awakeFromNib() {
        
        println(self.frame)
        
        self.closeContainerView.layer.cornerRadius = self.closeContainerView.frame.size.width / 2
        self.closeContainerView.layer.borderWidth  = 1.5
        self.closeContainerView.layer.borderColor = UIColor.grayColor().CGColor
        
        self.wishlistContainerView.layer.cornerRadius = self.wishlistContainerView.frame.size.width / 2
        self.rateContainerView.layer.cornerRadius = self.rateContainerView.frame.size.width / 2
        self.messageContainerView.layer.cornerRadius = self.messageContainerView.frame.size.width / 2
        self.shareContainerView.layer.cornerRadius = self.shareContainerView.frame.size.width / 2
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        var nib = UINib(nibName: "ProductSellerViewCollectionViewCell", bundle:nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "productSellerIdentifier")
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductSellerViewCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("productSellerIdentifier", forIndexPath: indexPath) as! ProductSellerViewCollectionViewCell
        
        cell.setImage(self.images[indexPath.row] as! String)
        
        return cell
    }

    // MARK: - Collection View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var page: CGFloat = self.collectionView.frame.size.width
        self.pageControl.currentPage = Int(self.collectionView.contentOffset.x / page)
    }
    
    // MARK: - Actions
    
    @IBAction func closeAction(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.close(self)
        }
    }
    
    @IBAction func wishlistAction(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.wishlist(self)
        }
    }
    
    @IBAction func rateAction(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.rate(self)
        }
    }
    
    @IBAction func messageAction(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.message(self)
        }
    }
    
    @IBAction func shareAction(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.share(self)
        }
    }
    
    // Functions
    
    func setDetails(name: String, price: Float, images: NSArray) {
        self.nameLabel.text = name
        
        self.priceLabel.text = String(format: "P%.2f", price)
        
        self.images = images
        if self.images.count == 0 {
            self.images = ["http://shop.bench.com.ph/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/Y/W/YWH0089BU4.jpg",
                "http://shop.bench.com.ph/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/Y/W/YWH0089BU4_F.jpg",
                "http://shop.bench.com.ph/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/Y/W/YWH0089BU4_S.jpg",
                "http://shop.bench.com.ph/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/Y/W/YWH0089BU4_B.jpg",
                "http://shop.bench.com.ph/media/catalog/product/cache/1/image/9df78eab33525d08d6e5fb8d27136e95/Y/W/YWH0089BU4_45.jpg"]
        }
         self.pageControl.numberOfPages = self.images.count
        self.collectionView.reloadData()
    }
    
}
