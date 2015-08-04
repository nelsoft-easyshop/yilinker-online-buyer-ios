//
//  CircularMenuViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Alvin John Tandoc on 7/28/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CircularMenuViewController: UIViewController {
    
    @IBOutlet weak var roundedButton: RoundedButton!
    
    @IBOutlet weak var dimView: UIView!
    
    var buttonImages: [String] = [""]
    
    
  /* @IBOutlet weak var logoutSemiRoundedButton: SemiRoundedButton!
    @IBOutlet weak var categoryLabel: RoundedLabel!
    @IBOutlet weak var todaysPromoLabel: RoundedLabel!
    @IBOutlet weak var customizeShoppingLabel: RoundedLabel!
    @IBOutlet weak var messagingLabel: RoundedLabel!
    @IBOutlet weak var followedSellerLabel: RoundedLabel!
    @IBOutlet weak var helpLabel: RoundedLabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageTitleButton: UIButton! */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initDimView()
        self.hideControlTitlesNotAnimated()
        
        /*let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "tapProfile")
        self.roundedProfileImageView.userInteractionEnabled = true
        self.roundedProfileImageView.addGestureRecognizer(tapGesture)*/
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.presentCirculardMenuAnimate()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeCircularMenuView(sender: AnyObject) {
        dissmissViewControllerAnimated()
    }
    
    private func presentCirculardMenuAnimate() {
        let delay = 0.01 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
                //self.roundedButton.transform = CGAffineTransformMakeScale(1.2, 1.2)
                }, completion: nil)
        }
        
       /* let helpFrame: CGRect = helpButton.frame
        let followedSellerFrame: CGRect = followedSellerButton.frame
        let messagingFrame: CGRect = messagingButton.frame
        let customizeShoppingFrame: CGRect = customizeShoppingButton.frame
        let todayPromoFrame: CGRect = todaysPromoButton.frame
        let categoryButtonFrame: CGRect = categoryButton.frame
        let roundedProfileImageViewFrame: CGRect = roundedProfileImageView.frame */
        
        self.hideControlNotAnimated()
        
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
           /* self.helpButton.frame = helpFrame
            self.followedSellerButton.frame = followedSellerFrame
            self.messagingButton.frame = messagingFrame
            self.customizeShoppingButton.frame = customizeShoppingFrame
            self.todaysPromoButton.frame = todayPromoFrame
            self.categoryButton.frame = categoryButtonFrame
            self.roundedButton.frame = roundedProfileImageViewFrame
            self.roundedProfileImageView.frame = roundedProfileImageViewFrame*/
            self.dimView.alpha = 0.6
            //self.showTitles()
        }), completion: nil)
    }
    
    
    private func hideControlNotAnimated() {
       /* self.helpButton.frame = CGRectMake(helpButton.frame.origin.x, view.frame.size.height + 50, helpButton.frame.size.width, helpButton.frame.size.height)
        self.followedSellerButton.frame = CGRectMake(self.followedSellerButton.frame.origin.x, self.view.frame.size.height + 50, self.followedSellerButton.frame.size.width, self.followedSellerButton.frame.size.height)
        self.messagingButton.frame = CGRectMake(self.messagingButton.frame.origin.x, self.view.frame.size.height + 50, self.messagingButton.frame.size.width, self.messagingButton.frame.size.height)
        self.customizeShoppingButton.frame = CGRectMake(self.customizeShoppingButton.frame.origin.x, self.view.frame.size.height + 50, self.customizeShoppingButton.frame.size.width, self.customizeShoppingButton.frame.size.height)
        self.todaysPromoButton.frame = CGRectMake(self.customizeShoppingButton.frame.origin.x, view.frame.size.height + 50, self.customizeShoppingButton.frame.size.width, self.customizeShoppingButton.frame.size.height)
        self.categoryButton.frame = CGRectMake(self.categoryButton.frame.origin.x, self.view.frame.size.height + 50, self.categoryButton.frame.size.width, self.categoryButton.frame.size.height)
        self.roundedProfileImageView.frame = CGRectMake(self.roundedProfileImageView.frame.origin.x, self.view.frame.size.height + 50, self.roundedProfileImageView.frame.size.width, self.roundedProfileImageView.frame.size.height) */
    }
    
    
     func dissmissViewControllerAnimated() {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 3.0, options: UIViewAnimationOptions.CurveEaseInOut, animations: ({
            self.hideControlNotAnimated()
          /*  self.roundedProfileImageView.transform = CGAffineTransformMakeScale(0.1, 0.1)
            
            self.helpButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.followedSellerButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.messagingButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.customizeShoppingButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.todaysPromoButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.categoryButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
            self.roundedProfileImageView.transform = CGAffineTransformMakeScale(0.1, 0.1) */
            self.dimView.alpha = 0.0
            
            self.hideControlTitlesNotAnimated()
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: nil, animations: {
                //self.roundedButton.transform = CGAffineTransformMakeScale(0.1, 0.1)
                }, completion: {(value: Bool) in
                    self.dismissViewControllerAnimated(false, completion: nil)
            })
            
        }), completion: {
            (value: Bool) in
            
          /*  self.helpButton.hidden = true
            self.followedSellerButton.hidden = true
            self.messagingButton.hidden = true
            self.customizeShoppingButton.hidden = true
            self.todaysPromoButton.hidden = true
            self.categoryButton.hidden = true
            self.roundedProfileImageView.hidden = true */
            
            
        })
    }
    
    
    private func initDimView() {
        self.dimView.alpha = 0.0
        dimView.userInteractionEnabled = true
        let tapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dissmissViewControllerAnimated")
        dimView.addGestureRecognizer(tapGesture)
    }
    
    func tapProfile() {
        println("Profile tap")
    }
    
    func showTitles() {
      /*  self.logoutSemiRoundedButton.alpha = 1.0
        self.categoryLabel.alpha = 1.0
        self.todaysPromoLabel.alpha = 1.0
        self.customizeShoppingLabel.alpha = 1.0
        self.messagingLabel.alpha = 1.0
        self.followedSellerLabel.alpha = 1.0
        self.helpLabel.alpha = 1.0
        self.nameLabel.alpha = 1.0
        self.messageTitleButton.alpha = 1.0*/
    }
    
    func hideControlTitlesNotAnimated() {
       /* self.logoutSemiRoundedButton.alpha = 0.0
        self.categoryLabel.alpha = 0.0
        self.todaysPromoLabel.alpha = 0.0
        self.customizeShoppingLabel.alpha = 0.0
        self.messagingLabel.alpha = 0.0
        self.followedSellerLabel.alpha = 0.0
        self.helpLabel.alpha = 0.0
        self.nameLabel.alpha = 0.0
        self.messageTitleButton.alpha = 0.0*/
    }
    
    
    @IBAction func logout(sender: AnyObject) {
        //logout function
    }
    
    @IBAction func helpAction(sender: AnyObject) {
        //help action
    }
    
    @IBAction func followedSellerAction(sender: AnyObject) {
        //followed action
    }
    
    @IBAction func messagingAction(sender: AnyObject) {
        //messaging action
    }
    
    @IBAction func customizeAction(sender: AnyObject) {
        //customizedAction
    }
    
    @IBAction func todaysPromoAction(sender: AnyObject) {
        //todaysAction
    }
    
    @IBAction func categoriesAction(sender: AnyObject) {

    }
    
}
