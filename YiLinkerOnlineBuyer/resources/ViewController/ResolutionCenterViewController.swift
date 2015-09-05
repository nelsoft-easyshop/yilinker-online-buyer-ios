//
//  ResolutionCenterViewController.swift
//  Bar Button Item
//
//  Created by @EasyShop.ph on 8/29/15.
//  Copyright (c) 2015 YiLinker. All rights reserved.
//

import UIKit

class ResolutionCenterViewController
: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var casesTab: UIButton!
    @IBOutlet weak var openTab: UIButton!
    @IBOutlet weak var closedTab: UIButton!
    var tabSelector = ButtonToTabBehaviorizer()
    @IBOutlet weak var disputeButton: UIButton!
    var dimView: UIView? = nil
    
    @IBOutlet weak var resolutionTableView: UITableView!
    var dummyData : [(id:String, status: String, date: String, type: String)] =
    [   ("7889360001", "Open", "December 12, 2015", "Seller")
        ,("7889360002", "Closed", "January 2, 2016", "Buyer")
        ,("7889360003", "Open", "February 4, 2016", "Seller")
        ,("2345647856", "Open", "January 21, 2016", "Seller")
        ,("2345647856", "Closed", "January 21, 2016", "Seller")]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Title text in Navigation Bar will now turn WHITE
        self.navigationController!.navigationBar.barStyle = UIBarStyle.Black
        
        // Initialize tab-behavior for buttons
        tabSelector.viewDidLoadInitialize(casesTab, second: openTab, third: closedTab)
        
        // UITableViewDataSource initialization
        resolutionTableView.dataSource = self
        resolutionTableView.delegate = self
        
        // Load custom cell
        let nib = UINib(nibName:"ResolutionCenterCell", bundle:nil)
        resolutionTableView.registerNib(nib, forCellReuseIdentifier: "RcCell")
        resolutionTableView.rowHeight = 108
        
        // Back button
        let backButton = UIBarButtonItem(title:" ", style:.Plain, target: self, action:"goBackButton")
        backButton.image = UIImage(named: "back-white")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
        
        // Filter button
        let filterButton = UIBarButtonItem(title:" ", style:.Plain, target: self, action:"goFilterButton")
        filterButton.image = UIImage(named: "filter-resolution")
        filterButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = filterButton
        
        // Dispute button
        disputeButton.addTarget(self, action:"disputePressed", forControlEvents:.TouchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let caseDetails = self.storyboard?.instantiateViewControllerWithIdentifier("CaseDetailsTableViewController")
            as! CaseDetailsTableViewController
        
        // PASS DATA
        //caseDetails.passModel(tableData[indexPath.row])
        
        self.navigationController?.pushViewController(caseDetails, animated:true);
    
    }

    
    // MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // TODO complete the code below
        let cell = resolutionTableView.dequeueReusableCellWithIdentifier("RcCell") as! ResolutionCenterCell
        
        // put values here
        let currentDataId:(String, status:String, date:String, type:String) = dummyData[indexPath.item]
        cell.setData(currentDataId)
        //cell.setData(currentData.id, status:currentData.status, date:currentData.date, type:currentData.type )
        
        return cell
    }
    
    // MARK: Tab Selection Logic
    @IBAction func casesPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }

        self.tabSelector.setSelection(.TabOne)
    }

    @IBAction func openPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        
        self.tabSelector.setSelection(.TabTwo)
    }
    
    @IBAction func closedPressed(sender: AnyObject) {
        if self.tabSelector.didSelectTheSameTab(sender) {
            return
        }
        
        self.tabSelector.setSelection(.TabThree)
    }
    
    // Mark: - File a Dispute
    func disputePressed() {
      //NSBundle.mainBundle().loadNibNamed("DisputeViewController", owner: self, options: nil)
        
        
        
        var attributeModal = DisputeViewController(nibName: "DisputeViewController", bundle: nil)
        attributeModal.delegate = self
        attributeModal.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        attributeModal.providesPresentationContextTransitionStyle = true
        attributeModal.definesPresentationContext = true
        attributeModal.view.backgroundColor = UIColor.clearColor()
        attributeModal.view.frame.origin.y = attributeModal.view.frame.size.height
      
        //UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(attributeModal, animated: true, completion: nil)
        self.navigationController?.presentViewController(attributeModal, animated: true, completion: nil)

        if self.dimView == nil {
            let dimView = UIView(frame: self.view.frame)
            dimView.tag = 1337;
            dimView.backgroundColor = UIColor.blackColor();
            dimView.alpha = 0.7;
            self.dimView = dimView
        }
        self.view.addSubview(self.dimView!);
        
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView?.alpha = 0.5
            self.dimView?.layer.zPosition = 2
            //self.view.transform = CGAffineTransformMakeScale(0.92, 0.95)
            //self.navigationController?.navigationBar.alpha = 0.0
        })
    }
    
    func dissmissDisputeViewController(controller: DisputeViewController, type: String) {
        
        UIView.animateWithDuration(0.3, animations: {
            self.dimView?.alpha = 0
            self.dimView?.layer.zPosition = -1
            //self.view.transform = CGAffineTransformMakeTranslation(1, 1)
            //self.navigationController?.navigationBar.alpha = CGFloat(self.visibility)
        })
    }

    
    
    // MARK: - Navigation Bar Buttons
    func goBackButton() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func goFilterButton() {
        let filtration =
            self.storyboard?.instantiateViewControllerWithIdentifier("FilterNavigationController")
                as! UINavigationController

        self.navigationController?.presentViewController(filtration, animated: true, completion: nil)
            //completion: (() -> Void)?
    }

    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
