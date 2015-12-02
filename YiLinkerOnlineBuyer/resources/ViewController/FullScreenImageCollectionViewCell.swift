//
//  FullScreenImageCollectionViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/23/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class FullScreenImageCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let scrollTap = UITapGestureRecognizer()
        scrollTap.addTarget(self, action: "recognizerForScrollView:")
        self.scrollView.addGestureRecognizer(scrollTap)
        self.scrollView.delegate = self
    }
    
    func setImage(image: String) {
        
        let imageTap = UITapGestureRecognizer()
        imageTap.numberOfTapsRequired = 2
        imageTap.addTarget(self, action: "tapRecognizer:")
        
        let imageViewHeight = 300 * (self.frame.size.width / 320)
        self.imageView = UIImageView(frame: CGRectMake(0, 0, self.frame.size.width, imageViewHeight))
        self.imageView.center = self.center
        self.imageView.sd_setImageWithURL(NSURL(string: image)!, placeholderImage: UIImage(named: "dummy-placeholder"))
        self.imageView.backgroundColor = UIColor.whiteColor()
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
        self.imageView.userInteractionEnabled = true
        self.imageView.addGestureRecognizer(imageTap)
        self.scrollView.addSubview(self.imageView)
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        for subview in scrollView.subviews as! [UIView]{
            if let view = subview as? UIImageView {
                return view
            }
        }
        
        return self.imageView
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {
        
        for subview in scrollView.subviews as! [UIView]{
            if let view = subview as? UIImageView {
                let boundSize: CGSize = self.scrollView.bounds.size
                var contentsFrame: CGRect = view.frame
                
                if contentsFrame.size.width < boundSize.width {
                   contentsFrame.origin.x = (boundSize.width - contentsFrame.size.width) / 2.0
                } else {
                   contentsFrame.origin.x = 0.0
                }
                
                if contentsFrame.size.height < boundSize.height {
                    contentsFrame.origin.y = (boundSize.height - contentsFrame.size.height) / 2.0
                } else {
                    contentsFrame.origin.y = 0.0
                }
                
                view.frame = contentsFrame
            }
        }
        
        if scrollView.zoomScale > 1.0 {
            
        } else {
            
        }
    }
    
    // MARK: - Gesture Recognizers
    
    func recognizerForScrollView(gesture: UITapGestureRecognizer) {
        for subview in self.contentView.subviews {
            if let view = subview as? UIScrollView {
                
            }
        }
    }
    
    func tapRecognizer(gesture: UITapGestureRecognizer) {
//        for subview in self.contentView.subviews {
//            if let view = subview as? UIScrollView {
//                if view.zoomScale > view.minimumZoomScale {
//                    view.setZoomScale(view.minimumZoomScale, animated: true)
//                } else {
//                    view.setZoomScale(view.maximumZoomScale, animated: true)
//                }
//            }
//        }
    }
    
    
    
    

}
