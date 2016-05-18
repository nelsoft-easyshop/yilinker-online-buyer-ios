//
//  OverseasCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 4/15/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol OverseasCollectionViewCellDataSource {
    func overseasCollectionViewCell(overseasCollectionViewCell: OverseasCollectionViewCell, numberOfItemsInSection section: Int) -> Int
    
    func overseasCollectionViewCell(overseasCollectionViewCell: OverseasCollectionViewCell, cellForRowAtIndexPath indexPath: NSIndexPath) -> FullImageCollectionViewCell
    
    func itemWidthInOverseasCollectionViewCell(overseasCollectionViewCell: OverseasCollectionViewCell) -> CGFloat
}

protocol OverseasCollectionViewCellDelegate {
    func overseasCollectionViewCell(carouselCollectionViewCell: OverseasCollectionViewCell, didSelectItemAtIndexPath indexPath: NSIndexPath)
}


class OverseasCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    @IBOutlet weak var horizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var dataSource: OverseasCollectionViewCellDataSource?
    var delegate: OverseasCollectionViewCellDelegate?
    
    let fullImageCellNib = "FullImageCollectionViewCell"
    
    class func nibNameAndIdentifier() -> String {
        return "OverseasCollectionViewCell"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.registerCellWithNibName(self.fullImageCellNib)
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
        let numberOfItems: Int = self.dataSource!.overseasCollectionViewCell(self, numberOfItemsInSection: section)
        
        if numberOfItems <= 3 {
            let halfItem: CGFloat = ((CGFloat(numberOfItems) * CGFloat(80)) + (CGFloat(numberOfItems) * 10)) / 2
            
            self.collectionView.layoutIfNeeded()
            self.horizontalConstraint.constant = (self.collectionView.frame.size.width / 2) - halfItem
        }
        
        return self.dataSource!.overseasCollectionViewCell(self, numberOfItemsInSection: section)
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return self.dataSource!.overseasCollectionViewCell(self, cellForRowAtIndexPath: indexPath)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        var cellSize:CGSize = CGSizeMake(self.dataSource!.itemWidthInOverseasCollectionViewCell(self), 50)
        return cellSize
    }
    
    //MARK: - Collection View Delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.delegate?.overseasCollectionViewCell(self, didSelectItemAtIndexPath: indexPath)
    }
    
    
}
