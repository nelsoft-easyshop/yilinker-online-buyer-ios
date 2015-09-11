//
//  ViewFeedBackViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Joriel Oller Fronda on 8/30/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

protocol ViewFeedBackViewControllerDelegate {
    func dismissDimView()
}

class ViewFeedBackViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ReviewTableViewCellDelegate {
    
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var ratingAndReviewsTableView: UITableView!
    
    let reviewTableViewCellIdentifier: String = "reviewIdentifier"
    
    var productReviewModel: ProductReviewModel?
    
    var screenWidth: CGFloat = 0.0
    
    var tabController = CustomTabBarController()
    
    var hud: MBProgressHUD?
    var delegate: ViewFeedBackViewControllerDelegate?
    
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
    
    @IBAction func closeAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.dismissDimView()
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
        
        manager.POST("\(APIAtlas.buyerSellerFeedbacks)?access_token=\(SessionManager.accessToken())&sellerId=1", parameters: nil, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            self.productReviewModel = ProductReviewModel.parseDataWithDictionary(responseObject as! NSDictionary)
            self.hud?.hide(true)
            self.ratingAndReviewsTableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                let task: NSHTTPURLResponse = task.response as! NSHTTPURLResponse
                if task.statusCode == 404 {
                    let data = error.userInfo as! Dictionary<String, AnyObject>
                    print(data["message"])
                    var message = data["message"] as! String
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "\(message)", title: "Error")
                } else {
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: "Something went wrong", title: "Error")
                }
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
