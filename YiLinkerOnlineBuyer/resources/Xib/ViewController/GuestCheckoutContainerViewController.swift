//
//  CheckoutContainerViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/19/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class CheckoutContainerViewController: UIViewController {
    
    var summaryViewController: SummaryViewController?
    var paymentViewController: PaymentViewController?
    var overViewViewController: OverViewViewController?
    
    var viewControllers = [UIViewController]()
    var selectedChildViewController: UIViewController?
    
    var contentViewFrame: CGRect?
    var selectedIndex: Int = 0
    
    @IBOutlet weak var contentView: UIView!
    
    
    @IBOutlet weak var firstCircleLabel: DynamicRoundedLabel!
    @IBOutlet weak var secondCircleLabel: DynamicRoundedLabel!
    @IBOutlet weak var thirdCircleLabel: DynamicRoundedLabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var paymentLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.respondsToSelector("edgesForExtendedLayout") {
            self.edgesForExtendedLayout = UIRectEdge.None
        }
        
        self.initViewController()
        self.setSelectedViewControllerWithIndex(self.selectedIndex)
        self.backButton()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function is for executing child view logic code
    func setSelectedViewControllerWithIndex(index: Int) {
        if self.viewControllers.count != 0 {
            let viewController: UIViewController = viewControllers[index]
            setSelectedViewController(viewController)
        }
            
        if index == 0 {
            self.firsCircle()
        } else if index == 1 {
            self.secondCircle()
        } else if index == 2 {
            self.thirdCircle()
        }
    }
    
    func firsCircle() {
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
        self.secondCircleLabel.backgroundColor = Constants.Colors.appTheme
        self.thirdCircleLabel.backgroundColor = UIColor.clearColor()
        
        self.secondCircleLabel.text = "2"
        self.thirdCircleLabel.text = ""
        
        self.summaryLabel.textColor = UIColor.lightGrayColor()
        self.paymentLabel.textColor = UIColor.whiteColor()
        self.overViewLabel.textColor = UIColor.lightGrayColor()
    }
    
    func thirdCircle() {
        self.firstCircleLabel.backgroundColor = Constants.Colors.appTheme
        self.secondCircleLabel.backgroundColor = Constants.Colors.appTheme
        self.thirdCircleLabel.backgroundColor = Constants.Colors.appTheme
        
        self.secondCircleLabel.text = "2"
        self.thirdCircleLabel.text = "3"
        
        self.summaryLabel.textColor = UIColor.lightGrayColor()
        self.paymentLabel.textColor = UIColor.lightGrayColor()
        self.overViewLabel.textColor = UIColor.whiteColor()
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
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func saveAndContinue(sender: AnyObject) {
        if selectedIndex != self.viewControllers.count - 1 {
            self.selectedIndex++
        }
        self.setSelectedViewControllerWithIndex(self.selectedIndex)
    }
}
