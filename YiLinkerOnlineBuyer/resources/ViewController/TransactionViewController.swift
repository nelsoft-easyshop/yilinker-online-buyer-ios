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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let nib = UINib(nibName: "TransactionTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "TransactionIdentifier")
        
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

    // Actions
    
    func allAction(gesture: UIGestureRecognizer) {
        if allView.tag == 1 {
            deselectView(allView, label: allLabel, imageView: allImageView, imageName: "all")
        } else {
            selectView(allView, label: allLabel, imageView: allImageView, imageName: "all2")
        }
    }
    
    func pendingAction(gesture: UIGestureRecognizer) {
        if pendingView.tag == 1 {
            deselectView(pendingView, label: pendingLabel, imageView: pendingImageView, imageName: "pending")
        } else {
            selectView(pendingView, label: pendingLabel, imageView: pendingImageView, imageName: "time")
        }
    }
    
    func onDeliveryAction(gesture: UIGestureRecognizer) {
        if onDeliveryView.tag == 1 {
            deselectView(onDeliveryView, label: onDeliveryLabel, imageView: onDeliveryImageView, imageName: "onDelivery")
        } else {
            selectView(onDeliveryView, label: onDeliveryLabel, imageView: onDeliveryImageView, imageName: "onDelivery2")
        }
    }
    
    func forFeedbackAction(gesture: UIGestureRecognizer) {
        if forFeedbackView.tag == 1 {
            deselectView(forFeedbackView, label: forFeedbackLabel, imageView: forFeedbackImageView, imageName: "forFeedback")
        } else {
            selectView(forFeedbackView, label: forFeedbackLabel, imageView: forFeedbackImageView, imageName: "forFeedback2")
        }
    }
    
    func supportAction(gesture: UIGestureRecognizer) {
        if supportView.tag == 1 {
            deselectView(supportView, label: supportLabel, imageView: supportImageView, imageName: "support")
        } else {
            selectView(supportView, label: supportLabel, imageView: supportImageView, imageName: "support2")
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
    
    func deselectView(view: UIView, label: UILabel, imageView: UIImageView, imageName: String) {
        view.backgroundColor = Constants.Colors.appTheme
        label.textColor = .whiteColor()
        imageView.image = UIImage(named: imageName)
        view.tag = 0
    }
    
}
