//
//  BottomLoaderCollectionReusableView.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 4/6/16.
//  Copyright (c) 2016 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class BottomLoaderCollectionReusableView: UICollectionReusableView {
    
    @IBOutlet weak var loaderLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLoaderTitle(text: String) {
        self.loaderLabel.text = text
    }
}
