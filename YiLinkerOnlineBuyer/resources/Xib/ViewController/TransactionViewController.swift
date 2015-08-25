//
//  TransactionViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/20/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var pendingView: UIView!
    @IBOutlet weak var onDeliveryView: UIView!
    @IBOutlet weak var forFeedbackView: UIView!
    @IBOutlet weak var supportView: UIView!
    
    @IBOutlet weak var allImageView: UIImageView!
    @IBOutlet weak var pendingImageView: UIImageView!
    @IBOutlet weak var onDeliveryImageView: UIImageView!
    @IBOutlet weak var forFeedbackImageView: UIImageView!
    @IBOutlet weak var supportImageView: UIImageView!
    
    @IBOutlet weak var allLabel: UILabel!
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet weak var onDeliveryLabel: UILabel!
    @IBOutlet weak var forFeedbackLabel: UILabel!
    @IBOutlet weak var supportLabel: UILabel!
    
    var viewsInArray: [UIView] = []
    var imagesInArray: [UIImageView] = []
    var labelsInArray: [UILabel] = []
    var deselectedImages: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TransactionIdentifier")
        
        viewsInArray = [allView, pendingView, onDeliveryView, forFeedbackView, supportView]
        imagesInArray = [allImageView, pendingImageView, onDeliveryImageView, forFeedbackImageView, supportImageView]
        labelsInArray = [allLabel, pendingLabel, onDeliveryLabel, forFeedbackLabel, supportLabel]
        deselectedImages = ["all", "pending", "onDelivery", "forFeedback", "support"]
        
        addViewsActions()
    }
    
    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: TransactionTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("TransactionIdentifier") as! TransactionTableViewCell
        
        return cell
    }

    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let transactionDetails = TransactionDetailsViewController(nibName: "TransactionDetailsViewController", bundle: nil)
        self.navigationController?.pushViewController(transactionDetails, animated: true)
    }
    
    // Actions
    
    func allAction(gesture: UIGestureRecognizer) {
        if allView.tag == 0 {
            selectView(allView, label: allLabel, imageView: allImageView, imageName: "all2")
            deselectOtherViews(allView)
        }
    }
    
    func pendingAction(gesture: UIGestureRecognizer) {
        if pendingView.tag == 0 {
            selectView(pendingView, label: pendingLabel, imageView: pendingImageView, imageName: "time")
            deselectOtherViews(pendingView)
        }
    }
    
    func onDeliveryAction(gesture: UIGestureRecognizer) {
        if onDeliveryView.tag == 0 {
            selectView(onDeliveryView, label: onDeliveryLabel, imageView: onDeliveryImageView, imageName: "onDelivery2")
            deselectOtherViews(onDeliveryView)
        }
    }
    
    func forFeedbackAction(gesture: UIGestureRecognizer) {
        if forFeedbackView.tag == 0 {
            selectView(forFeedbackView, label: forFeedbackLabel, imageView: forFeedbackImageView, imageName: "forFeedback2")
            deselectOtherViews(forFeedbackView)
        }
    }
    
    func supportAction(gesture: UIGestureRecognizer) {
        if supportView.tag == 0 {
            selectView(supportView, label: supportLabel, imageView: supportImageView, imageName: "support2")
            deselectOtherViews(supportView)
        }
    }
    
    // Methods
    
    func addViewsActions() {
        self.allView.addGestureRecognizer(tap("allAction:"))
        self.pendingView.addGestureRecognizer(tap("pendingAction:"))
        self.onDeliveryView.addGestureRecognizer(tap("onDeliveryAction:"))
        self.forFeedbackView.addGestureRecognizer(tap("forFeedbackAction:"))
        self.supportView.addGestureRecognizer(tap("supportAction:"))
    }
    
    func tap(action: Selector) -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: action)
        return tap
    }
    
    func selectView(view: UIView, label: UILabel, imageView: UIImageView, imageName: String) {
        view.backgroundColor = .whiteColor()
        label.textColor = Constants.Colors.appTheme
        imageView.image = UIImage(named: imageName)
        view.tag = 1
    }
    
    func deselectOtherViews(view: UIView) {
        for i in 0..<self.viewsInArray.count {
            if view != self.viewsInArray[i] {
                viewsInArray[i].backgroundColor = Constants.Colors.appTheme
                labelsInArray[i].textColor = .whiteColor()
                imagesInArray[i].image = UIImage(named: deselectedImages[i])
                viewsInArray[i].tag = 0
            }
        }
    }
}
