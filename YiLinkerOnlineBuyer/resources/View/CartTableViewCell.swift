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
}

class CartTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
    var delegate: CartTableViewCellDelegate?
    
    var isSwipeViewOpen: Bool = false
    
    let buttonViewWidth: CGFloat = 163          //Button view width
    let swipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification: String = "SwipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification"
    
    @IBOutlet weak var cellScrollView: UIScrollView!
    
    @IBOutlet weak var cellContentView: UIView!
    @IBOutlet weak var cellButtonView: UIView!
    @IBOutlet weak var swipeIndicatorView: UIView!
    
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
            delegate?.deleteButtonActionForIndex(self)
        } else if(sender as! NSObject == editButton) {
            updateSwipeViewStatus()
            delegate?.editButtonActionForIndex(self)
        } else if(sender as! NSObject == swipeIndicatorButton) {
            updateSwipeViewStatus()
        } else if(sender as! NSObject == checkBox) {
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "enclosingTableViewDidScroll", name: swipeForOptionsCellEnclosingTableViewDidBeginScrollingNotification, object: nil)

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
        //cellButtonView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - buttonViewWidth), 0.0, buttonViewWidth, CGRectGetHeight(self.bounds))
        
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
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