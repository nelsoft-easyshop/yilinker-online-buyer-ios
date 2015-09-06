//
//  ViewFeedBackViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class ViewFeedBackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReviewTableViewCellDelegate {
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingAndReviewsTableView: UITableView!
    @IBOutlet weak var feedFackTectField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let reviewTableViewCellIdentifier: String = "reviewIdentifier"
    
    var productReviewModel: ProductReviewModel?
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratingView.layer.cornerRadius = self.ratingView.frame.width/2
        self.ratingView.clipsToBounds = true
        
        self.ratingAndReviewsTableView.delegate = self
        self.ratingAndReviewsTableView.dataSource = self
        self.registerNibs()
        
        self.fireSellerFeedback()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func registerNibs() {
        let ratingAndReview: UINib = UINib(nibName: "ReviewTableViewCell", bundle: nil)
        self.ratingAndReviewsTableView.registerNib(ratingAndReview, forCellReuseIdentifier: reviewTableViewCellIdentifier)
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: ReviewTableViewCell = self.ratingAndReviewsTableView.dequeueReusableCellWithIdentifier(reviewTableViewCellIdentifier, forIndexPath: indexPath) as! ReviewTableViewCell
        
        if(self.productReviewModel != nil) {
            cell.messageLabel.text = self.productReviewModel?.reviews[indexPath.row].review
            cell.nameLabel.text = self.productReviewModel?.reviews[indexPath.row].fullName
            var strImageUrl = self.productReviewModel?.reviews[indexPath.row].profileImageUrl
            var strRate = self.productReviewModel?.reviews[indexPath.row].rating
            cell.setRating(strRate!)
            cell.setDisplayPicture(strImageUrl!)
        }
        
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
    
    
    func fireSellerFeedback() {
        self.showHUD()
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["access_token" : SessionManager.accessToken(), "sellerId" : "1"]
        manager.POST(APIAtlas.buyerSellerFeedbacks, parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.productReviewModel = ProductReviewModel.parseDataWithDictionary(responseObject as! NSDictionary)
            self.hud?.hide(true)
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                println(error.userInfo)
                self.hud?.hide(true)
        })
        self.ratingAndReviewsTableView.reloadData()

    }
    
    func showHUD() {
        if self.hud != nil {
            self.hud!.hide(true)
            self.hud = nil
        }
        
        self.hud = MBProgressHUD(view: self.view)
        self.hud?.removeFromSuperViewOnHide = true
        self.hud?.dimBackground = false
        self.navigationController?.view.addSubview(self.hud!)
        self.hud?.show(true)
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
