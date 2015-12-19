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
    var scrollView: UIScrollView!
    var imageView: UIImageView!
    @IBOutlet weak var pageLabel: UILabel!
    var carousel: UIScrollView!
    
    var images: [String] = []
    var index: Int = 0
    var page: Int = 0
    var screenSize: CGRect!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBarHidden = true
        UIApplication.sharedApplication().statusBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.carousel = UIScrollView(frame: CGRectMake(0, 0, screenSize.size.width, screenSize.size.height))
        self.carousel.backgroundColor = .blueColor()
        self.carousel.delegate = self
        self.carousel.pagingEnabled = true
        self.carousel.backgroundColor = .blackColor()
        self.view.addSubview(self.carousel)
        
        generateScrollViewWithImageView()
        self.pageLabel.text = "\(index + 1) of \(self.images.count)"
    }
    
    override func viewDidAppear(animated: Bool) {

    }
    
    @IBAction func closeAction(sender: AnyObject) {
        UIApplication.sharedApplication().statusBarHidden = false
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func generateScrollViewWithImageView() {
        
        for i in 0..<self.images.count {
            
            // Creating scrollView inside carouselScrollView
            self.scrollView = UIScrollView(frame: CGRectMake(CGFloat(i) * screenSize.size.width, 0, screenSize.size.width, screenSize.size.height))
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
            
            let imageViewHeight = self.scrollView.frame.size.width * (self.scrollView.frame.size.width / 320)
            self.imageView = UIImageView(frame: CGRectMake(0, 0, screenSize.size.width, imageViewHeight))
            self.imageView.sd_setImageWithURL(NSURL(string: images[i])!, placeholderImage: UIImage(named: "dummy-placeholder"))
//            self.imageView.backgroundColor = UIColor.greenColor()
            self.imageView.contentMode = UIViewContentMode.ScaleAspectFit
            self.imageView.userInteractionEnabled = true
            self.imageView.addGestureRecognizer(imageTap)
            self.imageView.center = self.scrollView.center
            
            self.scrollView.addSubview(self.imageView)
            self.carousel.addSubview(self.scrollView)
            scrollViewDidZoom(self.scrollView)
        }
        
        self.carousel.contentSize = CGSizeMake(CGFloat(self.images.count) * screenSize.size.width, 0)
        self.carousel.setContentOffset(CGPointMake(screenSize.size.width * CGFloat(index), 0), animated: false)
        
//        self.view.sendSubviewToBack(self.scrollView)
        self.view.sendSubviewToBack(self.carousel)
        
//        println(screenSize.size.width)
//        println(self.carouselScrollView.contentSize)
    }
    
    // MARK: - Scroll View Delegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        println(self.carousel.contentOffset.x)
        let pageWidth: CGFloat = self.carousel.frame.size.width
        page = Int((self.carousel.contentOffset.x / pageWidth) + 1)
        self.pageLabel.text = "\(page) of \(self.images.count)"
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
            self.closeButton.hidden = true
            self.pageLabel.hidden = true
        } else {
            self.closeButton.hidden = false
            self.pageLabel.hidden = false
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        var index: Int = 0
        for subview in self.carousel.subviews {
            if let view = subview as? UIScrollView {
                index++
                if index != page {
                    view.zoomScale = 1.0
                }
            }
        }
    }
    
    // MARK: - Gesture Recognizers
    
    func recognizerForScrollView(gesture: UITapGestureRecognizer) {
        for subview in self.carousel.subviews {
            if let view = subview as? UIScrollView {
                if self.closeButton.hidden == true {
                    self.closeButton.hidden = false
                    self.pageLabel.hidden = false
                } else {
                    self.closeButton.hidden = true
                    self.pageLabel.hidden = true
                }
            }
        }
    }
    
    func tapRecognizer(gesture: UITapGestureRecognizer) {
        for subview in self.carousel.subviews {
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
