//
//  ProductFullScreenViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 11/21/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ProductFullScreenViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var carouselScrollView: UIScrollView!
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    @IBOutlet weak var pageLabel: UILabel!
    
    var images: [String] = []
    var index: Int = 0
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        self.carouselScrollView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.carouselScrollView.pagingEnabled = true
//        self.carouselScrollView.bounces = false
        
        self.view.addSubview(self.carouselScrollView)
        generateScrollViewWithImageView()
        self.pageLabel.text = "\(index + 1) of \(self.images.count)"
    }
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func generateScrollViewWithImageView() {
        var carouselWidth: CGFloat = 0.0
        
        for i in 0..<self.images.count + 2 {
            
            // Creating scrollView inside carouselScrollView
            self.scrollView = UIScrollView(frame: CGRectMake(CGFloat(i) * self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height))
            self.scrollView.delegate = self
            self.scrollView.bounces = false
            self.scrollView.maximumZoomScale = 4.0
            self.scrollView.minimumZoomScale = 1.0
            self.scrollView.backgroundColor = .blackColor()
            self.scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "recognizerForScrollView:"))
            
            // Creating imageView inside scrollView
            let imageTap = UITapGestureRecognizer()
            imageTap.numberOfTapsRequired = 2
            imageTap.addTarget(self, action: "tapRecognizer:")
            
            let imageViewHeight = self.view.frame.size.width * (self.view.frame.size.width / 320)
            self.imageView = UIImageView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
            self.imageView.center = self.view.center

            if i == 0 {
                self.imageView.sd_setImageWithURL(NSURL(string: images[self.images.count - 1])!, placeholderImage: UIImage(named: "dummy-placeholder"))
            } else if i == self.images.count + 1 {
                self.imageView.sd_setImageWithURL(NSURL(string: images[0])!, placeholderImage: UIImage(named: "dummy-placeholder"))
            } else {
                self.imageView.sd_setImageWithURL(NSURL(string: images[i - 1])!, placeholderImage: UIImage(named: "dummy-placeholder"))
            }
//            self.imageView.backgroundColor = UIColor.whiteColor()
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.imageView.userInteractionEnabled = true
            self.imageView.addGestureRecognizer(imageTap)
            
            self.scrollView.addSubview(self.imageView)
            self.carouselScrollView.addSubview(self.scrollView)
            carouselWidth += self.view.frame.size.width
            scrollViewDidZoom(self.scrollView)
        }
        
        self.carouselScrollView.contentSize = CGSizeMake(carouselWidth, 0)
        self.carouselScrollView.setContentOffset(CGPointMake(self.carouselScrollView.frame.size.width * CGFloat(index + 1), 0), animated: false)
        
        self.view.sendSubviewToBack(self.scrollView)
        self.view.sendSubviewToBack(self.carouselScrollView)
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let pageWidth: CGFloat = self.carouselScrollView.frame.size.width
        let page: Int = Int((self.carouselScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1
        if page == 0 {
            self.pageLabel.text = "\(1) of \(self.images.count)"
        } else if page == self.images.count + 1 {
            self.pageLabel.text = "\(self.images.count) of \(self.images.count)"
        } else {
            self.pageLabel.text = "\(page) of \(self.images.count)"
        }
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
                let boundSize: CGSize = scrollView.bounds.size
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
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        for subview in self.carouselScrollView.subviews {
            if let view = subview as? UIScrollView {
                view.zoomScale = 1.0
            }
        }
        
        if scrollView.contentOffset.x == 0 {
            self.carouselScrollView.setContentOffset(CGPointMake(self.view.frame.size.width * CGFloat(self.images.count), 0), animated: false)
        } else if scrollView.contentOffset.x == self.view.frame.size.width * CGFloat(self.images.count + 1) {
            self.carouselScrollView.setContentOffset(CGPointMake(self.view.frame.size.width, 0), animated: false)
        }
    }
    
    // MARK: - Gesture Recognizers
    
    func recognizerForScrollView(gesture: UITapGestureRecognizer) {
        for subview in self.carouselScrollView.subviews {
            if let view = subview as? UIScrollView {
                
            }
        }
    }
    
    func tapRecognizer(gesture: UITapGestureRecognizer) {
        for subview in self.carouselScrollView.subviews {
            if let view = subview as? UIScrollView {
                if view.zoomScale > view.minimumZoomScale {
                    view.setZoomScale(view.minimumZoomScale, animated: true)
                } else {
                    view.setZoomScale(view.maximumZoomScale, animated: true)
                }
            }
        }
    }

}
