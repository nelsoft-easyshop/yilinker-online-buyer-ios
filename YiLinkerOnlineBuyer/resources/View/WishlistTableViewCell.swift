//
//  WishlistTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/9/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol WishlistTableViewCellDelegate{
    func deleteButtonActionForIndex(sender: AnyObject)
    func addToCartButtonActionForIndex(sender: AnyObject)
    func swipeViewDidScroll(sender: AnyObject)
}

class WishlistTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    var delegate: WishlistTableViewCellDelegate?
    
    var isSwipeViewOpen: Bool = false
    
    let buttonViewWidth: CGFloat = 163
    let swipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification: String = "SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification"

    @IBOutlet weak var cellScrollView: UIScrollView!
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellButtonView: UIView!
    @IBOutlet weak var swipeIndicatorView: UIView!
    
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var swipeIndicatorButton: UIButton!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDetailsLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var productItemImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeView()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func buttonClicked(sender : AnyObject) {
        cellScrollView.setContentOffset(CGPointZero, animated: true)
        if(sender as! NSObject == deleteButton){
            delegate!.deleteButtonActionForIndex(self)
        } else if(sender as! NSObject == addToCartButton) {
            updateSwipeViewStatus()
            delegate!.addToCartButtonActionForIndex(self)
        } else if(sender as! NSObject == swipeIndicatorButton) {
            updateSwipeViewStatus()
        } else {
            println("Unknown button was clicked!")
        }
    }
    
    func initializeView() {
        var bounds = UIScreen.mainScreen().bounds
        var width = bounds.size.width
        var height = bounds.size.height
        
        cellScrollView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.bounds))
        cellScrollView.contentSize = CGSize(width: width + buttonViewWidth, height: 0)
        cellScrollView.delegate = self
        
        cellButtonView.frame = CGRectMake(width, 0, buttonViewWidth, CGRectGetHeight(self.bounds))
        
        deleteButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        addToCartButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        cellContentView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.bounds))
        swipeIndicatorView.frame = CGRectMake((width - 25), 0, 25, CGRectGetHeight(self.bounds))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeSwipeView", name: swipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification, object: nil)
    }
    
    func updateSwipeViewStatus(){
        if isSwipeViewOpen {
            isSwipeViewOpen = false
            swipeIndicatorButton.setImage(UIImage(named: "left"), forState: UIControlState.Normal)
            swipeIndicatorButton.alpha = 1.0
            dispatch_async(dispatch_get_main_queue(), {
                self.cellScrollView.setContentOffset(CGPointZero, animated: true)
            })
        } else {
            if cellScrollView.contentOffset.x > 0 {
                isSwipeViewOpen = true
                swipeIndicatorButton.setImage(UIImage(named: "right"), forState: UIControlState.Normal)
                swipeIndicatorButton.alpha = 0.5
                dispatch_async(dispatch_get_main_queue(), {
                    self.cellScrollView.setContentOffset(CGPoint(x: self.buttonViewWidth, y: 0), animated: true)
                })
            }
        }
    }
    
    // Close Swipe View
    func closeSwipeView() {
        if isSwipeViewOpen {
            updateSwipeViewStatus()
        }
        cellScrollView.setContentOffset(CGPointZero, animated: true)
    }
    
    // MARK: - Scroll View Delegate
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x < 0 {
            scrollView.contentOffset = CGPointZero
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.swipeViewDidScroll(self)
        if scrollView.contentOffset.x > buttonViewWidth {
            Float(targetContentOffset.memory.x) == Float(buttonViewWidth)
            if !isSwipeViewOpen{
                updateSwipeViewStatus()
            }
        }
        else {
            updateSwipeViewStatus()
        }

    }

}
