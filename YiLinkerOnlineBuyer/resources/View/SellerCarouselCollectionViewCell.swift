//
//  SellerCarouselCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/26/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol SellerCarouselCollectionViewCellDataSource {
    func sellerCarouselCollectionViewCell(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell, numberOfItemsInSection section: Int) -> Int
    
    func sellerCarouselCollectionViewCell(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> SellerCollectionViewCell
    
    func itemWidthInSellerCarouselCollectionViewCell(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell) -> CGFloat
    
    func sellerCarouselCollectionViewCellnumberOfDotsInPageControl(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell) -> Int
}

protocol SellerCarouselCollectionViewCellDelegate {
    func sellerCarouselCollectionViewCell(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath)
    
    func sellerCarouselCollectionViewCellDidEndDecelerating(sellerCarouselCollectionViewCell: SellerCarouselCollectionViewCell)
}

class SellerCarouselCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var dataSource: SellerCarouselCollectionViewCellDataSource?
    var delegate: SellerCarouselCollectionViewCellDelegate?
    
    let sellerNibName = "SellerCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCellWithNibName(self.sellerNibName)
        self.pageControl.currentPageIndicatorTintColor = UIColor.purpleColor()
        self.collectionView.clipsToBounds = true
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
        self.pageControl.numberOfPages = self.dataSource!.sellerCarouselCollectionViewCellnumberOfDotsInPageControl(self)
        return self.dataSource!.sellerCarouselCollectionViewCell(self, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dataSource!.sellerCarouselCollectionViewCell(self, cellForRowAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize:CGSize = CGSizeMake(self.dataSource!.itemWidthInSellerCarouselCollectionViewCell(self) + 10, SectionHeight.sectionEight - 50)
        return cellSize
    }
    
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.sellerCarouselCollectionViewCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.delegate?.sellerCarouselCollectionViewCellDidEndDecelerating(self)
    }
}
