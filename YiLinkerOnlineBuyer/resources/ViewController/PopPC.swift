//
//  CancelOrderPC.swift
//  Messaging
//
//  Created by Dennis Nora on 8/22/15.
//  Copyright (c) 2015 Dennis Nora. All rights reserved.
//

import UIKit

class PopPC: UIPresentationController, UIAdaptivePresentationControllerDelegate {
    
    var cancelView : UIView = UIView()
    
    override init(presentedViewController: UIViewController!, presentingViewController: UIViewController!) {
        super.init(presentedViewController: presentedViewController, presentingViewController: presentingViewController)
        
        cancelView.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        cancelView.alpha = 0.0
        
        let tap = UITapGestureRecognizer(target: self, action: "cancelTapped:")
        
    }
    
    func cancelTapped(gesture : UIGestureRecognizer){
        if(gesture.state == UIGestureRecognizerState.Ended){
            presentingViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func frameOfPresentedViewInContainerView() -> CGRect {
        var presentedViewFrame = CGRectZero
        let containerBounds = containerView.bounds
        presentedViewFrame.size = sizeForChildContentContainer(presentedViewController, withParentContainerSize: containerBounds.size)
        
        presentedViewFrame.origin.x = (containerBounds.size.width - presentedViewFrame.size.width)/2
        presentedViewFrame.origin.y = (containerBounds.size.height - presentedViewFrame.size.height)/2
        
        return presentedViewFrame
    }
    
    override func sizeForChildContentContainer(container: UIContentContainer, withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSizeMake(parentSize.width * 0.9, CGFloat((floorf(Float(parentSize.height / 2.0)))))
    }
    
    override func presentationTransitionWillBegin() {
        cancelView.frame = self.containerView.bounds
        cancelView.alpha = 0.0
        
        containerView.insertSubview(cancelView, atIndex: 0)
        let coordinator = presentedViewController.transitionCoordinator()
        if (coordinator != nil) {
            coordinator!.animateAlongsideTransition({
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                    self.cancelView.alpha = 1.0
                }, completion: nil)
        } else {
            self.cancelView.alpha = 1.0
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let coordinator = presentedViewController.transitionCoordinator()
        if (coordinator != nil){
            coordinator!.animateAlongsideTransition({
                (context:UIViewControllerTransitionCoordinatorContext!) -> Void in
                    self.cancelView.alpha = 0.0
                }, completion: nil)
        } else {
            self.cancelView.alpha = 0.0
        }
    }

    override func containerViewWillLayoutSubviews() {
        cancelView.frame = containerView.bounds
        presentedView().frame = frameOfPresentedViewInContainerView()
    }
    
    override func shouldPresentInFullscreen() -> Bool {
        return false
    }
    
    override func adaptivePresentationStyle() -> UIModalPresentationStyle {
        return UIModalPresentationStyle.Custom
    }
    
}
