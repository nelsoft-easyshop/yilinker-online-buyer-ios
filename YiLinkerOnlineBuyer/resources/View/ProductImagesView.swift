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
    func fullScreen(controller: ProductImagesView)
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
    @IBOutlet weak var originalPrice: UILabel!
    @IBOutlet weak var priceCustomLabel: DiscountLabel!
    @IBOutlet weak var discountPercentLabel: UILabel!
    
    var imagesModel: [ProductImagesModel]!
    
    var images: [String] = []
    var width: CGFloat = 0
    
    var delegate: ProductImagesViewDelegate?
    
    override func awakeFromNib() {
        
        self.closeContainerView.layer.cornerRadius = self.closeContainerView.frame.size.width / 2
        self.closeContainerView.layer.borderWidth  = 1.5
        self.closeContainerView.layer.borderColor = UIColor.grayColor().CGColor
        
        self.wishlistContainerView.layer.cornerRadius = self.wishlistContainerView.frame.size.width / 2
        self.rateContainerView.layer.cornerRadius = self.rateContainerView.frame.size.width / 2
        self.messageContainerView.layer.cornerRadius = self.messageContainerView.frame.size.width / 2
        self.shareContainerView.layer.cornerRadius = self.shareContainerView.frame.size.width / 2
        self.discountPercentLabel.layer.cornerRadius = 5
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        var nib = UINib(nibName: "ProductSellerViewCollectionViewCell", bundle:nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: "productSellerIdentifier")
        
        addTapTo(self.closeContainerView, action: "closeAction:")
        addTapTo(self.wishlistContainerView, action: "wishlistAction:")
        addTapTo(self.rateContainerView, action: "rateAction:")
        addTapTo(self.messageContainerView, action: "messageAction:")
        addTapTo(self.shareContainerView, action: "shareAction:")
        addTapTo(self.collectionView, action: "fullScreenAction:")
    }
    
    func addTapTo(view: UIView, action: Selector) {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        view.addGestureRecognizer(tap)
    }
    
    // MARK: - Collection View Data Source
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.images.count != 0 {
            return self.images.count
        } else if self.imagesModel != nil {
            return self.imagesModel.count
        }
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: ProductSellerViewCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("productSellerIdentifier", forIndexPath: indexPath) as! ProductSellerViewCollectionViewCell
        if self.images.count != 0 {
            cell.setImage(self.images[indexPath.row])
            println(self.images[indexPath.row])
        } else if self.imagesModel != nil {
            cell.setImage(self.imagesModel[indexPath.row].imageLocation)
            println(self.imagesModel[indexPath.row].imageLocation)
        }
        
        cell.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }

    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
    }
    
    // MARK: - Collection View Delegate
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(width, self.collectionView.frame.size.height - 1)
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        var page: CGFloat = self.collectionView.frame.size.width
        self.pageControl.currentPage = Int(self.collectionView.contentOffset.x / page)
    }
    
    // MARK: - Actions
    
    func closeAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.close(self)
        }
    }

    func wishlistAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.wishlist(self)
        }
    }

    func rateAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.rate(self)
        }
    }

    func messageAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.message(self)
        }
    }

    func shareAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.share(self)
        }
    }
    
    func fullScreenAction(gesture: UIGestureRecognizer) {
        if let delegate = self.delegate {
            delegate.fullScreen(self)
        }
    }
    
    // Functions
    
    func setDetails(model: ProductDetailsModel, unitId: Int, width: CGFloat) {

        self.nameLabel.text = model.title

        if model.productUnits[unitId].price != model.productUnits[unitId].discountedPrice {
            self.priceCustomLabel.text = "₱" + model.productUnits[unitId].price
            self.priceCustomLabel.drawDiscountLine(true)
            self.priceLabel.text = "₱" + model.productUnits[unitId].discountedPrice
        } else {
            self.priceCustomLabel.hidden = true
            self.priceLabel.text = "₱" + model.productUnits[unitId].price
        }
        
        if model.productUnits[unitId].discount != 0 {
            self.discountPercentLabel.hidden = false
            self.discountPercentLabel.text = "\(model.productUnits[unitId].discount)% OFF "
        } else {
            self.discountPercentLabel.hidden = true
        }
        
        self.width = width
        
        self.imagesModel = model.images

        self.pageControl.numberOfPages = self.imagesModel.count
        self.collectionView.reloadData()
    }

    func updateDetails(model: ProductDetailsModel, unitId: Int, images: [String]) {
        
        if model.productUnits[unitId].price != model.productUnits[unitId].discountedPrice {
            self.priceCustomLabel.text = "₱" + model.productUnits[unitId].price
            self.priceCustomLabel.drawDiscountLine(true)
            self.priceLabel.text = "₱" + model.productUnits[unitId].discountedPrice
        } else {
            self.priceCustomLabel.hidden = true
            self.priceLabel.text = "₱" + model.productUnits[unitId].price
        }
        
        if model.productUnits[unitId].discount != 0 {
            self.discountPercentLabel.hidden = false
            self.discountPercentLabel.text = "\(model.productUnits[unitId].discount)% OFF "
        } else {
            self.discountPercentLabel.hidden = true
        }
        
        self.images = images
        println(self.images)
        self.pageControl.numberOfPages = self.images.count
        self.collectionView.reloadData()
    }
}

// MARK: Extentions

extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}

