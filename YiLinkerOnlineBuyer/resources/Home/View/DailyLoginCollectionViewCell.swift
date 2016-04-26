//
//  DailyLoginCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 11/25/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

/*protocol DailyLoginCollectionViewCellDelegate {
    func dailyLoginCollectionViewCellDidTapCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell)
    
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath)
    func dailyLoginCollectionViewCellDidEndDecelerating(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell)
}

protocol DailyLoginCollectionViewCellDataSource {
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, numberOfItemsInSection section: Int) -> Int
    
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell
    
    func itemWidthInDailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell) -> CGFloat
}

class DailyLoginCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: DailyLoginCollectionViewCellDataSource?
    var delegate: DailyLoginCollectionViewCellDelegate?
    
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
        self.pageControl.numberOfPages = self.dataSource!.dailyLoginCollectionViewCell(self, numberOfItemsInSection: section)
        return self.dataSource!.dailyLoginCollectionViewCell(self, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dataSource!.dailyLoginCollectionViewCell(self, cellForRowAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize:CGSize = CGSizeMake(self.dataSource!.itemWidthInDailyLoginCollectionViewCell(self), SectionHeight.sectionTwo)
        return cellSize
    }
    
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.dailyLoginCollectionViewCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.delegate?.dailyLoginCollectionViewCellDidEndDecelerating(self)
    }
}*/

protocol DailyLoginCollectionViewCellDelegate {
    func dailyLoginCollectionViewCellDidTapCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell)
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath)
    func dailyLoginCollectionViewCellDidEndDecelerating(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell)
}

protocol DailyLoginCollectionViewCellDataSource {
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, numberOfItemsInSection section: Int) -> Int
    func dailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell
    func itemWidthInDailyLoginCollectionViewCell(dailyLoginCollectionViewCell: DailyLoginCollectionViewCell) -> CGFloat
}

class DailyLoginCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    let fullImageCellNib = "FullImageCollectionViewCell"
    var target: String = ""
    var targetType: String = ""
    
    @IBOutlet weak var pageControl: UIPageControl!
    var delegate: DailyLoginCollectionViewCellDelegate?
    var dataSource: DailyLoginCollectionViewCellDataSource?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCellWithNibName(fullImageCellNib)
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
        self.pageControl.numberOfPages = self.dataSource!.dailyLoginCollectionViewCell(self, numberOfItemsInSection: section)
        return self.dataSource!.dailyLoginCollectionViewCell(self, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dataSource!.dailyLoginCollectionViewCell(self, cellForRowAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize:CGSize = CGSizeMake(self.dataSource!.itemWidthInDailyLoginCollectionViewCell(self), SectionHeight.sectionTwo)
        return cellSize
    }
    
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.dailyLoginCollectionViewCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.delegate?.dailyLoginCollectionViewCellDidEndDecelerating(self)
    }


}
