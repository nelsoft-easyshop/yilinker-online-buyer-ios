//
//  CartTableViewCell.swift
//  YiLinkerOnlineBuyer
//
//  Created by John Paul Chan on 8/10/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import Foundation

protocol CartTableViewCellDelegate{
    func deleteButtonActionForIndex(sender: AnyObject)
    func editButtonActionForIndex(sender: AnyObject)
    func checkBoxButtonActionForIndex(sender: AnyObject, state: Bool)
    func swipeViewDidScroll(sender: AnyObject)
    func tapDetails(sender: AnyObject)
}

class CartTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    var delegate: CartTableViewCellDelegate?
    
    var isSwipeViewOpen: Bool = false
    var swipeCtr: Int = 0
    
    let buttonViewWidth: CGFloat = 163
    let swipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification: String = "SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification"
    
    @IBOutlet weak var cellScrollView: UIScrollView!
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellButtonView: UIView!
    @IBOutlet weak var swipeIndicatorView: UIView!
    @IBOutlet weak var productDetailsView: UIView!
    @IBOutlet weak var checkBoxView: UIView!
    
    @IBOutlet weak var editLabel: UILabel!
    @IBOutlet weak var deleteLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var checkBox: UIButton!
    @IBOutlet weak var swipeIndicatorButton: UIButton!
    
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productDetailsLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    
    @IBOutlet weak var productItemImageView: UIImageView!
    @IBOutlet weak var swipeIndicatorImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        initializeView()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func buttonClicked(sender : AnyObject) {
        cellScrollView.setContentOffset(CGPointZero, animated: true)
        if(sender as! NSObject == deleteButton){
            updateSwipeViewStatus()
            delegate?.deleteButtonActionForIndex(self)
        } else if(sender as! NSObject == editButton) {
            updateSwipeViewStatus()
            delegate?.editButtonActionForIndex(self)
        } else if(sender as! NSObject == swipeIndicatorButton) {
            self.swipeCtr = 1
            if !isSwipeViewOpen {
                cellScrollView.contentOffset.x = 1
            }
            updateSwipeViewStatus()
        } else if(sender as! NSObject == checkBox) {
            contentTapAction()
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
        deleteButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        editButton.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        checkBox.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
        
        checkBox.backgroundColor = UIColor.whiteColor()
        checkBox.layer.borderWidth = 1
        checkBox.layer.borderColor = UIColor.darkGrayColor().CGColor
        
        cellContentView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.bounds))
        swipeIndicatorView.frame = CGRectMake((width - 25), 0, 25, CGRectGetHeight(self.bounds))
        checkBoxView.frame = CGRectMake(0, 0, 35, CGRectGetHeight(self.bounds))
        productDetailsView.frame = CGRectMake(35, 0, (width - 60), CGRectGetHeight(self.bounds))
        
        productNameLabel.frame = CGRectMake(productNameLabel.frame.origin.x, productNameLabel.frame.origin.y, (width - 187), productNameLabel.frame.height)
        productDetailsLabel.frame = CGRectMake(productDetailsLabel.frame.origin.x, productDetailsLabel.frame.origin.y, (width - 187), productDetailsLabel.frame.height)
        productPriceLabel.frame = CGRectMake(productPriceLabel.frame.origin.x, productPriceLabel.frame.origin.y, (width - 187), productPriceLabel.frame.height)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enclosingTableViewDidScroll", name: swipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification, object: nil)
        
        var contentTap = UITapGestureRecognizer(target:self, action:"contentTapAction")
        checkBoxView.addGestureRecognizer(contentTap)
        
        var detailsTap = UITapGestureRecognizer(target:self, action:"goToProductPage")
        productDetailsView.addGestureRecognizer(detailsTap)
        
        editLabel.text = StringHelper.localizedStringWithKey("CART_EDIT_LOCALIZE_KEY")
        deleteLabel.text = StringHelper.localizedStringWithKey("CART_DELETE_LOCALIZE_KEY")
    }
    
    func contentTapAction() {
        if checkBox.selected {
            checkBox.selected = false
            checkBox.backgroundColor = UIColor.whiteColor()
            checkBox.layer.borderWidth = 1
            checkBox.layer.borderColor = UIColor.darkGrayColor().CGColor
        } else {
            checkBox.selected = true
            checkBox.backgroundColor = UIColor(red: 68/255.0, green: 164/255.0, blue: 145/255.0, alpha: 1.0)
            checkBox.layer.borderWidth = 0
            checkBox.layer.borderColor = UIColor.whiteColor().CGColor
        }
        delegate?.checkBoxButtonActionForIndex(self, state: checkBox.selected)
    }
    
    func goToProductPage(){
        delegate?.tapDetails(self)
    }
    
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
    
    
    func enclosingTableViewDidScroll() {
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