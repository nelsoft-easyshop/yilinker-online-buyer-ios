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
    
    @IBOutlet weak var rateImageView1: UIButton!
    @IBOutlet weak var rateImageView2: UIButton!
    @IBOutlet weak var rateImageView3: UIButton!
    @IBOutlet weak var rateImageView4: UIButton!
    @IBOutlet weak var rateImageView5: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var generalRatingLabel: UILabel!
    @IBOutlet weak var sellerRatingLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var numberOfPeopleLabel: UILabel!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var ratingAndReviewsTableView: UITableView!
    
    let reviewTableViewCellIdentifier: String = "reviewIdentifier"
    
    var productReviewModel: ProductReviewModel?
    var sellerModel: SellerModel?
    var sellerId: Int = 0
    
    var screenWidth: CGFloat = 0.0
    
    var tabController = CustomTabBarController()
    
    var hud: MBProgressHUD?
    var delegate: ViewFeedBackViewControllerDelegate?
    
    var cancelTitle = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
    var sellerRating = StringHelper.localizedStringWithKey("SELLERS_RATING_AND_FEEDBACK_LOCALIZE_KEY")
    var ratingTitle = StringHelper.localizedStringWithKey("SELLERS_RATING_LOCALIZE_KEY")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratingView.layer.cornerRadius = self.ratingView.frame.width/2
        self.ratingView.clipsToBounds = true
        
        self.ratingAndReviewsTableView.delegate = self
        self.ratingAndReviewsTableView.dataSource = self
        self.registerNibs()
        
        self.cancelButton.setTitle(cancelTitle, forState: UIControlState.Normal)
        self.sellerRatingLabel.text = sellerRating
        self.ratingLabel.text = ratingTitle
        self.ratingAndReviewsTableView.hidden = true
        self.loadingLabel.hidden = false
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
        cell.delegate = self
        if(self.sellerModel != nil) {
            let reviewModel: ProductReviewsModel = self.sellerModel!.reviews[indexPath.section]
            cell.messageLabel.text = reviewModel.review
            cell.nameLabel.text = reviewModel.fullName
            var strImageUrl = reviewModel.profileImageUrl
            var strRate = reviewModel.ratingSellerReview
            cell.setRating(strRate)
            cell.setDisplayPicture(strImageUrl)
        }
        
        return cell
    
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        if self.sellerModel != nil {
            return self.sellerModel!.reviews.count
        } else {
            return 0
        }
        
    }
    
    func fireSellerFeedback() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        let manager = APIManager.sharedInstance
        let parameters: NSDictionary = ["sellerId" : self.sellerId];
        manager.POST("\(APIAtlas.buyerSellerFeedbacks)?access_token=\(SessionManager.accessToken())", parameters: parameters, success: {
            (task: NSURLSessionDataTask!, responseObject: AnyObject!) in
            println(responseObject["isSuccessful"])
            if responseObject["isSuccessful"] as! Bool {
                self.sellerModel = SellerModel.parseSellerReviewsDataFromDictionary(responseObject as! NSDictionary)
                self.setRating(self.sellerModel!.rating)
                self.generalRatingLabel.text = "\(self.sellerModel!.rating)"
                self.numberOfPeopleLabel.text = "\(self.sellerModel!.reviews.count)"
                self.ratingAndReviewsTableView.reloadData()
                if self.sellerModel!.reviews.count == 0 {
                    self.showAlert(title: ProductStrings.alertNoReviews, message: nil)
                    self.ratingAndReviewsTableView.hidden = true
                    self.loadingLabel.hidden = false
                    self.loadingLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_NO_REVIEWS_LOCALIZE_KEY")
                } else {
                    self.ratingAndReviewsTableView.hidden = false
                    self.loadingLabel.hidden = true
                }
            } else {
                self.showAlert(title: Constants.Localized.error, message: responseObject["message"] as! String)
                self.ratingAndReviewsTableView.hidden = true
                self.loadingLabel.hidden = false
                self.loadingLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_NO_REVIEWS_LOCALIZE_KEY")
            }
            UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            self.ratingAndReviewsTableView.reloadData()
            }, failure: {
                (task: NSURLSessionDataTask!, error: NSError!) in
                if error.userInfo != nil {
                    println(error.userInfo)
                    if let jsonResult = error.userInfo as? Dictionary<String, AnyObject> {
                        if jsonResult["message"] != nil {
                            self.showAlert(title: jsonResult["message"] as! String, message: nil)
                        } else {
                            self.showAlert(title: Constants.Localized.someThingWentWrong, message: nil)
                        }
                    }
                } else  {
                    self.showAlert(title: Constants.Localized.error, message: Constants.Localized.someThingWentWrong)
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.ratingAndReviewsTableView.hidden = true
                self.loadingLabel.hidden = true
        })
        
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
    
    func showAlert(#title: String!, message: String!) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: Constants.Localized.ok, style: .Default, handler: nil)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func setRating(rate: Int) {
        
        var r: Int = rate
        
        if r > 4 {
            rateImage(rateImageView5)
        }
        
        if r > 3 {
            rateImage(rateImageView4)
        }
        
        if r > 2 {
            rateImage(rateImageView3)
        }
        
        if r > 1  {
            rateImage(rateImageView2)
        }
        
        if r > 0 {
            rateImage(rateImageView1)
        }
    }
    
    func rateImage(ctr: UIButton) {
        ctr.setImage(UIImage(named: "rating2"), forState: UIControlState.Normal)
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
