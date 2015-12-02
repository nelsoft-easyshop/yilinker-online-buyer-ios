//
//  OneByOneCollectionViewFlowLayout.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 12/2/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class OneByOneCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func awakeFromNib() {
        super.awakeFromNib()
        self.minimumInteritemSpacing = 0
        self.minimumLineSpacing = 5
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }
    
    func pageWidth() -> CGFloat {
        return self.itemSize.width + self.minimumLineSpacing
    }
    
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var rawPageValue: CGFloat = self.collectionView!.contentOffset.x / self.pageWidth()
        var currentPage: CGFloat = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue)
        var nextPage: CGFloat = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue)
        var pannedLessThanAPage: Bool = fabs(1 + currentPage - rawPageValue) > 0.5
        var x: CGFloat = 0
        var flicked: Bool = fabs(velocity.x) > self.flickVelocity()
        if pannedLessThanAPage && flicked {
            //proposedContentOffset.x = nextPage * self.pageWidth
            x = nextPage * self.pageWidth()
        }
        else {
            x = round(rawPageValue) * self.pageWidth()
        }
        return CGPointMake(x, proposedContentOffset.y)
    }
    
    func flickVelocity() -> CGFloat {
        return 0.3
    }
}
