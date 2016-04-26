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
    var orderProductId: Int = 0
    var productId: Int = 0
    var feedback: Bool = false
    
    var screenWidth: CGFloat = 0.0
    
    var tabController = CustomTabBarController()
    
    var yiHud: YiHUD?
    var delegate: ViewFeedBackViewControllerDelegate?
    
    var cancelTitle = StringHelper.localizedStringWithKey("CANCEL_LOCALIZE_KEY")
    var sellerRating = StringHelper.localizedStringWithKey("SELLERS_RATING_AND_FEEDBACK_LOCALIZE_KEY")
    var productRating = StringHelper.localizedStringWithKey("RATING_FEEDBACK_LOCALIZE_KEY")
    var ratingTitle = StringHelper.localizedStringWithKey("SELLERS_RATING_LOCALIZE_KEY")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ratingView.layer.cornerRadius = self.ratingView.frame.width/2
        self.ratingView.clipsToBounds = true
        
        self.ratingAndReviewsTableView.delegate = self
        self.ratingAndReviewsTableView.dataSource = self
        self.registerNibs()
        
        self.cancelButton.setTitle(cancelTitle, forState: UIControlState.Normal)
        
        if self.feedback {
            self.sellerRatingLabel.text = sellerRating
        } else {
            self.sellerRatingLabel.text = productRating
        }
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
        if self.feedback {
            if(self.sellerModel != nil) {
                let reviewModel: ProductReviewsModel = self.sellerModel!.reviews[indexPath.section]
                cell.messageLabel.text = reviewModel.review
                cell.nameLabel.text = reviewModel.fullName
                var strImageUrl = reviewModel.profileImageUrl
                var strRate = reviewModel.ratingSellerReview
                cell.setRating(strRate)
                cell.setDisplayPicture(strImageUrl)
            }
        } else {
            if(self.productReviewModel != nil) {
                let reviewModel: ProductReviewsModel = self.productReviewModel!.reviews[indexPath.section]
                cell.messageLabel.text = reviewModel.review
                cell.nameLabel.text = reviewModel.fullName
                var strImageUrl = reviewModel.profileImageUrl
                var strRate = reviewModel.ratingSellerReview
                println("\(strRate)")
                cell.setRating(strRate)
                cell.setDisplayPicture(strImageUrl)
            }
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
        if self.feedback {
            if self.sellerModel != nil {
                return self.sellerModel!.reviews.count
            } else {
                return 0
            }
        } else {
            if self.productReviewModel != nil {
                return self.productReviewModel!.reviews.count
            } else {
                return 0
            }
        }
    }
    
    func fireSellerFeedback() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        var parameters: NSDictionary?
        var url: String = ""
        
        if self.feedback {
            parameters = ["sellerId" : self.sellerId]
            url = "\(APIAtlas.buyerSellerFeedbacks)?access_token=\(SessionManager.accessToken())"
        } else {
            parameters = ["productId" : self.productId]
            url = APIAtlas.productReviews
        }
        
        WebServiceManager.fireSellerFeedbackWithUrl(url, parameters: parameters, actionHandler: { (successful, responseObject, requestErrorType) -> Void in
            if successful {
                if responseObject["isSuccessful"] as! Bool {
                    if self.feedback {
                        self.sellerModel = SellerModel.parseSellerReviewsDataFromDictionary(responseObject as! NSDictionary)
                        self.setRating(self.sellerModel!.rating)
                        self.generalRatingLabel.text = "\(self.sellerModel!.rating)"
                        self.numberOfPeopleLabel.text = "\(self.sellerModel!.reviews.count)"
                        self.ratingAndReviewsTableView.reloadData()
                        if self.sellerModel!.reviews.count == 0 {
                            //self.showAlert(title: ProductStrings.alertNoReviews, message: nil)
                            self.ratingAndReviewsTableView.hidden = true
                            self.loadingLabel.hidden = false
                            self.loadingLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_NO_REVIEWS_LOCALIZE_KEY")
                        } else {
                            self.ratingAndReviewsTableView.hidden = false
                            self.loadingLabel.hidden = true
                        }
                    } else {
                        self.productReviewModel = ProductReviewModel.parseDataWithDictionary2(responseObject)
                        self.setRating(self.productReviewModel!.ratingAverage)
                        self.generalRatingLabel.text = "\(self.productReviewModel!.ratingAverage)"
                        self.numberOfPeopleLabel.text = "\(self.productReviewModel!.reviews.count)"
                        self.ratingAndReviewsTableView.reloadData()
                        if self.productReviewModel!.reviews.count == 0 {
                            //self.showAlert(title: ProductStrings.alertNoReviews, message: nil)
                            self.ratingAndReviewsTableView.hidden = true
                            self.loadingLabel.hidden = false
                            self.loadingLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_NO_REVIEWS_LOCALIZE_KEY")
                        } else {
                            self.ratingAndReviewsTableView.hidden = false
                            self.loadingLabel.hidden = true
                        }
                    }
                } else {
                    self.ratingAndReviewsTableView.hidden = true
                    self.loadingLabel.hidden = false
                    self.loadingLabel.text = StringHelper.localizedStringWithKey("TRANSACTION_NO_REVIEWS_LOCALIZE_KEY")
                }
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.ratingAndReviewsTableView.reloadData()
            } else {
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
                self.ratingAndReviewsTableView.hidden = true
                self.loadingLabel.hidden = true
                if requestErrorType == .ResponseError {
                    //Error in api requirements
                    let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(responseObject as! NSDictionary)
                    Toast.displayToastWithMessage(errorModel.message, duration: 1.5, view: self.view)
                } else if requestErrorType == .AccessTokenExpired {
                    self.fireRefreshToken()
                    self.ratingAndReviewsTableView.reloadData()
                } else if requestErrorType == .PageNotFound {
                    //Page not found
                    Toast.displayToastWithMessage(Constants.Localized.pageNotFound, duration: 1.5, view: self.view)
                } else if requestErrorType == .NoInternetConnection {
                    //No internet connection
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .RequestTimeOut {
                    //Request timeout
                    Toast.displayToastWithMessage(Constants.Localized.noInternetErrorMessage, duration: 1.5, view: self.view)
                } else if requestErrorType == .UnRecognizeError {
                    //Unhandled error
                    UIAlertController.displayErrorMessageWithTarget(self, errorMessage: Constants.Localized.someThingWentWrong, title: Constants.Localized.error)
                }
            }
        })
    }
    
    func showHUD() {
       self.yiHud = YiHUD.initHud()
       self.yiHud!.showHUDToView(self.view)
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
    
    func fireRefreshToken() {
        UIApplication.sharedApplication().networkActivityIndicatorVisible = true
        WebServiceManager.fireRefreshTokenWithUrl(APIAtlas.refreshTokenUrl, actionHandler: {
            (successful, responseObject, requestErrorType) -> Void in
            self.yiHud?.hide()
            
            if successful {
                SessionManager.parseTokensFromResponseObject(responseObject as! NSDictionary)
                self.fireSellerFeedback()
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            } else {
                let dictionary: NSDictionary = (error.userInfo as? Dictionary<String, AnyObject>)!
                let errorModel: ErrorModel = ErrorModel.parseErrorWithResponce(dictionary)
                UIAlertController.displayErrorMessageWithTarget(self, errorMessage: errorModel.message, title: Constants.Localized.someThingWentWrong)
                UIApplication.sharedApplication().networkActivityIndicatorVisible = false
            }
        })
    }
}
