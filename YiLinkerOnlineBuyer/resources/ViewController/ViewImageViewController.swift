//
//  ViewImageViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 11/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ViewImageViewControllerDelegate {
    func dismissViewImageViewController()
}

class ViewImageViewController: UIViewController {
    
    var delegate: ViewImageViewControllerDelegate?

    @IBOutlet weak var closeView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var image: UIImage?
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if image != nil {
            imageView.image = image
        } else {
            imageView.sd_setImageWithURL(NSURL(string: url), placeholderImage: UIImage(named: "dummy-placeholder"))
        }
        
        // Add tap event to Sort View
        var viewTypeTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target:self, action:"dismiss")
        closeView.addGestureRecognizer(viewTypeTapGesture)

        self.closeView.layer.cornerRadius = self.closeView.frame.size.width / 2
        self.closeView.layer.borderWidth  = 1.5
        self.closeView.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func dismiss(){
        delegate?.dismissViewImageViewController()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
