//
//  ProductReviewViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/5/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ProductReviewViewControllerDelegate {
    func pressedCancelReview(controller: ProductReviewViewController)
}

class ProductReviewViewController: UIViewController {

    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var cancelContainer: UIView!
    
    @IBOutlet weak var rate1: UIImageView!
    @IBOutlet weak var rate2: UIImageView!
    @IBOutlet weak var rate3: UIImageView!
    @IBOutlet weak var rate4: UIImageView!
    @IBOutlet weak var rate5: UIImageView!
    
    var model: ProductReviewModel!
    
    var delegate: ProductReviewViewControllerDelegate?
    
    let bodyText = ["Proin gravida nibh vel velit auctor aliquet. Aenean solicitudin, lorem quis bibendum auctir, nisi elit consequat ipsum.",
        "Proin gravida nibh vel velit auctor aliquet. Aenean solicitudin, lorem quis bibendum auctir, nisi elit consequat ipsum, nec sagittis sem nibh id elit. Duis sed odio sit amet nibh vulputate."]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "reviewIdentifier")
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100.0
        
        numberOfPeopleLabel.layer.shadowColor = UIColor.redColor().CGColor
        numberOfPeopleLabel.layer.shadowOffset = CGSizeMake(-1, 1)
        numberOfPeopleLabel.layer.shadowOpacity = 0.2
        numberOfPeopleLabel.layer.shadowRadius = 2
        
        rateLabel.layer.cornerRadius = rateLabel.frame.size.width / 2
        rateLabel.clipsToBounds = true
        
        let tap = UITapGestureRecognizer()
        tap.numberOfTapsRequired = 1
        tap.addTarget(self, action: "dimViewAction:")
        self.dimView.addGestureRecognizer(tap)
        self.dimView.backgroundColor = .clearColor()
        
        rateLabel.backgroundColor = Constants.Colors.productReviewGreen
        
    }

    // MARK: - Table View Data Source
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.reviews.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: ReviewTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("reviewIdentifier") as! ReviewTableViewCell
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        cell.setName(model.reviews[indexPath.row].name)
        cell.setDisplayPicture(model.reviews[indexPath.row].imageUrl)
        cell.setMessage(model.reviews[indexPath.row].message)
        cell.setRating(model.reviews[indexPath.row].rating)
        
        return cell
    }
    
    @IBAction func cancelAction(sender: AnyObject!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        if let delegate = self.delegate {
            delegate.pressedCancelReview(self)
        }
    }
    
    func passModel(model: ProductReviewModel) {
        self.model = model
        
        setRating(model.rating)
        var font = [NSFontAttributeName : UIFont.boldSystemFontOfSize(35.0)]
        var rater = NSMutableAttributedString(string: String(format: "%.f", model.rating), attributes: font)
        var textToAppend = NSMutableAttributedString(string: rateLabel.text!)
        rater.appendAttributedString(textToAppend)
        
        rateLabel.text = String(format: "%.f/5", model.rating)
        rateLabel.attributedText = rater
        
        font = [NSFontAttributeName : UIFont.boldSystemFontOfSize(14.0)]
        rater = NSMutableAttributedString(string: "\(model.reviews.count)", attributes: font)
        textToAppend = NSMutableAttributedString(string: " people rate this product")
        rater.appendAttributedString(textToAppend)
        
        numberOfPeopleLabel.attributedText = rater
    }
    
    func dimViewAction(gesture: UIGestureRecognizer) {
        cancelAction(nil)
    }
    
    func setRating(rate: Float) {
        
        if rate > 4 {
            rateImage(rate5)
        }
        
        if rate > 3 {
            rateImage(rate4)
        }
        
        if rate > 2 {
            rateImage(rate3)
        }
        
        if rate > 1  {
            rateImage(rate2)
        }
        
        if rate > 0 {
            rateImage(rate1)
        }
        
    }
    
    func rateImage(ctr: UIImageView) {
        ctr.image = UIImage(named: "rating2")
    }
    
    
    
}