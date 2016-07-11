//
//  TransactionDeliveryLogViewController.swift
//  YiLinkerOnlineBuyer
//
//  Created by Rj Constantino on 8/22/15.
//  Copyright (c) 2015 yiLinker-online-buyer. All rights reserved.
//

import UIKit

class TransactionDeliveryLogViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var transactionIdLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Delivery Log"
        
        self.tableView.backgroundColor = Constants.Colors.backgroundGray
        let nib = UINib(nibName: "TransactionDeliveryLogTableViewCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "DeliveryLogIdentifier")
        let nib2 = UINib(nibName: "TransactionDeliveryLog2TableViewCell", bundle: nil)
        self.tableView.registerNib(nib2, forCellReuseIdentifier: "DeliveryLog2Identifier")
    }

    // MARK: - Table View Data Source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row != 2 {
            let cell: TransactionDeliveryLogTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("DeliveryLogIdentifier") as! TransactionDeliveryLogTableViewCell
            
            return cell
        } else {
            let cell: TransactionDeliveryLog2TableViewCell = self.tableView.dequeueReusableCellWithIdentifier("DeliveryLog2Identifier") as! TransactionDeliveryLog2TableViewCell
            
            return cell
        }
        
    }
    
    // MARK: - Table View Delegate
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return setSectionHeader()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row != 2 {
            return 215
        } else {
            return 350
        }
    }
    
    // MARK: - Methods
    
    func setSectionHeader() -> UIView {
        var sectionHeaderView = UIView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.tableView.sectionHeaderHeight))
        sectionHeaderView.backgroundColor = Constants.Colors.backgroundGray
        
        var middleLine: UIView = UIView(frame: CGRectMake(0, 0, sectionHeaderView.frame.size.width, 0.5))
        middleLine.backgroundColor = .grayColor()
        middleLine.center.y = sectionHeaderView.center.y + (15 / 2)
        sectionHeaderView.addSubview(middleLine)
        
        var dateLabel: UILabel = UILabel(frame: CGRectMake(0, 0, sectionHeaderView.frame.size.width, 20))
        dateLabel.textAlignment = .Center
        dateLabel.font = UIFont.systemFontOfSize(12.0)
        dateLabel.textColor = .grayColor()
        dateLabel.text = "SEPTEMBER 23, 2014"
        dateLabel.sizeToFit()
        dateLabel.backgroundColor = Constants.Colors.backgroundGray
        dateLabel.frame.size.width = dateLabel.frame.size.width + 10
        dateLabel.center.x = sectionHeaderView.center.x
        dateLabel.center.y = sectionHeaderView.center.y + (15 / 2)
        
        sectionHeaderView.addSubview(dateLabel)
        
        return sectionHeaderView
    }
}
