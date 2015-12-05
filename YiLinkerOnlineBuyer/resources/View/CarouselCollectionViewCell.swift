//
//  CarouselCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/24/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol CarouselCollectionViewCellDataSource {
    func carouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell, numberOfItemsInSection section: Int) -> Int
 
    func carouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell
    
    func itemWidthInCarouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell) -> CGFloat
}

protocol CarouselCollectionViewCellDelegate {
    func carouselCollectionViewCell(carouselCollectionViewCell: CarouselCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath)
    func carouselCollectionViewCellDidEndDecelerating(carouselCollectionViewCell: CarouselCollectionViewCell)
}


class CarouselCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var dataSource: CarouselCollectionViewCellDataSource?
    var delegate: CarouselCollectionViewCellDelegate?
    
    let fullImageCellNib = "FullImageCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCellWithNibName(self.fullImageCellNib)
        self.pageControl.currentPageIndicatorTintColor = UIColor.darkGrayColor()
        self.collectionView.layer.cornerRadius = 5
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
        self.pageControl.numberOfPages = self.dataSource!.carouselCollectionViewCell(self, numberOfItemsInSection: section)
        return self.dataSource!.carouselCollectionViewCell(self, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dataSource!.carouselCollectionViewCell(self, cellForRowAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize:CGSize = CGSizeMake(self.dataSource!.itemWidthInCarouselCollectionViewCell(self), SectionHeight.sectionOne)
        return cellSize
    }
    
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.carouselCollectionViewCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.delegate?.carouselCollectionViewCellDidEndDecelerating(self)
    }
}
