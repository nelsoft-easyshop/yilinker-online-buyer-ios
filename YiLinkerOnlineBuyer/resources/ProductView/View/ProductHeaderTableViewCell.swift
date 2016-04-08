//
//  ProductHeaderTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 4/6/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductHeaderTableViewCellDataSource {
    
    func productHeaderTableViewCell(productHeaderTableViewCell: ProductHeaderTableViewCell, numberOfItemsInSection section: Int) -> Int
    
    func productHeaderTableViewCell(productHeaderTableViewCell: ProductHeaderTableViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell
    
    func cellItemWidth(productHeaderTableViewCell: ProductHeaderTableViewCell) -> CGFloat
}

protocol ProductHeaderTableViewCellDelegate {
    func productHeaderTableViewCell(productHeaderTableViewCell: ProductHeaderTableViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath)
}

class ProductHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var dataSource: ProductHeaderTableViewCellDataSource?
    var delegate: ProductHeaderTableViewCellDelegate?
    
    let fullImageCellNib = "FullImageCollectionViewCell"
    
    class func nibNameAndIdentifier() -> String {
        return "ProductHeaderTableViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCellWithNibName(self.fullImageCellNib)
        self.pageControl.currentPageIndicatorTintColor = UIColor.darkGrayColor()
    }
    
    //MARK: -
    //MARK: - Register Cell
    func registerCellWithNibName(nibName: String) {
        let nib: UINib = UINib(nibName: nibName, bundle: nil)
        self.collectionView.registerNib(nib, forCellWithReuseIdentifier: nibName)
    }
    
    //MARK: -
    //MARK: - Collection View Data Source
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.pageControl.numberOfPages = self.dataSource!.productHeaderTableViewCell(self, numberOfItemsInSection: section)
        return self.dataSource!.productHeaderTableViewCell(self, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dataSource!.productHeaderTableViewCell(self, cellForRowAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellSize: CGSize = CGSizeMake(self.dataSource!.cellItemWidth(self), self.frame.size.height)
        
        return cellSize
    }
    
    //MARK: -
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.productHeaderTableViewCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    //MARK: -
    //MARK: - ScrollView Delegate
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        self.layoutIfNeeded()
        
        let pageWidth: CGFloat = self.collectionView.frame.size.width
        let currentPage: CGFloat = self.collectionView.contentOffset.x / pageWidth
        
        if 0.0 != fmodf(Float(currentPage), 1.0) {
            self.pageControl.currentPage = Int(currentPage) + 1
        }
        else {
            self.pageControl.currentPage = Int(currentPage)
        }
    }
}
