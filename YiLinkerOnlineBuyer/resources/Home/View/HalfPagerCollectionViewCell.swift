//
//  HalfPagerCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/25/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol HalfPagerCollectionViewCellDataSource {
    func halfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell, numberOfItemsInSection section: Int) -> Int
    
    func halfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell
    
    func itemWidthHalfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell) -> CGFloat
    
    func halfPagerCollectionViewCellnumberOfDotsInPageControl(halfPagerCollectionViewCell: HalfPagerCollectionViewCell) -> Int
}

protocol HalfPagerCollectionViewCellDelegate {
    func halfPagerCollectionViewCell(halfPagerCollectionViewCell: HalfPagerCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath)
    func halfPagerCollectionViewCellDidEndDecelerating(carouselCollectionViewCell: HalfPagerCollectionViewCell)
}

class HalfPagerCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var dataSource: HalfPagerCollectionViewCellDataSource?
    var delegate: HalfPagerCollectionViewCellDelegate?
    
    let fullImageCellNib = "FullImageCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCellWithNibName(self.fullImageCellNib)
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.pageControl.currentPageIndicatorTintColor = UIColor.darkGrayColor()
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
        self.pageControl.numberOfPages = self.dataSource!.halfPagerCollectionViewCellnumberOfDotsInPageControl(self)
        return self.dataSource!.halfPagerCollectionViewCell(self, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dataSource!.halfPagerCollectionViewCell(self, cellForRowAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize:CGSize = CGSizeMake(self.dataSource!.itemWidthHalfPagerCollectionViewCell(self), self.collectionView.frame.size.height)
        
        return cellSize
    }
    
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.halfPagerCollectionViewCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.delegate?.halfPagerCollectionViewCellDidEndDecelerating(self)
    }

}
