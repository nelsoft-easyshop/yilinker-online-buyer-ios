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
    var swipeCtr: Int = 0
    
    let buttonViewWidth: CGFloat = 163          //Size of the hidden swipe buttons
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
    @IBOutlet weak var addToCartLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    
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
            self.swipeCtr = 1
            if !isSwipeViewOpen {
                cellScrollView.contentOffset.x = 1
            }
            updateSwipeViewStatus()
        } else {
            println("Unknown button was clicked!")
        }
    }
    
    func initializeView() {
        var bounds = UIScreen.mainScreen().bounds
        var width = bounds.size.width
        var height = bounds.size.height
        
        /*Set the width of the 'cellScrollView' to same as width of the screeen and
        * set the contentSize of the 'cellScrollView' to width of the screeen plus the 
        * width of the hidden swipe buttons */
        cellScrollView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.bounds))
        cellScrollView.contentSize = CGSize(width: width + buttonViewWidth, height: 0)
        cellScrollView.delegate = self
        
        //Set the width of the 'cellButtonView' to 'buttonViewWidth'(63)
        cellButtonView.frame = CGRectMake(width, 0, buttonViewWidth, CGRectGetHeight(self.bounds))
        
        deleteButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        addToCartButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        cellContentView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.bounds))
        swipeIndicatorView.frame = CGRectMake((width - 25), 0, 25, CGRectGetHeight(self.bounds))
        
        //Add observer for the cell swipe
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "closeSwipeView", name: swipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification, object: nil)
        
        addToCartLabel.text = StringHelper.localizedStringWithKey("WISHLIST_ADD_LOCALIZE_KEY")
        deleteLabel.text = StringHelper.localizedStringWithKey("WISHLIST_DELETE_LOCALIZE_KEY")
        
        /*Set the width of the 'productNameLabel', 'productDetailsLabel' and 'productPriceLabel' to width of the screeen minus
        * the width of product image and swipe indicator button (160). */
        productNameLabel.frame = CGRectMake(productNameLabel.frame.origin.x, productNameLabel.frame.origin.y, (width - 160), productNameLabel.frame.height)
        productDetailsLabel.frame = CGRectMake(productDetailsLabel.frame.origin.x, productDetailsLabel.frame.origin.y, (width - 160), productDetailsLabel.frame.height)
        productPriceLabel.frame = CGRectMake(productPriceLabel.frame.origin.x, productPriceLabel.frame.origin.y, (width - 160), productPriceLabel.frame.height)
        
    }
    
    //Functon in updating the status and scrollview's contentOffSet(Either show the hidden swipe button or hide it)
    func updateSwipeViewStatus(){
        if self.swipeCtr == 1 {
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
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.swipeCtr = 0
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        delegate?.swipeViewDidScroll(self)
        self.swipeCtr++
        if scrollView.contentOffset.x > buttonViewWidth {
            Float(targetContentOffset.memory.x) == Float(buttonViewWidth)
            if !isSwipeViewOpen {
                updateSwipeViewStatus()
            }
        }
        else {
            updateSwipeViewStatus()
        }
    }
    
}
