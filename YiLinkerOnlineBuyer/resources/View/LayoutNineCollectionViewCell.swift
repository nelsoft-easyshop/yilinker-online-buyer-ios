//
//  LayoutNineCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/26/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol LayoutNineCollectionViewCellDelegate {
    func layoutNineCollectionViewCellDidClickProductImage(productImage: ProductImageView)
    
    func layoutNineCollectionViewCell(layoutNineCollectionViewCell: LayoutNineCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath)
    func layoutNineCollectionViewCellDidEndDecelerating(layoutNineCollectionViewCell: LayoutNineCollectionViewCell)
}

protocol LayoutNineCollectionViewCellDataSource {
    func layoutNineCollectionViewCell(layoutNineCollectionViewCell: LayoutNineCollectionViewCell, numberOfItemsInSection section: Int) -> Int
    
    func layoutNineCollectionViewCell(layoutNineCollectionViewCell: LayoutNineCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell
    
    func layoutNineCollectionViewCell(layoutNineCollectionViewCell: LayoutNineCollectionViewCell) -> CGFloat
}

class LayoutNineCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var productImageViewOne: ProductImageView!
    @IBOutlet weak var productImageViewTwo: ProductImageView!
    @IBOutlet weak var productImageViewThree: ProductImageView!
    @IBOutlet weak var productImageViewFour: ProductImageView!
    @IBOutlet weak var productImageViewFive: ProductImageView!
    
    @IBOutlet weak var productOneNameLabel: UILabel!
    @IBOutlet weak var productTwoNameLabel: UILabel!
    @IBOutlet weak var productThreeNameLabel: UILabel!
    @IBOutlet weak var productFourNameLabel: UILabel!
    @IBOutlet weak var productFiveNameLabel: UILabel!
    
    @IBOutlet weak var viewOne: UIView!
    @IBOutlet weak var viewTwo: UIView!
    @IBOutlet weak var viewThree: UIView!
    @IBOutlet weak var viewFour: UIView!
    @IBOutlet weak var viewFive: UIView!
    
    
    let fullImageCellNib = "FullImageCollectionViewCell"
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    var delegate: LayoutNineCollectionViewCellDelegate?
    var dataSource: LayoutNineCollectionViewCellDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.addTapRecognizer(productImageViewOne)
        self.addTapRecognizer(productImageViewTwo)
        self.addTapRecognizer(productImageViewThree)
        self.addTapRecognizer(productImageViewFour)
        self.addTapRecognizer(productImageViewFive)
        
        self.registerCellWithNibName(self.fullImageCellNib)
        self.pageControl.currentPageIndicatorTintColor = UIColor.purpleColor()
        
        self.viewOne.layer.cornerRadius = 5
        self.viewTwo.layer.cornerRadius = 5
        self.viewThree.layer.cornerRadius = 5
        self.viewFour.layer.cornerRadius = 5
        self.viewFive.layer.cornerRadius = 5
    }
    
    //MARK: - Add Tap Recognizer
    func addTapRecognizer(productImageView: UIImageView) {
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "didTapItem:")
        productImageView.userInteractionEnabled = true
        productImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func didTapItem(tap: UITapGestureRecognizer) {
        let itemImageView: ProductImageView = tap.view as! ProductImageView
        self.delegate?.layoutNineCollectionViewCellDidClickProductImage(itemImageView)
    }
    
    //MARK: - Register Cell
    func registerCellWithNibName(nibName: String) {
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: nibName)
    }
    
    //MARK: - Collection View Data Source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = self.dataSource!.layoutNineCollectionViewCell(self, numberOfItemsInSection: section)
        return self.dataSource!.layoutNineCollectionViewCell(self, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dataSource!.layoutNineCollectionViewCell(self, cellForRowAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize:CGSize = CGSizeMake(self.dataSource!.layoutNineCollectionViewCell(self), SectionHeight.sectionOne)
        return cellSize
    }
    
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.layoutNineCollectionViewCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.delegate?.layoutNineCollectionViewCellDidEndDecelerating(self)
    }
}
