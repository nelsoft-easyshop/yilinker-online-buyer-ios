//
//  CheckoutContainerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CheckoutContainerViewController: UIViewController, PaymentWebViewViewControllerDelegate {
    
    var summaryViewController: SummaryViewController?
    var paymentViewController: PaymentViewController?
    var overViewViewController: OverViewViewController?
    
    var viewControllers = [UIViewController]()
    var selectedChildViewController: UIViewController?
    
    var contentViewFrame: CGRect?
    var selectedIndex: Int = 0
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var continueButton: UIButton!
    
    
    @IBOutlet weak var firstCircleLabel: DynamicRoundedLabel!
    @IBOutlet weak var secondCircleLabel: DynamicRoundedLabel!
    @IBOutlet weak var thirdCircleLabel: DynamicRoundedLabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleView()
        
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.initViewController()
        self.setSelectedViewControllerWithIndex(self.selectedIndex)
        self.backButton()
    }

    func titleView() {
        self.navigationController!.navigationBar.topItem!.title = "Checkout"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function is for executing child view logic code
    func setSelectedViewControllerWithIndex(index: Int) {
        if index == 0 {
            self.firsCircle()
            self.continueButton("Save and Continue")
            let viewController: UIViewController = viewControllers[index]
            setSelectedViewController(viewController)
        } else if index == 1 {
            self.secondCircle()
            self.continueButton("Save and Go to Payment")
            let viewController: UIViewController = viewControllers[index]
            setSelectedViewController(viewController)
        } else if index == 2 {
            self.redirectToPaymentWebViewWithUrl("http://www.dragonpay.ph")
        }
    }
    
    func firsCircle() {
        for imageView in self.firstCircleLabel.subviews {
            imageView.removeFromSuperview()
        }
        
        self.firstCircleLabel.backgroundColor = Constants.Colors.appTheme
        self.secondCircleLabel.backgroundColor = UIColor.clearColor()
        self.thirdCircleLabel.backgroundColor = UIColor.clearColor()
        
        self.firstCircleLabel.text = "1"
        self.secondCircleLabel.text = ""
        self.thirdCircleLabel.text = ""
        
        self.summaryLabel.textColor = UIColor.whiteColor()
        self.paymentLabel.textColor = UIColor.lightGrayColor()
        self.overViewLabel.textColor = UIColor.lightGrayColor()
    }
    
    func secondCircle() {
        self.firstCircleLabel.backgroundColor = Constants.Colors.appTheme
        
        let checkImageView: UIImageView = UIImageView(frame: CGRectMake(3, 4, 20, 20))
        checkImageView.image = UIImage(named: "check-white")
        checkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.firstCircleLabel.addSubview(checkImageView)
        self.firstCircleLabel.text = ""
        
        self.secondCircleLabel.backgroundColor = UIColor.clearColor()
        self.secondCircleLabel.textColor = Constants.Colors.appTheme
        
        self.thirdCircleLabel.backgroundColor = UIColor.clearColor()
        
        self.secondCircleLabel.text = "2"
        self.thirdCircleLabel.text = ""
        
        self.summaryLabel.textColor = UIColor.lightGrayColor()
        self.paymentLabel.textColor = UIColor.whiteColor()
        self.overViewLabel.textColor = UIColor.lightGrayColor()
    }
    
    func thirdCircle() {
        self.firstCircleLabel.backgroundColor = Constants.Colors.appTheme
        
        let checkImageView: UIImageView = UIImageView(frame: CGRectMake(3, 4, 20, 20))
        checkImageView.image = UIImage(named: "check-white")
        checkImageView.contentMode = UIViewContentMode.ScaleAspectFit
        
        let checkImageView2: UIImageView = UIImageView(frame: CGRectMake(3, 4, 20, 20))
        checkImageView2.image = UIImage(named: "check-white")
        checkImageView2.contentMode = UIViewContentMode.ScaleAspectFit
        
        self.firstCircleLabel.addSubview(checkImageView)
        self.firstCircleLabel.text = ""
        
        self.secondCircleLabel.backgroundColor = UIColor.clearColor()
        
        self.thirdCircleLabel.backgroundColor = UIColor.clearColor()
        
        self.secondCircleLabel.text = ""
        self.secondCircleLabel.addSubview(checkImageView2)
        self.secondCircleLabel.backgroundColor = Constants.Colors.appTheme
        
        self.thirdCircleLabel.text = "3"
        self.thirdCircleLabel.textColor = Constants.Colors.appTheme
        
        self.summaryLabel.textColor = UIColor.lightGrayColor()
        self.paymentLabel.textColor = UIColor.whiteColor()
        self.overViewLabel.textColor = UIColor.lightGrayColor()
    }
    
    override func viewDidLayoutSubviews() {
        self.contentViewFrame = contentView.bounds
        
    }
    
    func setSelectedViewController(viewController: UIViewController) {
        if !(selectedChildViewController == viewController) {
            if self.isViewLoaded() {
                selectedChildViewController?.willMoveToParentViewController(self)
                selectedChildViewController?.view.removeFromSuperview()
                selectedChildViewController?.removeFromParentViewController()
            }
        }
        self.view.layoutIfNeeded()
        self.addChildViewController(viewController)
        viewController.view.frame = self.contentViewFrame!
        contentView.addSubview(viewController.view)
        viewController.didMoveToParentViewController(self)
        selectedChildViewController = viewController
    }
    
    func initViewController() {
        summaryViewController = SummaryViewController(nibName: "SummaryViewController", bundle: nil)
        paymentViewController = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
        overViewViewController = OverViewViewController(nibName: "OverViewViewController", bundle: nil)
        
        self.viewControllers.append(summaryViewController!)
        self.viewControllers.append(paymentViewController!)
        self.viewControllers.append(overViewViewController!)
    }
    
    func backButton() {
        var backButton:UIButton = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
        backButton.frame = CGRectMake(0, 0, 40, 40)
        backButton.addTarget(self, action: "back", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "back-white"), forState: UIControlState.Normal)
        var customBackButton:UIBarButtonItem = UIBarButtonItem(customView: backButton)
        
        let navigationSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FixedSpace, target: nil, action: nil)
        navigationSpacer.width = -20
        
        self.navigationItem.leftBarButtonItems = [navigationSpacer, customBackButton]
    }
    
    func back() {
        if self.selectedIndex != 0 {
            self.selectedIndex--
            self.setSelectedViewControllerWithIndex(self.selectedIndex)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func saveAndContinue(sender: AnyObject) {
        if selectedIndex != self.viewControllers.count {
            self.selectedIndex++
        }
        
        if self.selectedIndex == 3 {
            self.dismissViewControllerAnimated(true, completion: nil)
        } else {
            self.setSelectedViewControllerWithIndex(self.selectedIndex)
        }

    }
    
    func continueButton(title: String) {
        self.continueButton.setTitle(title, forState: UIControlState.Normal)
    }
    
    func redirectToPaymentWebViewWithUrl(url: String) {
        let paymentWebViewController = PaymentWebViewViewController(nibName: "PaymentWebViewViewController", bundle: nil)
        paymentWebViewController.url = NSURL(string: url)!
        paymentWebViewController.delegate = self
        let navigationController: UINavigationController = UINavigationController(rootViewController: paymentWebViewController)
        navigationController.navigationBar.barTintColor = Constants.Colors.appTheme
        self.presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func paymentWebViewController(paymentDidCancel paymentWebViewController: PaymentWebViewViewController) {
        self.selectedIndex--
    }
    
    func paymentWebViewController(paymentDidSucceed paymentWebViewController: PaymentWebViewViewController) {
        self.selectedIndex++
        let viewController: UIViewController = viewControllers[2]
        setSelectedViewController(viewController)
        self.navigationItem.leftBarButtonItems = []
        self.navigationItem.rightBarButtonItems = []
        self.continueButton("Continue Shopping")
        self.thirdCircle()
    }
    
    func paymentWebViewController(paymentDidNotSucceed paymentWebViewController: PaymentWebViewViewController) {
        self.selectedIndex--
    }   
}
