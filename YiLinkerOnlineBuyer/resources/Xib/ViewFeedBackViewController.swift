//
//  ViewFeedBackViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ViewFeedBackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReviewTableViewCellDelegate {

    @IBOutlet weak var asBuyerButton: DynamicRoundedButton!
    @IBOutlet weak var asSellerButton: DynamicRoundedButton!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingAndReviewsTableView: UITableView!
    @IBOutlet weak var feedFackTectField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let reviewTableViewCellIdentifier: String = "reviewIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratingView.layer.cornerRadius = self.ratingView.frame.width/2
        self.ratingView.clipsToBounds = true
        
        self.ratingAndReviewsTableView.delegate = self
        self.ratingAndReviewsTableView.dataSource = self
        self.registerNibs();
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func asSeller(){
        asSellerButton.backgroundColor = Constants.Colors.appTheme
        asSellerButton.borderColor = UIColor.clearColor()
        asSellerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        
        asBuyerButton.layer.borderColor = Constants.Colors.grayLine.CGColor
        asBuyerButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        asBuyerButton.backgroundColor = UIColor.clearColor()
    }
    
    @IBAction func asBuyer(){
        asBuyerButton.backgroundColor = Constants.Colors.appTheme
        asBuyerButton.borderColor = UIColor.clearColor()
        asBuyerButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

        asSellerButton.layer.borderColor = Constants.Colors.grayLine.CGColor
        asSellerButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        asSellerButton.backgroundColor = UIColor.clearColor()
        
    }
    func registerNibs() {
        let ratingAndReview: UINib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        self.ratingAndReviewsTableView.registerNib(ratingAndReview, forCellReuseIdentifier: reviewTableViewCellIdentifier)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ReviewTableViewCell = self.ratingAndReviewsTableView.dequeueReusableCellWithIdentifier(reviewTableViewCellIdentifier, forIndexPath: indexPath) as! ReviewTableViewCell
        
        cell.delegate = self
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
